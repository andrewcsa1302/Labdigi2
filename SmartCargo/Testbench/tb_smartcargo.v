`timescale 1ns / 1ns // Definindo a escala de tempo para 1 ns por unidade de tempo

module tb_smartcargo;
    reg clk;
    reg reset;
    reg [3:0] sensoresNeg;
    reg iniciar;
    reg emergencia;
    reg echo;

    wire motorDescendoF;
    wire motorSubindoF;
    wire trigger_sensor_ultrasonico; 
    wire [1:0] saida_andar;

    // Transmissão serial
    reg RX2;

    reg envia_serial;
    reg [7:0] dados_enviados;
    
    // Registrador para controlar a máquina de estados serial
    reg [3:0] bit_count; // Contador de bits para transmissão
    reg [7:0] tx_data;   // Registrador de dados para transmissão (1 byte)
    reg serial_busy;     // Flag de transmissão

    reg [1:0] andar_atual_simulado;

    reg imprima_memoria;

    integer i;
    
    // Contador de ciclos para temporizar a transmissão serial
    reg [24:0] ciclo_count;  // Contador de ciclos, precisa contar até 173 para cada bit

    // DUT (Design Under Test)
    smart_cargo dut (
        .iniciar            (iniciar),
        .clock              (clk),
        .sensoresNeg        (sensoresNeg),
        .reset              (reset),
        .emergencia         (emergencia),
        .RX                 (RX2),  // RX2 será utilizado como entrada para simular a recepção
        .echo               (echo),
        .motorDescendoF     (motorDescendoF),
        .motorSubindoF      (motorSubindoF),
        .trigger_sensor_ultrasonico (trigger_sensor_ultrasonico),
        .saida_andar        (saida_andar)
    );

    // Gerador de clock para 50 MHz (período de 20 ns)
    initial clk = 0;
    always #10 clk = ~clk; // Toggling a cada 10 ns -> 50 MHz



    // Testes
    initial begin
        reset = 1;
        #20;  // 20 ns de atraso (correspondente ao 1º ciclo de clock)
        reset = 0;
        iniciar = 0;
        emergencia = 0;
        echo = 0;
        imprima_memoria = 0;
        #20;  // 20 ns de atraso
        iniciar = 1;
        // Primeira transmissao serial:
        dados_enviados = 8'b00011101; //  bits de dados obj 01, dest 11, origem 01 

        // Dados a serem transmitidos via serial (em formato 8N1: 1 start + 8 bits de dados + 1 stop bit)
        
        #20;
        
        // Começar a transmissão serial
        envia_serial = 1; // Inicia a transmissão
        #250000;


        dados_enviados = 8'b00011110; // obj 01, dest 11, origem 10
        envia_serial = 1; 
        #800000;
        envia_serial = 0;


        $display("Teste concluido.");
        $finish;
    end

    // Função para calcular os sensores simulados
    function [3:0] calcula_sensores(input [1:0] andar_atual);
        begin
            case (andar_atual)
                2'b00: calcula_sensores = 4'b1110;
                2'b01: calcula_sensores = 4'b1101;
                2'b10: calcula_sensores = 4'b1011;
                2'b11: calcula_sensores = 4'b0111;
                default: calcula_sensores = 4'b1111;
            endcase
        end
    endfunction

    // Lógica de simulação do elevador
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            andar_atual_simulado <= 2'b00;
        end else begin
            if (motorDescendoF || motorSubindoF) begin
                sensoresNeg <= 4'b1111;
                #50000; // tempo entre andares (nenhum sensor ligado)
                if (motorDescendoF == 1'b1) begin
                    if (andar_atual_simulado > 2'b00) begin
                        andar_atual_simulado <= andar_atual_simulado - 1;
                        imprima_memoria = 1;

                    end
                end else if (motorSubindoF == 1'b1) begin
                    if (andar_atual_simulado < 2'b11) begin
                        andar_atual_simulado <= andar_atual_simulado + 1;
                        imprima_memoria = 1;
                    end
                end
                imprima_memoria = 0;
                sensoresNeg <= calcula_sensores(andar_atual_simulado);
                #1000; // tempo que os sensores estão ativados porque estão parados em um andar
            end
        end
    end

        // Monitoramento de mudanças no andar_atual_simulado
    always @(imprima_memoria) begin
        $display("Conteudo da RAM (andar_atual_simulado = %0d):", andar_atual_simulado);
        for (i = 0; i < 16; i = i + 1) begin
            $display("RAM[%0d] = %b", i, dut.fluxodeDados.fila_ram.ram[i]);
        end
    end

        // Contador de ciclos para temporizar a transmissão de bits a 115200 bauds
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ciclo_count <= 0;
            bit_count <= 0;
            RX2 <= 1;  // Linha RX2 começa em nível alto (idle)
        end else if (envia_serial) begin
            tx_data <= dados_enviados;
            if (ciclo_count < 434) begin
                ciclo_count <= ciclo_count + 1;  // Incrementa o contador de ciclos
            end else begin
                ciclo_count <= 0;  // Reset o contador de ciclos para o próximo bit
                
                // Transmitir o próximo bit (0 para start, 1 para stop, dados entre 1 e 8)
                if (bit_count < 10) begin
                    if (bit_count == 0) begin
                        RX2 <= 0;  // Start bit (1 bit)
                    end else if (bit_count < 9) begin
                        RX2 <= tx_data[bit_count - 1];  // Dados (bits de 0 a 7)
                    end else if (bit_count == 9) begin
                        RX2 <= 1;  // Stop bit (1 bit)
                    end
                    bit_count <= bit_count + 1;  // Avança para o próximo bit
                end else begin
                    envia_serial <= 0;  // Parar a transmissão depois de enviar todos os bits
                    bit_count <= 0;  // Reset para a próxima transmissão
                end
            end
        end
    end

endmodule