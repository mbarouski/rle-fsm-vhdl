SetActiveLib -work
comp -include "$dsn\src\FSM_UNIT.vhd" 
comp -include "$dsn\src\TestBench\fsm_unit_TB.vhd" 
asim +access +r TESTBENCH_FOR_fsm_unit 
wave 
wave -noreg CLK
wave -noreg RST
wave -noreg START
wave -noreg HALT
wave -noreg ERROR
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\fsm_unit_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_fsm_unit 
