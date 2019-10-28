library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;


entity ram_tb is							   
	generic(
		N : INTEGER := 8;
		MEM_SIZE : INTEGER := 8 );
end ram_tb;

architecture TB_ARCHITECTURE of ram_tb is		 
	component ram
		generic(
			N : INTEGER := 8;
			MEM_SIZE : INTEGER := 8 );
		port(
			clk : in STD_LOGIC;
			rst : in STD_LOGIC;
			wr : in STD_LOGIC;
			rd : in STD_LOGIC;
			addr : in STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
			data_in : in STD_LOGIC_VECTOR(N-1 downto 0);
			data_out : out STD_LOGIC_VECTOR(N-1 downto 0) );
	end component;
	
	signal clk : STD_LOGIC;
	signal rst : STD_LOGIC;
	signal wr : STD_LOGIC;
	signal rd : STD_LOGIC;
	signal addr : STD_LOGIC_VECTOR(MEM_SIZE-1 downto 0);
	signal data_in : STD_LOGIC_VECTOR(N-1 downto 0);						   
	signal data_out : STD_LOGIC_VECTOR(N-1 downto 0); 
	
	constant clk_period : time := 10ns;
begin							 
	UUT : ram
	generic map (
		N => N,
		MEM_SIZE => MEM_SIZE
		)
	port map (
		clk => clk,
		rst => rst,
		wr => wr,
		rd => rd,
		addr => addr,
		data_in => data_in,
		data_out => data_out
		);
	
	clk_process: process
	begin								  
		clk <= '0';
		wait for clk_period / 2;
		clk <= '1';
		wait for clk_period / 2;
	end process;
	
	stimulus_process: process
	begin
		wait for clk_period / 2;								 						 
		rst <= '1'; wait for clk_period;
		rst <= '0'; wait for clk_period;
		
		for i in 0 to MEM_SIZE * MEM_SIZE - 1 loop
			addr <= CONV_STD_LOGIC_VECTOR(i, N); wait for clk_period;
			rd <= '1'; wait for clk_period;
			rd <= '0';
		end loop;	
		
		wait for 20 * clk_period;
		
		report "End of simulation" severity failure;
	end process;
	
end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_ram of ram_tb is
	for TB_ARCHITECTURE
		for UUT : ram
			use entity work.ram(ram);
		end for;
	end for;
end TESTBENCH_FOR_ram;

