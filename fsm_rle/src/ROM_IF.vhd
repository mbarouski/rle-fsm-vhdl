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
use IEEE.STD_LOGIC_ARITH.all;
use FSM_RLE.all;

entity ROM_IF is
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;	   
		
		PC_EN : in STD_LOGIC;
		IR_EN : in STD_LOGIC; 
							 				
		EQ : in STD_LOGIC; 
		GT : in STD_LOGIC; 
		
		ROM_ADR : out BYTE;
		ROM_DATA : in BYTE;
		
		D: in BYTE;
		
		IR_OUT : out BYTE
		);
end ROM_IF;									 

architecture ROM_IF of ROM_IF is 
	
	signal pc_current: BYTE;
	signal pc_next: BYTE;
	signal ir: BYTE;	 -- instruction register	
	signal opcode: NIBBLE;	 
	signal argfield: NIBBLE;
	signal d_register: BYTE;
	
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
	d_register <= D;
	
	CURRENT_PROGRAM_COUNTER_REGISTER_PROCESS: process(CLK, RST, PC_EN, pc_next)
	begin
		if RST = '1' then
			pc_current <= (others => '0');
		elsif PC_EN = '1' then
			if rising_edge(clk) then
				pc_current <= pc_next;
			end if;
		end if;
	end process;					  
	
	-- d_register is needed to get (3 downto 0) part as the first part of jump address
	NEXT_PROGRAM_COUNTER_REGISTER_PROCESS: process(EQ, GT, pc_current, opcode, d_register, argfield)
	begin
		if EQ = '1' and opcode = JEQ then
			pc_next <= d_register(3 downto 0) & argfield; 
		elsif GT = '1' and opcode = JEG then
			pc_next <= d_register(3 downto 0) & argfield;
		else
			pc_next <= conv_std_logic_vector(conv_integer(unsigned(pc_current)) + 1, 8);
		end if;	
	end process;
	
	IR_OUT <= ir;
	ROM_ADR <= pc_current;
		
end ROM_IF;
