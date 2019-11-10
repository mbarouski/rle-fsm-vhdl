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
use FSM_RLE.all;

entity rom is
	port(
		clk : in STD_LOGIC;
		en : in STD_LOGIC;
		rst : in STD_LOGIC;
		adr : in NIBBLE;
		dout : out BYTE
		);
end rom;									  

architecture rom of rom is	
	
	type T_ROM is array (0 to 15) of BYTE;
	
	constant c_rom : T_ROM := (	 
	0 => PUSHV & "0000",
	1 => PUSHC & "0000",
	2 => ADD & NONE,
	3 => RD & NONE,
	4 => PUSHC & "0010",
	5 => WR & NONE,
	6 => INC & NONE,
	7 => PUSHV & "0001",
	8 => CMP & NONE,
	9 => JL & "0010",
	10 => STOP & NONE,
	
	others => NONE & NONE
	); 
	
	signal rom_data: BYTE;
	signal reg_out: BYTE;
	signal rom_adr: integer range 0 to 15;
	
begin										
	
	rom_adr <= conv_integer(unsigned(adr));
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
