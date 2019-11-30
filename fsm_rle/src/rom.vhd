-------------------------------------------------------------------------------
--
-- Title       : rom
-- Design      : fsm_rle
-- Author      : maxim
-- Company     : none
--
-------------------------------------------------------------------------------
--
-- File        : rom.vhd
-- Generated   : Sun Nov 10 17:25:36 2019
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
use work.FSM_RLE.all;

entity rom is 
	generic(
		N: integer := 128
		);
	port(
		clk : in STD_LOGIC;
		en : in STD_LOGIC;
		rst : in STD_LOGIC;
		adrr : in BYTE;
		dout : out BYTE
		);
end rom;									  

architecture rom of rom is	
	
	type T_ROM is array (0 to N-1) of BYTE;
	
	constant c_rom : T_ROM := (	 
	
	0 => MOV & J & "0",	    -- mov j 0
	1 => MOV2ADR & ADR & "1",  -- mov2adr 1
	2 => RD & NONE,		    -- rd
	3 => MOVDAT & A &"0",		    -- movdat a
	4 => MOV & C & "1",    -- mov c 1
	5 => MOV & I & "1",		    -- mov i 1
	
	-- read length of source array and mov to d for compare	TODO: maybe move CYCLE label here
	6 => MOV2ADR & ADR & "0",	    -- mov2adr 0
	7 => RD & "0000",    -- rd
	8 => MOVDAT & D & "0",	    -- movdat d
	
	9 => CMP & I & "0",	    -- cmp i
	10 => MOVC2D & "0010", -- mov to d a part of jmp address (in this case STOP label)
	11 => JEQ & "1000", -- jeq STOP		  :CYCLE   
	
	12 => MOV2ADR & ADR & "1",	-- mov2adr 1
	13 => RD & "0000", -- rd	  	 
	14 => MOVDAT & D & "0",		-- movdat d
	15 => ADD & I & "0",		-- add i
	16 => MOV2ADR & D & "0",		-- mov2adr d
	17 => RD & "0000",   -- rd
	18 => MOVDAT & B & "0",		-- movdat b
	19 => MOV2D & A & "0",	    -- mov2d a
	20 => CMP & B & "0",   -- cmp b	  
	
	21 => MOV2D & D & "0", -- address for jump is stored in two places: D register and J** ARGUMENT = D[4:] + INSTRUCTION[4:0]
	22 => JEQ & "0000", -- jeq INC_COUNTER   
	
	23 => MOV2ADR & ADR & "1",	    -- mov2adr 1
	24 => INC & ADR & "0",	    -- inc adr 
	25 => RD & "0000",	   -- rd
	26 => MOVDAT & D & "0", -- movdat d
	27 => ADD & J & "0",		   -- add j
	28 => MOV2ADR & D & "0",		   -- mov2adr d
	29 => MOV2DAT & A & "0",   -- mov2dat a
	30 => WR & "0000",		   -- wr
	31 => INC & ADR & "0",	   -- inc adr
	32 => MOV2DAT & C & "0",   -- mov2dat c 
	33 => WR & "0000",	   -- wr	  
	
	34 => MOV2D & D & "0",
	35 => JMP & "0000",	   -- jmp AFTER_INC_COUNTER	  
	
	36 => INC & C & "0",	   -- inc c	  :INC_COUNTER
	37 => INC & I & "0",   -- inc i   :AFTER_INC_COUNTER	
	
	38 => MOV2D & D & "0",
	39 => JMP & "0000",	   -- jmp CYCLE
	
	40 => STOP & "0000",	   -- stop
	
	others => NONE & NONE
	); 
	
	signal rom_data: BYTE;
	signal reg_out: BYTE;
	signal rom_adr: integer range 0 to N-1;
	
begin										
	
	rom_adr <= conv_integer(unsigned(adrr));
	rom_data <= c_rom(rom_adr);
	
	P_REG_OUT: process(clk, rst, en, rom_data)
	begin
		if rst = '1' then
			reg_out <= (others => '0');
		elsif en = '1' then 
			if rising_edge(clk) then
				reg_out <= rom_data;
			end if;	
		end if;
	end process; 
	
	dout <= reg_out;
	
end rom;
