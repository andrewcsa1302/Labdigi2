module uc_movimento(
    input       clock,
    input       reset,
    input       iniciar, 
    input       chegouDestino, 
    input       bordaSensorAtivo,
    input       fimT,
    input       temDestino,
    input       sobe,
    input       eh_origem,  
    output reg  dbQuintoBitEstado, 
    output reg  shift,
    output reg  enableRAM, // falta designacao
    output reg  contaT, 
    output reg  zeraT,
    output reg  clearAndarAtual, // falta designacao
    output reg  clearSuperRam,
    output reg  select2,
    output reg  enableAndarAtual,
    output [3:0] Eatual1_db,
    output reg motorSubindo,
    output reg motorDescendo,
    output reg tira_objetos,
    output reg coloca_objetos
);


// variaveis internas da UC

// reg [1:0] acaoElevador;  // 00 vazio, 01 subindo, 10 descendo, 11 parado

reg [4:0] Eatual, Eprox;



assign Eatual1_db = Eatual[3:0];



// estados da máquina de estados
// UNDERLINE para separar palavras somente aqui !!
parameter inicial               = 5'b00000; // 0
parameter inicializa_elementos  = 5'b00001; // 1
parameter prox_pedido           = 5'b00010; // 2
parameter subindo               = 5'b00011; // 3 
parameter descendo              = 5'b00100; // 4
parameter registra_subindo      = 5'b00101; // 5
parameter checa_subindo         = 5'b00110; // 6
parameter shift_fila            = 5'b00111; // 7
parameter aguarda_passageiro    = 5'b01000; // 8
parameter registra_descendo     = 5'b01001; // 9
parameter checa_descendo        = 5'b01010; // A
parameter entra_elevador        = 5'b01011; // B
parameter sai_elevador          = 5'b01100; // C




initial Eatual = inicial;

// Transicao de estado todo clock
always @(posedge clock or posedge reset) begin
    if (reset)
        Eatual <= inicial;
    
    else
        Eatual <= Eprox;
end

// Logica de proximo estado (Moore)
always @* begin
    case (Eatual)

        // Transicao usual 
        inicial:                    Eprox = iniciar? inicializa_elementos : inicial;
        inicializa_elementos:       Eprox = prox_pedido;
        prox_pedido:                Eprox = (temDestino? (sobe? subindo : descendo) : prox_pedido);
        subindo:                    Eprox = bordaSensorAtivo? registra_subindo : subindo;
        descendo:                   Eprox = bordaSensorAtivo? registra_descendo : descendo;
        checa_subindo:              Eprox = chegouDestino ? (eh_origem? entra_elevador : sai_elevador) : subindo;
        checa_descendo:             Eprox = chegouDestino ? (eh_origem? entra_elevador : sai_elevador) : descendo;
        registra_subindo:           Eprox = checa_subindo;
        registra_descendo:          Eprox = checa_descendo;
        entra_elevador:             Eprox = shift_fila; // soh funciona para pegar 1 obj por vez, pq só estará passando uma borda do coloca_objetos           
        sai_elevador:               Eprox = shift_fila;
        shift_fila:                 Eprox = aguarda_passageiro; 
        aguarda_passageiro:         Eprox = fimT? prox_pedido : aguarda_passageiro;

        default:                    Eprox = inicial;
    endcase
end

    // Logica dos sinais de controle
    always @* begin

        shift               = (Eatual == shift_fila);

        contaT              = ((Eatual == descendo) || (Eatual == subindo) || (Eatual == aguarda_passageiro));
        zeraT               = ((Eatual == prox_pedido) || (Eatual == shift_fila));

        select2             = (Eatual == registra_subindo);
        enableAndarAtual    = ((Eatual == registra_subindo) || (Eatual == registra_descendo));

        // Saídas do conteúdo do elevador

        coloca_objetos      = (Eatual == entra_elevador);
        tira_objetos        = (Eatual == sai_elevador);

        // Saídas motor 

        motorDescendo       = (Eatual == registra_descendo || Eatual == descendo || Eatual == checa_descendo);
        motorSubindo        = (Eatual == registra_subindo || Eatual == subindo || Eatual == checa_subindo);

        // inicializacoes
        clearSuperRam       = (Eatual == inicializa_elementos);

    end

endmodule