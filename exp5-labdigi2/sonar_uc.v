module sonar_uc (
    input clock,
    input mensurar,
    input reset,
    input fim_1s,
    input fim_2s,
    output reg [3:0] db_estado,
    output reg move_servo,
    output reg inicio_medir,
    output reg conta_posicao,
    output reg conta_timer,
    output reg fim_posicao
);

    // Estados
    reg [2:0] Eatual, Eprox;

    parameter inicial       = 4'b0000;
    parameter preparacao    = 4'b0001;
    parameter envia_trigger = 4'b0010;
    parameter espera_timer  = 4'b0011;
    parameter gira_servo 	= 4'b0100;
    parameter final_medida  = 4'b0101;
	 
	 
	always @(posedge clock, posedge reset) begin
        if (reset) 
            Eatual <= inicial;
        else
            Eatual <= Eprox; 
    end
	 
	 // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
            inicial:        Eprox = mensurar ? preparacao : inicial;
            preparacao:     Eprox = envia_trigger;
            envia_trigger:  Eprox = espera_timer;
            espera_timer:   Eprox = fim_2s ? gira_servo : espera_timer;
            gira_servo:     Eprox = final_medida;
            final_medida:   Eprox = inicial;
            default: 
                Eprox = inicial;
        endcase
    end
	 
	 // Saidas de controle
    always @(*) begin
        move_servo  = (Eatual == gira_servo)? 1'b1 : 1'b0;
        inicio_medir = (Eatual == envia_trigger)? 1'b1 : 1'b0;
        fim_posicao  = (Eatual == final_medida)? 1'b1 : 1'b0;
        conta_posicao = (Eatual == final_medida)? 1'b1 : 1'b0;
        conta_timer = (Eatual == espera_timer)? 1'b1 : 1'b0;
		 
    case (Eatual)
        inicial:       db_estado = 4'b0000;
        preparacao:    db_estado = 4'b0001;
        envia_trigger: db_estado = 4'b0010;
        espera_timer:  db_estado = 4'b0011;
        gira_servo:    db_estado = 4'b0100;
        final_medida:  db_estado = 4'b0101;
        default:       db_estado = 4'b0000;
    endcase

    end

    
endmodule