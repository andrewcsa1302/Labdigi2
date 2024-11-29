 module envio_serial_automatico_fd (
    input        clock        ,
    input        reset        ,
    input  [5:0] dados_fila_elevador,
    input  [3:0] dados_conteudo_elevador,
    input        eh_conteudo_elevador,
    input        conta_conteudo_elevador,
    input        conta_fila_elevador,
    input        envia_serial,
    output       TX,
    output       enviado,
    output [3:0] addr_conteudo_elevador,
    output [3:0] addr_fila_elevador,
    output       fim_transmissao_conteudo_elevador,
    output       fim_transmissao_fila_elevador
);

wire [6:0] dados_enviados;
wire [6:0] dados_fila_elevador_prontos;
wire [6:0] dados_conteudo_elevador_prontos;

// Mensagem enviada quando é fila do elevador: 1'b0 + [1:0]TIPO_OBJETO + [1:0]ORIGEM_OBJETO + [1:0]DESTINO_OBJETO
assign dados_fila_elevador_prontos = {1'b0, dados_fila_elevador};

// Mensagem enviada quando é conteúdo do elevador: 3'b1 + [1:0]TIPO_OBJETO + [1:0]DESTINO_OBJETO
assign dados_conteudo_elevador_prontos = {3'b111, dados_conteudo_elevador};

// Mux para selecionar qual dado será enviado
assign dados_enviados = eh_conteudo_elevador ? dados_conteudo_elevador_prontos : dados_fila_elevador_prontos;

// Adicionando depuração para exibir o conteúdo de dados_enviados quando envia_serial é acionado
always @(posedge envia_serial) begin
    $display("envia_serial acionado para conteudo = %b: dados_enviados = %b",eh_conteudo_elevador, dados_enviados);
end

tx_serial_7O1 serial (
    .clock           ( clock          ),
    .reset           ( reset          ),
    .partida         ( envia_serial   ),
    .dados_ascii     ( dados_enviados ),
    .saida_serial    ( TX             ),
    .pronto          ( enviado        ),
    .db_clock        (                ), // Porta aberta (desconectada)
    .db_tick         (                ), // Porta aberta (desconectada)
    .db_partida      (                ), // Porta aberta (desconectada)
    .db_saida_serial (                ), // Porta aberta (desconectada)
    .db_estado       (                )  // Porta aberta (desconectada)
);

contador_m #(
    .M(8),
    .N(4)
) contador_addr_conteudo_elevador (
    .clock   (clock),
    .zera_as (1'b0 ),
    .zera_s  (reset ),
    .conta   (conta_conteudo_elevador),
    .Q       (addr_conteudo_elevador ), 
    .fim     (fim_transmissao_conteudo_elevador),
    .meio    (     )  // porta meio em aberto (desconectada)
);

contador_m #(
    .M(16),
    .N(5)
) contador_addr_fila_elevador (
    .clock   (clock),
    .zera_as (1'b0 ),
    .zera_s  (reset ),
    .conta   (conta_fila_elevador),
    .Q       (addr_fila_elevador ), 
    .fim     (fim_transmissao_fila_elevador),
    .meio    (     )  // porta meio em aberto (desconectada)
);

endmodule