SetActiveLib -work
comp -include "$dsn\src\GPR.vhd" 
comp -include "$dsn\src\TestBench\gpr_TB.vhd" 
asim +access +r TESTBENCH_FOR_gpr 
wave 
wave -noreg WR
wave -noreg RD
wave -noreg CLK
wave -noreg RST
wave -noreg DATAIN
wave -noreg REG
wave -noreg DATAOUT
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\gpr_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_gpr 
