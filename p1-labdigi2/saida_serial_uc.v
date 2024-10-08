module saida_serial_uc ( 
    input  wire         clock            ,
    input  wire         reset            ,
    input  wire         inicio           ,
    input  wire         serial_enviado   ,
    input  wire         fim_contador     ,
    output reg          zera_contador    ,
    output reg          conta_contador   ,
    output reg          proximo          ,
    output reg          pronto           
);

    // Estados
    reg [2:0] Eatual, Eprox;

    parameter inicial               = 4'b000;
    parameter prepara               = 4'b001;
    parameter transmite             = 4'b010;
    parameter incrementa            = 4'b011;
    parameter fim                   = 4'b100;


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
            inicial:                Eprox = inicio ?        prepara    : inicial;
            prepara:                Eprox = transmite;
            transmite:              Eprox = serial_enviado? incrementa : transmite;
            incrementa:             Eprox = fim_contador?   fim        : prepara;
            fim:                    Eprox = inicial;       
            default:                Eprox = inicial;
        endcase
    end

    // Logica de saida
    always @* begin
        zera_contador       = (Eatual == inicial)         ? 1'b1 : 1'b0;
        proximo             = (Eatual == prepara)         ? 1'b1 : 1'b0;
        conta_contador      = (Eatual == incrementa)      ? 1'b1 : 1'b0;
        pronto              = (Eatual == fim)             ? 1'b1 : 1'b0;
    end

endmodule
