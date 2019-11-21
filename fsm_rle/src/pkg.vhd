library IEEE;
use IEEE.STD_LOGIC_1164.all;

package FSM_RLE is
	subtype BYTE is std_logic_vector(7 downto 0);
	subtype NIBBLE is std_logic_vector(3 downto 0);
	subtype REGI is std_logic_vector(2 downto 0);	
	
	type ROM_UNIT_OUTPUTS is record	 
		CLK: std_logic;
		RST: std_logic;
		PC_EN: std_logic;
		IR_EN: std_logic;
		EN: std_logic;
		L: std_logic;
	end record ROM_UNIT_OUTPUTS;	
	
	type ROM_UNIT_INPUTS is record   
		IR: BYTE;		   	
	end record ROM_UNIT_INPUTS; 
	
	type RAM_UNIT_INPUTS is record	
		DATA: BYTE;
	end record RAM_UNIT_INPUTS; 
	
	type LIFO_UNIT_OUTPUTS is record	
		CLK: std_logic;
		RST: std_logic;
		ALU_RESULT: BYTE;
		RAM_DATA: BYTE;
		IR: NIBBLE;
		EN: std_logic; 					   			   
		MODE: std_logic_vector(1 downto 0);
		PUSHDATA: std_logic_vector(1 downto 0);
	end record LIFO_UNIT_OUTPUTS;	
	
	type RAM_UNIT_OUTPUTS is record	
		CLK: std_logic;
		RST: std_logic;	 
		TOS: NIBBLE; 
		TOS_1: BYTE;
		IR: NIBBLE;
		R_EN: std_logic;
		W_EN: std_logic;   
		ADR_SEL: std_logic;
		ADR_EN: std_logic;
		DATA_EN: std_logic;
	end record RAM_UNIT_OUTPUTS; 
	
	type FSM_LIFO_INPUTS is record
		EMPTY: std_logic;
		FULL: std_logic; 
		TOS: BYTE;
		TOS_1: BYTE;  
		IR: NIBBLE;
	end record;   
	
	type FSM_ALU_INPUTS is record
		L_FLAG: std_logic; 
		DATA: BYTE;
	end record;
	
	type FSM_ALU_OUTPUTS is record
		CLK: std_logic; 
		RST: std_logic; 
		ARG_1: BYTE; 
		ARG_2: BYTE; 
		OPCODE: NIBBLE; 
		DATA: BYTE;
		EN: std_logic;
	end record;
	
	-- instructions
--  constant PUSHV: NIBBLE := "0000"; 
--	constant PUSHC: NIBBLE := "0001"; 
--	constant WR: NIBBLE := "0010"; 
--	constant RD: NIBBLE := "0011"; 
--	constant ADD: NIBBLE := "0100"; 
--	constant INC: NIBBLE := "0101"; 
--	constant CMP: NIBBLE := "0110"; 
--	constant JL: NIBBLE := "0111"; 
--	constant STOP: NIBBLE := "1000"; 
--	constant NONE: NIBBLE := "1111"; 
															   
	constant MOV: NIBBLE := "0000";
	constant RD: NIBBLE := "0001";
	constant WR: NIBBLE := "0010";
	constant MOVDAT: NIBBLE := "0011";
	--constant CMP: NIBBLE := "0100";
	constant JEQ: NIBBLE := "0101";
	constant JEG: NIBBLE := "0110";
	constant JMP: NIBBLE := "0111";
	constant MOV2D: NIBBLE := "1000";
	constant INC: NIBBLE := "1001";
	constant ADD: NIBBLE := "1010";
	constant MOV2DAT: NIBBLE := "1011";
	constant MOV2ADR: NIBBLE := "1100";
	
	-- registers
	constant A: REGI := "000";
	constant B: REGI := "001";
	constant C: REGI := "010";
	constant D: REGI := "011"; -- it is a register which is used as one of operands for commands CMP and ADD
	constant I: REGI := "100";
	constant J: REGI := "101";
	constant ADR: REGI := "110";
	constant DAT: REGI := "111";
	
	type GPR_STATE is record	
		A: BYTE; 	
		B: BYTE; 	
		C: BYTE; 	
		D: BYTE; 	
		I: BYTE; 	
		J: BYTE; 	
		ADR: BYTE; 	
		DAT: BYTE; 
	end record;
end FSM_RLE;   

package body FSM_RLE is
end FSM_RLE;