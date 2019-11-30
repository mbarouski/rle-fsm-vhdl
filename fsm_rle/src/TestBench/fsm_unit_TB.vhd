library ieee;
use ieee.std_logic_1164.all;
use work.FSM_RLE.all;

	-- Add your library and packages declaration here ...

entity fsm_unit_tb is
end fsm_unit_tb;

architecture TB_ARCHITECTURE of fsm_unit_tb is
	-- Component declaration of the tested unit
	component fsm_unit
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		START : in STD_LOGIC;
		HALT : out STD_LOGIC;
		ERROR : out STD_LOGIC );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC;
	signal RST : STD_LOGIC;
	signal START : STD_LOGIC;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal HALT : STD_LOGIC;
	signal ERROR : STD_LOGIC;

	constant clk_period : time := 10ns;

begin

	-- Unit Under Test port map
	UUT : fsm_unit
		port map (
			CLK => CLK,
			RST => RST,
			START => START,
			HALT => HALT,
			ERROR => ERROR
		);

	clk_process: process
	begin
		clk <= '0'; wait for clk_period / 2;
		clk <= '1'; wait for clk_period / 2;
	end process;
	
	stim_process: process
	begin															  
		RST <= '1'; wait for clk_period;
		RST <= '0'; wait for clk_period;
		START <= '1'; wait for clk_period;
		START <= '0';
		
		wait for 120 * clk_period;
		
		report "End of simulation" severity failure;
	end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_fsm_unit of fsm_unit_tb is
	for TB_ARCHITECTURE
		for UUT : fsm_unit
			use entity work.fsm_unit(fsm_unit);
		end for;
	end for;
end TESTBENCH_FOR_fsm_unit;

