-------------------------------------------------------------------------------
--
-- Title       : LIFO_UNIT
-- Design      : fsm_rle
-- Author      : Maxim
-- Company     : None
--
-------------------------------------------------------------------------------
--
-- File        : LIFO_UNIT.vhd
-- Generated   : Wed Nov 13 00:45:56 2019
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
use FSM_RLE.all;

entity LIFO_UNIT is
	generic(N: integer := 4);
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		LIFO_EN : in STD_LOGIC;
		MODE : in STD_LOGIC_VECTOR(1 downto 0);
		PUSHDATA : in STD_LOGIC_VECTOR(1 downto 0);
		OB_RESULT : in BYTE;
		RAM_DATA : in BYTE;
		IR_OUT : in NIBBLE;
		EMPTY : out STD_LOGIC;
		FULL : out STD_LOGIC;
		TOS : out BYTE;
		TOS_1 : out BYTE
		);
end LIFO_UNIT;								 

architecture LIFO_UNIT of LIFO_UNIT is	
	
	component LIFO is
		generic(N: integer := 4);
		port(
			CLK : in STD_LOGIC;
			RST : in STD_LOGIC;
			LIFO_EN : in STD_LOGIC;
			MODE : in STD_LOGIC_VECTOR(1 downto 0);
			DATA_IN : in BYTE; 
			EMPTY : out STD_LOGIC;
			FULL : out STD_LOGIC;
			TOS : out BYTE;
			TOS_1 : out BYTE
			);
	end component; 
	
	signal data_in: BYTE;	  
	signal error: std_logic;
	signal lifo_enable_in: std_logic;
	signal lifo_empty_out: std_logic;
	signal lifo_full_out: std_logic;
	
begin								  						 
	
	lifo_enable_in <= LIFO_EN and (not error);	 
	EMPTY <= lifo_empty_out;
	FULL <= lifo_full_out;
	
	U_LIFO: LIFO generic map (N) port map (CLK, RST, lifo_enable_in, MODE, data_in, lifo_empty_out, lifo_full_out, TOS, TOS_1);
	
	P_LIFO_DATA_SELECT: process(PUSHDATA, OB_RESULT, RAM_DATA, IR_OUT)
	begin
		if PUSHDATA = "00" then
			data_in <= OB_RESULT;
		elsif PUSHDATA = "01" then
			data_in <= RAM_DATA;
		elsif PUSHDATA = "10" then
			data_in <= "0000" & IR_OUT;
		else
			data_in <= (others => '0');			
		end if;
	end process; 
	
	P_ERROR: process(PUSHDATA)
	begin
		if PUSHDATA = "11" then
			error <= '1';
		else
			error <= '0';		
		end if;
	end process;
	
end LIFO_UNIT;
