module smart_cargo_fd (
 input clock,
 input [3:0] sensores, 
 input shift,
 input enableRAM,
 input enableTopRAM,
 input select1,
 input select2,
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
 output [1:0] saida_andar
);

//Declaração de fios gerais 
wire [3:0] proxAndarD, proxAndarS ; // proximo andar caso suba e proximo andar caso desça
wire [3:0] saidaRegDestino, saidaRegOrigem, saidaSecundaria;
wire sentidoUsuario, elevadorSubindo, enderecoMaiorQueOrigem, bordaNovaOrigem, mesmoAndar;
wire [3:0] saidaSecundariaAnterior, addrSecundarioAnterior;
wire objetivoMaiorAnterior, objetivoMenorAtual;
wire [3:0] addrSecundario, caronaOrigem;
wire fim_ultrasonico;

wire wire_eh_origem_objeto_da_vez;
wire [1:0] wire_tipo_objeto_da_vez;
wire [1:0] wire_origem_objeto_da_vez;
wire [1:0] wire_destino_objeto_da_vez;

assign proxParada = wire_destino_objeto_da_vez;

// Recepcao serial : 2 bits mais significativos nao sao usados, 
// 2 bits: tipo_obj, 2 bits: destino_obj, 2 bits: origem_obj

wire serial_recebido;
wire [7:0] dados_serial;
wire [1:0] origemSerial, destinoSerial, tipoSerial;

assign origemSerial = dados_serial[1:0];
assign destinoSerial = dados_serial[3:2];
assign tipoSerial = dados_serial[5:4];

// Multiplexadores
wire [3:0] mux1, mux2, mux3;
assign mux1 = select1? saidaRegOrigem : saidaRegDestino ; 
assign mux2 = select2? proxAndarS : proxAndarD ; // nao esta sendo usado
assign mux3 = select3? andarAtual : saidaSecundariaAnterior;
// Portas lógicas

assign mesmoSentido             = ~(sentidoElevador ^ sentidoUsuario);
assign carona_origem            = (mesmoSentido & objetivoMaiorAnterior & objetivoMenorAtual & ramSecDifZero);
assign carona_destino           = (objetivoMaiorAnterior & objetivoMenorAtual & ramSecDifZero & enderecoMaiorQueOrigem);
assign ramSecDifZero            = (saidaSecundaria[3] | saidaSecundaria[2] | saidaSecundaria[1] | saidaSecundaria[0]); 
assign temDestino               = (proxParada[0] | proxParada[1]);

assign andarRepetidoOrigem      = (mesmoSentido & mesmoAndar);
assign andarRepetidoDestino     = (mesmoAndar & enderecoMaiorQueOrigem);
assign sensorAtivo              = (sensores[0] | sensores[1] | sensores[2] | sensores[3]);

//Somador e subtrator do registrador do andar atual

assign addrSecundarioAnterior = addrSecundario - 1;
assign proxAndarD = andarAtual - 1;
assign proxAndarS = andarAtual + 1;

// Registradores 

registrador_4 andarAtual_reg (
    .clock      (clock),
    .clear      (reset),
    .enable     (enableAndarAtual),
    .D          (saida_andar),
    .Q          (andarAtual) 
);


registrador_4 reg_origem(
    .clock      (clock),
    .clear      (reset),
    .enable     (bordaNovaOrigem),
    .D          (origemSerial),
    .Q          (saidaRegOrigem)
);

registrador_4 reg_destino(
    .clock     (clock),
    .clear     (reset),
    .enable    (enableRegDestino),
    .D         (destinoSerial),
    .Q         (saidaRegDestino)
);

registrador_4 reg_carona_origem(
    .clock     (clock),
    .clear     (reset),
    .enable    (enableRegCaronaOrigem),
    .D         (addrSecundario),
    .Q         (caronaOrigem)
);

// Mostra andar atual

interpretador_andar interpretador_andar_atual( 
    .clock(clock),
    .reset(reset),
    .medir(fim_ultrasonico),
    .echo(echo),
	.sensores(sensores),
    .trigger(trigger_sensor_ultrasonico),
    .hex0(),
    .hex1(),
    .hex2(),
	 .hex3(),
	 .saida_andar(saida_andar),
    .pronto()
);

