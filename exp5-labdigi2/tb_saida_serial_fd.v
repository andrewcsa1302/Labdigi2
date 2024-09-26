`timescale 1ns / 1ps

module tb_saida_serial_fd;

    // Sinais do testbench
    reg clock;
    reg reset;
    reg proximo;
    reg [1:0] selecao_mux;
    reg [11:0] dados;
    wire saida_serial;
    wire serial_pronto;

    // Instanciando o módulo a ser testado
    saida_serial_fd uut (
        .clock(clock),
        .reset(reset),
        .proximo(proximo),
        .selecao_mux(selecao_mux),
        .dados(dados),
        .saida_serial(saida_serial),
        .serial_pronto(serial_pronto)
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
        proximo = 0;
        selecao_mux = 2'b00; // Seleciona o primeiro dado
        dados = 12'b101010101010; // Exemplo de dados

        // Aplicar reset
        #10;
        reset = 0;

        // Ativar proximo para enviar o primeiro dado
        #20;
        proximo = 1; // Indica que deve pegar o próximo dígito

        // Verificar saída após ativar 'proximo'
        #20;
        proximo = 0; // Desativar 'proximo'

        // Testar a seleção de diferentes dados
        #20;
        selecao_mux = 2'b01; // Seleciona o segundo dado
        proximo = 1;
        #20;
        proximo = 0;

        #20;
        selecao_mux = 2'b10; // Seleciona o terceiro dado
        proximo = 1;
        #20;
        proximo = 0;

        #20;
        selecao_mux = 2'b11; // Seleciona o hashtag
        proximo = 1;
        #20;
        proximo = 0;

        // Aguardar alguns ciclos de clock para observar a saída
        #100;

        // Fim do teste
        $stop; // Para simulação
    end

    // Monitorando sinais
    initial begin
        $monitor("Time: %0t | Reset: %b | Proximo: %b | Seleção Mux: %b | Dados: %b | Saida Serial: %b | Serial Pronto: %b", 
                 $time, reset, proximo, selecao_mux, dados, saida_serial, serial_pronto);
    end

endmodule
