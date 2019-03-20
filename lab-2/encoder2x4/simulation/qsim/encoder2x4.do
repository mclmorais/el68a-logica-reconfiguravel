onerror {quit -f}
vlib work
vlog -work work encoder2x4.vo
vlog -work work encoder2x4.vt
vsim -novopt -c -t 1ps -L cycloneiii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.encoder2x4_vlg_vec_tst
vcd file -direction encoder2x4.msim.vcd
vcd add -internal encoder2x4_vlg_vec_tst/*
vcd add -internal encoder2x4_vlg_vec_tst/i1/*
add wave /*
run -all
