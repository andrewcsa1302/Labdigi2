module interpretador_andar(

    input        clock,
    input        reset,
    input        medir,
    input        echo,
	 input  [3:0] sensores,
    output       trigger,
    output wire [6:0] hex0,
    output wire [6:0] hex1,
    output wire [6:0] hex2,
	 output wire [6:0] hex3,
	 output wire  [1:0] saida_andar,
    output       pronto

);

wire [2:0]  compara;
wire [1:0] s_saida_andar;
wire [3:0] s_andar;
wire [1:0] s_display;
wire [1:0] andar;

assign compara =        (sensores == 4'b1110)? 3'b000:
                        (sensores == 4'b1101)? 3'b001:
                        (sensores == 4'b1011)? 3'b010:
                        (sensores == 4'b0111)? 3'b011:
                                               3'b111;
															
assign s_display =     (sensores == 4'b1111)? s_saida_andar: compara[1:0];

assign saida_andar = s_display;


andar_ultrassonico andar_ultrassonico_detec(
    .clock			(clock),
    .reset			(reset),
    .medir			(medir),
    .echo			(echo),
    .trigger		(trigger),
	 .hex1			(hex1),
	 .hex2			(hex2),
	 .hex3			(hex3),
	 .saida_andar  (s_saida_andar),
    .pronto			(pronto)
);	 
assign s_andar = {2'b00, s_display};

    hexa7seg H0 (
        .hexa   (s_andar ), 
        .display(hex0)
);



endmodule
