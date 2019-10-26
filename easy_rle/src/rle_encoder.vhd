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
	
	signal current_counter: UNSIGNED(N-1 downto 0) := (0 => '1', others => '0');
	signal previous_counter: UNSIGNED(N-1 downto 0) := (0 => '1', others => '0');
	
	signal sequence_finished: STD_LOGIC := '0';
	
	signal stage: STD_LOGIC := '0';
begin	
	in_out_process: process(clk, enable)
	begin
		if enable = '1' then 
			if rising_edge(clk) then
				if stage = '0' then	   
					current_number <= signed(input);
				else
					previous_number <= current_number;
				end if;							 	  
			elsif falling_edge(clk) then 
				if stage = '0' then	   				 		  
					if current_number = previous_number then	 
						current_counter <= current_counter + 1;
						sequence_finished <= '0';
						stage <= not stage;
					else
						previous_counter <= current_counter;
						stage <= not stage;
						if current_counter > 0 then	
							sequence_finished <= '1';
						end if;					 
					end if;
				else
					output <= STD_LOGIC_VECTOR(previous_number);
					counter <= STD_LOGIC_VECTOR(previous_counter);
					
					if sequence_finished = '1' then
						current_counter <= (0 => '1', others => '0');
					end if;															   
					
					read <= sequence_finished;
					stage <= not stage;
				end if;			   
			end if;
		end if;
	end process in_out_process;
end rle_encoder;
