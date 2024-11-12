`timescale 1us / 1us

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
    wire saida_andar;

    // Transmissao serial
    reg RX;

    reg envia_serial;
    reg [6:0] dados_enviados;
    
    // Registrador para controlar a máquina de estados serial
    reg [3:0] bit_count; // Contador de bits para transmissão
    reg [10:0] tx_data;   // Registrador de dados para transmissão (1 byte)
    reg serial_busy;     // Flag de transmissão

    integer i;

    // DUT (Design Under Test)
    smart_cargo dut (
        .iniciar            (iniciar),
        .clock              (clk),
        .sensoresNeg        (sensoresNeg),
        .reset              (reset),
        .emergencia         (emergencia),
        .RX                 (RX),
        .echo               (echo),
        .motorDescendoF     (motorDescendoF),
        .motorSubindoF      (motorSubindoF),
        .trigger_sensor_ultrasonico (trigger_sensor_ultrasonico),
        .saida_andar        (saida_andar)
    );

    // Gerador de clock
    initial clk = 0;
    always #2 clk = ~clk;

    // Máquina de estados para a transmissão serial
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_count <= 0;
            serial_busy <= 0;
            tx_data <= 11'b0;
            RX <= 1;
        end
        else if (envia_serial && !serial_busy && dados_enviados!=0) begin
            serial_busy <= 1;
            tx_data <= {1'b1, ~^dados_enviados[6:0] , dados_enviados[6:0], 2'b10}; // 1 bit de stop + 7 bits de dados + 1 bit de start (0)
            RX <= 0;  // Começar a enviar os dados
        end
        else if (serial_busy) begin
            // Transmitir bit por bit (bit_count varia de 0 a 7)
            if (bit_count < 12) begin
                RX <= tx_data[bit_count];  // Enviar o bit de tx_data
                bit_count <= bit_count + 1;
            end
            else begin
                serial_busy <= 0;  // Terminar a transmissão
                RX <= 1; // Linha de RX desativa
            end
        end
    end

    // Testes
    initial begin
        reset = 1;
        #10;
        reset = 0;
        iniciar = 0;
        emergencia = 0;
        sensoresNeg = 4'b1111;
        echo = 0;
        
        #10;
        iniciar = 1;
        
        // Exemplo de dados a serem enviados via serial:
        dados_enviados = 7'b0011100; // 7 bits de dados, representando tipo_objeto, destino_objeto, origem_objeto
        #10
         // Transmitir os dados
        envia_serial = 1; // Começar a transmissão
        #10
        dados_enviados = 0;
        #70; // Atraso para garantir que a transmissão seja completada
        envia_serial = 0;
        
        // Aguardar um tempo e então finalizar o teste
        #1000;
        #4000;
        #(4_000);

        $display("Teste concluído.");
        $finish;
    end

endmodule
