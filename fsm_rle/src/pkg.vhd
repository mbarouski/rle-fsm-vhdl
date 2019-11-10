library IEEE;
use IEEE.STD_LOGIC_1164.all;

package FSM_RLE is
	subtype BYTE is std_logic_vector(7 downto 0);
	subtype NIBBLE is std_logic_vector(3 downto 0);
							 
	constant PUSHV: NIBBLE := "1111"; 
	constant PUSHC: NIBBLE := "1111"; 
	constant WR: NIBBLE := "1111"; 
	constant RD: NIBBLE := "1111"; 
	constant ADD: NIBBLE := "1111"; 
	constant INC: NIBBLE := "1111"; 
	constant CMP: NIBBLE := "1111"; 
	constant JL: NIBBLE := "1111"; 
	constant STOP: NIBBLE := "1111"; 
	constant NONE: NIBBLE := "1111"; 
end FSM_RLE;   

package body FSM_RLE is
end FSM_RLE;