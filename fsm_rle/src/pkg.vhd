library IEEE;
use IEEE.STD_LOGIC_1164.all;

package FSM_RLE is
	subtype BYTE is std_logic_vector(7 downto 0);
	subtype NIBBLE is std_logic_vector(3 downto 0);
							 
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