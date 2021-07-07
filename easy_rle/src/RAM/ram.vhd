-------------------------------------------------------------------------------
--
-- Title       : ram
-- Design      : easy_rle
-- Author      : Maxim
-- Company     : None
--
-------------------------------------------------------------------------------
--
-- File        : ram.vhd
-- Generated   : Mon Oct 28 22:02:03 2019
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : RAM block
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;

entity ram is
	generic(
		N: integer := 8;
		MEM_SIZE: integer := 4 -- log2 16 = 4
		);
	port(
		clk : in STD_LOGIC;
		rst : in STD_LOGIC := '0';
		wr : in STD_LOGIC := '0'; -- write
		rd : in STD_LOGIC := '0'; -- read
		addr : in STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
		data_in : in STD_LOGIC_VECTOR(N-1 downto 0);
		data_out : out STD_LOGIC_VECTOR(N-1 downto 0)
		);
end ram;										  

architecture ram of ram is
	
	type TYPE_RAM is array (0 to MEM_SIZE * MEM_SIZE - 1) of STD_LOGIC_VECTOR(N-1 downto 0);
	
	signal ram_state: TYPE_RAM := (					   
		-- array start	
		0 => "00000010",
		1 => "00001010",
		2 => "00001010",
		3 => "00001010",
		4 => "00000001",
		5 => "00000001",
		-- array end	    
		others => (others => '0')
	);
	
	signal inner_data_in: STD_LOGIC_VECTOR(N-1 downto 0);
	signal inner_data_out: STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
	signal inner_addr: integer range 0 to MEM_SIZE * MEM_SIZE - 1; 
begin								  						 
	inner_data_in <= data_in;
	inner_addr <= CONV_INTEGER(unsigned(addr));	 
	
	read_process: process(clk, rd, rst, ram_state, inner_addr)
	begin
		if rst = '1' then
			inner_data_out <= (others => '0');
		elsif rd = '1' then
			if rising_edge(clk) then   
				inner_data_out <= ram_state(inner_addr);
			end if;								 
		end if;
	end process;	 
	
	write_process: process(clk, wr, ram_state, inner_data_in, inner_addr)
	begin
		if wr = '1' then  
			if rising_edge(clk) then 
				ram_state(inner_addr) <= inner_data_in;
			end if;	
		end if;
	end process;
	
	data_out <= inner_data_out;	
end ram;
