module smart_cargo_fd (
 input clock,
 input [3:0] sensores, 
 input shift,
 input enableRAM,
 input enableTopRAM,
 input select1,
 input select2, // nao esta sendo usado
 input select3,
 input zeraT,
 input contaT,
 input clearAndarAtual,
 input clearSuperRam, 
 input enableAndarAtual, 
 input enableRegOrigem,
 input enableRegDestino,
 input zeraAddrSecundario,
 input contaAddrSecundario,
 input reset,
 input fit,
 input coloca_objetos,
 input tira_objetos,
 input RX,
 input echo,
 input inicia_ultrasonico,
 input guarda_origem_ram, // para determinar o que será colocado no destino na fila
 output chegouDestino,
 output bordaNovoDestino,
 output fimT,
 output ramSecDifZero,
 output [1:0] proxParada,
 output [1:0] andarAtual, 
 output sentidoElevador,
 output carona_origem,
 output carona_destino,
 output enableRegCaronaOrigem,
 output temDestino,
 output sobe,
 output andarRepetidoOrigem,
 output andarRepetidoDestino,
 output bordaSensorAtivo,
 output [13:0] db_serial_hex,
 output trigger_sensor_ultrasonico,
 output [1:0] saida_andar,
 output eh_origem_fila
);

//Declaração de fios gerais 
wire [1:0] proxAndarD, proxAndarS ; // proximo andar caso suba e proximo andar caso desça
wire [1:0] saidaRegDestino, saidaRegOrigem, saidaSecundaria;
wire sentidoUsuario, enderecoMaiorQueOrigem, bordaNovaOrigem, mesmoAndar;
wire [1:0] saidaSecundariaAnterior, addrSecundarioAnterior;
wire objetivoMaiorAnterior, objetivoMenorAtual;
wire [3:0] addrSecundario, caronaOrigem;
wire fim_ultrasonico;

wire [1:0] tipo_obj_fila;
wire [1:0] origem_fila;


// Recepcao serial : 2 bits mais significativos nao sao usados, 
// 2 bits: tipo_obj, 2 bits: destino_obj, 2 bits: origem_obj

wire serial_recebido;
wire [7:0] dados_serial_recebido;
wire [1:0] origemSerial, destinoSerial, tipoSerial;

assign origemSerial = dados_serial_recebido[1:0];
assign destinoSerial = dados_serial_recebido[3:2];
assign tipoSerial = dados_serial_recebido[5:4];

// Multiplexadores
wire [1:0] mux1, mux2, mux3, destino_fila;
assign mux1 = select1? saidaRegOrigem : saidaRegDestino ; 
// assign mux2 = select2? proxAndarS : proxAndarD ; // nao esta sendo usado
assign mux3 = select3? andarAtual : saidaSecundariaAnterior;

assign destino_fila = guarda_origem_ram? saidaRegOrigem : saidaRegDestino; // se é para guardar uma origem ou um destino na RAM

// Portas lógicas

assign mesmoSentido             = ~(sentidoElevador ^ sentidoUsuario);
assign carona_origem            = (mesmoSentido & objetivoMaiorAnterior & objetivoMenorAtual & ramSecDifZero);
assign carona_destino           = (objetivoMaiorAnterior & objetivoMenorAtual & ramSecDifZero & enderecoMaiorQueOrigem);
assign ramSecDifZero            = (saidaSecundaria[1] | saidaSecundaria[0]); 
assign temDestino               = (tipo_obj_fila[1] | tipo_obj_fila[0]); // nao tem destino se o tipo do objeto do prox da fila for 00

assign andarRepetidoOrigem      = (mesmoSentido & mesmoAndar);
assign andarRepetidoDestino     = (mesmoAndar & enderecoMaiorQueOrigem);
assign sensorAtivo              = (saida_andar[0] || saida_andar[1]);

//Somador e subtrator do registrador do andar atual

assign addrSecundarioAnterior = addrSecundario - 1;
assign proxAndarD = andarAtual - 1;
assign proxAndarS = andarAtual + 1;

// Registradores 

registrador_N #(2) andarAtual_reg (
    .clock      (clock),
    .clear      (reset),
    .enable     (enableAndarAtual),
    .D          (saida_andar),
    .Q          (andarAtual) 
);

registrador_N #(2) reg_origem(
    .clock      (clock),
    .clear      (reset),
    .enable     (bordaNovaOrigem),
    .D          (origemSerial),
    .Q          (saidaRegOrigem)
);

registrador_N #(2) reg_destino(
    .clock     (clock),
    .clear     (reset),
    .enable    (enableRegDestino),
    .D         (destinoSerial),
    .Q         (saidaRegDestino)
);

registrador_N #(4) reg_carona_origem(
    .clock     (clock),
    .clear     (reset),
    .enable    (enableRegCaronaOrigem),
    .D         (addrSecundario),
    .Q         (caronaOrigem)
);


interpretador_andar interpretador_andar_atual( 
    .clock(clock),
    .reset(reset),
    .medir(fim_ultrasonico),
    .echo(echo),
	.sensores(sensores),
    .trigger(trigger_sensor_ultrasonico),
    .hex0(),
    .hex1(db_serial_hex [6:0]),
    .hex2(db_serial_hex [13:7]),
    .hex3(),
    .saida_andar(saida_andar),
    .pronto()
);

contador_m #(25000000,25) timer_ultrasonico( //  10_000_000 == 0.2s 10000000
    .clock      (clock),
    .zera_as    (),
    .zera_s     (reset),
    .conta      (inicia_ultrasonico),
    .Q          (),
    .fim        (fim_ultrasonico),
    .meio       ()
);

