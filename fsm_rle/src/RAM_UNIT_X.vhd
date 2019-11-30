-------------------------------------------------------------------------------
--
-- Title       : RAM_UNIT_X
-- Design      : fsm_rle
-- Author      : Maxim
-- Company     : None
--
-------------------------------------------------------------------------------
--
-- File        : RAM_UNIT_X.vhd
-- Generated   : Wed Nov 13 23:11:03 2019
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
use work.FSM_RLE.all;

entity RAM_UNIT_X is
	port(
		RAM_IN : in RAM_UNIT_OUTPUTS; -- it is output for fsm
		RAM_OUT : out RAM_UNIT_INPUTS -- it is input for fsm
		);
end RAM_UNIT_X;								  

architecture RAM_UNIT_X of RAM_UNIT_X is 	 

	component RAM_UNIT is
		port(
			CLK : in STD_LOGIC;
			RST : in STD_LOGIC;	 
			ADR: in BYTE;
			DATA_IN: in BYTE;
			IR : in NIBBLE;			 
			ADR_EN : in STD_LOGIC;
			DATA_EN : in STD_LOGIC;
			W_EN : in STD_LOGIC;
			R_EN : in STD_LOGIC;
			RAM_DATA : out BYTE
			);
	end component;
	
begin									  
	
	U_RAM_UNIT_X: RAM_UNIT port map (
		RAM_IN.CLK, RAM_IN.RST, RAM_IN.ADR, RAM_IN.DATA, RAM_IN.IR, RAM_IN.ADR_EN, RAM_IN.DATA_EN, RAM_IN.W_EN, RAM_IN.R_EN,
		RAM_OUT.DATA
		);
	
end RAM_UNIT_X;
