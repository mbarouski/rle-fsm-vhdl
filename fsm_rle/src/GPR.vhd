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
end GPR;									 

architecture GPR of GPR is	
						   				
	signal ramdata: BYTE;  
	signal aluresult: BYTE;	  
	signal instruction: BYTE;
	signal regdata: BYTE;					   			   
	signal datasrc: std_logic_vector(0 to 1);
	signal regsrc: REGI;
	signal regdst: REGI;	
	
	-- registers state
	signal state: GPR_STATE; 
	
begin			 	   
	AA <= state.A;
	BB <= state.B;
	CC <= state.C;
	DD <= state.D;
	II <= state.I;
	JJ <= state.J;
	ADRR <= state.ADR;
	DATT <= state.DAT;
						 				
	ramdata <= RAM_DATA;
	aluresult <= RAM_DATA;
	instruction <= RAM_DATA;
	regdata <= RAM_DATA; 
	datasrc <= DATA_SRC; 
	regsrc <= REG_SRC;
	regdst <= REG_DST;
	
	REGISTER_DATA: process(CLK, WR, REG_SRC)
	begin
		if rising_edge(CLK) then
			if WR = '1' then
			 	if datasrc = "00" then
					 case regsrc is			 		  	   
						 when A => regdata <= state.A;
						 when B => regdata <= state.B;
						 when C => regdata <= state.C;
						 when D => regdata <= state.D;
						 when I => regdata <= state.I;
						 when J => regdata <= state.J;
						 when ADR => regdata <= state.ADR;
						 when DAT => regdata <= state.DAT;
						 when others => null;
					end case;
				end if;
			end if;
		end if;
	end process;
	
	WR_PROCESS: process(CLK, RST, WR)
	begin		
		if rising_edge(CLK) then
			if WR = '1' then
				case DATA_SRC is
					when "00" => null; -- reg	
						case regdst is					  				
							when A => state.A <= regdata;
							when B => state.B <= regdata;
							when C => state.C <= regdata;
							when D => state.D <= regdata;
							when I => state.I <= regdata;
							when J => state.J <= regdata;
							when ADR => state.ADR <= regdata;
							when DAT => state.DAT <= regdata; 
							when others => null;
						end case;
					when "01" => null; -- ram data
						case regdst is					  				
							when A => state.A <= ramdata;
							when B => state.B <= ramdata;
							when C => state.C <= ramdata;
							when D => state.D <= ramdata;
							when I => state.I <= ramdata;
							when J => state.J <= ramdata;
							when ADR => state.ADR <= ramdata;
							when DAT => state.DAT <= ramdata; 
							when others => null;
						end case;	   	 
					when "10" => null; -- instruction  
						case regdst is					  				
							when A => state.A <= "0000000" & instruction(7);
							when B => state.B <= "0000000" & instruction(7);
							when C => state.C <= "0000000" & instruction(7);
							when D => state.D <= "0000000" & instruction(7);
							when I => state.I <= "0000000" & instruction(7);
							when J => state.J <= "0000000" & instruction(7);
							when ADR => state.ADR <= "0000000" & instruction(7);
							when DAT => state.DAT <= "0000000" & instruction(7); 
							when others => null;
						end case;
					when "11" => null; -- alu
						case regdst is					  				
							when A => state.A <= aluresult;
							when B => state.B <= aluresult;
							when C => state.C <= aluresult;
							when D => state.D <= aluresult;
							when I => state.I <= aluresult;
							when J => state.J <= aluresult;
							when ADR => state.ADR <= aluresult;
							when DAT => state.DAT <= aluresult; 
							when others => null;
						end case;
					when others => null;
				end case;
			end if;
		end if;
	end process; 
	
end GPR;
