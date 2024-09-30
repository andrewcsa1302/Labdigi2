module sonar_uc (
    input mensurar,
	 input reset,
	 input fim_1s,
	 input fim_2s,
	 output reg inicio_giro,
	 output reg inicio_medir,
	 output reg transmite_dado;
	 
);

	 parameter inicial       = 4'b0000;
    parameter preparacao    = 4'b0001;
    parameter envia_trigger = 4'b0010;
	 parameter trigger       = 4'b0011;
	 parameter envia_giro 	 = 4'b0111;
	 parameter giro          = 4'b1000;
    parameter final_medida  = 4'b1001;
	 
	 
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
            envia_trigger:  Eprox = trigger;
				trigger:        Eprox = fim_2s ? envia_giro : trigger;
				envia_giro:     Eprox = giro;
				giro:           Eprox = fim_1s ? final_medida : envia_giro;
            final_medida:   Eprox = inicial;
            default: 
                Eprox = inicial;
        endcase
    end
	 
	 // Saidas de controle
    always @(*) begin
        inicio_giro  = (Eatual == envia_giro)? 1'b1 : 1'b0;
        inicio_medir = (Eatual == envia_trigger)? 1'b1 : 1'b0;
		 

        case (Eatual)
            inicial:       db_estado = 4'b0000;
            preparacao:    db_estado = 4'b0001;
            envia_trigger: db_estado = 4'b0010;
            espera_echo:   db_estado = 4'b0011;           
            final_medida:  db_estado = 4'b1111;
            default:       db_estado = 4'b1110;
        endcase
    end

    
endmodule