SetActiveLib -work
comp -include "$dsn\src\GPR.vhd" 
comp -include "$dsn\src\TestBench\gpr_TB.vhd" 
asim +access +r TESTBENCH_FOR_gpr 
wave 
wave -noreg AA
wave -noreg BB
wave -noreg CC
wave -noreg DD
wave -noreg II
wave -noreg JJ
wave -noreg ADRR
wave -noreg DATT
wave -noreg WR
wave -noreg CLK
wave -noreg RST
wave -noreg ALU_RESULT
wave -noreg RAM_DATA
wave -noreg IR
wave -noreg DATA_SRC
wave -noreg REG_SRC
wave -noreg REG_DST
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\gpr_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_gpr 
