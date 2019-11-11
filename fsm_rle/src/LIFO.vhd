-------------------------------------------------------------------------------
--
-- Title       : LIFO
-- Design      : fsm_rle
-- Author      : Maxim
-- Company     : None
--
-------------------------------------------------------------------------------
--
-- File        : LIFO.vhd
-- Generated   : Mon Nov 11 23:36:49 2019
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

entity LIFO is	
	generic (N: integer := 4);
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		LIFO_EN : in STD_LOGIC;
		DATA_IN : in STD_LOGIC;
		MODE : in STD_LOGIC_VECTOR(1 downto 0);
		EMPTY : out STD_LOGIC;
		FULL : out STD_LOGIC;
		TOS : out BYTE;
		TOS_1 : out BYTE
		);
end LIFO;	 

architecture LIFO of LIFO is   

type t_reg is array (0 to N-1) of BYTE;	  

type t_state is (L_EMPTY, L_NORMAL, L_FULL);

type t_flags is record
	empty: std_logic;
	full: std_logic;
end record;

type t_lifo is record 
	tos: BYTE;	  
	tos_1: BYTE;
	regs: t_reg;   
	state: t_state;
	flags: t_flags;
end record;

signal s_lifo: t_lifo;

begin	  



end LIFO;
