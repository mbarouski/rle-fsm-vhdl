-------------------------------------------------------------------------------
--
-- Title       : ROM_IF
-- Design      : fsm_rle
-- Author      : Maxim
-- Company     : None
--
-------------------------------------------------------------------------------
--
-- File        : ROM_IF.vhd
-- Generated   : Mon Nov 11 00:17:08 2019
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

entity ROM_IF is
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		PC_EN : in STD_LOGIC;
		IR_EN : in STD_LOGIC;
		L : in STD_LOGIC; 
		ROM_ADR : out NIBBLE;
		ROM_DATA : in BYTE;   
		IR_OUT : out BYTE
		);
end ROM_IF;									 

architecture ROM_IF of ROM_IF is 
	
	signal pc_current: NIBBLE;
	signal pc_next: NIBBLE;
	signal ir: BYTE;	 -- instruction register	
	signal opcode: NIBBLE;
	signal argfield: NIBBLE;
	
begin	
	
	INSTRUCTION_REGISTER_PROCESS: process(CLK, RST, IR_EN, ROM_DATA)
	begin
		if RST = '1' then
			ir <= NONE & NONE;
		elsif IR_EN = '1' then
			if rising_edge(clk) then
				ir <= ROM_DATA;
			end if;
		end if;
	end process;
	
	opcode <= ir(7 downto 4);
	argfield <= ir(3 downto 0);
	
	PROGRAM_COUNTER_REGISTER_PROCESS: process(CLK, RST, PC_EN, pc_next)
	begin
		if RST = '1' then
			pc_current <= (others => '0');
		elsif PC_EN = '1' then
			if rising_edge(clk) then
				pc_current <= pc_next;
			end if;
		end if;
	end process;					  
	
	NEXT_PROGRAM_COUNTER_REGISTER_PROCESS: process(L, pc_current, opcode, argfield)
	begin
		if L = '1' and opcode = JL then
			pc_next <= argfield;
		else 
			pc_next <= pc_current + 1;
		end if;	
	end process;
	
	IR_OUT <= ir;
	ROM_ADR <= pc_current;
		
end ROM_IF;
