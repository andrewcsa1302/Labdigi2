module smart_cargo(
    input iniciar,
    input clock,
    input [3:0] sensoresNeg,
    input reset, 
    input emergencia,
    input RX,
    input echo,
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
    output db_bordaSensorAtivo,
    output db_motorSubindo,
    output db_motorDescendo,
    output [3:0] db_sensores,
    output [13:0] db_serial_hex,
    output trigger_sensor_ultrasonico,
    output [1:0] saida_andar // o que esta vindo dos sensores nesse exato momento. Se 0, quer dizer que nao esta passando pelos sensores
);

// NOVOS SINAIS SMARTCARGO
wire coloca_objetos, tira_objetos;
wire eh_origem_fila;
wire guarda_origem_ram;

// SINAIS ANTIGOS
wire enableAndarAtual, shift, enableRAM, enableTopRAM, select1, select2, select3, chegouDestino, fit, temDestino, sobe; 
wire bordaNovoDestino, fimT, contaT, zeraT, clearAndarAtual, clearSuperRam, carona_origem, finalRam, enableRegOrigem, andarRepetidoDestino, andarRepetidoOrigem;
wire enableRegDestino, contaAddrSecundario, zeraAddrSecundario, sentidoElevador, ramSecDifZero, bordaSensorAtivo, motorSubindo, motorDescendo;
wire [1:0] proxParada, andarAtual;
wire [3:0] Eatual1_db, Eatual2_db, sensores;

assign db_iniciar = iniciar;
assign db_clock = clock;
assign db_reset = reset;
assign db_bordaSensorAtivo = bordaSensorAtivo;
assign sensores = ~sensoresNeg;
assign db_motorSubindo = motorSubindo;
assign db_motorDescendo = motorDescendo;
assign db_sensores = sensoresNeg;

assign motorSubindoF = motorSubindo | emergencia;
assign motorDescendoF = motorDescendo | emergencia;

smart_cargo_fd fluxodeDados (
.clock                      (clock),
.echo                       (echo),
.inicia_ultrasonico         (iniciar),
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
.tira_objetos               (tira_objetos),
.coloca_objetos             (coloca_objetos),
.RX                         (RX),
.db_serial_hex              (db_serial_hex),
.trigger_sensor_ultrasonico (trigger_sensor_ultrasonico),
.saida_andar                (saida_andar),
.eh_origem_fila             (eh_origem_fila),
.guarda_origem_ram          (guarda_origem_ram)
);


uc_movimento UC_MOVIMENTO (
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
.motorDescendo              (motorDescendo),
.eh_origem                  (eh_origem_fila),
.tira_objetos               (tira_objetos),
.coloca_objetos             (coloca_objetos)
);


uc_nova_entrada UC_NOVA_ENTRADA (
.bordaNovoDestino           (bordaNovoDestino),
.select1                    (select1),
.enableTopRAM               (enableTopRAM),
.fit                        (fit),
.iniciar                    (iniciar),
.reset                      (reset),
.clock                      (clock),
.carona_origem              (carona_origem),
.carona_destino             (carona_destino),
.andarRepetidoDestino       (andarRepetidoDestino),
.andarRepetidoOrigem        (andarRepetidoOrigem),
.ramSecDifZero              (ramSecDifZero),
.select3                    (select3),
.enableRegOrigem            (enableRegOrigem),
.enableRegDestino           (enableRegDestino),
.enableRegCaronaOrigem      (enableRegCaronaOrigem),
.contaAddrSecundario        (contaAddrSecundario),
.zeraAddrSecundario         (zeraAddrSecundario),
.Eatual2_db                 (Eatual2_db),
.guarda_origem_ram          (guarda_origem_ram)  
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


endmodule