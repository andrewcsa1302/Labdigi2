onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 35 /sonar_tb/DUT/clock
add wave -noupdate -height 35 /sonar_tb/DUT/reset
add wave -noupdate -height 35 /sonar_tb/DUT/ligar
add wave -noupdate -height 35 /sonar_tb/DUT/echo
add wave -noupdate -color {Cornflower Blue} -height 35 /sonar_tb/DUT/trigger
add wave -noupdate -color Yellow -height 35 /sonar_tb/DUT/saida_serial
add wave -noupdate -color Salmon -height 35 /sonar_tb/DUT/pwm
add wave -noupdate -color Violet -height 35 -radix binary /sonar_tb/DUT/fim_posicao
add wave -noupdate -height 34 /sonar_tb/DUT/fd/fim_2s
add wave -noupdate -height 34 -radix hexadecimal /sonar_tb/DUT/fd/serial/dados
add wave -noupdate -height 34 -radix ascii /sonar_tb/DUT/fd/serial/angulos
add wave -noupdate -height 34 /sonar_tb/DUT/uc/Eatual
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 4} {1948 ns} 0} {{Cursor 3} {2274 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 211
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
WaveRestoreZoom {733402371 ns} {733402697 ns}
