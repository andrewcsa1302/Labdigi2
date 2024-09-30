module sonar_fd #(parameter MODULO_TIMER = 100000000)
(
    input wire        clock,
    input wire        reset,
    input wire        mensurar,
    input wire        inicio_giro,
    input wire        inicio_medir,
    input wire        echo,
    output wire       trigger,
    output wire       saida_serial,
    output wire       pwm,
    output wire		  fim_1s,
    output wire       fim_2s,
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
    wire        s_medida_pronta;
    wire 		s_mensurar_negado;
    wire        s_medir_pulso;
    wire [2:0]  s_posicao;
    wire [23:0] s_angulos;
	 
	assign s_mensurar_negado = ~mensurar;

    // Circuito de interface com sensor
    interface_hcsr04 INT (
        .clock    (clock    ),
        .reset    (reset    ),
        .medir 	  (inicio_medir),
        .echo     (echo     ),
        .trigger  (s_trigger),
        .medida   (s_medida ),
        .pronto   (s_medida_pronta),
        .db_estado(s_estado )
    );

    saida_serial serial (
        .clock          ( clock          ),
        .reset          ( reset          ),
        .inicio         ( s_medida_pronta),
        .dados          ( s_medida       ),
        .angulos        ( s_angulos      ),
        .saida_serial   ( saida_serial   ),
        .pronto         ( pronto         ),
        .db_inicio      (                ),
        .db_saida_serial (               ),
        .db_estado       (               )
    );

	//rom com angulos para serem transmitidos pelo serial
	rom_angulos_8x24 rom_angulos (
        .endereco(s_posicao), 
        .saida(s_angulos)
); 
	 
	 
	//conta 2s pela medicao
    contador_m #(
        .M(MODULO_TIMER),
        .N(28)
    )contador_2s(
        .clock(clock),
        .zera_as(1'b0),
        .zera_s(reset),
        .conta(inicio_medir),
        .Q(),
        .fim(fim_2s),
        .meio()
    );

    //conta 1s pelo giro
    contador_m #(
        .M(MODULO_TIMER/2),
        .N(28)
    )contador_1s(
        .clock(clock),
        .zera_as(1'b0),
        .zera_s(reset),
        .conta(inicio_giro),
        .Q(),
        .fim(fim_1s),
        .meio()
    );

    //servo motor
    controle_servo servo_motor (
        .clock(clock),
        .reset(reset),
        .posicao(s_posicao),
        .controle(pwm),
        .db_reset(),
        .db_posicao(),
        .db_controle()
);

    // Define posição do servo
    contadorg_updown_m #(
        .M(8),  // Módulo do contador
        .N(3)   // Número de bits de saída
    ) contador_posicao (
        .clock(clock),
        .zera_as(1'b0),
        .zera_s(reset),
        .conta(inicio_giro),
        .Q(s_posicao),
        .inicio(),
        .fim(),
        .meio(),
        .direcao()
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
        .sinal(s_mensurar_negado  ), 
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
    assign db_mensurar  = s_mensurar_negado;

endmodule