// Fila 
// GUARDA NESSA ORDEM: EH_ORIGEM, TIPO_OBJETO, ORIGEM_OBJETO, DESTINO_OBJETO

sync_ram_16x7_mod fila_ram(
    .clk                        (clock),
    .we                         (enableRAM),
    .in_tipo_objeto             (tipoSerial),
    .in_origem_objeto           (saidaRegOrigem),
    .in_destino_objeto          (destino_fila),
    .addrSecundario             (addrSecundario), // usado para dar o fit na memória
    .addrSecundarioAnterior     (addrSecundarioAnterior), // usado para a UC entender o sentido entre dois registros da memória
    .addr                       (4'b0000),
    .shift                      (shift),
    .weT                        (enableTopRAM),
    .fit                        (fit),
    .clear                      (reset),
    .eh_origem                  (eh_origem_fila),
    .tipo_objeto                (tipo_obj_fila),
    .origem_objeto              (origem_fila),
    .destino_objeto             (proxParada),
    .saidaSecundaria            (saidaSecundaria),
    .saidaSecundariaAnterior    (saidaSecundariaAnterior)
    // faltas os addrSerial, dados_addrSerial, eh_origem_addrSerial
);
ram_conteudo_elevador conteudo_elevador (
    .clk                (clock),
    .clear              (reset),
    .in_tipo_objeto     (tipo_obj_fila),
    .in_destino_objeto  (proxParada), // nao necessariamente pq pode estar levando outros- CORRIGIR 
    .shift              (), // desconectado
    .weT                (coloca_objetos),
    .tira_objetos       (tira_objetos),
    .andar_atual        (andarAtual),
    .tipo_objeto        (), // desconectado - vai ser usado na transmissao serial
    .destino_objeto     ()  // desconectado vai ser usado na transmissao serial
    // falta addr e tem_vaga
);

// Recepcao serial dos sinais

rx_serial_8N1 recepcao_serial (
.clock                      (clock),
.reset                      (reset),
.RX                         (RX),
.pronto                     (serial_recebido),
.dados_ascii                (dados_serial_recebido),
.db_clock                   ( ), // desconectado
.db_tick                    ( ), // desconectado
.db_dados                   ( ), // desconectado
.db_estado                  ( ) // desconectado
);

// Depuracao da recepcao serial

hexa7seg HEX_MENOS_SIGNIFICATIVO ( 
.hexa    ( dados_serial_recebido [3:0] ), 
.display (       )
);
    
hexa7seg HEX_MAIS_SIGNIFICATIVO ( 
.hexa    ( dados_serial_recebido [7:4] ), 
.display (    )
);

// detector de bordas

edge_detector detectorDeDestino(
    .clock  (clock),
    .reset  (reset),
    .sinal  (serial_recebido),
    .pulso  (bordaNovoDestino)
);

edge_detector detectorDeOrigem(
    .clock  (clock),
    .reset  (reset),
    .sinal  (serial_recebido),
    .pulso  (bordaNovaOrigem)
);

edge_detector detectorDeSensores(
    .clock  (clock),
    .reset  (reset),
    .sinal  (sensorAtivo),
    .pulso  (bordaSensorAtivo)
);

// timer 

contador_m #(50000000,26) timer_2seg(
    .clock      (clock),
    .zera_as    (),
    .zera_s     (zeraT),
    .conta      (contaT),
    .Q          (),
    .fim        (fimT),
    .meio       ()
);



// Comparadores

comparador_85 #(2) destino_comp(
    .ALBi   (1'b0),
    .AGBi   (1'b0), 
    .AEBi   (1'b1), 
    .A      (proxParada), 
    .B      (andarAtual), 
    .ALBo   (), 
    .AGBo   (sobe), 
    .AEBo   (chegouDestino)
);

comparador_85 #(2) sentido_usuario(
    .ALBi   (0),
    .AGBi   (0), 
    .AEBi   (1'b1), 
    .A      (saidaRegDestino), 
    .B      (saidaRegOrigem), 
    .ALBo   (), 
    .AGBo   (sentidoUsuario), 
    .AEBo   ()
);

comparador_85 #(2) sentido_elevador(
    .ALBi   (0),
    .AGBi   (0), 
    .AEBi   (1'b1), 
    .A      (saidaSecundaria), 
    .B      (saidaSecundariaAnterior), 
    .ALBo   (), 
    .AGBo   (sentidoElevador), 
    .AEBo   ()
);



comparador_85 #(2) verifica_se_maior(
    .ALBi   (0),
    .AGBi   (0), 
    .AEBi   (1'b1), 
    .A      (mux1), 
    .B      (mux3), 
    .ALBo   (), 
    .AGBo   (objetivoMaiorAnterior), 
    .AEBo   ()
);

comparador_85 #(2) verifica_se_menor(
    .ALBi   (0),
    .AGBi   (0), 
    .AEBi   (1'b1), 
    .A      (mux1), 
    .B      (saidaSecundaria), 
    .ALBo   (objetivoMenorAtual), 
    .AGBo   (), 
    .AEBo   (mesmoAndar)
);

comparador_85 #(4) verifica_se_endereco_maior_que_origem(
    .ALBi   (0),
    .AGBi   (0), 
    .AEBi   (1'b1), 
    .A      (addrSecundario), 
    .B      (caronaOrigem), 
    .ALBo   (), 
    .AGBo   (enderecoMaiorQueOrigem), 
    .AEBo   ()
);

contador_p endereco_secundario(
    .clock      (clock),
    .zera_as    (),
    .zera_s     (zeraAddrSecundario),
    .conta      (contaAddrSecundario),
    .Q          (addrSecundario),
    .fim        (),
    .meio       ()
);

endmodule
