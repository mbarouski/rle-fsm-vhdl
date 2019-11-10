-------------------------------------------------------------------------------
--
-- Title       : ROM_UNIT
-- Design      : fsm_rle
-- Author      : Maxim
-- Company     : None
--
-------------------------------------------------------------------------------
--
-- File        : ROM_UNIT.vhd
-- Generated   : Mon Nov 11 00:31:33 2019
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

entity ROM_UNIT is
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		PC_EN : in STD_LOGIC;
		IR_EN : in STD_LOGIC;
		ROM_EN : in STD_LOGIC;
		L : in STD_LOGIC;
		IR_OUT : out BYTE
		);
end ROM_UNIT;								

architecture ROM_UNIT of ROM_UNIT is 
	
	component ROM_IF is
		port(				   			  
			CLK: in std_logic;
			RST: in std_logic;
			PC_EN: in std_logic;
			IR_EN: in std_logic;
			L: in std_logic;
			ROM_ADR: out NIBBLE;
			ROM_DATA: in BYTE;
			IR_OUT: out BYTE
			);
	end component;
	
	component ROM is
		port(				   			  
			CLK: in std_logic;
			RST: in std_logic;
			EN: in std_logic;	
			ADR: in NIBBLE;
			DOUT: out BYTE
			);
	end component;	
						   				  
	signal rom_adr: NIBBLE;
	signal rom_data: BYTE;	
	
begin								  						 
	
	U_ROM: ROM port map (CLK, RST, ROM_EN, rom_adr, rom_data);
	U_ROM_IF: ROM_IF port map (CLK, RST, PC_EN, IR_EN, L, rom_adr, rom_data, IR_OUT);
	
end ROM_UNIT;
