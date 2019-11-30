library fsm_rle;
use fsm_rle.FSM_RLE.all;
library ieee;
use ieee.std_logic_1164.all;

-- Add your library and packages declaration here ...

entity ram_unit_tb is
end ram_unit_tb;

architecture TB_ARCHITECTURE of ram_unit_tb is 
	
	component RAM_UNIT is
		port(
			CLK : in STD_LOGIC;
			RST : in STD_LOGIC;		 
			ADR: in BYTE;
			DATA_IN: in BYTE;
			IR : in NIBBLE;					 
			ADR_EN : in STD_LOGIC;
			DATA_EN : in STD_LOGIC;
			W_EN : in STD_LOGIC;
			R_EN : in STD_LOGIC;
			RAM_DATA : out BYTE
			);
	end component;
	
	signal CLK : STD_LOGIC;
	signal RST : STD_LOGIC;
	signal ADR : BYTE;
	signal DATA_IN : BYTE;
	signal IR : NIBBLE;		   
	signal ADR_EN : STD_LOGIC;
	signal DATA_EN : STD_LOGIC;
	signal W_EN : STD_LOGIC;
	signal R_EN : STD_LOGIC;
	signal RAM_DATA : BYTE;
	
	constant clk_period: time := 10ns;
	
begin
	
	-- Unit Under Test port map
	UUT : ram_unit
	port map (
		CLK => CLK,
		RST => RST,
		ADR => ADR,
		DATA_IN => DATA_IN,
		IR => IR,			
		ADR_EN => ADR_EN,
		DATA_EN => DATA_EN,
		W_EN => W_EN,
		R_EN => R_EN,
		RAM_DATA => RAM_DATA
		);	   	
	
	CLK_PROCESS: process
	begin															  
		CLK <= '0'; wait for clk_period / 2;
		CLK <= '1'; wait for clk_period / 2;
	end process;
	
	STIMULUS_PROCESS: process
	begin									
		wait for clk_period / 2;  
		
		RST <= '1'; wait for clk_period;
		RST <= '0'; wait for clk_period;  
		
		-- WR RAM[ADR] = RAM_DATA	 
		  
		ADR <= "00000001";
		DATA_IN <= "01010101";
		ADR_EN <= '1';
		DATA_EN <= '1'; wait for clk_period;  
		ADR_EN <= '0';
		DATA_EN <= '0';					  			  
		W_EN <= '1'; wait for clk_period;
		W_EN <= '0';
		
		-- RD RAM[ADR]
		
		ADR <= "00000001";
		ADR_EN <= '1'; wait for clk_period;
		ADR_EN <= '0';
		R_EN <= '1'; wait for clk_period;
		R_EN <= '0'; 
		
		-- RD RAM[ADR]
		
--		IR <= "0001";						 	 				
--		ADR_EN <= '1'; wait for clk_period;
--		ADR_EN <= '0'; 
--		R_EN <= '1'; wait for clk_period;
--		R_EN <= '0'; 
		
		wait for 5 * clk_period;
		
		report "End of simulation" severity failure;
	end process;
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_ram_unit of ram_unit_tb is
	for TB_ARCHITECTURE
		for UUT : ram_unit
			use entity work.ram_unit(ram_unit);
		end for;
	end for;
end TESTBENCH_FOR_ram_unit;

