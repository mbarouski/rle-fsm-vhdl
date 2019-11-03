-------------------------------------------------------------------------------
--
-- Title       : xorn
-- Design      : easy_rle
-- Author      : Maxim
-- Company     : None
--
-------------------------------------------------------------------------------
--
-- File        : xorn.vhd
-- Generated   : Sun Nov  3 21:10:45 2019
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

entity xorn is
	generic (
		N : integer := 8
		);
	port(
		a : in STD_LOGIC_VECTOR(N-1 downto 0);
		b : in STD_LOGIC_VECTOR(N-1 downto 0);
		c : out STD_LOGIC_VECTOR(N-1 downto 0)
		);
end xorn;									 

architecture xorn of xorn is  
	component XOR2 
		port (
			a: std_logic;
			b: std_logic;
			c: std_logic
			);
	end component;
begin
	GEN_XORN: for i in 0 to N-1 generate
		XOR2_0 : XOR2 port map (a => a(i), b => b(i), c => c(i));
	end generate GEN_XORN;
end xorn;
