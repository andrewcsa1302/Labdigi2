onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 35 /sonar_seg_tb/clock
add wave -noupdate -height 35 /sonar_seg_tb/reset
add wave -noupdate -height 35 /sonar_seg_tb/ligar
add wave -noupdate -height 35 /sonar_seg_tb/echo
add wave -noupdate -height 35 /sonar_seg_tb/trigger
add wave -noupdate -height 35 /sonar_seg_tb/pwm
add wave -noupdate -color Yellow -height 35 /sonar_seg_tb/saida_serial
add wave -noupdate -height 35 /sonar_seg_tb/fim_posicao
add wave -noupdate -height 35 /sonar_seg_tb/DUT/uc/Eatual
add wave -noupdate -height 35 /sonar_seg_tb/DUT/fd/serial/dados
add wave -noupdate -height 35 -radix ascii /sonar_seg_tb/DUT/fd/serial/angulos
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3520109 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 242
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
WaveRestoreZoom {0 ns} {15165583 ns}
