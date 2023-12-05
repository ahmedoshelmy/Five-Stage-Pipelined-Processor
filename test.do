vsim work.processor
add wave -position end  sim:/processor/reset
add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/pc
add wave -position end  sim:/processor/instruction_if_ex
add wave -position end  sim:/processor/pc_if_ex
add wave -position end  sim:/processor/alu_src_2_id_ex
add wave -position end  sim:/processor/alu_op_id_ex
add wave -position end  sim:/processor/alu_out_ex
add wave -position end  sim:/processor/alu_out_ex_mem
add wave -position end  sim:/processor/alu_src_2_ex_mem
add wave -position end  sim:/processor/imm_en
add wave -position end  sim:/processor/imm_en_internal


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
