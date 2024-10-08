module sonar_uc (
    input clock,
    input ligar,
    input reset,
    input fim_2s,
	input movimento,
    output reg [3:0] db_estado,
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
    parameter move_ou_nao 	 = 4'b0100;
    parameter move_servo    = 4'b0101;
	 
	 
	always @(posedge clock, posedge reset) begin
        if (reset) 
            Eatual <= inicial;
        else
            Eatual <= Eprox; 
    end
	 
	 // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
            inicial:        Eprox = ligar ? preparacao : inicial;
            preparacao:     Eprox = envia_trigger;
            envia_trigger:  Eprox = espera_timer;
            espera_timer:   Eprox = fim_2s ? move_ou_nao : espera_timer;
            move_ou_nao:    Eprox = movimento? move_servo : inicial;
            move_servo:     Eprox = inicial;
            default: 
                Eprox = inicial;
        endcase
    end
	 
	 // Saidas de controle
    always @(*) begin
        inicio_medir    = (Eatual == envia_trigger)?    1'b1 : 1'b0;
        fim_posicao     = (Eatual == move_servo)?       1'b1 : 1'b0;
        conta_posicao   = (Eatual == move_servo)?       1'b1 : 1'b0;
        conta_timer     = (Eatual == espera_timer)?     1'b1 : 1'b0;
		 
    case (Eatual)
        inicial:       db_estado = 4'b0000;
        preparacao:    db_estado = 4'b0001;
        envia_trigger: db_estado = 4'b0010;
        espera_timer:  db_estado = 4'b0011;
        move_ou_nao:   db_estado = 4'b0100;
        move_servo:    db_estado = 4'b0101;
        default:       db_estado = 4'b0000;
    endcase

    end

    
endmodule