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
    wire RX;

    reg envia_serial;

    reg [6:0] dados_enviados;

    integer i;

    // dut
    smart_cargo dut (
        .iniciar            ( iniciar           ),
        .clock              ( clk               ),
        .sensoresNeg        ( sensoresNeg       ),
        .reset              ( reset             ),
        .emergencia         ( emergencia        ),
        .RX                 ( RX                ),
        .echo               ( echo              ),
        .dbQuintoBitEstado  (                   ),
        .db_iniciar         (                   ),
        .db_clock           (                   ),
        .db_reset           (                   ),
        .motorDescendoF     ( motorDescendoF    ),
        .motorSubindoF      ( motorSubindoF     ),
        .andarAtual_db      (                   ),
        .proxParada_db      (                   ),
        .Eatual_1           (                   ),
        .Eatual_2           (                   ),
        .db_bordaSensorAtivo(                   ),
        .db_motorSubindo    (                   ),
        .db_motorDescendo   (                   ),
        .db_sensores        (                   ),
        .db_serial_hex      (                   ),
        .trigger_sensor_ultrasonico (trigger_sensor_ultrasonico ),
        .saida_andar        (saida_andar        )
    );

    // gerador de clock
    initial clk = 0;
    always #2 clk = ~clk;

    // testes
initial begin

    reset = 1;
    #10;
    reset = 0;
    iniciar = 0;
    emergencia = 0;
    #10;
    iniciar = 1;
    sensoresNeg = 4'b1111;

    // Transmissão serial de dados
    // Formato dos dados: {tipo_objeto, destino_objeto, origem_objeto}
    // Exemplo: tipo_objeto = 2'b01, destino_objeto = 2'b11, origem_objeto = 2'b00
    // 1 bit sem uso | tipo_obj |destino_obj | origem_obj
    dados_enviados = 7'b0011100; // tipo_objeto = 01, destino_objeto = 11, origem_objeto = 00
    #10;

    envia_serial = 1;
    #5;
    envia_serial = 0;
    #1000;
    #4000;
    #(4_000_000);

    $display("Teste concluído.");
    $finish;

end


endmodule