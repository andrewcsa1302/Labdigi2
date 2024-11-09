`timescale 1us / 1us

module tb_serial_automatico;
    reg clock;
    reg reset;
    reg mudou_de_andar = 0;
    integer i;

    // sinais envio_serial_automatico
    wire [5:0] dados_fila_elevador;
    wire [3:0] dados_conteudo_elevador;
    wire TX;
    wire [3:0] addr_conteudo_elevador;
    wire [3:0] addr_fila_elevador;
    wire       eh_origem_fila_elevador;

    // dut
    envio_serial_automatico dut (
        .clock(clock),
        .reset(reset),
        .mudou_de_andar(mudou_de_andar),
        .dados_fila_elevador(dados_fila_elevador),
        .dados_conteudo_elevador(dados_conteudo_elevador),
        .addr_conteudo_elevador(addr_conteudo_elevador),
        .addr_fila_elevador(addr_fila_elevador),
        .TX(TX),
        .eh_origem_fila_elevador(eh_origem_fila_elevador)
    );

    
    // sinais ram_conteudo_elevador
    reg [1:0] in_tipo_objeto;
    reg [1:0] in_destino_objeto;
    reg weT;
    wire [1:0] tipo_objeto_da_vez;
    wire [1:0] destino_objeto_da_vez;
    wire tem_vaga;

    assign dados_conteudo_elevador = {tipo_objeto_da_vez, destino_objeto_da_vez};

    // ram_conteudo_elevador
    ram_conteudo_elevador conteudo (
        .clk(clock),
        .clear (reset),
        .in_tipo_objeto(in_tipo_objeto),
        .in_destino_objeto(in_destino_objeto),
        .shift(1'b0),
        .weT(weT),
        .tira_objetos(1'b0),
        .andar_atual(2'b00),
        .tipo_objeto(tipo_objeto_da_vez),
        .destino_objeto(destino_objeto_da_vez),
        .tem_vaga(tem_vaga),
        .addr(addr_conteudo_elevador)
    );

    // sinais ram_fila_elevador
    reg [1:0] in_tipo_objeto_fila;
    reg [1:0] in_origem_objeto_fila;
    reg [1:0] in_destino_objeto_fila;
    reg weT_fila = 0;


    // ram_fila_elevador
    sync_ram_16x7_mod fila (
        .clk(clock),
        .we(1'b0),
        .in_tipo_objeto(in_tipo_objeto_fila),
        .in_origem_objeto(in_origem_objeto_fila),
        .in_destino_objeto(in_destino_objeto_fila),
        .addrSecundarioAnterior(4'b0001),
        .addrSecundario(4'b0000),
        .addr(4'b0000),
        .shift(1'b0),
        .weT(weT_fila),
        .fit(1'b0),
        .clear(reset),
        .saidaSecundaria( ), // desconectado
        .saidaSecundariaAnterior( ), // desconectado
        .eh_origem( ), // desconectado
        .tipo_objeto( ), // desconectado
        .origem_objeto( ), // desconectado
        .destino_objeto(), // desconectado
        .addrSerial(addr_fila_elevador), 
        .dados_addrSerial(dados_fila_elevador),
        .eh_origem_addrSerial(eh_origem_fila_elevador)
    );

    // gerador de clock
    initial clock = 0;
    always #2 clock = ~clock;

    // testes
    initial begin
        // Teste de reset
        reset = 1;
        #5;
        reset = 0;
        #5;
        
        $display("Reset concluido.");

        // Preenchimento da RAM de conteudo do elevador
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
            $display("RAM Conteudo[%0d] = %b", i, conteudo.ram[i]);
        end
            $display("Tem vaga: %b", tem_vaga);

        // Preenchimento da RAM de fila do elevador
        for (i = 0; i < 16; i = i + 1) begin
            in_tipo_objeto_fila = i[1:0];
            in_origem_objeto_fila = (i + 1) & 2'b11;
            if (i<8) in_destino_objeto_fila = (i + 1) & 2'b11;
            else in_destino_objeto_fila = (i + 2) & 2'b11;

            weT_fila = 1;
            #4;
            weT_fila = 0;
            #4;
        end

        // Verificação do preenchimento
        for (i = 0; i < 16; i = i + 1) begin
            $display("RAM Fila[%0d] = %b", i, fila.ram[i]);
        end

        // Teste de mudança de andar
        mudou_de_andar = 1;
        #5;
        #1000000;

        $display("Teste de mudança de andar concluido.");
        $finish;

    end
endmodule