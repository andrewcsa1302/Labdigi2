
module interface_ultrassonico (
    input wire        clock,
    input wire        reset,
    input wire        medir,
    input wire        echo,
    output wire       trigger,
    output wire [6:0] hex0,
    output wire [6:0] hex1,
    output wire [6:0] hex2,
    output wire [6:0] hex3,
    output wire [1:0] saida_andar,
    output wire       pronto,
    output wire       db_medir,
    output wire       db_echo,
    output wire       db_trigger,
    output wire [6:0] db_estado
);

    // Sinais internos
    wire        s_medir  ;
    wire        s_trigger;
    wire [11:0] s_medida ;
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
        .medida   (s_medida ),
        .pronto   (pronto   ),
        .db_estado(s_estado )
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
	 conversor_andarXcm conversor(
		.unidades(s_medida[3:0]),  
		.dezenas(s_medida[7:4]),    
		.centenas(s_medida[11:8]),   
		.andar(andar) 
	 );

    // Sinais de saída
    assign trigger = s_trigger;
	 
	 assign s_andar = {2'b00, andar};
	 
	 assign saida_andar = andar;
	 
	 

    // Sinal de depuração (estado da UC)
    hexa7seg H5 (
        .hexa   (s_estado ), 
        .display(db_estado)
    );
    assign db_echo    = echo;
    assign db_trigger = s_trigger;
    assign db_medir   = medir;

endmodule