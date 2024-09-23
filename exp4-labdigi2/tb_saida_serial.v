`timescale 1ns / 1ps

module tb_saida_serial;

    // Parâmetros do clock
    reg clock;
    reg reset;
    reg inicio;
    reg [11:0] dados;
    wire saida_serial;
    wire pronto;
    wire db_inicio;
    wire db_saida_serial;
    wire [6:0] db_estado;

    // Instanciando o módulo a ser testado
    saida_serial uut (
        .clock(clock),
        .reset(reset),
        .inicio(inicio),
        .dados(dados),
        .saida_serial(saida_serial),
        .pronto(pronto),
        .db_inicio(db_inicio),
        .db_saida_serial(db_saida_serial),
        .db_estado(db_estado)
    );

    // Gerador de clock
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // Clock de 10ns de período
    end

    // Bloco de estímulo
    initial begin
        // Inicialização
        reset = 1;
        inicio = 0;
        dados = 12'b101010101010;

        // Aplicar reset
        #10;
        reset = 0;

        // Enviar dados
        #10;
        inicio = 1; // Ativar o início do processo

        #10;
        inicio = 0; // Desativar início

        // Aguardar alguns ciclos de clock
        #100;

        // Fim do teste
        $stop; // Para simulação
    end

    // Monitorando sinais
    initial begin
        $monitor("Time: %0t | Reset: %b | Inicio: %b | Dados: %b | Saida Serial: %b | Pronto: %b", 
                 $time, reset, inicio, dados, saida_serial, pronto);
    end

endmodule
