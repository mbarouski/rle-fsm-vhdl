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
		rst : in STD_LOGIC;
		en : in STD_LOGIC;
		input : in STD_LOGIC_VECTOR(N-1 downto 0);	 
		output : out STD_LOGIC_VECTOR(N-1 downto 0); 
		counter : out STD_LOGIC_VECTOR(N-1 downto 0)
		);
end rle_encoder;

architecture rle_encoder of rle_encoder is	  	 							  				
	signal current_number: std_logic_vector(8 downto 0) := (others => '0');	
	signal previous_number: std_logic_vector(8 downto 0) := (others => '1');  
	
	signal inner_counter: integer range 0 to 255 := 0;
	
	signal sequence_finished: std_logic := '0';	    
begin
	current_number(7 downto 0) <= input;
	
	p: process(clk, rst, en)
		variable same: std_logic := '0';
	begin					 	 
		if rising_edge(clk) then
			if rst = '1' then
				inner_counter <= 0;			   		   
				previous_number <= (others => '1');
			elsif en = '1' then
				-- TODO(max): Write using cycle
				same := (
				(not (current_number(0) xor previous_number(0)))
				and 
				(not (current_number(1) xor previous_number(1)))
				and 
				(not (current_number(2) xor previous_number(2)))
				and 
				(not (current_number(3) xor previous_number(3)))
				and 
				(not (current_number(4) xor previous_number(4)))
				and 
				(not (current_number(5) xor previous_number(5)))
				and 
				(not (current_number(6) xor previous_number(6)))
				and 
				(not (current_number(7) xor previous_number(7)))
				and 
				(not (current_number(8) xor previous_number(8)))
				);
				
				if same = '1' then
					inner_counter <= inner_counter + 1;
				else		 						 
					inner_counter <= 1;
				end if;	
				
				previous_number <= current_number; 
			end if;
			
		end if;
	end process;   														 
	
	output <= previous_number(N-1 downto 0); 	
	counter <= conv_std_logic_vector(inner_counter, N);
end rle_encoder;
