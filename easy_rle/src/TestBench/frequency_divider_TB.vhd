library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;						

entity frequency_divider_tb is					 
	generic(
		N : INTEGER := 2 );
end frequency_divider_tb;

architecture TB_ARCHITECTURE of frequency_divider_tb is	 
	component frequency_divider
		generic(
			N : INTEGER := 2 );
		port(
			clk_in : in STD_LOGIC;
			clk_out : out STD_LOGIC );
	end component;
	
	signal clk_in : STD_LOGIC;												   
	signal clk_out : STD_LOGIC;
	
	constant clk_period: time := 1us;
	
begin
	UUT : frequency_divider
	generic map (
		N => N
		)
	port map (
		clk_in => clk_in,
		clk_out => clk_out
		);			  		 
	
	p: process
	begin	   	 
		clk_in <= '0';
		wait for clk_period/2;
		clk_in <= '1';
		wait for clk_period/2;
	end process p;
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_frequency_divider of frequency_divider_tb is
	for TB_ARCHITECTURE
		for UUT : frequency_divider
			use entity work.frequency_divider(frequency_divider);
		end for;
	end for;
end TESTBENCH_FOR_frequency_divider;

