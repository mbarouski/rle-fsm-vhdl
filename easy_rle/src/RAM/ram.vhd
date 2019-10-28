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
		rst : in STD_LOGIC;
		wr : in STD_LOGIC; -- write
		rd : in STD_LOGIC; -- read
		addr : in STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
		data_in : in STD_LOGIC_VECTOR(N-1 downto 0);
		data_out : out STD_LOGIC_VECTOR(N-1 downto 0)
		);
end ram;										  

architecture ram of ram is
	
	type TYPE_RAM is array (0 to MEM_SIZE * MEM_SIZE - 1) of STD_LOGIC_VECTOR(N-1 downto 0);
	
	signal ram_state: TYPE_RAM := (
		0 => "00000010", -- P address of source array -- 2
		1 => "00001010", --	N size of source array -- 10 
		-- array start
		2 => "00001010",
		3 => "00001010",
		4 => (others => '0'),
		5 => (others => '0'),
		6 => "00001011",
		7 => "00001011",
		8 => (others => '0'),
		9 => (others => '0'),
		10 => (others => '0'),
		11 => (others => '0'),
		-- array end
		-- destination array start (it has twice size coz RLE can produce twice sequence :( )	 
		12 => (others => '0'),
		13 => (others => '0'),
		14 => (others => '0'),
		15 => (others => '0'),
		16 => (others => '0'),
		17 => (others => '0'),
		18 => (others => '0'),
		19 => (others => '0'),
		20 => (others => '0'),
		21 => (others => '0'), 
		22 => (others => '0'),
		23 => (others => '0'),
		24 => (others => '0'),
		25 => (others => '0'),
		26 => (others => '0'),
		27 => (others => '0'),
		28 => (others => '0'),
		29 => (others => '0'),
		30 => (others => '0'),
		31 => (others => '0'),
	-- destination array end  
		others => (others => '0')
	);
	
	signal inner_data_in: STD_LOGIC_VECTOR(N-1 downto 0);
	signal inner_data_out: STD_LOGIC_VECTOR(N-1 downto 0);
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
