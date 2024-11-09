module envio_serial_automatico (
    input      clock,
    input      reset,
    input      mudou_de_andar,
    input  [5:0] dados_fila_elevador,
    input  [3:0] dados_conteudo_elevador,
    input        eh_origem_fila_elevador,
    output [3:0] addr_conteudo_elevador,
    output [3:0] addr_fila_elevador,
    output     RX
);

wire s_eh_conteudo_elevador, s_conta_conteudo_elevador, s_conta_fila_elevador, s_envia_serial,
     s_enviado, s_fim_transmissao_conteudo_elevador, s_fim_transmissao_fila_elevador;
    

envio_serial_automatico_fd fd(
    .clock(clock),
    .reset(s_zera),
    .dados_fila_elevador(dados_fila_elevador),
    .dados_conteudo_elevador(dados_conteudo_elevador),
    .eh_conteudo_elevador(s_eh_conteudo_elevador),
    .conta_conteudo_elevador(s_conta_conteudo_elevador),
    .conta_fila_elevador(s_conta_fila_elevador),
    .envia_serial(s_envia_serial),
    .RX(RX),
    .enviado(s_enviado),
    .addr_conteudo_elevador(addr_conteudo_elevador),
    .addr_fila_elevador(addr_fila_elevador),
    .fim_transmissao_conteudo_elevador(s_fim_transmissao_conteudo_elevador),
    .fim_transmissao_fila_elevador(s_fim_transmissao_fila_elevador)
);

envio_serial_automatico_uc uc(
    .clock(clock),
    .reset(reset),
    .mudou_de_andar(mudou_de_andar),
    .enviado(s_enviado),
    .fim_transmissao_conteudo_elevador(s_fim_transmissao_conteudo_elevador),
    .fim_transmissao_fila_elevador(s_fim_transmissao_fila_elevador),
    .eh_conteudo_elevador(s_eh_conteudo_elevador),
    .conta_conteudo_elevador(s_conta_conteudo_elevador),
    .conta_fila_elevador(s_conta_fila_elevador),
    .envia_serial(s_envia_serial),
    .zera(s_zera),
    .eh_origem_fila_elevador(eh_origem_fila_elevador)
);

endmodule