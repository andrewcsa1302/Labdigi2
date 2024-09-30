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
 
module sonar (
    input wire        clock,
    input wire        reset,
    input wire        ligar,
    input wire        echo,
    output wire       trigger,
    output wire       saida_serial,
	 output wire       pwm,
	 output wire       fim_posicao,
);

    sonar_fd fd (
    .clock(clock),
    .reset(reset),
    .mensurar(ligar),
	 .inicio_giro(),
	 .inicio_medir(),
    .echo(echo),
    .trigger(trigger),
    .saida_serial(saida_serial),
	 .pwm,(pwm)
	 .fim_posicao(fim_posicao),
	 .fim_1s(),
	 .fim_2s(),
    .medida0(),
    .medida1(),
    .medida2(),
    .pronto(),
    .db_mensurar(),
    .db_echo(),
    .db_trigger(),
    .db_estado()
);

 sonar_uc uc (
    .mensurar(ligar),
	 .reset(reset),
	 .fim_1s(),
	 .fim_2s(),
	 .inicio_giro(),
	 .inicio_medir(),
	 .transmite_dado();
	 
);



 
endmodule