contador_m #(5000,16) timer_ultrasonico(
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
    .in_destino_objeto          (saidaRegDestino),
    .addrSecundario             (addrSecundario), // usado para dar o fit na memória
    .addrSecundarioAnterior     (addrSecundarioAnterior), // usado para a UC entender o sentido entre dois registros da memória
    .addr                       (4'b0000),
    .shift                      (shift),
    .weT                        (enableTopRAM),
    .fit                        (fit),
    .clear                      (reset),
    .eh_origem                  (wire_eh_origem_objeto_da_vez),
    .tipo_objeto                (wire_tipo_objeto_da_vez),
    .origem_objeto              (wire_origem_objeto_da_vez),
    .destino_objeto             (wire_destino_objeto_da_vez),
    .saidaSecundaria            (saidaSecundaria),
    .saidaSecundariaAnterior    (saidaSecundariaAnterior)
);
ram_conteudo_elevador conteudo_elevador (
    .clk                (clock),
    .clear              (reset),
    .in_tipo_objeto     (wire_tipo_objeto_da_vez),
    .in_destino_objeto  (wire_destino_objeto_da_vez),
    .shift              (), // desconectado
    .weT                (coloca_objetos),
    .tira_objetos       (tira_objetos),
    .andar_atual        (andarAtual),
    .tipo_objeto        (), // desconectado - vai ser usado na transmissao serial
    .destino_objeto     ()  // desconectado vai ser usado na transmissao serial
);

// Recepcao serial dos sinais

rx_serial_8N1 serial (
.clock                      (clock),
.reset                      (reset),
.RX                         (RX),
.pronto                     (serial_recebido),
.dados_ascii                (dados_serial),
.db_clock                   ( ), // desconectado
.db_tick                    ( ), // desconectado
.db_dados                   ( ), // desconectado
.db_estado                  ( ) // desconectado
);

// Depuracao da recepcao serial

hexa7seg HEX_MENOS_SIGNIFICATIVO ( 
.hexa    ( dados_serial [3:0] ), 
.display ( db_serial_hex [6:0]      )
);
    
hexa7seg HEX_MAIS_SIGNIFICATIVO ( 
.hexa    ( dados_serial [7:4] ), 
.display ( db_serial_hex [13:7]     )
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

contador_m #(2000,14) timer_2seg(
    .clock      (clock),
    .zera_as    (),
    .zera_s     (zeraT),
    .conta      (contaT),
    .Q          (),
    .fim        (fimT),
    .meio       ()
);



// Comparadores

comparador_85 destino_comp(
    .ALBi   (),
    .AGBi   (), 
    .AEBi   (1'b1), 
    .A      (proxParada), 
    .B      (andarAtual), 
    .ALBo   (), 
    .AGBo   (sobe), 
    .AEBo   (chegouDestino)
);

comparador_85 sentido_usuario(
    .ALBi   (0),
    .AGBi   (0), 
    .AEBi   (1'b1), 
    .A      (saidaRegDestino), 
    .B      (saidaRegOrigem), 
    .ALBo   (), 
    .AGBo   (sentidoUsuario), 
    .AEBo   ()
);

comparador_85 sentido_elevador(
    .ALBi   (0),
    .AGBi   (0), 
    .AEBi   (1'b1), 
    .A      (saidaSecundaria), 
    .B      (saidaSecundariaAnterior), 
    .ALBo   (), 
    .AGBo   (sentidoElevador), 
    .AEBo   ()
);



comparador_85 verifica_se_maior(
    .ALBi   (0),
    .AGBi   (0), 
    .AEBi   (1'b1), 
    .A      (mux1), 
    .B      (mux3), 
    .ALBo   (), 
    .AGBo   (objetivoMaiorAnterior), 
    .AEBo   ()
);

comparador_85 verifica_se_menor(
    .ALBi   (0),
    .AGBi   (0), 
    .AEBi   (1'b1), 
    .A      (mux1), 
    .B      (saidaSecundaria), 
    .ALBo   (objetivoMenorAtual), 
    .AGBo   (), 
    .AEBo   (mesmoAndar)
);

comparador_85 verifica_se_endereco_maior_que_origem(
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
