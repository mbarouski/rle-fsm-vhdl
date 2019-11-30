library IEEE;
use IEEE.STD_LOGIC_1164.all;

package FSM_RLE is
	subtype BYTE is std_logic_vector(7 downto 0);
	subtype NIBBLE is std_logic_vector(3 downto 0);
	subtype REGI is std_logic_vector(2 downto 0);	
	
	-- this is what fsm outputs to rom
	type ROM_UNIT_OUTPUTS is record	 
		CLK: std_logic;
		RST: std_logic;
		PC_EN: std_logic;
		IR_EN: std_logic;
		EN: std_logic;
		EQ: std_logic;
		GT: std_logic;
		D: BYTE;
	end record;	

	-- this is what fsm inputs from rom
	type ROM_UNIT_INPUTS is record   
		IR: BYTE; -- instruction	   	
	end record; 
		  
	-- this is what fsm outputs to ram
	type RAM_UNIT_OUTPUTS is record	
		CLK: std_logic;
		RST: std_logic;
		IR: NIBBLE;
		R_EN: std_logic;
		W_EN: std_logic;   
--		ADR_SEL: std_logic;
		ADR_EN: std_logic;
		DATA_EN: std_logic;	 
		ADR: BYTE; -- address to read or write 
		DATA: BYTE; -- data for writing		  
	end record; 
		   
	-- this is what fsm inputs from ram
	type RAM_UNIT_INPUTS is record	
		DATA: BYTE; -- read data
	end record; 
				   
	-- this is what fsm outputs to gpr
	type GPR_UNIT_OUTPUTS is record	
		CLK: std_logic;
		RST: std_logic;	
		
		-- sources of input data 
		PUSHDATA: std_logic_vector(0 to 1); -- for mutex which decides what data should be written
		ALU_RESULT: BYTE;
		RAM_DATA: BYTE;
		IR: BYTE; -- todo: uconnect it with smth in fsm
		
		--EN: std_logic; 
		W_EN: std_logic;
		REG_SRC: std_logic_vector(0 to 2);	   			   
		REG_DST: std_logic_vector(0 to 2);		  
	end record;	
				 
	-- this is what fsm inputs from gpr
	type GPR_UNIT_INPUTS is record 
		A: BYTE;
		B: BYTE;
		C: BYTE;
		D: BYTE;
		I: BYTE;
		J: BYTE;
		ADR: BYTE; 
		DAT: BYTE;
	end record;   
	
	type ALU_UNIT_OUTPUTS is record
		CLK: std_logic; 
		RST: std_logic; 
		ARG_1: BYTE; 
		ARG_2: BYTE; 
		OPCODE: NIBBLE; 
		DATA: BYTE;
		EN: std_logic;
	end record;
	
	type ALU_UNIT_INPUTS is record 
		EQ_FLAG: std_logic;
		GT_FLAG: std_logic; 
		DATA: BYTE;
	end record;	  
	
	-- instructions															   
	constant MOV: NIBBLE := "0000";										   
	--constant MOVC: NIBBLE := "1111";
	constant RD: NIBBLE := "0001";
	constant WR: NIBBLE := "0010";
	constant MOVDAT: NIBBLE := "0011"; 
	constant CMP: NIBBLE := "0100";
	constant JEQ: NIBBLE := "0101";
	constant JEG: NIBBLE := "0110";
	constant JMP: NIBBLE := "0111";
	constant MOV2D: NIBBLE := "1000";
	constant INC: NIBBLE := "1001";
	constant ADD: NIBBLE := "1010";
	constant MOV2DAT: NIBBLE := "1011";
	constant MOV2ADR: NIBBLE := "1100"; 
	constant STOP: NIBBLE := "1101"; 
	constant NONE: NIBBLE := "1110";
	
	-- registers
	constant A: REGI := "000";
	constant B: REGI := "001";
	constant C: REGI := "010";
	constant D: REGI := "011"; -- it is a register which is used as one of operands for commands CMP and ADD and JEQ and JEG
	constant I: REGI := "100";
	constant J: REGI := "101";
	constant ADR: REGI := "110";
	constant DAT: REGI := "111";
	
	-- keeping value for each register
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