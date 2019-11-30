library ieee;
use ieee.std_logic_1164.all;
use work.FSM_RLE.all;

-- Add your library and packages declaration here ...

entity rom_unit_tb is
end rom_unit_tb;

architecture TB_ARCHITECTURE of rom_unit_tb is
	-- Component declaration of the tested unit
	component rom_unit
		port(
			CLK : in STD_LOGIC;
			RST : in STD_LOGIC;
			PC_EN : in STD_LOGIC;
			IR_EN : in STD_LOGIC;
			ROM_EN : in STD_LOGIC;
			EQ: in std_logic;
			GT: in std_logic; 
			D: in std_logic_vector(0 to 7);
			IR_OUT : out BYTE );
	end component;
	
	signal CLK : STD_LOGIC;	  
	signal RST : STD_LOGIC;
	signal EQ : STD_LOGIC;
	signal GT : STD_LOGIC;	
	signal D: std_logic_vector(0 to 7);
	signal PC_EN : STD_LOGIC;
	signal IR_EN : STD_LOGIC;
	signal ROM_EN : STD_LOGIC; 												   
	signal IR_OUT : BYTE;
	
	constant clk_period : time := 10ns;	   
	
	type t_micro_instruction is (
	i_MOV, i_MOV2ADR, i_MOV2D, i_MOV2DAT, i_MOVDAT,
	i_WR, i_RD, i_ADD, i_INC, i_CMP, i_JEQ,
	i_JEG, i_JMP, i_STOP, i_NONE
	);	   
	
	signal m_inst: t_micro_instruction;
	signal opcode: NIBBLE;
	
begin
	
	-- Unit Under Test port map
	UUT : rom_unit
	port map (
		CLK => CLK,
		RST => RST,
		PC_EN => PC_EN,
		IR_EN => IR_EN,
		ROM_EN => ROM_EN,  
		EQ => EQ,
		GT => GT,	
		D => D,
		IR_OUT => IR_OUT
		);
	
	opcode <= IR_OUT(7 downto 4); 
	
	with opcode select m_inst <=  
	i_MOV when MOV, 
	i_WR when WR, 
	i_RD when RD, 
	i_ADD when ADD, 
	i_INC when INC, 
	i_CMP when CMP,    
	i_JEQ when JEQ,   
	i_JEG when JEG,   
	i_JMP when JMP,   
	i_STOP when STOP, 	  
	i_MOVDAT when MOVDAT,  
	i_MOV2DAT when MOV2DAT,	
	i_MOV2D when MOV2D, 
	i_MOV2ADR when MOV2ADR, 
	i_NONE when others;
	
	CLK_PROCESS: process
	begin							   					   
		CLK <= '0'; wait for clk_period / 2;
		CLK <= '1'; wait for clk_period / 2;
	end process;   
	
	STIMULATION_PROCESS: process 
		variable i: integer := 0;
	begin
		wait for clk_period / 2;
		
		RST <= '1'; wait for clk_period;
		RST <= '0'; wait for clk_period;
		
		while m_inst /= i_STOP loop			   		 
			ROM_EN <= '1'; wait for clk_period;
			ROM_EN <= '0';
			
			IR_EN <= '1'; wait for clk_period;
			IR_EN <= '0'; 
			
			if m_inst = i_CMP then
				if i < 2 then 
					GT <= '1'; 
					EQ <= '0';
				elsif i < 5 then
					GT <= '0'; 
					EQ <= '1';
				else 
					GT <= '0';
					EQ <= '0';
				end if;
				i := i + 1;
			else		   		 
				GT <= '0';
				EQ <= '0';
			end if;
			
			PC_EN <= '1'; wait for clk_period;
			PC_EN <= '0';
		end loop;
		
		wait for clk_period * 20;
		
		report "End of simulation" severity failure;
	end process;
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_rom_unit of rom_unit_tb is
	for TB_ARCHITECTURE
		for UUT : rom_unit
			use entity work.rom_unit(rom_unit);
		end for;
	end for;
end TESTBENCH_FOR_rom_unit;

