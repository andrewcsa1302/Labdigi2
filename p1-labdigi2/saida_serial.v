module saida_serial (
    input        clock           ,
    input        reset           ,
    input        inicio          , 
    input [11:0] dados           ,
    input [23:0] angulos         ,
    output       saida_serial    ,
    output       pronto          ,
    output       db_inicio       ,
    output       db_saida_serial ,
    output [3:0] db_estado          
);

    wire s_serial_pronto;
    wire s_proximo;
    wire [1:0] s_selecao_mux;
    wire s_saida_serial;
    wire s_fim_contador;
    wire s_conta_contador;
    wire s_zera_contador;
    

    saida_serial_fd serial_fd (
        .clock          ( clock            ),
        .reset          ( reset            ),
        .proximo        ( s_proximo        ),
        .zera_contador  ( s_zera_contador  ),
        .conta_contador ( s_conta_contador ),
        .dados          ( dados            ),
        .angulos        ( angulos          ),
        .saida_serial   ( s_saida_serial   ),
        .fim_contador   ( s_fim_contador   ),
        .serial_pronto  ( s_serial_pronto  )
    );

    saida_serial_uc serial_uc (
        .clock           ( clock           ),
        .reset           ( reset           ),
        .inicio          ( inicio          ),
        .serial_enviado  ( s_serial_pronto ),
        .fim_contador    ( s_fim_contador  ),
        .zera_contador   ( s_zera_contador ),
        .conta_contador  ( s_conta_contador),
        .proximo         ( s_proximo       ),
        .pronto          ( pronto          )
    );
    
    // saida serial
    assign saida_serial = s_saida_serial;

    // depuracao
    assign db_saida_serial = s_saida_serial;
    assign db_inicio       = inicio;
  
endmodule