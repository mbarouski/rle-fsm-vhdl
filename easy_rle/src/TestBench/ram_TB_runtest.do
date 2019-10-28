SetActiveLib -work
comp -include "$dsn\src\RAM\ram.vhd" 
comp -include "$dsn\src\TestBench\ram_TB.vhd" 
asim +access +r TESTBENCH_FOR_ram 
wave 
wave -noreg clk
wave -noreg rst
wave -noreg wr
wave -noreg rd
wave -noreg addr
wave -noreg data_in	
wave -noreg data_out
wave -noreg ram.ram_state
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\ram_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_ram 
