module ram_conteudo_elevador(
    input        clk,
    input  [1:0] in_tipo_objeto,
    input  [1:0] in_destino_objeto,
    input        shift,
    input        weT, // write enable top (coloca o dado novo no fim da fila)
    input        clear,
    input        tira_objetos,
    input  [1:0] andar_atual,
    output [1:0] tipo_objeto,
    output [1:0] destino_objeto
);

    // Formato do dado da RAM: tipo_objeto [1:0], destino_objeto [1:0] -> 4 bits
    reg [3:0] ram[7:0];
    reg [3:0] data;
    assign data = {in_tipo_objeto, in_destino_objeto};
    integer i,j;

    // Registra endereco de acesso
    reg [2:0] addr_reg;

    initial begin
        ram[0] = 0;
        ram[1] = 0;
        ram[2] = 0;
        ram[3] = 0;
        ram[4] = 0;
        ram[5] = 0;
        ram[6] = 0;
        ram[7] = 0;
    end
    always @ (posedge clk or posedge clear)
    begin
            // Escrita da memoria
            if (clear) begin
                for (i = 0; i < 8; i = i + 1) begin
                    ram[i] <= 4'b0;
                end
            end else begin
            if (weT) begin 
                if(ram[0] == 4'b0000) ram[0] = data;
                else if(ram[1] == 4'b0000) ram[1] = data;
                else if(ram[2] == 4'b0000) ram[2] = data;
                else if(ram[3] == 4'b0000) ram[3] = data;
                else if(ram[4] == 4'b0000) ram[4] = data;
                else if(ram[5] == 4'b0000) ram[5] = data;
                else if(ram[6] == 4'b0000) ram[6] = data;
                else if(ram[7] == 4'b0000) ram[7] = data;
            end
            else if(shift) begin // no shift, o fim da fila fica com uma vaga sobrando
                ram[0] = 15;
                ram[0] = ram[1];
                ram[1] = ram[2];
                ram[2] = ram[3];
                ram[3] = ram[4];
                ram[4] = ram[5];
                ram[5] = ram[6];
                ram[6] = ram[7];
                ram[7] = 0;
            end

            // Remocao de objetos do andar atual
            else if (tira_objetos) begin
                for (i = 0; i < 8; i = i + 1) begin
                    if (ram[i] != 4'b0000 && ram[i][1:0] == andar_atual) begin // remove o objeto do andar
                        $display("Removendo objeto na posicao %0d", i);
                        for (j = i; j < 7; j = j + 1) begin // shifta os objetos para baixo
                            ram[j] = ram[j +  1];
                        end
                    ram[7] = 4'b0000;
                    i = i - 1;
                    end
                end
            end
        end
    end

    // Atribuicao continua

    assign tipo_objeto = ram[0][3:2];
    assign destino_objeto = ram[0][1:0];


endmodule