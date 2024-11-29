module ram_conteudo_elevador (
    input        clk,
    input  [1:0] in_tipo_objeto,
    input  [1:0] in_destino_objeto,
    input        shift,
    input        weT, // write enable top (coloca o dado novo no fim da fila)
    input        clear,
    input        tira_objetos,
    input  [1:0] andar_atual,
    input  [3:0] addr,
    output [1:0] tipo_objeto,
    output [1:0] destino_objeto,
    output       tem_vaga
);

    // Formato do dado da RAM: tipo_objeto [1:0], destino_objeto [1:0] -> 4 bits
    reg [3:0] ram[7:0];
    integer i;
    reg found_empty_slot;
    reg [3:0] data;
    reg tem_vaga_reg;
    reg [3:0] addr_reg;

    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            ram[i] = 4'b0000;
        end
    end

    always @(posedge clk or posedge clear) begin
        if (clear) begin
            for (i = 0; i < 8; i = i + 1) begin
                ram[i] <= 4'b0000;
            end
        end else begin
            // Atribuição procedural para a variável data
            data = {in_tipo_objeto, in_destino_objeto};

            if (weT) begin
                write_to_empty_slot(data);
            end else if (shift) begin
                shift_ram(0); // Chama a tarefa de shift começando do índice 0
            end else if (tira_objetos) begin
                // Verifica se há objetos a serem removidos
                for (i = 0; i < 8; i = i + 1) begin
                    if (ram[i] != 4'b0000 && ram[i][1:0] == andar_atual) begin
                        $display("Removendo objeto na posicao %0d", i);
                        ram[i] <= 4'b0000;
                    end
                end
            end
        end

        // Verificação se algum slot da RAM está vazio
        // tem_vaga_reg = 0;
        // for (i = 0; i < 8; i = i + 1) begin
        //     if (ram[i] == 4'b0000) begin
        //         tem_vaga_reg = 1;
        //     end
        // end


    end
	 
    always @(posedge clk) begin
        addr_reg <= addr;
    end


    // Atribuição contínua
    assign tipo_objeto = ram[addr_reg][3:2];
    assign destino_objeto = ram[addr_reg][1:0];
    assign tem_vaga = tem_vaga_reg;

    // Tarefa para escrever no primeiro slot vazio
    task write_to_empty_slot(input [3:0] data);
        begin
            found_empty_slot = 0;
            for (i = 0; i < 8 && !found_empty_slot; i = i + 1) begin
                if (ram[i] == 4'b0000) begin
                    ram[i] <= data;
                    found_empty_slot = 1;
                end
            end
        end
    endtask

    // Tarefa para realizar o shift na RAM
    task shift_ram(input integer inicio);
        begin
            if (inicio == 0) begin
                for (i = 0; i < 7; i = i + 1) begin
                    ram[i] <= ram[i + 1];
                end
            end else if (inicio == 1) begin
                for (i = 1; i < 7; i = i + 1) begin
                    ram[i] <= ram[i + 1];
                end
            end else if (inicio == 2) begin
                for (i = 2; i < 7; i = i + 1) begin
                    ram[i] <= ram[i + 1];
                end
            end else if (inicio == 3) begin
                for (i = 3; i < 7; i = i + 1) begin
                    ram[i] <= ram[i + 1];
                end
            end else if (inicio == 4) begin
                for (i = 4; i < 7; i = i + 1) begin
                    ram[i] <= ram[i + 1];
                end
            end else if (inicio == 5) begin
                for (i = 5; i < 7; i = i + 1) begin
                    ram[i] <= ram[i + 1];
                end
            end else if (inicio == 6) begin
                for (i = 6; i < 7; i = i + 1) begin
                    ram[i] <= ram[i + 1];
                end
            end
            ram[7] <= 4'b0000;
        end
    endtask

endmodule