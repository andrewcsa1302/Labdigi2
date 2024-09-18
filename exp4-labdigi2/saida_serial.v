module saida_serial (
    input        clock           ,
    input        reset           ,
    input        inicio          , 
    input [11:0] dados           ,
    output       saida_serial    ,
    output       pronto          ,
    output       db_inicio       ,
    output       db_saida_serial ,
    output [6:0] db_estado          
);

    // Circuito de transmissão serial
    // Precisa instanciar um mux para passar um dado por vez e o hashtag
    // Precisa converter cada dígito BCD para ASCII, juntando com [0011] na frente

    // Sinais internos
    wire [6:0]  s_dado_ascii;
    wire        s_serial_pronto;

    // Precisa passar certo os inouts de cada módulo

    // fluxo de dados
    saida_serial_fd U1_FD (
        .clock        ( clock          ),
        .reset        ( s_reset        ),
        .zera         ( s_zera         ),
        .conta        ( s_conta        ),
        .carrega      ( s_carrega      ),
        .desloca      ( s_desloca      ),
        .dados_ascii  ( dados_ascii    ),
        .saida_serial ( s_saida_serial ),
        .fim          ( s_fim          )
    );


    // unidade de controle
    saida_serial_uc U2_UC (
        .clock     ( clock        ),
        .reset     ( s_reset      ),
        .partida   ( s_partida_ed ),
        .tick      ( s_tick       ),
        .fim       ( s_fim        ),
        .zera      ( s_zera       ),
        .conta     ( s_conta      ),
        .carrega   ( s_carrega    ),
        .desloca   ( s_desloca    ),
        .pronto    ( pronto       ),
        .db_estado ( s_estado     )
    );

    // saida serial
    assign saida_serial = s_saida_serial;

    // depuracao
    assign db_saida_serial = s_saida_serial;
    assign db_inicio        = inicio;

    // hexa0
    hexa7seg HEX0 ( 
        .hexa    ( s_estado  ), 
        .display ( db_estado )
    );
  
endmodule