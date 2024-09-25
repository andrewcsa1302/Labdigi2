transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/tx_serial_uc.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/tx_serial_7O1_fd.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/tx_serial_7O1.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/saida_serial_uc.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/saida_serial_fd.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/saida_serial.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/registrador_n.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/mux_4x1_n.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/interface_hcsr04_uc.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/interface_hcsr04_fd.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/interface_hcsr04.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/hexa7seg.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/gerador_pulso.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/exp4_trena.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/edge_detector.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/deslocador_n.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/contador_m.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/contador_cm_uc.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/contador_cm_fd.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/contador_cm.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/contador_bcd_3digitos.v}

vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/exp4-labdigi2 {C:/Users/pptel/Labdigi2/exp4-labdigi2/tb_exp4_trena.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_exp4_trena

add wave *
view structure
view signals
run -all