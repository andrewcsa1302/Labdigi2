`timescale 1us / 1us

module tb_smartcargo;
    reg clk;
    reg reset;
    reg [3:0] sensoresNeg;
    reg iniciar;
    reg emergencia;

    wire motorDescendoF;
    wire motorSubindoF;

    // Transmissao serial
    wire RX;

    reg envia_serial;

    reg [6:0] dados_enviados;

    integer i;

    // dut
    smart_cargo dut (
        .iniciar            ( iniciar           ),
        .clock              ( clk             ),
        .sensoresNeg        ( sensoresNeg       ),
        .reset              ( reset             ),
        .emergencia         ( emergencia        ),
        .RX                 ( RX                ),
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
        .db_serial_hex      (                   )
    );
    
    // Modulo de transmissao serial
    tx_serial_7O1 serial (
        .clock           ( clk          ),
        .reset           ( reset          ),
        .partida         ( envia_serial ),
        .dados_ascii     ( dados_enviados ),
        .saida_serial    ( RX             ),
        .pronto          (  ),
        .db_clock        (                ), // Porta aberta (desconectada)
        .db_tick         (                ), // Porta aberta (desconectada)
        .db_partida      (                ), // Porta aberta (desconectada)
        .db_saida_serial (                ), // Porta aberta (desconectada)
        .db_estado       (                )  // Porta aberta (desconectada)
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
    sensoresNeg = 4'b0000;

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


    $display("Teste concluído.");
    $finish;

end


endmodule