/* --------------------------------------------------------------------------
 *  Arquivo   : interface_hcsr04.v
 * --------------------------------------------------------------------------
 *  Descricao : circuito de interface com sensor ultrassonico de distancia
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */
 
module interface_hcsr04 (
    input wire         clock,
    input wire         reset,
    input wire         ligado,
    input wire         echo,
    output wire        trigger,
    output wire [1:0]  andar,
    output wire        pronto,
    output wire [3:0]  db_estado
);

    // Sinais internos
    wire        s_zera;
    wire        s_gera;
    wire        s_registra;
    wire        s_fim_medida;
    wire        s_fim_loop;
    wire [1:0]  s_medida;

    // Unidade de controle
    interface_hcsr04_uc U1 (
        .clock     (clock       ),
        .reset     (reset       ),
        .ligado    (ligado      ),
        .medir     (s_fim_loop  ),
        .echo      (echo        ),
        .fim_medida(s_fim_medida),
        .zera      (s_zera      ),
        .gera      (s_gera      ),
        .registra  (s_registra  ),
        .pronto    (pronto      ),
        .db_estado (db_estado   )
    );

    // Fluxo de dados
    interface_hcsr04_fd U2 (
        .clock     (clock       ),
        .reset     (reset       ),
        .pulso     (echo        ), 
        .zera      (s_zera      ),
        .gera      (s_gera      ),
        .registra  (s_registra  ),
        .fim_medida(s_fim_medida),
        .trigger   (trigger     ),
        .fim       (            ),  // (desconectado)
        .andar     (s_medida    ),
        .fim_loop  (s_fim_loop  )
    );

    // Saída
    assign andar = s_medida; 

endmodule