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
    wire [1:0]saida_andar;

    // Transmissão serial
    reg RX;
    reg RX2;

    reg envia_serial;
    reg [7:0] dados_enviados;
    
    // Registrador para controlar a máquina de estados serial
    reg [3:0] bit_count; // Contador de bits para transmissão
    reg [7:0] tx_data;   // Registrador de dados para transmissão (1 byte)
    reg serial_busy;     // Flag de transmissão

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

    // Testes
    initial begin
        reset = 1;
	    dados_enviados = 8'b00011100; // 7 bits de dados obj 01, dest 11, org 00 
        #20;  // 20 ns de atraso (correspondente ao 1º ciclo de clock)
        reset = 0;
        iniciar = 0;
        emergencia = 0;
        sensoresNeg = 4'b1110;
        echo = 0;
        RX2 = 1;
        
        #20;  // 20 ns de atraso
        iniciar = 1;

        // Dados a serem transmitidos via serial (em formato 8N1: 8 bits de dados + 1 start + 1 stop bit)
        
        #20;
        
        // Começar a transmissão serial
        envia_serial = 1; // Inicia a transmissão
        #250000;
        sensoresNeg = 4'b1110;
        #50000;
        sensoresNeg = 4'b1101;
        #50000;
        sensoresNeg = 4'b1011;
        #50000;
        sensoresNeg = 4'b0111;
        dados_enviados = 8'b00011110;
        envia_serial = 1;  // Atraso para garantir que 1 byte (10 bits) seja transmitido a 115200 bauds (8.68 us por bit)
        #300000;
        envia_serial = 0;

        // Aguardar a recepção e processamento
        #1000;  // 1000 ns de espera
        #4000;  // 4000 ns de espera

        $display("Teste concluído.");
        $finish;
    end

endmodule
