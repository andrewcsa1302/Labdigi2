onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/sensores
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/shift
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/enableRAM
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/enableTopRAM
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/select1
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/select2
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/select3
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/zeraT
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/contaT
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/clearAndarAtual
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/clearSuperRam
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/enableAndarAtual
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/enableRegOrigem
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/enableRegDestino
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/zeraAddrSecundario
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/contaAddrSecundario
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/reset
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/fit
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/coloca_objetos
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/tira_objetos
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/RX
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/echo
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/inicia_ultrasonico
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/chegouDestino
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/bordaNovoDestino
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/fimT
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/ramSecDifZero
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/proxParada
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/andarAtual
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/sentidoElevador
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/carona_origem
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/carona_destino
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/enableRegCaronaOrigem
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/temDestino
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/sobe
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/andarRepetidoOrigem
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/andarRepetidoDestino
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/bordaSensorAtivo
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/db_serial_hex
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/trigger_sensor_ultrasonico
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/saida_andar
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/proxAndarD
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/proxAndarS
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/saidaRegDestino
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/saidaRegOrigem
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/saidaSecundaria
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/sentidoUsuario
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/enderecoMaiorQueOrigem
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/bordaNovaOrigem
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/mesmoAndar
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/saidaSecundariaAnterior
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/addrSecundarioAnterior
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/objetivoMaiorAnterior
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/objetivoMenorAtual
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/addrSecundario
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/caronaOrigem
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/fim_ultrasonico
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/eh_origem_fila
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/tipo_obj_fila
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/origem_fila
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/destino_fila
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/serial_recebido
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/dados_serial_recebido
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/origemSerial
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/destinoSerial
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/tipoSerial
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/mux1
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/mux3
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/mesmoSentido
add wave -noupdate -height 30 /tb_smartcargo/dut/fluxodeDados/sensorAtivo
add wave -noupdate -height 30 /tb_smartcargo/reset
add wave -noupdate -height 30 /tb_smartcargo/sensoresNeg
add wave -noupdate -height 30 /tb_smartcargo/iniciar
add wave -noupdate -height 30 /tb_smartcargo/emergencia
add wave -noupdate -height 30 /tb_smartcargo/echo
add wave -noupdate -height 30 /tb_smartcargo/motorDescendoF
add wave -noupdate -height 30 /tb_smartcargo/motorSubindoF
add wave -noupdate -height 30 /tb_smartcargo/trigger_sensor_ultrasonico
add wave -noupdate -height 30 /tb_smartcargo/saida_andar
add wave -noupdate -height 30 /tb_smartcargo/RX2
add wave -noupdate -height 30 /tb_smartcargo/envia_serial
add wave -noupdate -height 30 /tb_smartcargo/dados_enviados
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/chegouDestino
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/bordaSensorAtivo
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/fimT
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/temDestino
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/sobe
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/eh_origem
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/dbQuintoBitEstado
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/shift
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/enableRAM
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/contaT
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/zeraT
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/clearAndarAtual
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/clearSuperRam
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/select2
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/enableAndarAtual
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/Eatual1_db
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/motorSubindo
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/motorDescendo
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/tira_objetos
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/coloca_objetos
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_MOVIMENTO/Eatual
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_NOVA_ENTRADA/bordaNovoDestino
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_NOVA_ENTRADA/carona_origem
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_NOVA_ENTRADA/carona_destino
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_NOVA_ENTRADA/ramSecDifZero
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_NOVA_ENTRADA/andarRepetidoOrigem
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_NOVA_ENTRADA/andarRepetidoDestino
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_NOVA_ENTRADA/select1
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_NOVA_ENTRADA/enableTopRAM
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_NOVA_ENTRADA/fit
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_NOVA_ENTRADA/select3
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_NOVA_ENTRADA/enableRegDestino
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_NOVA_ENTRADA/enableRegOrigem
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_NOVA_ENTRADA/enableRegCaronaOrigem
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_NOVA_ENTRADA/contaAddrSecundario
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_NOVA_ENTRADA/zeraAddrSecundario
add wave -noupdate -height 30 /tb_smartcargo/dut/UC_NOVA_ENTRADA/Eatual2_db
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {329589 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 326
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ns} {1756800 ns}
