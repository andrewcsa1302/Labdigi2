module sonar #(parameter TIMER = 100000000)
(
    input wire        clock,
    input wire        reset,
    input wire        ligar,
    input wire        echo,
    input wire        movimento,
    output wire       trigger,
    output wire       saida_serial,
    output wire       pwm,
    output wire [6:0] medida_unidade,
    output wire [6:0] medida_dezena,
    output wire [6:0] medida_centena,
    output wire       fim_posicao,
    output wire [6:0] db_estado_sonar,
    output wire       final_timer
);

    wire s_inicio_medir;
    wire s_fim_2s;
    wire [6:0] s_medida_unidade;
    wire [6:0] s_medida_dezena;
    wire [6:0] s_medida_centena;
    wire s_pronto;
    wire s_db_mensurar;
    wire s_db_echo;
    wire s_db_trigger;
    wire [3:0] s_db_estado;
    wire s_transmite_dado;
    wire s_conta_posicao;
    wire s_conta_timer;

    sonar_fd #(
        .MODULO_TIMER(TIMER)
    )fd (
        .clock(clock),
        .reset(reset),
        .inicio_medir(s_inicio_medir),
        .echo(echo),
        .trigger(trigger),
        .saida_serial(saida_serial),
        .pwm (pwm),
        .fim_2s(s_fim_2s),
        .medida_unidade (medida_unidade),
        .medida_dezena (medida_dezena),
        .medida_centena (medida_centena),
        .serial_enviado(), // serial enviado
        .conta_posicao (s_conta_posicao),
        .conta_timer(s_conta_timer),
        .db_echo(),
        .db_trigger(),
        .db_estado_interface(),
        .db_estado_serial()
);

    sonar_uc uc
    (
        .clock(clock),
        .ligar(ligar),
        .reset(reset),
        .fim_2s(s_fim_2s),
        .movimento(movimento),
        .db_estado(s_db_estado),
        .inicio_medir(s_inicio_medir),
        .conta_posicao (s_conta_posicao),
        .conta_timer(s_conta_timer),
        .fim_posicao(fim_posicao)
    );

    // Sinal de depuração (estado da UC)
    hexa7seg H5 (
        .hexa   (s_db_estado ), 
        .display(db_estado_sonar)
    );

    assign final_timer = s_fim_2s;


 
endmodule