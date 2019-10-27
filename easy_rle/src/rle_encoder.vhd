-------------------------------------------------------------------------------
--
-- Title       : rle_encoder
-- Design      : easy_rle
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
use ieee.numeric_std.all;

entity rle_encoder is
	generic(
		N: integer := 8);
	port(								  
		clk : in STD_LOGIC;
		enable : in STD_LOGIC;
		input : in STD_LOGIC_VECTOR(N-1 downto 0);	 
		output : out STD_LOGIC_VECTOR(N-1 downto 0); 
		counter : out STD_LOGIC_VECTOR(N-1 downto 0);
		read : out STD_LOGIC
		);
end rle_encoder;

architecture rle_encoder of rle_encoder is	  	 
	signal current_number: SIGNED(N-1 downto 0) := (others => '0');
	signal previous_number: SIGNED(N-1 downto 0) := (others => '0');
	
	signal inner_counter: UNSIGNED(N-1 downto 0) := (others => '0');
	
	signal sequence_finished: STD_LOGIC := '0';
begin
	current_number <= signed(input);
	
	p: process(clk, enable)
	begin
		if enable = '1' then 
			if rising_edge(clk) then	  				 		  
				if current_number = previous_number then	 
					inner_counter <= inner_counter + 1;
					sequence_finished <= '0';
				else				
					sequence_finished <= '1'; 		 			 
				end if;						 	  
			elsif falling_edge(clk) then  
				if sequence_finished = '1' then
					inner_counter <= (0 => '1', others => '0'); 
					previous_number <= current_number;	
				end if;		  		   
			end if;
		end if;
	end process p;	  
	
	output <= STD_LOGIC_VECTOR(previous_number);
	counter <= STD_LOGIC_VECTOR(inner_counter);	
	read <= sequence_finished;
end rle_encoder;
