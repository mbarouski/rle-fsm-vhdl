library fsm_rle;
use fsm_rle.FSM_RLE.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

	-- Add your library and packages declaration here ...

entity alu_unit_tb is
end alu_unit_tb;

architecture TB_ARCHITECTURE of alu_unit_tb is
	-- Component declaration of the tested unit
	component alu_unit
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		EN : in STD_LOGIC;
		ARG_1 : in BYTE;
		ARG_2 : in BYTE;
		OPCODE : in NIBBLE;
		EQ_FLAG : out STD_LOGIC;
		GT_FLAG : out STD_LOGIC;
		RESULT : out BYTE );
	end component;

	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal CLK : STD_LOGIC;
	signal RST : STD_LOGIC;
	signal EN : STD_LOGIC;
	signal ARG_1 : BYTE;
	signal ARG_2 : BYTE;
	signal OPCODE : NIBBLE;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal EQ_FLAG : STD_LOGIC;
	signal GT_FLAG : STD_LOGIC;
	signal RESULT : BYTE;

	constant clk_period : time := 10ns;

begin

	-- Unit Under Test port map
	UUT : alu_unit
		port map (
			CLK => CLK,
			RST => RST,
			EN => EN,
			ARG_1 => ARG_1,
			ARG_2 => ARG_2,
			OPCODE => OPCODE,
			EQ_FLAG => EQ_FLAG,
			GT_FLAG => GT_FLAG,
			RESULT => RESULT
		);					   				
		
	clk_process: process
	begin	   								  						   
		CLK <= '0'; wait for clk_period / 2;
		CLK <= '1'; wait for clk_period / 2;
	end process;				   				
		
	stim_process: process
	begin	   								
		RST <= '1'; wait for clk_period;	
		RST <= '0'; wait for clk_period; 
										   
		ARG_1 <= "00000101";
		ARG_2 <= "00000111"; 
		OPCODE <= ADD;
		EN <= '1';
		wait for clk_period;
		EN <= '0';	  
		wait for clk_period;
		
		OPCODE <= INC;
		EN <= '1';
		wait for clk_period;
		EN <= '0';	  
		wait for clk_period;	
										   
		ARG_1 <= "00000101";
		ARG_2 <= "00000111"; 
		OPCODE <= CMP;
		EN <= '1';
		wait for clk_period;
		EN <= '0';	  
		wait for clk_period;	
										   
		ARG_1 <= "00000111";
		ARG_2 <= "00000101"; 
		OPCODE <= CMP;
		EN <= '1';
		wait for clk_period;
		EN <= '0';	  
		wait for clk_period;	
										   
		ARG_1 <= "00000101";
		ARG_2 <= "00000101"; 
		OPCODE <= CMP;
		EN <= '1';
		wait for clk_period;
		EN <= '0';	  
		wait for clk_period;
		
		wait for 3 * clk_period; 
		
		report "End of simulation" severity failure;
	end process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_alu_unit of alu_unit_tb is
	for TB_ARCHITECTURE
		for UUT : alu_unit
			use entity work.alu_unit(alu_unit);
		end for;
	end for;
end TESTBENCH_FOR_alu_unit;

