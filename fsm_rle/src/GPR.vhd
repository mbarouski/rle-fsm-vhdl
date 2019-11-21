-------------------------------------------------------------------------------
--
-- Title       : GPR
-- Design      : fsm_rle
-- Author      : maxim
-- Company     : none
--
-------------------------------------------------------------------------------
--
-- File        : GPR.vhd
-- Generated   : Thu Nov 21 21:08:27 2019
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

entity GPR is
	 port(
		 WR : in STD_LOGIC;
		 RD : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 RST : in STD_LOGIC;
		 DATAIN : in BYTE;
		 REG : in REGI;
		 DATAOUT : out BYTE
	     );
end GPR;									 

architecture GPR of GPR is	

signal din: BYTE;
signal dout: BYTE;
signal r: REGI;	

-- registers state
signal state: GPR_STATE; 

begin					  				
	
	din <= DATAIN;
	r <= REG;
	
	WR_PROCESS: process(CLK, RST, WR)
	begin		
		if rising_edge(CLK) then
			if WR = '1' then
				case r is					  				
					when A => state.A <= din;
					when B => state.B <= din;
					when C => state.C <= din;
					when D => state.D <= din;
					when I => state.I <= din;
					when J => state.J <= din;
					when ADR => state.ADR <= din;
					when DAT => state.DAT <= din; 
					when others => null;
				end case;
			end if;
		end if;
	end process;
	
	RD_PROCESS: process(CLK, RST, RD)
	begin		
		if rising_edge(CLK) then
			if RST = '1' then
				dout <= (others => '0');
			elsif RD = '1' then
				case r is					  				
					when A => dout <= state.A;				
					when B => dout <= state.B;				
					when C => dout <= state.C;				
					when D => dout <= state.D;				
					when I => dout <= state.I;				
					when J => dout <= state.J;				
					when ADR => dout <= state.ADR;				
					when DAT => dout <= state.DAT; 
					when others => null;
				end case;
			end if;
		end if;
	end process;
	
	DATAOUT <= dout;

end GPR;
