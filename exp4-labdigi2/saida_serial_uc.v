module saida_serial_uc ( 
    input  wire         clock            ,
    input  wire         reset            ,
    input  wire         inicio           ,
    input  wire         serial_enviado   ,
    output reg [1:0]    selecao_mux      ,
    output reg          proximo          ,
    output reg          pronto           
);

    // Estados
    reg [3:0] Eatual, Eprox;

    parameter inicial               = 4'b0000;
    parameter start                 = 4'b1111;
    parameter transmite_centena     = 4'b0001;
    parameter incrementa_1          = 4'b0010;
    parameter transmite_dezena      = 4'b0011;
    parameter incrementa_2          = 4'b0100;
    parameter transmite_unidade     = 4'b0101;
    parameter incrementa_3          = 4'b0110;
    parameter transmite_hashtag     = 4'b0111;
    parameter fim                   = 4'b1000;


    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
            inicial:                Eprox = inicio ?           start  : inicial;
            start:                  Eprox = transmite_centena;
            transmite_centena:      Eprox = serial_enviado?    incrementa_1 : transmite_centena;
            incrementa_1:           Eprox = transmite_dezena;
            transmite_dezena:       Eprox = serial_enviado?    incrementa_2 : transmite_dezena;
            incrementa_2:           Eprox = transmite_unidade;
            transmite_unidade:      Eprox = serial_enviado?    incrementa_3 : transmite_unidade;
            incrementa_3:           Eprox = transmite_hashtag;
            transmite_hashtag:      Eprox = serial_enviado?    fim          : transmite_hashtag;
            fim:                    Eprox = inicial;            
            default:                Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina de Moore)
    always @* begin
        selecao_mux = (Eatual == transmite_centena) ? 2'b00 :
                      (Eatual == transmite_dezena) ? 2'b01 :
                      (Eatual == transmite_unidade) ? 2'b10 :
                      (Eatual == transmite_hashtag) ? 2'b11 :
                                                2'b11 ; // Isso vai dar problema
        pronto = (Eatual == fim) ? 1'b1 : 1'b0;

        proximo = (Eatual == start) ||
                  (Eatual == incrementa_1) ||
                  (Eatual == incrementa_2) ||
                  (Eatual == incrementa_3) ? 1'b1 : 1'b0;
                  
    end

    assign db_estado = Eatual;

endmodule
