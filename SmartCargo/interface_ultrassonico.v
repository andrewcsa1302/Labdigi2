
module interface_ultrassonico #(parameter EPS = 2, h0 = 6, h1 = 15, h2 = 30, h3 = 40) (
    input wire        clock,
    input wire        reset,
    input wire        medir,
    input wire        echo,
    output wire       trigger,
    output wire [6:0] hex0,
    output wire [6:0] hex1,
    output wire [6:0] hex2,
    output wire [6:0] hex3,
    output wire       pronto,
    output wire       db_medir,
    output wire       db_echo,
    output wire       db_trigger,
    output wire [6:0] db_estado,
    output wire [1:0] andar_aproximado,
    output wire [1:0] andar_exato,
    output wire       mudou_andar_edge
);

    // Sinais internos
    wire        s_medir  ;
    wire        s_trigger;
    wire [11:0] s_medida, s_medida_imediata ;
    wire [3:0]  s_estado ;
    wire [3:0]  s_andar  ;
    wire [1:0]  andar;

    // Circuito de interface com sensor
    interface_hcsr04 INT (
        .clock    (clock    ),
        .reset    (reset    ),
        .medir    (s_medir  ),
        .echo     (echo     ),
        .trigger  (s_trigger),
        .medida   (s_medida_imediata ),
        .pronto   (pronto   ),
        .db_estado(s_estado )
    );

    // Registrador das medidas para evitar flutuacoes
    registrador_N #(12) reg_medida_ultrassonico(
    .clock     (clock),
    .clear     (reset),
    .enable    (pronto),
    .D         (s_medida_imediata),
    .Q         (s_medida)
);

    // Displays para medida (4 dígitos BCD)
    hexa7seg H0 (
        .hexa   (s_andar), 
        .display(hex0         )
    );
    hexa7seg H1 (
        .hexa   (s_medida[3:0]), 
        .display(hex1         )
    );
		  hexa7seg H2 (
        .hexa   (s_medida[7:4]), 
        .display(hex2          )
    );
	 hexa7seg H3 (
        .hexa   (s_medida[11:8]), 
        .display(hex3          )
    );

    // Trata entrada medir (considerando borda de subida)
    edge_detector DB (
        .clock(clock  ),
        .reset(reset  ),
        .sinal(medir  ), 
        .pulso(s_medir)
    );
	 //
	 conversor_andarXcm #(EPS, h0, h1, h2, h3) conversor(
        .reset (reset),
        .clock (clock),
		.unidades(s_medida[3:0]),  
		.dezenas(s_medida[7:4]),    
		.centenas(s_medida[11:8]),
        .andar_exato (andar_exato),   
		.andar_aproximado (andar_aproximado),
        .mudou_andar (mudou_andar)
	 );

    edge_detector detector_mudou_andar(
    .clock  (clock),
    .reset  (reset),
    .sinal  (mudou_andar),
    .pulso  (mudou_andar_edge)
);

    // Sinais de saída
    assign trigger = s_trigger;
	 
    assign s_andar = {2'b00, andar_aproximado};

    // Sinal de depuração (estado da UC)
    hexa7seg H5 (
        .hexa   (s_estado ), 
        .display(db_estado)
    );
    assign db_echo    = echo;
    assign db_trigger = s_trigger;
    assign db_medir   = medir;

endmodule