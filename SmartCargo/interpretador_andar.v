module interpretador_andar #(parameter EPS = 2, h0 = 6, h1 = 15, h2 = 30, h3 = 40)(

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
    output wire [1:0] andar_fusao_sensores,
    output wire [1:0] andar_aproximado,
    output       pronto

);

wire [2:0]  compara;
wire [1:0] s_andar_exato;
wire [3:0] s_andar;

assign compara =        (sensores == 4'b0001)? 3'b000:
                        (sensores == 4'b0010)? 3'b001:
                        (sensores == 4'b0100)? 3'b010:
                        (sensores == 4'b1000)? 3'b011:
                                               3'b100;
															
assign andar_fusao_sensores = (sensores == 4'b0000)? s_andar_exato: compara[1:0];



interface_ultrassonico #(EPS, h0, h1, h2, h3) andar_ultrassonico_detec(
    .clock			(clock),
    .reset			(reset),
    .medir			(medir),
    .echo			(echo),
    .trigger		(trigger),
    .hex1			(hex1),
    .hex2			(hex2),
    .hex3			(hex3),
    .andar_exato    (s_andar_exato),
    .pronto			(pronto),
    .andar_aproximado  (andar_aproximado)
);	 
assign s_andar = {2'b00, andar_fusao_sensores};

hexa7seg H0 (
    .hexa   (s_andar ), 
    .display(hex0)
);



endmodule
