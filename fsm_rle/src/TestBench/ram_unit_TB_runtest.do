SetActiveLib -work
comp -include "$dsn\src\RAM_UNIT.vhd" 
comp -include "$dsn\src\TestBench\ram_unit_TB.vhd" 
asim +access +r TESTBENCH_FOR_ram_unit 
wave 
wave -noreg CLK
wave -noreg RST
wave -noreg TOS
wave -noreg TOS_1
wave -noreg IR
wave -noreg ADR_SEL
wave -noreg ADR_EN
wave -noreg DATA_EN
wave -noreg W_EN
wave -noreg R_EN
wave -noreg RAM_DATA
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\ram_unit_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_ram_unit 
