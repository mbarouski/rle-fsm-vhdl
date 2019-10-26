-------------------------------------------------------------------------------
--
-- Title       : rle_encoder
-- Design      : easy-rle
-- Author      : Maxim
-- Company     : None
--
-------------------------------------------------------------------------------
--
-- File        : rle_encoder.vhd
-- Generated   : Sat Oct 26 20:56:02 2019
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : RLE Encoder
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity rle_encoder is
	generic(
		N: integer := 8);
	port(
		clk : in STD_LOGIC;
		input : in STD_LOGIC_VECTOR(N-1 downto 0);	 
		output : out STD_LOGIC_VECTOR(N-1 downto 0); 
		counter : out STD_LOGIC_VECTOR(N-1 downto 0);
		read : out STD_LOGIC
		);
end rle_encoder;

architecture rle_encoder of rle_encoder is	  	 
	signal current_number: signed(N-1 downto 0) := 0;
	signal previous_number: signed(N-1 downto 0) := 0;
	
	signal _counter: unsigned(N-1 downto 0) := 0;
	signal _read: STD_LOGIC := '0';
begin		  	 
	handler_process: process(clk)
	begin
		if (rising_edge(clk)) then				 		   
			
		end if;
	end process in_out_process;	
	
	in_out_process: process(clk)
	begin
		if (rising_edge(clk)) then
			current_number <= signed(input);
			
			output <= STD_LOGIC_VECTOR(previous_number);
		end if;	
		
		if (falling_edge(clk)) then
			previous_number <= current_number;
		end if;
	end process in_out_process;
	
end rle_encoder;
