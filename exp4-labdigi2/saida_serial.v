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


    saida_serial_fd serial_fd (
        .clock        ( clock        ),
        .reset        ( reset        ),
        .proximo      ( conta        ),
        .conta        ( carrega      ),
        .carrega      ( desloca      ),
        .dados_ascii  ( s_dado_ascii_0),
        .saida_serial ( saida_serial ),
        .fim          ( fim          )
    );

    saida_serial_uc serial_uc (
        .clock           ( clock          ),
        .reset           ( reset          ),
        .inicio          ( proximo        ),
        .serial_enviado  ( s_serial_pronto),
        .selecao_mux     ( selecao_mux    ),
        .pronto          ( pronto         ),
        .db_estado       ( db_estado      )
    );


    // saida serial
    assign saida_serial = s_saida_serial;

    // depuracao
    assign db_saida_serial = s_saida_serial;
    assign db_inicio       = inicio;

    // hexa0
    hexa7seg HEX0 ( 
        .hexa    ( s_estado  ), 
        .display ( db_estado )
    );
  
endmodule