SetActiveLib -work
comp -include "$dsn\src\rle_encoder.vhd" 
comp -include "$dsn\src\TestBench\rle_encoder_tb.vhd" 
asim +access +r TESTBENCH_FOR_rle_encoder 
wave 					
wave -noreg enable
wave -noreg clk
wave -noreg input
wave -noreg output
wave -noreg counter
wave -noreg read
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\rle_encoder_tb_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_rle_encoder 
