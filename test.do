vsim -voptargs=+acc work.processor

add wave -position end  sim:/processor/reset
add wave -position end  sim:/processor/reset_internal
add wave -position end  sim:/processor/clk

add wave -position end  sim:/processor/pc
add wave -position end  sim:/processor/instruction_if_ex
add wave -position end  sim:/processor/pc_if_ex

add wave -position end  sim:/processor/alu_src_2_id_ex
add wave -position end  sim:/processor/alu_op_id_ex

add wave -position end  sim:/processor/alu_out_ex_mem
add wave -position end  sim:/processor/alu_src_2_ex_mem
add wave -position end  sim:/processor/mem_read_ex_mem
add wave -position end  sim:/processor/mem_write_ex_mem

add wave -position end  sim:/processor/mem_out_mem_wb
add wave -position end  sim:/processor/alu_out_mem_wb
add wave -position end  sim:/processor/wb_src_mem_wb
add wave -position end  sim:/processor/address_mem_in
add wave -position end  sim:/processor/mem_protect_ex_mem
add wave -position end  sim:/processor/memoryDataMemory/ISPROTECTEDMEMORY

add wave -position end  sim:/processor/reg_one_write_mem_wb
add wave -position end  sim:/processor/rd1_mem_wb
add wave -position end  sim:/processor/regWriteData
add wave -position end sim:/processor/decode_REGFILE/registers
add wave -position end  sim:/processor/wb_PORTS/outPortReg




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
