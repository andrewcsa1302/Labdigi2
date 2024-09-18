/* --------------------------------------------------------------------------
 *  Arquivo   : exp3_sensor.v
 * --------------------------------------------------------------------------
 *  Descricao : circuito de teste do componente interface_hcsr04.v
 *              inclui componentes para dispositivos externos
 *              detector de borda e codificadores de displays de 7 segmentos
 *
 *              usar para sintetizar projeto no Intel Quartus Prime
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */
 
module exp4_trena (
    input wire        clock,
    input wire        reset,
    input wire        mensurar,
    input wire        echo,
    output wire       trigger,
    output wire       saida_serial,
    output wire [6:0] medida0,
    output wire [6:0] medida1,
    output wire [6:0] medida2,
    output wire       pronto,
    output wire       db_mensurar,
    output wire       db_echo,
    output wire       db_trigger,
    output wire [6:0] db_estado
);

    // Sinais internos
    wire        s_mensurar;
    wire        s_trigger;
    wire [11:0] s_medida ;
    wire [3:0]  s_estado ;


    // Circuito de interface com sensor
    interface_hcsr04 INT (
        .clock    (clock    ),
        .reset    (reset    ),
        .mensurar (s_mensurar),
        .echo     (echo     ),
        .trigger  (s_trigger),
        .medida   (s_medida ),
        .pronto   (pronto   ),
        .db_estado(s_estado )
    );

    // NÃO SEI SE FAZ SENTIDO ISSO!!! PODE SER INSTANCIANDO O SAIDA_SERIAL QUE CUIDE INTERNAMENTE DA LÓGICA
    // Circuito de transmissão serial
    // Precisa instanciar um mux para passar um dado por vez e o hashtag
    // Precisa converter cada dígito BCD para ASCII, juntando com [0011] na frente


    tx_serial_7O1 serial (
        .clock           ( clock        ),
        .reset           ( reset        ),
        .partida         ( s_mensurar   ),
        .dados_ascii     ( s_dado_ascii ),
        .saida_serial    ( saida_serial ),
        .pronto          ( s_serial_pronto ),
        .db_clock        (              ), // Porta aberta (desconectada)
        .db_tick         (              ), // Porta aberta (desconectada)
        .db_partida      (              ), // Porta aberta (desconectada)
        .db_saida_serial (              ), // Porta aberta (desconectada)
        .db_estado       (              )  // Porta aberta (desconectada)
    );

    // Displays para medida (4 dígitos BCD)
    hexa7seg H0 (
        .hexa   (s_medida[3:0]), 
        .display(medida0      )
    );
    hexa7seg H1 (
        .hexa   (s_medida[7:4]), 
        .display(medida1      )
    );
    hexa7seg H2 (
        .hexa   (s_medida[11:8]), 
        .display(medida2       )
    );

    // Trata entrada mensurar (considerando borda de subida)
    edge_detector DB (
        .clock(clock  ),
        .reset(reset  ),
        .sinal(mensurar  ), 
        .pulso(s_mensurar)
    );

    // Sinais de saída
    assign trigger = s_trigger;

    // Sinal de depuração (estado da UC)
    hexa7seg H5 (
        .hexa   (s_estado ), 
        .display(db_estado)
    );

    assign db_echo      = echo;
    assign db_trigger   = s_trigger;
    assign db_mensurar  = mensurar;

endmodule