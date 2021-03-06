transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Test/draw {D:/GZM/study/ELSE/ECE385_Project/Final/Test/draw/triangle_fifo_ram.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Test/draw {D:/GZM/study/ELSE/ECE385_Project/Final/Test/draw/triangle_fifo.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Test/draw {D:/GZM/study/ELSE/ECE385_Project/Final/Test/draw/fifo_writer.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Test/draw {D:/GZM/study/ELSE/ECE385_Project/Final/Test/draw/draw_test_top.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Test/draw {D:/GZM/study/ELSE/ECE385_Project/Final/Test/draw/draw_line.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Test/draw {D:/GZM/study/ELSE/ECE385_Project/Final/Test/draw/draw.sv}
vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Test/draw {D:/GZM/study/ELSE/ECE385_Project/Final/Test/draw/draw_triangle.sv}

vlog -sv -work work +incdir+D:/GZM/study/ELSE/ECE385_Project/Final/Test/draw {D:/GZM/study/ELSE/ECE385_Project/Final/Test/draw/draw_test_top_testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  draw_test_top_testbench

add wave *
view structure
view signals
run 10000 ns
