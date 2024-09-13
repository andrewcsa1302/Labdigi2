onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Tick
add wave -noupdate -divider Entradas
add wave -noupdate -height 30 /tx_serial_7N2_tb/dut/clock
add wave -noupdate -height 30 /tx_serial_7N2_tb/dut/reset
add wave -noupdate -height 30 /tx_serial_7N2_tb/dut/partida
add wave -noupdate -height 30 /tx_serial_7N2_tb/dut/dados_ascii
add wave -noupdate -divider Saidas
add wave -noupdate -color Magenta -height 30 /tx_serial_7N2_tb/dut/saida_serial
add wave -noupdate -height 30 /tx_serial_7N2_tb/dut/pronto
add wave -noupdate -divider Tick
add wave -noupdate -color White -height 30 /tx_serial_7N2_tb/dut/s_tick
add wave -noupdate -divider Estado
add wave -noupdate -height 30 /tx_serial_7N2_tb/dut/U2_UC/Eatual
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 6} {10540 ns} 0} {{Cursor 7} {19225 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 243
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
configure wave -timelineunits ns
update
WaveRestoreZoom {5390 ns} {24550 ns}
