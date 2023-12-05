vsim work.processor
add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/reset
add wave -position end  sim:/processor/fetchPcEG/PC_OUT
add wave -position end  sim:/processor/fetchIMEM/dataout
add wave -position end  sim:/processor/fetchPipeREG/INSTRUCTION_IF_EX
add wave -position end  sim:/processor/decodePipeReg/alu_op_out
add wave -position end  sim:/processor/decodePipeReg/rd1_out
add wave -position end  sim:/processor/decodePipeReg/alu_src_2_out

force -freeze sim:/processor/clk 0 5, 1 {10 ns} -r 10
force -freeze sim:/processor/interrupt 0 0
force -freeze sim:/processor/reset 1 0
force -freeze sim:/processor/decode_REGFILE/reg_file(0) 00 0
force -freeze sim:/processor/decode_REGFILE/reg_file(1) 10 0
force -freeze sim:/processor/decode_REGFILE/reg_file(2) 20 0
force -freeze sim:/processor/decode_REGFILE/reg_file(3) 30 0
force -freeze sim:/processor/decode_REGFILE/reg_file(4) 40 0
force -freeze sim:/processor/decode_REGFILE/reg_file(5) 50 0
force -freeze sim:/processor/decode_REGFILE/reg_file(6) 60 0
force -freeze sim:/processor/decode_REGFILE/reg_file(7) 70 0
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

