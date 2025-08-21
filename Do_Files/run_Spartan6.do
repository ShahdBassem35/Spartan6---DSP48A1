vlib work
vlog Spartan6.v Spartan6_tb.v
vsim -voptargs=+acc work.Spartan6_tb
add wave *
run -all
#quit -sim