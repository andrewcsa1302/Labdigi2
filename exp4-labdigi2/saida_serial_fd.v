 module saida_serial_fd (
    input        clock        ,
    input        reset        ,
    input        proximo      , // Para mandar pegar o proximo digito 
    input        conta        ,
    input        carrega      ,
    input        desloca      ,
    input  [6:0] dados_ascii  ,
    output       saida_serial ,
    output       fim
);

    // Sinais internos
    wire        s_serial_pronto;
    wire [6:0]  s_dado_transmitido;
    wire [6:0]  s_dado_ascii_0;
    wire [6:0]  s_dado_ascii_1;
    wire [6:0]  s_dado_ascii_2;
    wire [6:0]  s_hashtag;

    // # em hexa: 23H = 0010 0011
    assign s_hashtag = 7'b0010011;

    // Converter cada dígito BCD para ASCII, juntando com [0011] na frente
    assign s_dado_ascii_0 = {3'b011, dados[3:0]};
    assign s_dado_ascii_1 = {3'b011, dados[7:4]};
    assign s_dado_ascii_2 = {3'b011, dados[11:8]};


    // Modulo de transmissao serial
    tx_serial_7O1 serial (
        .clock           ( clock          ),
        .reset           ( reset          ),
        .partida         ( inicio         ),
        .dados_ascii     ( s_saida_mux    ),
        .saida_serial    ( saida_serial   ),
        .pronto          ( s_serial_pronto),
        .db_clock        (                ), // Porta aberta (desconectada)
        .db_tick         (                ), // Porta aberta (desconectada)
        .db_partida      (                ), // Porta aberta (desconectada)
        .db_saida_serial (                ), // Porta aberta (desconectada)
        .db_estado       (                )  // Porta aberta (desconectada)
    );

    // Mux para passar um dado por vez e o hashtag
    mux_4x1_n #(4) dut (
        .D3     ( s_hashtag       ),
        .D2     ( s_dado_ascii_2  ),
        .D1     ( s_dado_ascii_1  ),
        .D0     ( s_dado_ascii_0  ),
        .SEL    ( selecao_mux     ),
        .MUX_OUT( s_saida_mux     )
    );
    
    // Saida serial do transmissor
    assign saida_serial = ;
  
endmodule
