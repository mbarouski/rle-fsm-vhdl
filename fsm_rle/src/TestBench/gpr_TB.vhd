library fsm_rle;
use fsm_rle.FSM_RLE.all;
library ieee;						   
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

	-- Add your library and packages declaration here ...

entity gpr_tb is
end gpr_tb;

architecture TB_ARCHITECTURE of gpr_tb is
	-- Component declaration of the tested unit
	component gpr
	port(
		WR : in STD_LOGIC;
		RD : in STD_LOGIC;
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		DATAIN : in BYTE;
		REG : in REGI;
		DATAOUT : out BYTE );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal WR : STD_LOGIC;
	signal RD : STD_LOGIC;
	signal CLK : STD_LOGIC;
	signal RST : STD_LOGIC;
	signal DATAIN : BYTE;
	signal REG : REGI;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal DATAOUT : BYTE;

	-- Add your code here ...
	
	constant clk_period : time := 10ns;

begin

	-- Unit Under Test port map
	UUT : gpr
		port map (
			WR => WR,
			RD => RD,
			CLK => CLK,
			RST => RST,
			DATAIN => DATAIN,
			REG => REG,
			DATAOUT => DATAOUT
		); 

	clk_process: process
	begin															  
		CLK <= '0'; wait for clk_period / 2;
		CLK <= '1'; wait for clk_period / 2;
	end process;

	wr_rd_process: process
	begin									
		RST <= '1'; wait for clk_period;	
		RST <= '0'; wait for clk_period;
		
		for r in 0 to 7 loop
			REG <= conv_std_logic_vector(r, 3);
			DATAIN <= conv_std_logic_vector(r, 8);
			WR <= '1';			 		
			wait for clk_period;
			WR <= '0';	   
			wait for clk_period;
		end loop;
		
		for r in 0 to 7 loop
			REG <= conv_std_logic_vector(r, 3);	
			RD <= '1';
			wait for clk_period;
			RD <= '0';	 
			wait for clk_period;
		end loop;  
		
		wait for 3 * clk_period;
		
		report "End of simulation" severity failure;
	end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_gpr of gpr_tb is
	for TB_ARCHITECTURE
		for UUT : gpr
			use entity work.gpr(gpr);
		end for;
	end for;
end TESTBENCH_FOR_gpr;

