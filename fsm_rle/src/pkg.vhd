library IEEE;
use IEEE.STD_LOGIC_1164.all;

package FSM_RLE is
	subtype BYTE is std_logic_vector(7 downto 0);
	subtype NIBBLE is std_logic_vector(3 downto 0);	
	
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
	
	constant PUSHV: NIBBLE := "0000"; 
	constant PUSHC: NIBBLE := "0001"; 
	constant WR: NIBBLE := "0010"; 
	constant RD: NIBBLE := "0011"; 
	constant ADD: NIBBLE := "0100"; 
	constant INC: NIBBLE := "0101"; 
	constant CMP: NIBBLE := "0110"; 
	constant JL: NIBBLE := "0111"; 
	constant STOP: NIBBLE := "1000"; 
	constant NONE: NIBBLE := "1111"; 
end FSM_RLE;   

package body FSM_RLE is
end FSM_RLE;