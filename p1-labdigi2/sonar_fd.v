module sonar_fd #(parameter MODULO_TIMER = 100000000)
(
    input wire        clock,
    input wire        reset,
    input wire        conta_posicao, 
    input wire        inicio_medir,
    input wire        echo,
    input wire        conta_timer,
    output wire       trigger,
    output wire       saida_serial,
    output wire       pwm,
    output wire       fim_2s,
    output wire       serial_enviado,
    output wire       db_echo,
    output wire       db_trigger,
    output wire [6:0] medida_unidade,
    output wire [6:0] medida_dezena,
    output wire [6:0] medida_centena,
    output wire [6:0] db_estado_interface,
    output wire [6:0] db_estado_serial
);

    // Sinais internos
    wire        s_trigger;
    wire [11:0] s_medida ;
    wire [3:0]  s_estado_interface ;
    wire [3:0]  s_estado_serial;
    wire        s_medida_pronta;
    wire        s_medir_pulso;
    wire [2:0]  s_posicao;
    wire [23:0] s_angulos;
	 

    // Circuito de interface com sensor
    interface_hcsr04 INT (
        .clock    (clock    ),
        .reset    (reset    ),
        .medir 	  (inicio_medir),
        .echo     (echo     ),
        .trigger  (s_trigger),
        .medida   (s_medida ),
        .pronto   (s_medida_pronta),
        .db_estado(s_estado_interface )
    );

    saida_serial serial (
        .clock          ( clock          ),
        .reset          ( reset          ),
        .inicio         ( s_medida_pronta),
        .dados          ( s_medida       ),
        .angulos        ( s_angulos      ),
        .saida_serial   ( saida_serial   ),
        .pronto         ( serial_enviado ),
        .db_inicio      (                ),
        .db_saida_serial (               ),
        .db_estado      ( )
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
        .conta(conta_timer),
        .Q(),
        .fim(fim_2s),
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

    // Define posição do servo motor
    contador_m #(
        .M(8),
        .N(3)
    )contador_posicao(
        .clock      ( clock         ),
        .zera_as    ( 1'b0          ),
        .zera_s     ( reset         ),
        .conta      ( conta_posicao ),
        .Q          ( s_posicao     ),
        .fim        (               ),
        .meio       (               )
    );


    // Displays para medida (4 dígitos BCD)
    hexa7seg H0 (
        .hexa   (s_medida[3:0]), 
        .display(medida_unidade)
    );
    hexa7seg H1 (
        .hexa   (s_medida[7:4]), 
        .display(medida_dezena)
    );
    hexa7seg H2 (
        .hexa   (s_medida[11:8]), 
        .display(medida_centena)
    );

    // Sinais de saída
    assign trigger = s_trigger;

    // Sinal de depuração (estado da UC da interface)
    hexa7seg HInterface (
        .hexa   (s_estado_interface ), 
        .display(db_estado_interface)
    );

    // Sinal de depuração (estado da UC da serial)
    hexa7seg HSerial (
        .hexa   (s_estado_serial ), 
        .display(db_estado_serial)
    );

    assign db_echo      = echo;
    assign db_trigger   = s_trigger;

endmodule