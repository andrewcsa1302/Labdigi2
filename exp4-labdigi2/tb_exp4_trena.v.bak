`timescale 1ns / 1ns

module tb_exp4_trena;

    // Sinais do testbench
    reg clock;
    reg reset;
    reg mensurar;
    reg echo;
    wire trigger;
    wire saida_serial;
    wire [6:0] medida0;
    wire [6:0] medida1;
    wire [6:0] medida2;
    wire pronto;
    wire db_mensurar;
    wire db_echo;
    wire db_trigger;
    wire [6:0] db_estado;

    // Instanciando o módulo a ser testado
    exp4_trena uut (
        .clock(clock),
        .reset(reset),
        .mensurar(mensurar),
        .echo(echo),
        .trigger(trigger),
        .saida_serial(saida_serial),
        .medida0(medida0),
        .medida1(medida1),
        .medida2(medida2),
        .pronto(pronto),
        .db_mensurar(db_mensurar),
        .db_echo(db_echo),
        .db_trigger(db_trigger),
        .db_estado(db_estado)
    );

    // Gerador de clock
    initial begin
        clock = 0;
        forever #10 clock = ~clock; // Clock de 20ns de período
    end

    // Bloco de estímulo
    initial begin
        // Inicialização
        reset = 1;
        mensurar = 0;
        echo = 0;

        // Aplicar reset
        #2000;
        reset = 0;

        // Simulação do sinal de mensurar
        #100000;
        mensurar = 1; // Ativar mensuração
        #100;
        mensurar = 0; // Desativar mensuração

        // Simulação do sinal de echo
        #(400_000);
        echo = 1; // Simulando o eco
        #5882000;
        echo = 0; // Finaliza o eco

        // Esperar um pouco para observar os resultados
        #500000000;

        // Fim do teste
        $stop; // Para simulação
    end

    // Monitorando sinais
    initial begin
        $monitor("Time: %0t | Reset: %b | Mensurar: %b | Echo: %b | Trigger: %b | Saida Serial: %b | Pronto: %b | Medida0: %b | Medida1: %b | Medida2: %b",
                 $time, reset, mensurar, echo, trigger, saida_serial, pronto, medida0, medida1, medida2);
    end

endmodule
