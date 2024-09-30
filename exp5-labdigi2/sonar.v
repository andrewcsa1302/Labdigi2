module sonar #(parameter TIMER = 100000000)
(
    input wire        clock,
    input wire        reset,
    input wire        ligar,
    input wire        echo,
    output wire       trigger,
    output wire       saida_serial,
    output wire       pwm,
    output wire       fim_posicao,
    output wire       db_estado_sonar
);

    wire s_inicio_giro;
    wire s_inicio_medir;
    wire s_fim_1s;
    wire s_fim_2s;
    wire [3:0] s_medida0;
    wire [3:0] s_medida1;
    wire [3:0] s_medida2;
    wire s_pronto;
    wire s_db_mensurar;
    wire s_db_echo;
    wire s_db_trigger;
    wire s_db_estado;
    wire s_transmite_dado;


    sonar_fd #(
        .MODULO_TIMER(TIMER)
    )fd (
        .clock(clock),
        .reset(reset),
        .mensurar(ligar),
        .inicio_giro(s_inicio_giro),
        .inicio_medir(s_inicio_medir),
        .echo(echo),
        .trigger(trigger),
        .saida_serial(saida_serial),
        .pwm (pwm),
        .fim_1s(s_fim_1s),
        .fim_2s(s_fim_2s),
        .medida0(),
        .medida1(),
        .medida2(),
        .pronto(), // serial enviado
        .db_mensurar(),
        .db_echo(),
        .db_trigger(),
        .db_estado()
);

    sonar_uc uc
    (
        .clock(clock),
        .mensurar(ligar),
        .reset(reset),
        .fim_1s(s_fim_1s),
        .fim_2s(s_fim_2s),
        .db_estado(s_db_estado),
        .inicio_giro(s_inicio_giro),
        .inicio_medir(s_inicio_medir),
        .fim_posicao(fim_posicao)
    );

    // Sinal de depuração (estado da UC)
    hexa7seg H5 (
        .hexa   (s_db_estado ), 
        .display(db_estado_sonar)
    );


 
endmodule