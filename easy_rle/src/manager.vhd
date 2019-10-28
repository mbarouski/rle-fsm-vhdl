-------------------------------------------------------------------------------
--
-- Title       : manager
-- Design      : easy_rle
-- Author      : Maxim
-- Company     : None
--
-------------------------------------------------------------------------------
--
-- File        : manager.vhd
-- Generated   : Tue Oct 29 00:00:08 2019
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
use IEEE.STD_LOGIC_ARITH.all;

entity manager is
	generic(
		N: integer := 8;
		MEM_SIZE : integer := 8
		);
	port(
		clk : in STD_LOGIC;
		en : in STD_LOGIC;																		   
		src_addr: in STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
		dest_addr: in STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
		array_size: in STD_LOGIC_VECTOR(MEM_SIZE downto 0);
		finish : out STD_LOGIC;
		number : out STD_LOGIC_VECTOR(N-1 downto 0)
		);
end manager;				 

architecture manager of manager is
	
	component ram
		generic(
			N : INTEGER := N;
			MEM_SIZE : INTEGER := MEM_SIZE );
		port(
			clk : in STD_LOGIC;
			rst : in STD_LOGIC;
			wr : in STD_LOGIC;
			rd : in STD_LOGIC;
			addr : in STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
			data_in : in STD_LOGIC_VECTOR(N-1 downto 0);
			data_out : out STD_LOGIC_VECTOR(N-1 downto 0) );																													
	end component;							   
	
	-- ram
	signal ram_rst : STD_LOGIC;
	signal ram_wr : STD_LOGIC;
	signal ram_rd : STD_LOGIC;
	signal ram_addr : STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
	signal ram_data_in : STD_LOGIC_VECTOR(N-1 downto 0);						   
	signal ram_data_out : STD_LOGIC_VECTOR(N-1 downto 0);
	
	-- inner duplicates
	signal inner_src_addr: STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
	signal inner_dest_addr: STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
	signal inner_array_size: STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
	signal inner_en: std_logic;
	signal inner_finish: std_logic := '0';
	
	-- inner service
	signal address_offset: integer range 0 to MEM_SIZE * MEM_SIZE - 1 := 0;																									  
	signal number_from_ram: std_logic_vector(N-1 downto 0);
	signal number_to_ram: std_logic_vector(N-1 downto 0);
	signal counter_to_ram: std_logic_vector(N-1 downto 0);
begin							 					 
	
	ACTIVE_RAM : ram
	generic map (
		N => N,
		MEM_SIZE => MEM_SIZE
		)
	port map (
		clk => clk,
		rst => ram_rst,
		wr => ram_wr,
		rd => ram_rd,
		addr => ram_addr,
		data_in => ram_data_in,
		data_out => ram_data_out
		);
	
	inner_en <= en;
	
	main: process(clk, en)
	begin
		if en = '1' then
			if falling_edge(clk) then
				ram_rd <= '1';
				ram_addr <= conv_std_logic_vector(conv_integer(unsigned(inner_src_addr)) + address_offset, MEM_SIZE);
				if address_offset = conv_integer(unsigned(inner_array_size)) then
					inner_finish <= '1';
				end if;	  
				address_offset <= address_offset + 1;
			elsif rising_edge(clk) then				 		  
				
			end if;
		end if;
	end process;
	
	finish <= inner_finish;
	number <= ram_data_out;
end manager;
