vsim -voptargs=+acc work.processor -t ps

restart -f

add wave -position end  sim:/processor/reset
add wave -position end  sim:/processor/clk

add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/instruction_if_ex
add wave -position end  sim:/processor/port_out
add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/flags_in_alu
add wave -position end  sim:/processor/alu_out_ex_mem
add wave -position end  sim:/processor/alu_src_2_ex_mem
add wave -position end  sim:/processor/decode_REGFILE/registers
add wave -position end  sim:/processor/executeALU/*


if {0} {
add wave -position end  sim:/processor/alu_src_2_ex_mem
add wave -position end  sim:/processor/mem_read_ex_mem
add wave -position end  sim:/processor/mem_write_ex_mem
add wave -position end  sim:/processor/alu_src_1_SEL
add wave -position end  sim:/processor/alu_src_2_SEL
add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/mem_out_mem_wb
add wave -position end  sim:/processor/alu_out_mem_wb
add wave -position end  sim:/processor/wb_src_mem_wb
add wave -position end  sim:/processor/address_mem_in
add wave -position end  sim:/processor/mem_protect_ex_mem
add wave -position end  sim:/processor/memoryDataMemory/ISPROTECTEDMEMORY

add wave -position end  sim:/processor/reg_one_write_mem_wb
add wave -position end  sim:/processor/rd1_mem_wb
add wave -position end  sim:/processor/regWriteData
add wave -position end  sim:/processor/outport
add wave -position end  sim:/processor/out_port_en_mem_wb
}


force -freeze sim:/processor/clk 0 0, 1 {50 ps} -r 100
add wave -position end   sim:/processor/port_in 
force -freeze sim:/processor/interrupt 0 0
force -freeze sim:/processor/reset 1 0
force -freeze sim:/processor/port_in 5 0

run
force -freeze sim:/processor/reset 0 0



force -freeze sim:/processor/port_in 5 0
run 250ps
force -freeze sim:/processor/port_in 19 0
run 100ps
force -freeze sim:/processor/port_in FFFD 0
run 100ps
force -freeze sim:/processor/port_in F320 0
run 2550ps