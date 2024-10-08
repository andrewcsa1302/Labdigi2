`timescale 1ns / 1ns

module sonar_tb;

    //Sinais do testbench
    reg clock;
    reg reset;
    reg ligar;
    reg echo;
    wire trigger;
    wire saida_serial;
    wire [6:0] medida0;
    wire [6:0] medida1;
    wire [6:0] medida2;
    wire pwm;
    wire fim_posicao;
    wire db_pronto_medida;
    wire db_medir;
    wire db_echo;
    wire db_trigger;
    wire db_pwm;
    wire db_saida_serial;
    wire [6:0] db_estado;
    wire db_pronto_transmissao;
    wire [6:0] db_seletor;
    wire [6:0] db_contador_angulo;
    
    // Instanciação do DUT
    sonar #(
        .TIMER(2_500_000) //
    ) DUT (
        .clock(clock),
        .reset(reset),
        .ligar(ligar),
        .echo(echo),
        .trigger(trigger),
        .saida_serial(saida_serial),
        .pwm(pwm),
        .fim_posicao(fim_posicao),
        .db_estado_sonar(db_estado)
    );


    // Configuração do clock
    parameter clockPeriod = 20; // em ns, f=50MHz

    // Gerador de clock
    always #(clockPeriod / 2) clock = ~clock;

     // Largura do pulso
    reg [31:0] larguraPulso; // Usando 32 bits para acomodar tempos maiores 

    // Vetor de teste
    reg [11:0] vetor_medidas [0:6];
    reg [31:0] vetor_echo [0:6];
    integer caso;

    initial begin
        vetor_medidas[0] = {4'd1, 4'd1, 4'd1}; // BCD
        vetor_echo[0] = 6529; // 6529us (valor para 111cm)

        vetor_medidas[1] = {4'd2, 4'd0, 4'd7}; // BCD
        vetor_echo[1] = 12175; // us

        vetor_medidas[2] = {4'd2, 4'd2, 4'd5}; //BCD
        vetor_echo[2] = 1470; // us

        vetor_medidas[3] = {4'd0, 4'd8, 4'd0}; //BCD
        vetor_echo[3] = 4705; // us

        vetor_medidas[4] = {4'd0, 4'd6, 4'd8}; //BCD
        vetor_echo[4] = 4000; // us

        vetor_medidas[5] = {4'd0, 4'd4, 4'd5}; //BCD
        vetor_echo[5] = 2647; // us

        vetor_medidas[6] = {4'd0, 4'd7, 4'd9}; //BCD
        vetor_echo[6] = 4646; // us

        clock         = 1'b0;
        reset         = 1'b0;
        caso          = 1'b0;
        ligar         = 1'b0;
        echo          = 1'b0;
        // Reset
        caso = 0; 
        #(2*clockPeriod);
        reset = 1;
        #(2_000); // 2 us
        reset = 0;
        @(negedge clock);

        ligar = 1;
        // Espera de 2us
        #(2_000); // 2 us

        for (caso = 0; caso < 6; caso = caso + 1) begin
            
            // 1) Determina a largura do pulso echo
            larguraPulso = vetor_echo[caso]*1000; // 1us=1000

            // 2) Espera por 100us após o trigger baixar (tempo de medida)
            @(negedge trigger)
            #(100_000); // 100 us

            // 3) Gera pulso de echo
            echo = 1;
            #(larguraPulso);
            echo = 0;

            // 4) Espera até a transmissão da medida
            #(764_000); // Aproximadamente 11*8.68us*8

            // 5) Espera o delay de 2s
            #(5_000_000); // 5ms

        end

        // Fim da simulação
        caso = 99;
        #(10*clockPeriod); // Aguarda um pequeno tempo para garantir que o clock pare
        $stop;
        end 
    endmodule