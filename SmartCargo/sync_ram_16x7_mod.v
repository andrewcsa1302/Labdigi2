module sync_ram_16x7_mod(
    input        clk,
    input        we, // write enable para escrita no addr dado
    input  [1:0] in_tipo_objeto,
    input  [1:0] in_origem_objeto,
    input  [1:0] in_destino_objeto,
    input  [3:0] addrSecundarioAnterior,
    input  [3:0] addrSecundario,
    input  [3:0] addr,
    input  [3:0] addrSerial,
    input        shift,
    input        weT, // write enable top (coloca o dado novo no fim da fila)
    input        fit, // insere o dado entre outros 2 dados
    input        clear,
    output [1:0] saidaSecundaria,
    output [1:0] saidaSecundariaAnterior,
    output       eh_origem,
    output [1:0] tipo_objeto,
    output [1:0] origem_objeto,
    output [1:0] destino_objeto,
    output [5:0] dados_addrSerial,
    output       eh_origem_addrSerial
);

    // Formato do dado da RAM: eh_origem, tipo_objeto [1:0], origem_objeto [1:0], destino_objeto [1:0] -> 7 bits
    reg [6:0] ram[15:0];
    reg [6:0] data;
    wire       in_eh_origem;
    // Comparação direta de 4 bits
    assign in_eh_origem = (in_origem_objeto == in_destino_objeto) ? 1'b1 : 1'b0;


    // Registra endereco de acesso
    reg [3:0] addr_reg;
    reg [3:0] addrSerial_reg;
    integer i;

    initial begin
        ram[0] = 0;
        ram[1] = 0;
        ram[2] = 0;
        ram[3] = 0;
        ram[4] = 0;
        ram[5] = 0;
        ram[6] = 0;
        ram[7] = 0;
        ram[8] = 0;
        ram[9] = 0;
        ram[10] = 0;
        ram[11] = 0;
        ram[12] = 0;
        ram[13] = 0;
        ram[14] = 0;
        ram[15] = 0;
    end
    always @ (posedge clk or posedge clear)
    begin
        data = {in_eh_origem, in_tipo_objeto, in_origem_objeto, in_destino_objeto};

        // Escrita da memoria
        if (clear) begin
            ram[0] = 0;
            ram[1] = 0;
            ram[2] = 0;
            ram[3] = 0;
            ram[4] = 0;
            ram[5] = 0;
            ram[6] = 0;
            ram[7] = 0;
            ram[8] = 0;
            ram[9] = 0;
            ram[10] = 0;
            ram[11] = 0;
            ram[12] = 0;
            ram[13] = 0;
            ram[14] = 0;
            ram[15] = 0;
        end
        else begin
        if (we) ram[addr] = data;
        if (weT) begin 
            if(ram[0] == 7'b0000000) ram[0] = data;
            else if(ram[1] == 7'b0000000) ram[1] = data;
            else if(ram[2] == 7'b0000000) ram[2] = data;
            else if(ram[3] == 7'b0000000) ram[3] = data;
            else if(ram[4] == 7'b0000000) ram[4] = data;
            else if(ram[5] == 7'b0000000) ram[5] = data;
            else if(ram[6] == 7'b0000000) ram[6] = data;
            else if(ram[7] == 7'b0000000) ram[7] = data;
            else if(ram[8] == 7'b0000000) ram[8] = data;
            else if(ram[9] == 7'b0000000) ram[9] = data;
            else if(ram[10] == 7'b0000000) ram[10] = data;
            else if(ram[11] == 7'b0000000) ram[11] = data;
            else if(ram[12] == 7'b0000000) ram[12] = data;
            else if(ram[13] == 7'b0000000) ram[13] = data;
            else if(ram[14] == 7'b0000000) ram[14] = data;
            else if(ram[15] == 7'b0000000) ram[15] = data;
        end
        if(shift) begin // no shift, o fim da fila fica com uma vaga sobrando
            ram[0] = 15;
            ram[0] = ram[1];
            ram[1] = ram[2];
            ram[2] = ram[3];
            ram[3] = ram[4];
            ram[4] = ram[5];
            ram[5] = ram[6];
            ram[6] = ram[7];
            ram[7] = ram[8];
            ram[8] = ram[9];
            ram[9] = ram[10];
            ram[10] = ram[11];
            ram[11] = ram[12];
            ram[12] = ram[13];
            ram[13] = ram[14];
            ram[14] = ram[15];
            ram[15] = 0;
        end
        if(fit) begin // se tiver com fit, insere no lugar do addrSecundario e joga o resto pra tras
            if (addrSecundario <= 14) ram[15] = ram[14];
            if (addrSecundario <= 13) ram[14] = ram[13];
            if (addrSecundario <= 12) ram[13] = ram[12];
            if (addrSecundario <= 11) ram[12] = ram[11];
            if (addrSecundario <= 10) ram[11] = ram[10];
            if (addrSecundario <= 9) ram[10] = ram[9];
            if (addrSecundario <= 8) ram[9] = ram[8];
            if (addrSecundario <= 7) ram[8] = ram[7];
            if (addrSecundario <= 6) ram[7] = ram[6];
            if (addrSecundario <= 5) ram[6] = ram[5];
            if (addrSecundario <= 4) ram[5] = ram[4];
            if (addrSecundario <= 3) ram[4] = ram[3];
            if (addrSecundario <= 2) ram[3] = ram[2];
            if (addrSecundario <= 1) ram[2] = ram[1];
            if (addrSecundario == 0) ram[1] = ram[0];
            
            ram[addrSecundario] = data;
        end
        
        addr_reg <= addr;
        addrSerial_reg <= addrSerial;
        end
    end

    // Atribuicao continua

    assign eh_origem = ram[addr_reg][6];
    assign tipo_objeto = ram[addr_reg][5:4];
    assign origem_objeto = ram[addr_reg][3:2];
    assign destino_objeto = ram[addr_reg][1:0];

    assign dados_addrSerial = ram[addrSerial_reg][5:0];
    assign eh_origem_addrSerial = ram[addrSerial_reg][6];

    assign saidaSecundaria = ram[addrSecundario][1:0]; 
    assign saidaSecundariaAnterior = ram[addrSecundarioAnterior][1:0];

endmodule