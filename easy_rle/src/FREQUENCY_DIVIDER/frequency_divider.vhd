-------------------------------------------------------------------------------
--
-- Title       : frequency_divider
-- Design      : easy_rle
-- Author      : maxim
-- Company     : none
--
-------------------------------------------------------------------------------
--
-- File        : frequency_divider.vhd
-- Generated   : Sun Oct 27 19:50:01 2019
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description :   Frequency divider
--
-------------------------------------------------------------------------------	

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;

entity frequency_divider is
	generic(
		N : integer := 2);
	port(
		clk_in : in STD_LOGIC;
		clk_out : out STD_LOGIC
		);
end frequency_divider;						  

architecture frequency_divider of frequency_divider is	
signal counter : integer := 0;
signal inner_clk_out : STD_LOGIC := '0';
begin 					 			  	
	p: process(clk_in)
	begin
		if rising_edge(clk_in) then 
			if counter = 0 then
				inner_clk_out <= '1';
			end if;				   
		elsif falling_edge(clk_in) then 	
			if counter = N-1 then
				inner_clk_out <= '0';
				counter <= 0;
			else 
				counter <= counter + 1;
			end if;					
		end if;
	end process p;		
	
	clk_out <= inner_clk_out;
end frequency_divider;
