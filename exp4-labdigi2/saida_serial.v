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

    wire s_serial_pronto;
    wire s_proximo;
    wire [1:0] s_selecao_mux;
    wire s_saida_serial;
    
    saida_serial_fd serial_fd (
        .clock          ( clock        ),
        .reset          ( reset        ),
        .proximo        ( s_proximo     ),
        .selecao_mux    ( s_selecao_mux ),
        .dados          ( dados         ),
        .saida_serial   ( s_saida_serial ),
        .serial_pronto  ( s_serial_pronto )
    );

    saida_serial_uc serial_uc (
        .clock           ( clock          ),
        .reset           ( reset          ),
        .inicio          ( inicio         ),
        .serial_enviado  ( s_serial_pronto),
        .selecao_mux     ( s_selecao_mux   ),
        .proximo         ( s_proximo      ),
        .pronto          ( pronto         )
    );
    
    // saida serial
    assign saida_serial = s_saida_serial;

    // depuracao
    assign db_saida_serial = s_saida_serial;
    assign db_inicio       = inicio;
  
endmodule