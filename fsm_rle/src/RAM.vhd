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
use FSM_RLE.all;

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
	
type T_RAM is array (0 to 15) of BYTE;

signal c_ram : T_RAM := ( 
  0 => "0000" & "0111",
  1 => "0000" & "0011",
  2 => (others => '0'),
  3 => (others => '0'),
  4 => (others => '0'),
  5 => (others => '0'),
  6 => (others => '0'),
  7 => "0001" & "0001",
  8 => "0010" & "0010",
  9 => "0011" & "0011",
  others => NONE & NONE
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
