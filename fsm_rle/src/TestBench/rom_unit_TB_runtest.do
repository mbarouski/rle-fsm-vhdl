SetActiveLib -work
comp -include "$dsn\src\ROM_UNIT.vhd" 
comp -include "$dsn\src\TestBench\rom_unit_TB.vhd" 
asim +access +r TESTBENCH_FOR_rom_unit 
wave 
wave -noreg CLK
wave -noreg RST
wave -noreg PC_EN
wave -noreg IR_EN
wave -noreg ROM_EN
wave -noreg L
wave -noreg IR_OUT
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\rom_unit_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_rom_unit 
