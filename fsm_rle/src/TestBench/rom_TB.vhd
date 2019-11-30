library fsm_rle;
use fsm_rle.FSM_RLE.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

	-- Add your library and packages declaration here ...

entity rom_tb is
end rom_tb;

architecture TB_ARCHITECTURE of rom_tb is
	-- Component declaration of the tested unit
	component rom
	port(
		clk : in STD_LOGIC;
		en : in STD_LOGIC;
		rst : in STD_LOGIC;
		adr : in BYTE;
		dout : out BYTE );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal clk : STD_LOGIC;
	signal en : STD_LOGIC;
	signal rst : STD_LOGIC;
	signal adr : BYTE;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal dout : BYTE;

	constant clk_period: time := 10ns; 			
begin							
	UUT : rom
		port map (
			clk => clk,
			en => en,
			rst => rst,
			adr => adr,
			dout => dout
		);

	clk_process: process
	begin										 
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period / 2;
	end process;
	
	test_process: process
	begin	
		wait for clk_period / 2;
		
		rst <= '1'; wait for clk_period;
		rst <= '0'; wait for clk_period;		  
		
		for i in 0 to 15 loop
			adr <= conv_std_logic_vector(i, 4); wait for clk_period; 
			en <= '1'; wait for clk_period; 
			en <= '0';
		end loop;
						 
							 
		wait for clk_period;
		
		report "End of simulation" severity failure;
	end process test_process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_rom of rom_tb is
	for TB_ARCHITECTURE
		for UUT : rom
			use entity work.rom(rom);
		end for;
	end for;
end TESTBENCH_FOR_rom;

