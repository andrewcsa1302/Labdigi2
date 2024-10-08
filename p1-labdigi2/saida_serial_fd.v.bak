 module saida_serial_fd (
    input  wire      clock        ,
    input  wire      reset        ,
    input  wire      proximo      , // Para mandar pegar o proximo digito 
    input  wire      zera_contador,
    input  wire      conta_contador,
    input  wire [11:0] dados      ,
    input  wire [23:0] angulos    ,
    output wire      saida_serial ,
    output wire      fim_contador ,
    output wire      serial_pronto      
);

    // Sinais internos
    wire [6:0]  s_saida_mux;
    wire [2:0]  s_selecao_mux;

    // Sinais para passar medida e #
    wire [6:0]  s_dado_ascii_unidade;
    wire [6:0]  s_dado_ascii_dezena;
    wire [6:0]  s_dado_ascii_centena;
    wire [6:0]  s_hashtag;

    // Converter cada dígito BCD para ASCII, juntando com [0011] na frente
    assign s_dado_ascii_unidade = {3'b011, dados[3:0]};
    assign s_dado_ascii_dezena = {3'b011, dados[7:4]};
    assign s_dado_ascii_centena = {3'b011, dados[11:8]};

    // # em hexa: 23H = 0010 0011
    assign s_hashtag = 7'b0100011;

    // Sinais para passar cada digito do angulo e virgula
    wire [6:0]  s_angulo_centena;
    wire [6:0]  s_angulo_dezena;
    wire [6:0]  s_angulo_unidade;
    wire [6:0]  s_virgula;

    assign s_angulo_centena = angulos[23:16];
    assign s_angulo_centena = angulos[15:8];
    assign s_angulo_centena = angulos[7:0];

    // , em hexa: 2CH = 0010 1100
    assign s_virgula = 7'b0101100;


    // Modulo de transmissao serial
    tx_serial_7O1 serial (
        .clock           ( clock          ),
        .reset           ( reset          ),
        .partida         ( proximo        ),
        .dados_ascii     ( s_saida_mux    ),
        .saida_serial    ( saida_serial   ),
        .pronto          ( serial_pronto  ),
        .db_clock        (                ), // Porta aberta (desconectada)
        .db_tick         (                ), // Porta aberta (desconectada)
        .db_partida      (                ), // Porta aberta (desconectada)
        .db_saida_serial (                ), // Porta aberta (desconectada)
        .db_estado       (                )  // Porta aberta (desconectada)
    );

    // Contador para direcionar a selecao do mux
    contador_m #(
        .M (8), 
        .N (3)
    ) U1 (
        .clock   (clock           ),
        .zera_as (1'b0            ),
        .zera_s  (zera_contador   ),
        .conta   (conta_contador  ),
        .Q       (s_selecao_mux   ), 
        .fim     (fim_contador    ), 
        .meio    (                ) // Porta aberta (desconectada)
    );


    mux_8x1_n #(7) mux (
        .D7     ( s_hashtag       ),
        .D6     ( s_dado_ascii_centena),
        .D5     ( s_dado_ascii_dezena ),
        .D4     ( s_dado_ascii_unidade),
        .D3     ( s_virgula       ),
        .D2     ( s_angulo_unidade  ),
        .D1     ( s_angulo_dezena  ),
        .D0     ( s_angulo_centena  ),
        .SEL    ( s_selecao_mux   ),
        .MUX_OUT( s_saida_mux     )
    );
    
endmodule
