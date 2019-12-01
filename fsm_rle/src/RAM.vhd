-------------------------------------------------------------------------------
--
-- Title       : RAM
-- Design      : fsm_rle
-- Author      : Maxim
-- Company     : None
--
-------------------------------------------------------------------------------
--
-- File        : RAM.vhd
-- Generated   : Mon Nov 11 21:29:20 2019
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
use work.FSM_RLE.all;

entity RAM is
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		W_EN : in STD_LOGIC;
		R_EN : in STD_LOGIC;
		ADR : in BYTE;
		DIN : in BYTE;
		DOUT : out BYTE
		);
end RAM;									  

architecture RAM of RAM is	 
	
	type T_RAM is array (0 to 31) of BYTE;
	
	signal c_ram : T_RAM := ( 
		0 => "00000110", --0 => "00000011", -- 3 --0 => "00001010", -- length on source array = 10
		1 => "00000011", --1 => "00000011", -- 3 --1 => "00000011", --	start of source array = 3 	
		2 => "00001001", --2 => "00000110", -- 6 --2 => "00001101", --	start of destination array = 13 	
		
		-- array start
		3 => "00000010",
		4 => "00001010",
		5 => "00001010",
		6 => "00001010",
		7 => (others => '0'),
		8 => (others => '0'),
		9 => "00001011",
		10 => "00001011",	     
		11 => (others => '0'),
		12 => (others => '0'),
		-- array end	 
		
		-- destination array start (it has twice size coz RLE can produce twice sequence :( )		  
		others => (others => '0')
	);	  
	
	signal reg_in: BYTE;  
	signal reg_out: BYTE;
	signal ram_adr: integer range 0 to 15;
	
begin															  
	
	reg_in <= DIN;
	ram_adr <= conv_integer(unsigned(ADR));	   
	
	WRITE_PROCESS: process(CLK, W_EN, ram_adr, reg_in)
	begin			
		if W_EN = '1' then
			if rising_edge(CLK) then
				c_ram(ram_adr) <= reg_in;
			end if;
		end if;
	end process;	
	
	READ_PROCESS: process(CLK, RST, R_EN, c_ram, ram_adr)
	begin
		if RST = '1' then
			reg_out <= (others => '0');
		elsif R_EN = '1' then
			if rising_edge(CLK) then
				reg_out <= c_ram(ram_adr);
			end if;
		end if;
	end process;
	
	DOUT <= reg_out;
	
end RAM;
