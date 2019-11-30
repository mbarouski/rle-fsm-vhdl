-------------------------------------------------------------------------------
--
-- Title       : GPR_UNIT_X
-- Design      : fsm_rle
-- Author      : maxim
-- Company     : none
--
-------------------------------------------------------------------------------
--
-- File        : GPR_UNIT_X.vhd
-- Generated   : Sat Nov 30 13:57:17 2019
-- From        : interface description file
-- By          : Itf2Vhdl ver. 1.22
--
-------------------------------------------------------------------------------
--
-- Description : 
--
-------------------------------------------------------------------------------

--{{ Section below this comment is automatically maintained
--   and may be overwritten
--{entity {GPR_UNIT_X} architecture {GPR_UNIT_X}}

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use FSM_RLE.all;

entity GPR_UNIT_X is 
	port(
		GPR_IN : in GPR_UNIT_OUTPUTS;
		GPR_OUT : out GPR_UNIT_INPUTS
		);
end GPR_UNIT_X;								  

architecture GPR_UNIT_X of GPR_UNIT_X is 
	
	component GPR is
		port(													   
			AA: out std_logic_vector(0 to 7);
			BB: out std_logic_vector(0 to 7);
			CC: out std_logic_vector(0 to 7);
			DD: out std_logic_vector(0 to 7);
			II: out std_logic_vector(0 to 7);
			JJ: out std_logic_vector(0 to 7);
			ADRR: out std_logic_vector(0 to 7);
			DATT: out std_logic_vector(0 to 7);
			
			WR : in STD_LOGIC;	 
			CLK : in STD_LOGIC;
			RST : in STD_LOGIC;
			
			-- this should be in GPR_IF but we need fast in implementation solution :(
			ALU_RESULT : in BYTE;  
			RAM_DATA : in BYTE;
			IR : in BYTE;  
			
			DATA_SRC: in std_logic_vector(0 to 1);
			
			REG_SRC : in REGI;
			REG_DST : in REGI
			);
	end component;
	
begin
	
	U_GPR: GPR port map(
		GPR_OUT.A, GPR_OUT.B, GPR_OUT.C, GPR_OUT.D, GPR_OUT.I, GPR_OUT.J, GPR_OUT.ADR, GPR_OUT.DAT,
		GPR_IN.W_EN, GPR_IN.CLK, GPR_IN.RST, GPR_IN.ALU_RESULT, GPR_IN.RAM_DATA, GPR_IN.IR, GPR_IN.PUSHDATA, GPR_IN.REG_SRC, GPR_IN.REG_DST
		);
	
end GPR_UNIT_X;
