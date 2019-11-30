library ieee;				 			
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.FSM_RLE.all;

-- Add your library and packages declaration here ...

entity gpr_tb is
end gpr_tb;

architecture TB_ARCHITECTURE of gpr_tb is
	-- Component declaration of the tested unit
	component gpr
		port(
			AA : out STD_LOGIC_VECTOR(0 to 7);
			BB : out STD_LOGIC_VECTOR(0 to 7);
			CC : out STD_LOGIC_VECTOR(0 to 7);
			DD : out STD_LOGIC_VECTOR(0 to 7);
			II : out STD_LOGIC_VECTOR(0 to 7);
			JJ : out STD_LOGIC_VECTOR(0 to 7);
			ADRR : out STD_LOGIC_VECTOR(0 to 7);
			DATT : out STD_LOGIC_VECTOR(0 to 7);
			WR : in STD_LOGIC;
			CLK : in STD_LOGIC;
			RST : in STD_LOGIC;
			ALU_RESULT : in BYTE;
			RAM_DATA : in BYTE;
			IR : in BYTE;
			DATA_SRC : in STD_LOGIC_VECTOR(0 to 1);
			REG_SRC : in REGI;
			REG_DST : in REGI );
	end component;
	
	-- Stimulus signals - signals mapped to the input and inout ports of tested entity
	signal WR : STD_LOGIC;
	signal CLK : STD_LOGIC;
	signal RST : STD_LOGIC;
	signal ALU_RESULT : BYTE;
	signal RAM_DATA : BYTE;
	signal IR : BYTE;
	signal DATA_SRC : STD_LOGIC_VECTOR(0 to 1);
	signal REG_SRC : REGI;
	signal REG_DST : REGI;
	-- Observed signals - signals mapped to the output ports of tested entity
	signal AA : STD_LOGIC_VECTOR(0 to 7);
	signal BB : STD_LOGIC_VECTOR(0 to 7);
	signal CC : STD_LOGIC_VECTOR(0 to 7);
	signal DD : STD_LOGIC_VECTOR(0 to 7);
	signal II : STD_LOGIC_VECTOR(0 to 7);
	signal JJ : STD_LOGIC_VECTOR(0 to 7);
	signal ADRR : STD_LOGIC_VECTOR(0 to 7);
	signal DATT : STD_LOGIC_VECTOR(0 to 7);		
	
	constant clk_period : time := 10ns;
	
begin
	
	-- Unit Under Test port map
	UUT : gpr
	port map (
		AA => AA,
		BB => BB,
		CC => CC,
		DD => DD,
		II => II,
		JJ => JJ,
		ADRR => ADRR,
		DATT => DATT,
		WR => WR,
		CLK => CLK,
		RST => RST,
		ALU_RESULT => ALU_RESULT,
		RAM_DATA => RAM_DATA,
		IR => IR,
		DATA_SRC => DATA_SRC,
		REG_SRC => REG_SRC,
		REG_DST => REG_DST
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
			DATA_SRC <= "01"; -- ram data
			REG_DST <= conv_std_logic_vector(r, 3);
			RAM_DATA <= conv_std_logic_vector(r, 8);
			WR <= '1';			 		
			wait for clk_period;
			WR <= '0';	   
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

