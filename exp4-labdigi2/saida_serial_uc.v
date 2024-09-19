module saida_serial_uc ( 
    input      clock            ,
    input      reset            ,
    input      inicio           ,
    input      serial_enviado   ,
    output reg [1:0] selecao_mux,
    output reg pronto           ,
    output reg [3:0] db_estado
);
    // Chave seletora para o mux
    reg [1:0] selecao_mux; // precisa inicializar

    // Estados
    reg [3:0] Eatual, Eprox;

    parameter inicial        = 4'b0000;
    parameter transmite_0    = 4'b0001;
    parameter incrementa_0   = 4'b0010;
    parameter transmite_1    = 4'b0011;
    parameter incrementa_1   = 4'b0100;
    parameter transmite_2    = 4'b0101;
    parameter incrementa_2   = 4'b0110;
    parameter transmite_3    = 4'b0111;
    parameter fim            = 4'b1000;


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
            inicial:        Eprox = inicio ?           transmite_0  : inicial;
            transmite_0:    Eprox = serial_enviado?    incrementa_0 : transmite_0;
            incrementa_0:   Eprox = transmite_1;
            transmite_1:    Eprox = serial_enviado?    incrementa_1 : transmite_1;
            incrementa_1:   Eprox = transmite_2;
            transmite_2:    Eprox = serial_enviado?    incrementa_2 : transmite_2;
            incrementa_2:   Eprox = transmite_3;
            transmite_3:    Eprox = serial_enviado?    fim          : transmite_3;
            fim:            Eprox = inicial;            
            default:        Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina de Moore)
    always @* begin
        selecao_mux = (Eatual == transmite_0) ? 2'b00 :
                      (Eatual == transmite_1) ? 2'b01 :
                      (Eatual == transmite_2) ? 2'b10 :
                      (Eatual == transmite_3) ? 2'b11 :
                                                2'b00 ; // Isso vai dar problema
        pronto = (Eatual == fim) ? 1'b1 : 1'b0;
    end

    assign db_estado = Eatual;

endmodule
