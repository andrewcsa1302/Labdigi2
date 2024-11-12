transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/uc_nova_entrada.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/uc_movimento.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/sync_ram_16x7_mod.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/smart_cargo_fd.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/smart_cargo.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/rx_serial_uc.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/rx_serial_8N1_fd.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/rx_serial_8N1.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/registrador_n.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/registrador_4.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/ram_conteudo_elevador.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/interface_hcsr04_uc.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/interface_hcsr04_fd.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/interface_hcsr04.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/hexa7seg.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/gerador_pulso.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/edge_detector.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/deslocador_n.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/conversor_andarXcm.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/contador_p.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/contador_m .v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/contador_cm_uc.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/contador_cm_fd.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/contador_cm.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/contador_bcd_3digitos.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/comparador_85.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/andar_ultrassonico.v}
vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo {C:/Users/pptel/Labdigi2/SmartCargo/andar_atual.v}

vlog -vlog01compat -work work +incdir+C:/Users/pptel/Labdigi2/SmartCargo/Quartus/../Testbench {C:/Users/pptel/Labdigi2/SmartCargo/Quartus/../Testbench/tb_smartcargo.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_smartcargo

add wave *
view structure
view signals
run -all
