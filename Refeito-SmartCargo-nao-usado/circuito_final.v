module circuito_final(
    input iniciar,
    input clock,
    input [3:0]sensoresNeg,
    input reset, 
    input emergencia,
    input RX,
    output dbQuintoBitEstado,
    output db_iniciar,
	output db_clock,
	output db_reset,
    output motorDescendoF,
    output motorSubindoF,
    output [6:0] andarAtual_db,
	output [6:0] proxParada_db,
	output [6:0] Eatual_1,
	output [6:0] Eatual_2,
    output [6:0] db_serial_hex_menos,
    output [6:0] db_serial_hex_mais,
	output db_bordaSensorAtivo,
	output db_motorSubindo,
	output db_motorDescendo,
	output [3:0]db_sensores
);

wire enableAndarAtual, shift, enableRAM, enableTopRAM, select1, select2, select3, chegouDestino, fit, temDestino, sobe; 
wire bordaNovoDestino, fimT, contaT, zeraT, clearAndarAtual, clearSuperRam, carona_origem, finalRam, enableRegOrigem, andarRepetidoDestino, andarRepetidoOrigem;
wire enableRegDestino, contaAddrSecundario, zeraAddrSecundario, sentidoElevador, ramSecDifZero, bordaSensorAtivo, motorSubindo, motorDescendo;
wire [3:0] proxParada, andarAtual, Eatual1_db,Eatual2_db, sesnsores ;

wire [3:0] origemBot, destinoBot, sensores;

assign db_iniciar = iniciar;
assign db_clock = clock;
assign db_reset = reset;
assign db_bordaSensorAtivo = sensoresNeg[0];
assign sensores = ~sensoresNeg;
assign db_motorSubindo = motorSubindo;
assign db_motorDescendo = motorDescendo;
assign db_sensores = sensoresNeg;

assign motorSubindoF = motorSubindo | emergencia;
assign motorDescendoF = motorDescendo | emergencia;

wire [7:0] dados_serial_recebido;
wire [1:0] origemSerial, destinoSerial, tipoSerial;

assign origemSerial = dados_serial_recebido[1:0];
assign destinoSerial = dados_serial_recebido[3:2];
assign tipoSerial = dados_serial_recebido[5:4];

assign origemBot = {2'b00, origemSerial};
assign destinoBot = {2'b00, destinoSerial};

wire pronto_serial_recebido;

rx_serial_8N1 recepcao_serial (
.clock                      (clock),
.reset                      (reset),
.RX                         (RX),
.pronto                     (pronto_serial_recebido),
.dados_ascii                (dados_serial_recebido),
.db_clock                   ( ), // desconectado
.db_tick                    ( ), // desconectado
.db_dados                   ( ), // desconectado
.db_estado                  ( ) // desconectado
);

FD fluxodeDados (
.clock                      (clock),
.origemBot                  (origemBot), 
.destinoBot                 (destinoBot),
.enableAndarAtual           (enableAndarAtual), // enable da ram estado atual
.shift                      (shift), //shift ram
.fit                        (fit),
.enableRAM                  (enableRAM), // enable ram destinos
.enableTopRAM               (enableTopRAM), // enable top ram destinos
.select1                    (select1), // seleciona a origem ou destino
.select2                    (select2), // seleciona andar pra cima ou pra baixo
.select3                    (select3),
.chegouDestino              (chegouDestino), // chegou no andar
.bordaNovoDestino           (bordaNovoDestino), // borda do pronto
.proxParada                 (proxParada), // saida da ram com o prox destino
.andarAtual                 (andarAtual), // andar atual e entra no comparador
.fimT                       (fimT), //passou dois segundou 
.contaT                     (contaT),
.zeraT                      (zeraT),
.clearAndarAtual            (clearAndarAtual),
.clearSuperRam              (clearSuperRam),
.ramSecDifZero              (ramSecDifZero),
.enableRegDestino           (enableRegDestino),
.enableRegOrigem            (enableRegOrigem),
.enableRegCaronaOrigem      (enableRegCaronaOrigem),
.contaAddrSecundario        (contaAddrSecundario),
.zeraAddrSecundario         (zeraAddrSecundario),
.carona_origem              (carona_origem),
.carona_destino             (carona_destino),
.andarRepetidoDestino       (andarRepetidoDestino),
.andarRepetidoOrigem        (andarRepetidoOrigem),
.sentidoElevador            (sentidoElevador),
.reset                      (reset),
.temDestino                 (temDestino),
.sobe                       (sobe),
.sensores                   (sensores),
.bordaSensorAtivo           (bordaSensorAtivo),
.pronto_serial_recebido     (pronto_serial_recebido)
);


unidade_controle UC (
.clock                      (clock),
.reset                      (reset),
.iniciar                    (iniciar),
.chegouDestino              (chegouDestino),// saida do comparador de andares
.fimT                       (fimT),
.bordaSensorAtivo           (bordaSensorAtivo),// timer do elevador normal
.shift                      (shift),
.enableRAM                  (enableRAM),
.contaT                     (contaT),
.zeraT                      (zeraT),
.clearAndarAtual            (clearAndarAtual),
.clearSuperRam              (clearSuperRam),
.select2                    (select2),
.enableAndarAtual           (enableAndarAtual),
.dbQuintoBitEstado          (dbQuintoBitEstado),// quinto bit do estado sai em led
.sobe                       (sobe),
.temDestino                 (temDestino),
.Eatual1_db                 (Eatual1_db),
.motorSubindo               (motorSubindo),
.motorDescendo              (motorDescendo)
);


uc_novajogada UC_NOVAJOGADA (
.bordaNovoDestino           (bordaNovoDestino),
.select1                    (select1),
.enableTopRAM               (enableTopRAM),
.fit                        (fit),
.iniciar                    (iniciar),
.reset                      (reset),
.clock                      (clock),
.carona_origem              (carona_origem),
.carona_destino             (carona_destino),
.andarRepetidoDestino        (andarRepetidoDestino),
.andarRepetidoOrigem         (andarRepetidoOrigem),
.ramSecDifZero              (ramSecDifZero),
.select3                    (select3),
.enableRegOrigem            (enableRegOrigem),
.enableRegDestino           (enableRegDestino),
.enableRegCaronaOrigem      (enableRegCaronaOrigem),
.contaAddrSecundario        (contaAddrSecundario),
.zeraAddrSecundario         (zeraAddrSecundario),
.Eatual2_db                 (Eatual2_db)
);



// displays 7 seg

hexa7seg display_andarAtual(
.hexa                       (andarAtual),
.display                    (andarAtual_db)
);


hexa7seg display_proxParada(
.hexa                       (proxParada),
.display                    (proxParada_db)

);

hexa7seg display_estado1(
.hexa                       (Eatual1_db),
.display                    (Eatual_1)
);


hexa7seg display_estado2(
.hexa                       (Eatual2_db),
.display                    (Eatual_2)
);

// Depuracao da recepcao serial

hexa7seg HEX_MENOS_SIGNIFICATIVO ( 
.hexa    ( dados_serial_recebido [3:0] ), 
.display ( db_serial_hex_menos    )
);
    
hexa7seg HEX_MAIS_SIGNIFICATIVO ( 
.hexa    ( dados_serial_recebido [7:4] ), 
.display ( db_serial_hex_mais     )
);



endmodule