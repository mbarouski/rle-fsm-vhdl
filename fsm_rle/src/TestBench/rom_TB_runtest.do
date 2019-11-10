SetActiveLib -work
comp -include "$dsn\src\pkg.vhd" 
comp -include "$dsn\src\rom.vhd" 
comp -include "$dsn\src\TestBench\rom_TB.vhd" 
asim +access +r TESTBENCH_FOR_rom 
wave 
wave -noreg clk
wave -noreg en
wave -noreg rst
wave -noreg adr
wave -noreg dout
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\rom_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_rom 
