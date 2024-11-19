module envio_serial_automatico_uc (
    input      clock,
    input      reset,
    input      mudou_de_andar,
    input      enviado,
    input      fim_transmissao_conteudo_elevador,
    input      fim_transmissao_fila_elevador,
    input      eh_origem_fila_elevador,
    output reg     eh_conteudo_elevador,
    output reg     conta_conteudo_elevador,
    output reg    conta_fila_elevador,
    output reg    envia_serial,
    output reg    zera // conecta no reset do fd
);

    // Estados da UC
    parameter inicial                = 4'b0000; 
    parameter preparacao             = 4'b0001; 
    parameter transmissao_conteudo   = 4'b0011; 
    parameter conta_addr_conteudo    = 4'b0100; 
    parameter eh_para_transmitir_fila = 4'b1000;
    parameter transmissao_fila       = 4'b0101;
    parameter conta_addr_fila        = 4'b0110;
    parameter final                  = 4'b0111;

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Logica de proximo estado
    always @* begin
        case (Eatual)
            inicial                : Eprox = mudou_de_andar ? preparacao : inicial;
            preparacao             : Eprox = transmissao_conteudo;
            transmissao_conteudo   : Eprox = enviado ? (fim_transmissao_conteudo_elevador ? eh_para_transmitir_fila : conta_addr_conteudo) : transmissao_conteudo;
            conta_addr_conteudo    : Eprox = transmissao_conteudo;
            eh_para_transmitir_fila : Eprox = eh_origem_fila_elevador? transmissao_fila : conta_addr_fila;
            transmissao_fila       : Eprox = enviado ? (fim_transmissao_fila_elevador ? final : conta_addr_fila) : transmissao_fila;
            conta_addr_fila        : Eprox = eh_para_transmitir_fila;
            final                  : Eprox = inicial;
            default                : Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina de Moore)
    always @* begin
        zera                    = (Eatual == preparacao) ? 1'b1 : 1'b0;
        conta_conteudo_elevador = (Eatual == conta_addr_conteudo) ? 1'b1 : 1'b0;
        conta_fila_elevador     = (Eatual == conta_addr_fila) ? 1'b1 : 1'b0;
        envia_serial            = (Eatual == transmissao_conteudo || Eatual == transmissao_fila) ? 1'b1 : 1'b0;
        eh_conteudo_elevador    = (Eatual == transmissao_conteudo || Eatual == conta_addr_conteudo) ? 1'b1 : 1'b0; // pode dar algum problema de timing isso
    end

endmodule
