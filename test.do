add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/reset
add wave -position end  sim:/processor/interrupt
add wave -position end  sim:/processor/fetchPcEG/PC_OUT
add wave -position end  sim:/processor/fetchIMEM/dataout
add wave -position end  sim:/processor/fetchPipeREG/INSTRUCTION_IF_EX

force -freeze sim:/processor/clk 0 5, 1 {10 ns} -r 10
force -freeze sim:/processor/interrupt 0 0
force -freeze sim:/processor/reset 1 0
run
force -freeze sim:/processor/reset 0 0
run
run
run
run
run
run
run
run
run
run
run
run