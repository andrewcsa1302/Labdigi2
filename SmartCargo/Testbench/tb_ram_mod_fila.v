`timescale 1ns / 1ns

module tb_ram_mod;
    reg clk;
    reg we = 0;
    reg in_eh_origem;
    reg [1:0] in_tipo_objeto;
    reg [1:0] in_origem_objeto;
    reg [1:0] in_destino_objeto;
    reg [3:0] addrSecAnt, addrSec;
    reg [3:0] addr;
    reg shift = 0;
    reg weT = 0;
    reg fit = 0;
    reg clear = 0;
    wire [1:0] saidaSecundaria, saidaSecundariaAnterior;
    wire eh_origem;
    wire [1:0] tipo_objeto;
    wire [1:0] origem_objeto;
    wire [1:0] destino_objeto;

    sync_ram_16x4_mod duut (
        .clk(clk),
        .we(we),
        .in_eh_origem(in_eh_origem),
        .in_tipo_objeto(in_tipo_objeto),
        .in_origem_objeto(in_origem_objeto),
        .in_destino_objeto(in_destino_objeto),
        .addrSecundarioAnterior(addrSecAnt),
        .addrSecundario(addrSec),
        .addr(addr),
        .shift(shift),
        .weT(weT),
        .fit(fit),
        .clear(clear),
        .saidaSecundaria(saidaSecundaria),
        .saidaSecundariaAnterior(saidaSecundariaAnterior),
        .eh_origem(eh_origem),
        .tipo_objeto(tipo_objeto),
        .origem_objeto(origem_objeto),
        .destino_objeto(destino_objeto)
    );

    initial clk = 0;
    always #2 clk = ~clk;

    initial begin
        $dumpfile("tb_ram_mod.vcd");
        $dumpvars(0, tb_ram_mod);

        // Teste 1. Guarda um valor no endereço 0.
        addr = 0;
        in_eh_origem = 1'b0;
        in_tipo_objeto = 2'b10;
        in_origem_objeto = 2'b10;
        in_destino_objeto = 2'b10;
        #10;
        we = 1;
        #5;
        we = 0;
        #30;

        // Teste 2. Guarda um valor no endereço 0 usando weT
        in_eh_origem = 1'b1;
        in_tipo_objeto = 2'b01;
        in_origem_objeto = 2'b01;
        in_destino_objeto = 2'b01;
        #10;
        weT = 1;
        #2;
        weT = 0;

        // Teste 3. Guarda um valor no endereço 1 usando weT.
        in_eh_origem = 1'b0;
        in_tipo_objeto = 2'b00;
        in_origem_objeto = 2'b01;
        in_destino_objeto = 2'b11;
        #10;
        weT = 1;
        #2;
        weT = 0;

        // Teste 4. Shift
        #10;
        shift = 1;
        #2;
        shift = 0;

        // Teste 5. Guarda um valor usando weT
        in_eh_origem = 1'b0;
        in_tipo_objeto = 2'b00;
        in_origem_objeto = 2'b01;
        in_destino_objeto = 2'b00;
        #4;
        weT = 1;
        #4;
        weT = 0;

        // Teste 5. Fit
        addrSec = 1;
        in_eh_origem = 1'b1;
        in_tipo_objeto = 2'b11;
        in_origem_objeto = 2'b10;
        in_destino_objeto = 2'b11;
        #8;
        fit = 1;
        #4;
        fit = 0;

        #20;
        $finish;
    end
endmodule