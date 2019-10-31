library ieee;
use ieee.NUMERIC_STD.all;
use ieee.std_logic_1164.all;

-- Add your library and packages declaration here ...

entity rle_encoder_tb is
	-- Generic declarations of the tested unit
	generic(
		N : INTEGER := 8 );
end rle_encoder_tb;

architecture rle_encoder_tb_arch of rle_encoder_tb is
	-- Component declaration of the tested unit
	component rle_encoder
		generic(
			N : INTEGER := 8 );
		port(								  
			enable : in STD_LOGIC;
			clk : in STD_LOGIC;
			input : in STD_LOGIC_VECTOR(N-1 downto 0);
			output : out STD_LOGIC_VECTOR(N-1 downto 0);
			counter : out STD_LOGIC_VECTOR(N-1 downto 0);
			read : out STD_LOGIC );
	end component;
	
	-- Stimulus signals - signals mapped to the input and inout ports of tested entity	   
	signal enable : STD_LOGIC;
	signal clk : STD_LOGIC;
	signal input : STD_LOGIC_VECTOR(N-1 downto 0);
	-- Observed signals - signals mapped to the output ports of tested entity
	signal output : STD_LOGIC_VECTOR(N-1 downto 0);
	signal counter : STD_LOGIC_VECTOR(N-1 downto 0);
	signal read : STD_LOGIC;
	
	-- Add your code here ...	 
	
	constant clk_period: time := 1us;
	
begin
	UUT : rle_encoder
	generic map (
		N => N
		)
	
	port map (		 	 
		enable => enable,
		clk => clk,
		input => input,
		output => output,
		counter => counter,
		read => read
		);
	
	clk_process: process
	begin										 
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period / 2;
	end process;
	
	test_process: process
	begin		   
		input <= (others => '0');
		wait for clk_period / 4;
		enable <= '1'; 		   	
		wait for clk_period / 4; 
		wait for clk_period;    
		
		input <= "00000010";
		wait for clk_period; 
		
		input <= "00001010";
		wait for clk_period * 3; 
		
		input <= "00001111";
		wait for clk_period * 4;
		
		input <= (others => '1');
		wait for clk_period * 3;
		
		wait for 5 * clk_period;  
		enable <= '0'; 	
		wait for 5 * clk_period;	   
		
		report "End of simulation" severity failure;
	end process test_process;
	
end rle_encoder_tb_arch;

configuration TESTBENCH_FOR_rle_encoder of rle_encoder_tb is
	for rle_encoder_tb_arch
		for UUT : rle_encoder
			use entity work.rle_encoder(rle_encoder);
		end for;
	end for;
end TESTBENCH_FOR_rle_encoder;

