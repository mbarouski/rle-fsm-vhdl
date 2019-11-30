-------------------------------------------------------------------------------
--
-- Title       : ROM_UNIT_X
-- Design      : fsm_rle
-- Author      : Maxim
-- Company     : None
--
-------------------------------------------------------------------------------
--
-- File        : ROM_UNIT_X.vhd
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
use FSM_RLE.all;

entity ROM_UNIT_X is
	port(
		ROM_IN : in ROM_UNIT_OUTPUTS; -- it is output for fsm
		ROM_OUT : out ROM_UNIT_INPUTS -- it is input for fsm		
		);
end ROM_UNIT_X;								  

architecture ROM_UNIT_X of ROM_UNIT_X is 	   
	
	component ROM_UNIT is
		port (
			CLK: in std_logic;
			RST: in std_logic;
			
			PC_EN: in std_logic;
			IR_EN: in std_logic;
			ROM_EN: in std_logic;
			
			EQ: in std_logic;
			GT: in std_logic;
			
			D: in BYTE;
			
			IR_OUT: out BYTE);
	end component;
	
begin									  
	
	U_ROM_UNIT_X: ROM_UNIT port map (
		ROM_IN.CLK, ROM_IN.RST, ROM_IN.PC_EN, ROM_IN.IR_EN, ROM_IN.EN, ROM_IN.EQ, ROM_IN.GT, ROM_IN.D,
		ROM_OUT.IR
		);
	
end ROM_UNIT_X;
