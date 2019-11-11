-------------------------------------------------------------------------------
--
-- Title       : RAM_UNIT
-- Design      : fsm_rle
-- Author      : Maxim
-- Company     : None
--
-------------------------------------------------------------------------------
--
-- File        : RAM_UNIT.vhd
-- Generated   : Mon Nov 11 22:50:33 2019
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

entity RAM_UNIT is
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		TOS : in NIBBLE;
		TOS_1 : in BYTE;
		IR : in NIBBLE;
		ADR_SEL : in STD_LOGIC;
		ADR_EN : in STD_LOGIC;
		DATA_EN : in STD_LOGIC;
		W_EN : in STD_LOGIC;
		R_EN : in STD_LOGIC;
		RAM_DATA : out BYTE
		);
end RAM_UNIT;	   

architecture RAM_UNIT of RAM_UNIT is 
	
	component RAM is 
		port (			  		 
			CLK: in STD_LOGIC;
			RST: in STD_LOGIC;
			W_EN : in STD_LOGIC;
			R_EN : in STD_LOGIC;
			ADR : in NIBBLE;
			DIN : in BYTE;
			DOUT : out BYTE
			);
	end component;
	
	component RAM_IF is 
		port (			  		 
			CLK: in STD_LOGIC;
			RST: in STD_LOGIC; 
			TOS : in NIBBLE;
			TOS_1 : in BYTE;
			IR : in NIBBLE;
			ADR_SEL : in STD_LOGIC;
			ADR_EN : in STD_LOGIC;
			DATA_EN : in STD_LOGIC;	
			RAM_DATA : out BYTE;
			RAM_ADR: out NIBBLE
			);
	end component;	 
	
	signal ram_adr: NIBBLE;	  
	signal ram_data_in: BYTE;
	signal ram_data_out: BYTE;
	
begin 
	
	U_RAM: RAM port map (CLK, RST, W_EN, R_EN, ram_adr, ram_data_in, ram_data_out);
	U_RAM_IF: RAM_IF port map (CLK, RST, TOS, TOS_1, IR, ADR_SEL, ADR_EN, DATA_EN, ram_data_in, ram_adr);
	
	RAM_DATA <= ram_data_out;
	
end RAM_UNIT;
