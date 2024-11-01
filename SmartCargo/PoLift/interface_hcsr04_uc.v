/* --------------------------------------------------------------------------
 *  Arquivo   : interface_hcsr04_uc.v
 * --------------------------------------------------------------------------
 *  Descricao : Codigo da unidade de controle do circuito de 
 *              interface com sensor ultrassonico de distancia
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */
 
module interface_hcsr04_uc (
    input wire       clock,
    input wire       reset,
    input wire       medir,
    input wire       echo,
    input wire       fim_medida,
    input wire       ligado,
    output reg       inicia_loop,
    output reg       zera,
    output reg       gera,
    output reg       registra,
    output reg       pronto,
    output reg [3:0] db_estado 
);

    // Tipos e sinais
    reg [2:0] Eatual, Eprox; // 3 bits são suficientes para 7 estados

    // Parâmetros para os estados
    parameter inicial       = 4'b0000;
    parameter preparacao    = 4'b0001;
    parameter envia_trigger = 4'b0010;
    parameter espera_echo   = 4'b0011;
    parameter medida        = 4'b0100;
    parameter armazenamento = 4'b0101;
    parameter final_medida  = 4'b0110;
    parameter inicial_loop  = 4'b0111;
	 parameter espera_loop   = 4'b1100;

    // Estado
    always @(posedge clock, posedge reset) begin
        if (reset) 
            Eatual <= inicial;
        else
            Eatual <= Eprox; 
    end

    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
            inicial:        Eprox = ligado ? inicial_loop : inicial;
            inicial_loop:   Eprox = espera_loop;
				espera_loop:	 Eprox = medir ? preparacao : inicial_loop;
            preparacao:     Eprox = envia_trigger;
            envia_trigger:  Eprox = espera_echo;
            espera_echo:    Eprox = medir ? envia_trigger : echo ? medida : espera_echo;
            medida:         Eprox = fim_medida ? armazenamento : medida;
            armazenamento:  Eprox = final_medida;
            final_medida:   Eprox = inicial;
            default: 
                Eprox = inicial;
        endcase
    end

    // Saidas de controle
    always @(*) begin
        zera        = (Eatual == preparacao)? 1'b1 : 1'b0;
        pronto      = (Eatual == fim_medida)? 1'b1 : 1'b0;
        gera        = (Eatual == envia_trigger)? 1'b1 : 1'b0;
        registra    = (Eatual == armazenamento)? 1'b1 : 1'b0;
        pronto      = (Eatual == final_medida)? 1'b1 : 1'b0; 
        inicia_loop = (Eatual == inicial_loop)? 1'b1 : 1'b0;

        case (Eatual)
            inicial:       db_estado = 4'b0000;
            preparacao:    db_estado = 4'b0001;
            envia_trigger: db_estado = 4'b0010;
            espera_echo:   db_estado = 4'b0011;
            medida:        db_estado = 4'b0100;
            armazenamento: db_estado = 4'b0101;
            final_medida:  db_estado = 4'b1111;
				inicial_loop:  db_estado = 4'b1001;
				espera_loop:   db_estado = 4'b1100;
            default:       db_estado = 4'b1110;
        endcase
    end

endmodule