onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 35 /sonar_tb_certo/clock
add wave -noupdate -height 35 /sonar_tb_certo/reset
add wave -noupdate -height 35 /sonar_tb_certo/ligar
add wave -noupdate -height 35 /sonar_tb_certo/echo
add wave -noupdate -height 35 /sonar_tb_certo/trigger
add wave -noupdate -height 35 /sonar_tb_certo/pwm
add wave -noupdate -color Yellow -height 35 /sonar_tb_certo/saida_serial
add wave -noupdate -color {Orange Red} -height 35 /sonar_tb_certo/fim_posicao
add wave -noupdate -height 35 /sonar_tb_certo/DUT/uc/Eatual
add wave -noupdate -height 35 -radix hexadecimal /sonar_tb_certo/DUT/fd/serial/dados
add wave -noupdate -height 35 -radix ascii /sonar_tb_certo/DUT/fd/serial/angulos
add wave -noupdate -color {Sky Blue} -height 35 /sonar_tb_certo/movimento
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 2} {192548975 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 242
configure wave -valuecolwidth 48
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
WaveRestoreZoom {0 ns} {530284304 ns}
