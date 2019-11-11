library fsm_rle;
use fsm_rle.FSM_RLE.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

	-- Add your library and packages declaration here ...

entity ram_tb is
end ram_tb;

architecture TB_ARCHITECTURE of ram_tb is
	-- Component declaration of the tested unit
	component ram
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		W_EN : in STD_LOGIC;
		R_EN : in STD_LOGIC;
		ADR : in NIBBLE;
		DIN : in BYTE;
		DOUT : out BYTE );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC;
	signal RST : STD_LOGIC;
	signal W_EN : STD_LOGIC;
	signal R_EN : STD_LOGIC;
	signal ADR : NIBBLE;
	signal DIN : BYTE;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal DOUT : BYTE;	   
	
	constant clk_period: time := 10ns;

begin

	-- Unit Under Test port map
	UUT : ram
		port map (
			CLK => CLK,
			RST => RST,
			W_EN => W_EN,
			R_EN => R_EN,
			ADR => ADR,
			DIN => DIN,
			DOUT => DOUT
		);

	CLK_PROCESS: process
	begin
		CLK <= '0'; wait for clk_period / 2;
		CLK <= '1'; wait for clk_period / 2;
	end process;   
	
	--READ_STIMULUS_PROCESS: process
--	begin
--		wait for clk_period / 2;
--																
--		RST <= '1'; wait for clk_period;   
--		RST <= '0'; wait for clk_period;   
--		
--		for i in 0 to 15 loop
--			ADR <= conv_std_logic_vector(i, 4); wait for clk_period;
--			R_EN <= '1'; wait for clk_period;
--			R_EN <= '0';
--		end loop; 
--		
--		wait for 20 * clk_period;
--		
--		report "End of simulation" severity failure;
--	end process; 

	
	READ_WRITE_STIMULUS_PROCESS: process
	begin
		wait for clk_period / 2;
																
		RST <= '1'; wait for clk_period;   
		RST <= '0'; wait for clk_period;
		DIN <= "10100101";
		
		for i in 0 to 15 loop
			ADR <= conv_std_logic_vector(i, 4); wait for clk_period; 
			R_EN <= '1'; wait for clk_period;
			R_EN <= '0';
			W_EN <= '1'; wait for clk_period;
			W_EN <= '0';
		end loop; 
		
		wait for clk_period;
		DIN <= (others => '0');
		for i in 0 to 15 loop
			ADR <= conv_std_logic_vector(i, 4); wait for clk_period;
			R_EN <= '1'; wait for clk_period;
			R_EN <= '0';
		end loop; 
		
		wait for 20 * clk_period;
		
		report "End of simulation" severity failure;
	end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_ram of ram_tb is
	for TB_ARCHITECTURE
		for UUT : ram
			use entity work.ram(ram);
		end for;
	end for;
end TESTBENCH_FOR_ram;

