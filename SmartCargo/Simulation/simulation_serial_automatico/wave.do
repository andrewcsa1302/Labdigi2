onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_serial_automatico/dut/clock
add wave -noupdate /tb_serial_automatico/dut/reset
add wave -noupdate /tb_serial_automatico/dut/mudou_de_andar
add wave -noupdate /tb_serial_automatico/dut/dados_fila_elevador
add wave -noupdate /tb_serial_automatico/dut/dados_conteudo_elevador
add wave -noupdate /tb_serial_automatico/dut/eh_origem_fila_elevador
add wave -noupdate /tb_serial_automatico/dut/addr_conteudo_elevador
add wave -noupdate /tb_serial_automatico/dut/addr_fila_elevador
add wave -noupdate /tb_serial_automatico/dut/s_eh_conteudo_elevador
add wave -noupdate /tb_serial_automatico/dut/s_conta_conteudo_elevador
add wave -noupdate /tb_serial_automatico/dut/s_conta_fila_elevador
add wave -noupdate /tb_serial_automatico/dut/s_envia_serial
add wave -noupdate /tb_serial_automatico/dut/s_enviado
add wave -noupdate /tb_serial_automatico/dut/s_fim_transmissao_conteudo_elevador
add wave -noupdate /tb_serial_automatico/dut/s_fim_transmissao_fila_elevador
add wave -noupdate /tb_serial_automatico/dut/s_zera
add wave -noupdate /tb_serial_automatico/dut/fd/serial/s_tick
add wave -noupdate /tb_serial_automatico/TX
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {24 us} 0} {{Cursor 2} {1000030 us} 0}
quietly wave cursor active 2
configure wave -namecolwidth 286
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
WaveRestoreZoom {999939 us} {1000222 us}
