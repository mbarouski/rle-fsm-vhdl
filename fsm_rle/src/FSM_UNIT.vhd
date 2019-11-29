-------------------------------------------------------------------------------
--
-- Title       : FSM_UNIT
-- Design      : fsm_rle
-- Author      : maxim
-- Company     : none
--
-------------------------------------------------------------------------------
--
-- File        : FSM_UNIT.vhd
-- Generated   : Sat Nov 30 00:55:14 2019
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
--{entity {FSM_UNIT} architecture {FSM_UNIT}}

library IEEE;						   
use IEEE.STD_LOGIC_1164.all;
use FSM_RLE.all;

entity FSM_UNIT is
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		START : in STD_LOGIC;
		HALT : out STD_LOGIC;
		ERROR : out STD_LOGIC
		);
end FSM_UNIT;							   

architecture FSM_UNIT of FSM_UNIT is 
	
	component FSM is
		port(
			CLK : in STD_LOGIC;
			RST : in STD_LOGIC;
			START : in STD_LOGIC;			
			HALT : out STD_LOGIC;
			ERROR : out STD_LOGIC;	  
			FSM_ROM_IN : in ROM_UNIT_INPUTS; 
			FSM_ROM_OUT : out ROM_UNIT_OUTPUTS;
			FSM_RAM_IN : in RAM_UNIT_INPUTS;   
			FSM_RAM_OUT : out RAM_UNIT_OUTPUTS;
			FSM_GPR_IN : in GPR_UNIT_INPUTS;  
			FSM_GPR_OUT : out GPR_UNIT_OUTPUTS;
			FSM_ALU_IN : in ALU_UNIT_INPUTS;	
			FSM_ALU_OUT : out ALU_UNIT_OUTPUTS
			);
	end component;
	
	component ROM_UNIT_X is
		port(
			ROM_IN : in ROM_UNIT_OUTPUTS;
			ROM_OUT : out ROM_UNIT_INPUTS
			);
	end component; 
	
	component RAM_UNIT_X is
		port (						   				   
			RAM_IN: in RAM_UNIT_INPUTS;
			RAM_OUT: out RAM_UNIT_OUTPUTS
			);
	end component;
	
	component GPR_UNIT_X is
		port (						   				   
			GPR_IN: in GPR_UNIT_INPUTS;
			GPR_OUT: out GPR_UNIT_OUTPUTS
			);
	end component; 
	
	component ALU_UNIT_X is
		port (
			ALU_IN: in ALU_UNIT_INPUTS;
			ALU_OUT: out ALU_UNIT_OUTPUTS
			);
	end component;			  		
	
	signal BUS_ROM: ROM_UNIT_INPUTS;
	signal ROM_DATA: ROM_UNIT_OUTPUTS;
	
	signal BUS_RAM: RAM_UNIT_INPUTS;
	signal RAM_DATA: RAM_UNIT_OUTPUTS; 
	
	signal BUS_GPR: GPR_UNIT_INPUTS;
	signal GPR_DATA: GPR_UNIT_OUTPUTS;
	
	signal BUS_ALU: ALU_UNIT_INPUTS;
	signal ALU_DATA: ALU_UNIT_OUTPUTS;
	
begin													   
	
	U_FSM: FSM port map (
		CLK, RST, START, HALT, ERROR,
		BUS_ROM, ROM_DATA,
		BUS_RAM, RAM_DATA,
		BUS_GPR, GPR_DATA,
		BUS_ALU, ALU_DATA
		);													   
	
	U_ROM_UNIT: ROM_UNIT_X port map (BUS_ROM, ROM_DATA);
	U_RAM_UNIT: RAM_UNIT_X port map (BUS_RAM, RAM_DATA);
	U_GPR_UNIT: GPR_UNIT_X port map (BUS_GPR, GPR_DATA);
	U_ALU_UNIT: ALU_UNIT_X port map (BUS_ALU, ALU_DATA);
	
end FSM_UNIT;
