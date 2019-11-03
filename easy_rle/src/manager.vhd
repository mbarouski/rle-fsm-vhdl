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
		rst : in STD_LOGIC;
		src_addr: in STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
		dest_addr: in STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
		array_size: in STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
		finish : out STD_LOGIC;
		-- for debug since I can't lok at internal signals
		src_num : out STD_LOGIC_VECTOR(N-1 downto 0);
		dest_num : out STD_LOGIC_VECTOR(N-1 downto 0);
		dest_counter : out STD_LOGIC_VECTOR(N-1 downto 0)
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
	
	component rle_encoder
		generic(
			N : INTEGER := N );
		port(								  
			rst : in STD_LOGIC;
			clk : in STD_LOGIC;
			input : in STD_LOGIC_VECTOR(N-1 downto 0);
			output : out STD_LOGIC_VECTOR(N-1 downto 0);
			counter : out STD_LOGIC_VECTOR(N-1 downto 0)
			);
	end component;
	
	-- rle encoder				 		   
	signal rle_rst: STD_LOGIC;
	signal rle_input : STD_LOGIC_VECTOR(N-1 downto 0);
	signal rle_output : STD_LOGIC_VECTOR(N-1 downto 0);
	signal rle_counter : STD_LOGIC_VECTOR(N-1 downto 0);
	
	-- ram
	signal ram_rst : STD_LOGIC;
	signal ram_wr : STD_LOGIC;
	signal ram_rd : STD_LOGIC;
	signal ram_addr : STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
	signal ram_data_in : STD_LOGIC_VECTOR(N-1 downto 0);						   
	signal ram_data_out : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
	
	-- inner duplicates
	signal inner_src_addr: STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
	signal inner_dest_addr: STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
	signal inner_array_size: STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
	signal inner_rst: std_logic;
	signal inner_finish: std_logic := '0';
	
	-- inner service
	signal address_offset: integer range 0 to MEM_SIZE * MEM_SIZE - 1 := 0;
begin							 					 
	
	ram_0 : ram
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
	
	rle_encoder_0 : rle_encoder
	generic map (
		N => N
		)
	
	port map (		 	 
		rst => rle_rst,
		clk => clk,
		input => rle_input,
		output => rle_output,
		counter => rle_counter
		);
	
	-- global in
	inner_rst <= rst;
	inner_array_size <= array_size;	 
	inner_src_addr <= src_addr;
	inner_dest_addr <= dest_addr;
	
	-- inner bindings	   
	rle_rst <= inner_rst;   
	rle_input <= ram_data_out;
	rle_input <= ram_data_out;
	
	-- global out
	finish <= inner_finish;	 
	src_num <= ram_data_out;
	dest_num <= rle_output;
	dest_counter <= rle_counter; 
	
	main: process(clk, rst)
	begin
		if rst = '0' then
			if falling_edge(clk) then
				ram_rd <= '1';
				ram_addr <= conv_std_logic_vector(conv_integer(unsigned(inner_src_addr)) + address_offset, MEM_SIZE);
				if address_offset = conv_integer(unsigned(inner_array_size)) then
					inner_finish <= '1';
				end if;	  
				address_offset <= address_offset + 1;
			elsif rising_edge(clk) then				 		  
				-- nothing for now
			end if;
		else 
			
		end if;
	end process; 
end manager;
