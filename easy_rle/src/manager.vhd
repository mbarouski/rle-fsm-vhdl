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
		-- for debug since I can't look at internal signals
		src_num : out STD_LOGIC_VECTOR(N-1 downto 0);
		dest_num : out STD_LOGIC_VECTOR(N-1 downto 0);
		dest_counter : out STD_LOGIC_VECTOR(N-1 downto 0)
		);
end manager;				 

architecture manager of manager is
	component ram
		generic(
			N : INTEGER := N;
			MEM_SIZE : INTEGER := MEM_SIZE
			);
		port(
			clk : in STD_LOGIC;
			rst : in STD_LOGIC;
			wr : in STD_LOGIC;
			rd : in STD_LOGIC;
			addr : in STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
			data_in : in STD_LOGIC_VECTOR(N-1 downto 0);
			data_out : out STD_LOGIC_VECTOR(N-1 downto 0)
			);																													
	end component;
	
	component rle_encoder
		generic(
			N : INTEGER := N );
		port(								  
			rst : in STD_LOGIC;
			clk : in STD_LOGIC;
			en : in std_logic;
			input : in STD_LOGIC_VECTOR(N-1 downto 0);
			output : out STD_LOGIC_VECTOR(N-1 downto 0);
			counter : out STD_LOGIC_VECTOR(N-1 downto 0)
			);
	end component;
	
	-- rle encoder				 		   
	signal rle_rst: STD_LOGIC; 		   
	signal rle_en: STD_LOGIC := '0';
	signal rle_input : STD_LOGIC_VECTOR(N-1 downto 0);
	signal rle_output : STD_LOGIC_VECTOR(N-1 downto 0);
	signal rle_counter : STD_LOGIC_VECTOR(N-1 downto 0);   
															  											
	signal rle_prev_output : STD_LOGIC_VECTOR(N-1 downto 0);
	signal rle_prev_counter : STD_LOGIC_VECTOR(N-1 downto 0);
	
	-- ram
	signal ram_rst : STD_LOGIC;
	signal ram_wr : STD_LOGIC;
	signal ram_rd : STD_LOGIC;
	signal ram_addr : STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
	signal ram_data_in : STD_LOGIC_VECTOR(N-1 downto 0);						   
	signal ram_data_out : STD_LOGIC_VECTOR(N-1 downto 0) := (others => '0');
	
	-- inner duplicates
	signal inner_src_addr: STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0) := (others => '0');
	signal inner_dest_addr: STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
	signal inner_array_size: STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
	signal inner_rst: std_logic;
	signal inner_finish: std_logic := '0';
	
	-- inner service													   										  
	signal rd_address_offset: integer range 0 to MEM_SIZE * MEM_SIZE - 1 := 0;
	signal wr_address_offset: integer range 0 to MEM_SIZE * MEM_SIZE - 1 := 0;
	
	signal state : integer range 0 to 3 := 0;
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
		clk => clk,		 	 
		rst => rle_rst,
		en => rle_en,
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
		ram_rst <= rst;
		rle_rst <= rst;
		if rst = '1' then 
			state <= 0;
		else
			if rising_edge(clk) then	
				if state = 0 then	   							 				   					
					rle_en <= '1';
					ram_rd <= '1';
					ram_wr <= '0';
					ram_addr <= conv_std_logic_vector(conv_integer(unsigned(inner_src_addr)) + rd_address_offset, MEM_SIZE); 
					rle_prev_counter <= rle_counter;	
				elsif state = 1 then
					rle_en <= '0';	
					ram_rd <= '0';
					ram_wr <= '0';					
				elsif state = 2 then						  				  					
					rle_en <= '0';
					
					ram_rd <= '0';
					ram_wr <= '1';																						   																   
					ram_addr <= conv_std_logic_vector(conv_integer(unsigned(inner_dest_addr)) + wr_address_offset, MEM_SIZE);
					ram_data_in <= rle_output;
				else
					rle_en <= '0';
					
					ram_rd <= '0';
					ram_wr <= '1';																						   																   
					ram_addr <= conv_std_logic_vector(conv_integer(unsigned(inner_dest_addr)) + wr_address_offset - 1, MEM_SIZE);
					ram_data_in <= rle_counter;
					
				end if;
			elsif falling_edge(clk) then
				if state = 0 then					
					state <= state + 1;	

					rd_address_offset <= rd_address_offset + 1;	
				elsif state = 1 then			
					state <= state + 1;	
				elsif state = 2 then				
					state <= state + 1;	 
   							  
					if rle_prev_output /= rle_output and rle_prev_counter /= (N-1 downto 0 => '0') then 
						wr_address_offset <= wr_address_offset + 2;
					end if;
				else   					
					state <= (state + 1) mod 4;

					rle_prev_output <= rle_output;
				end if;
			end if;	 
		end if;
	end process; 
end manager;
