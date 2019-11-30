-------------------------------------------------------------------------------
--
-- Title       : RAM_IF
-- Design      : fsm_rle
-- Author      : Maxim
-- Company     : None
--
-------------------------------------------------------------------------------
--
-- File        : RAM_IF.vhd
-- Generated   : Mon Nov 11 22:41:40 2019
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

entity RAM_IF is
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		--		 TOS : in NIBBLE;
		--		 TOS_1 : in BYTE; 
		ADR: in BYTE;
		DATA_IN : in BYTE;
		IR : in NIBBLE;
		--		 ADR_SEL : in STD_LOGIC;
		ADR_EN : in STD_LOGIC;
		DATA_EN : in STD_LOGIC;
		RAM_DATA : out BYTE;
		RAM_ADR : out BYTE
		);
end RAM_IF;									

architecture RAM_IF of RAM_IF is
	
	signal din_reg: BYTE; 
	signal adr_reg: BYTE;
	signal adr_in: BYTE;
	
begin															  
	
	P_DIN_REG: process(CLK, RST, DATA_EN, DATA_IN)
	begin
		if RST = '1' then
			din_reg <= (others => '0');
		elsif DATA_EN = '1' then
			if rising_edge(CLK) then
				din_reg <= DATA_IN;
			end if;
		end if;
	end process;
	
	adr_in <= ADR;
	
	--P_MUX: process(TOS, IR, ADR_SEL)
--	begin
--		if ADR_SEL = '0' then
--			adr_in <= TOS;
--		else
--			adr_in <= IR;
--		end if;
--	end process; 
	
	P_ADR_REG: process(CLK, RST, ADR_EN, adr_in)
	begin		
		if RST = '1' then
			adr_reg <= (others => '0');
		elsif ADR_EN = '1' then
			if rising_edge(CLK) then
				adr_reg <= adr_in;
			end if;
		end if;
	end process; 
	
	RAM_DATA <= din_reg;
	RAM_ADR <= adr_reg;
	
end RAM_IF;
