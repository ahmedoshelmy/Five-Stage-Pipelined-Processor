onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /processor/reset
add wave -noupdate /processor/clk
add wave -noupdate /processor/clk
add wave -noupdate /processor/instruction_if_ex
add wave -noupdate /processor/port_out
add wave -noupdate /processor/clk
add wave -noupdate /processor/flags_in_alu
add wave -noupdate /processor/alu_out_ex_mem
add wave -noupdate /processor/alu_src_2_ex_mem
add wave -noupdate /processor/decode_REGFILE/registers
add wave -noupdate /processor/executeALU/aluIn1
add wave -noupdate /processor/executeALU/aluIn2
add wave -noupdate /processor/executeALU/func
add wave -noupdate /processor/executeALU/flagsIn
add wave -noupdate /processor/executeALU/flagsOut
add wave -noupdate /processor/executeALU/aluOut
add wave -noupdate /processor/port_in
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2293 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {3255 ps}
