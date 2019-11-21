SetActiveLib -work
comp -include "$dsn\src\ALU_UNIT.vhd" 
comp -include "$dsn\src\TestBench\alu_unit_TB.vhd" 
asim +access +r TESTBENCH_FOR_alu_unit 
wave 
wave -noreg CLK
wave -noreg RST
wave -noreg EN
wave -noreg ARG_1
wave -noreg ARG_2
wave -noreg OPCODE
wave -noreg EQ_FLAG
wave -noreg GT_FLAG
wave -noreg RESULT
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\alu_unit_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_alu_unit 
