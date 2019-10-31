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
	signal current_number: integer range -128 to 128 := 0;	  
	signal previous_number: integer range -128 to 128 := 128; 
	
	signal inner_counter: integer range 0 to 255 := 0;
	
	signal sequence_finished: STD_LOGIC := '0';
begin
	current_number <= conv_integer(signed(input));
	
	p: process(clk, enable)	 
		variable xored_numbers: std_logic_vector(N downto 0) := (others => '0');	   
		variable not_xored_numbers: std_logic_vector(N downto 0) := (others => '0');
		variable add_operand: std_logic := '0';
	begin					 
		if rising_edge(clk) and enable = '1' then							   					   			
			for i in N downto 0 loop
				xored_numbers(i) := conv_std_logic_vector(current_number, N+1)(i) xor conv_std_logic_vector(previous_number, N+1)(i);
			end loop; 											 
			
			for i in N downto 0 loop
				not_xored_numbers(i) := not xored_numbers(i);
			end loop;
			
			for i in N downto 0 loop
				add_operand := add_operand or xored_numbers(i);
			end loop;
			
			inner_counter <= inner_counter + conv_integer(add_operand);
		elsif falling_edge(clk) then
			previous_number <= current_number;
		end if;
	end process;
	
	output <= (conv_std_logic_vector(current_number, N+1)(N-1 downto 0)); 	
	counter <= conv_std_logic_vector(inner_counter, N);-- when sequence_finished = '1' else (others => '0');	
	read <= sequence_finished; 
end rle_encoder;
