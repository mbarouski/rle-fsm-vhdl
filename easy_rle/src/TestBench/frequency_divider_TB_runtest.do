SetActiveLib -work
comp -include "$dsn\src\FREQUENCY_DIVIDER\frequency_divider.vhd" 
comp -include "$dsn\src\TestBench\frequency_divider_TB.vhd" 
asim +access +r TESTBENCH_FOR_frequency_divider 
wave 
wave -noreg clk_in
wave -noreg clk_out
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\frequency_divider_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_frequency_divider 
