-------------------------------------------------------------------------------
--
-- Title       : ALU_UNIT
-- Design      : fsm_rle
-- Author      : Maxim
-- Company     : None
--
-------------------------------------------------------------------------------
--
-- File        : ALU_UNIT.vhd
-- Generated   : Wed Nov 13 01:06:06 2019
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------	  

library IEEE;						   
use IEEE.STD_LOGIC_1164.all;		   
use IEEE.STD_LOGIC_ARITH.all;
use FSM_RLE.all;

entity ALU_UNIT is
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		EN : in STD_LOGIC;
		ARG_1 : in BYTE;
		ARG_2 : in BYTE;
		OPCODE : in NIBBLE;
		L_FLAG : out STD_LOGIC;
		RESULT : out BYTE
		);
end ALU_UNIT;								 

architecture ALU_UNIT of ALU_UNIT is   
	
	signal sarg2: std_logic; -- mux param to get the 2nd operand for add or inc (tos_1 or 1)
	signal reg_res: BYTE;
	signal op0, op1: BYTE;
	signal res: BYTE;	  
	signal l: std_logic;
	signal l_res: std_logic;
	
begin								   						  
	
	sarg2 <= '1' when OPCODE = INC else '0';
	
	P_OP1: process(ARG_2, sarg2)
	begin
		if sarg2 = '1' then
			op1 <= (0 => '1', others => '0');
		else
			op1 <= ARG_2;
		end if;
	end process;
	
	op0 <= ARG_1;
	
	P_ADDER: process(op0, op1)
	begin
		res <= conv_std_logic_vector(conv_integer(unsigned(op0)) + conv_integer(unsigned(op1)), 8);	
	end process;
	
	P_CMP: process(op0, op1)
	begin
		if op0 > op1 then
			l <= '1';
		else  
			l <= '0';
		end if;						 	
	end process; 
	
	P_REG_RES: process(CLK, RST, EN, OPCODE, sarg2, res)
	begin
		if RST = '1' then	  
			reg_res <= (others => '0');
		elsif EN = '1' then
			if OPCODE = ADD or sarg2 = '1' then
				if rising_edge(CLK) then
					reg_res <= res;
				end if;
			end if;
		end if;
	end process;
	
	P_L_RES: process(CLK, RST, EN, OPCODE, l)
	begin
		if RST = '1' then	  
			l_res <= '0';
		elsif EN = '1' then	
			if rising_edge(CLK) then  
				if OPCODE = CMP or OPCODE = JL then
					l_res <= l;
				else 
					l_res <= '0';
				end if;
			end if;	
		end if;
	end process;
	
	L_FLAG <= l_res;
	RESULT <= reg_res;
	
end ALU_UNIT;
