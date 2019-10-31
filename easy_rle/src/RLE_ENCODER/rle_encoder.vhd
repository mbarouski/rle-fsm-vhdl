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
use IEEE.STD_LOGIC_ARITH.all;

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
	signal current_number: signed(N-1 downto 0) := (others => '0');
	signal previous_number: integer range -256 to 256 := 256;
	
	signal inner_counter: integer range 0 to 255 := 0;
	
	signal sequence_finished: STD_LOGIC := '0';
begin
	current_number <= signed(input);
	
	p: process(clk, enable)
	begin
		if enable = '1' then 
			if rising_edge(clk) then
				if sequence_finished = '1' then	
					inner_counter <= 1;	
				end if;
				
				if conv_integer(current_number) = previous_number then	 
					inner_counter <= inner_counter + 1;
					sequence_finished <= '0';
				else
					previous_number <= conv_integer(current_number);				
					sequence_finished <= '1'; 		  	
				end if; 	  		   
			end if;
		end if;
	end process;
	
	output <= conv_std_logic_vector(previous_number, N+1)(N-1 downto 0);
	counter <= conv_std_logic_vector(inner_counter, N) when sequence_finished = '1' else (others => '0');	
	read <= sequence_finished;
end rle_encoder;
