-------------------------------------------------------------------------------
--
-- Title       : ALU_UNIT_X
-- Design      : fsm_rle
-- Author      : maxim
-- Company     : none
--
-------------------------------------------------------------------------------
--
-- File        : ALU_UNIT_X.vhd
-- Generated   : Sat Nov 30 14:52:53 2019
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {ALU_UNIT_X} architecture {ALU_UNIT_X}}

library IEEE;				 			
use IEEE.STD_LOGIC_1164.all;
use work.FSM_RLE.all;

entity ALU_UNIT_X is
	port(
		ALU_IN : in ALU_UNIT_OUTPUTS; -- it is output for fsm
		ALU_OUT : out ALU_UNIT_INPUTS -- it is input for fsm
		);
end ALU_UNIT_X;							  

architecture ALU_UNIT_X of ALU_UNIT_X is 
	
	component ALU_UNIT is
		port(
			CLK : in STD_LOGIC;
			RST : in STD_LOGIC;
			EN : in STD_LOGIC;
			ARG_1 : in BYTE;
			ARG_2 : in BYTE;
			OPCODE : in NIBBLE;										 
			
			EQ_FLAG: out std_logic; -- if arg_1 == arg_2
			GT_FLAG: out std_logic; -- if arg_1 > arg_2
			
			RESULT : out BYTE
			);
	end component;
	
begin
	
	U_ALU_UNIT: ALU_UNIT port map (
		ALU_IN.CLK, ALU_IN.RST, ALU_IN.EN, ALU_IN.ARG_1, ALU_IN.ARG_2, ALU_IN.OPCODE,
		ALU_OUT.EQ_FLAG, ALU_OUT.GT_FLAG, ALU_OUT.DATA
		);
	
end ALU_UNIT_X;
