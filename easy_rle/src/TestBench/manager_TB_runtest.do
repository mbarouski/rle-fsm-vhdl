SetActiveLib -work
comp -include "$dsn\src\manager.vhd" 
comp -include "$dsn\src\TestBench\manager_TB.vhd" 
asim +access +r TESTBENCH_FOR_manager 
wave 
wave -noreg clk
wave -noreg en
wave -noreg src_addr
wave -noreg dest_addr
wave -noreg array_size
wave -noreg finish
wave -noreg number
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\manager_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_manager 
