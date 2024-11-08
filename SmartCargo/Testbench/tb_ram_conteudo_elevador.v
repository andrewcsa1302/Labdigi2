`timescale 1ns / 1ns

module tb_ram_conteudo_elevador;
    reg clk;
    reg clear;
    reg [1:0] in_tipo_objeto;
    reg [1:0] in_destino_objeto;
    reg shift;
    reg weT;
    reg tira_objetos;
    reg [1:0] andar_atual;
    wire [1:0] tipo_objeto_da_vez;
    wire [1:0] destino_objeto_da_vez;
    wire tem_vaga;
    reg [3:0] addr;

    integer i;

    // dut
    ram_conteudo_elevador dut (
        .clk(clk),
        .clear (clear),
        .in_tipo_objeto(in_tipo_objeto),
        .in_destino_objeto(in_destino_objeto),
        .shift(shift),
        .weT(weT),
        .tira_objetos(tira_objetos),
        .andar_atual(andar_atual),
        .tipo_objeto(tipo_objeto_da_vez),
        .destino_objeto(destino_objeto_da_vez),
        .tem_vaga(tem_vaga),
        .addr(addr)
    );

    // gerador de clock
    initial clk = 0;
    always #2 clk = ~clk;

    // testes
    initial begin
        // Teste de reset
        clear = 1;
        #5;
        clear = 0;
        #5;
        
        // Verificação do reset
        for (i = 0; i < 8; i = i + 1) begin
            if (dut.ram[i] !== 4'b0000) begin
                $display("Erro: RAM[%0d] não foi resetada corretamente.", i);
            end
        end
        $display("Teste de reset concluido.");

        // Preenchimento da RAM
        for (i = 0; i < 8; i = i + 1) begin
            in_tipo_objeto = i[1:0];
            in_destino_objeto = (i + 1) & 2'b11;
            weT = 1;
            #4;
            weT = 0;
            #4;
        end

        // Verificação do preenchimento
        for (i = 0; i < 8; i = i + 1) begin
            $display("RAM[%0d] = %b", i, dut.ram[i]);
        end
            $display("Tem vaga: %b", tem_vaga);

        // Remoção de objetos por andar
        for (andar_atual = 0; andar_atual < 4; andar_atual = andar_atual + 1) begin
            tira_objetos = 1;
            addr = andar_atual + 1;
            #4;
            tira_objetos = 0;
            #4;
            $display("Apos remover objetos do andar %0d:", andar_atual);
            for (i = 0; i < 8; i = i + 1) begin
                $display("RAM[%0d] = %b", i, dut.ram[i]);
            end
                $display("Tem vaga: %b", tem_vaga);
                $display("Tipo do addr %b: %b", addr, tipo_objeto_da_vez);
                $display("Destino do addr %b: %b",addr, destino_objeto_da_vez);
            if (andar_atual == 3) begin
                $display("Teste de remocao de objetos concluido.");
                $finish;
            end
        end

    end
endmodule