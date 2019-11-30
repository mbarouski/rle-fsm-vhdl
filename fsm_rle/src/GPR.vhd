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
use work.FSM_RLE.all;

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
	aluresult <= ALU_RESULT;
	instruction <= IR;
	datasrc <= DATA_SRC; 
	regsrc <= REG_SRC;
	regdst <= REG_DST;
	
	--REGISTER_DATA: process(CLK, WR, REG_SRC)
	--	begin
	--		if rising_edge(CLK) then
	--			if WR = '1' then
	--			 	if datasrc = "00" then
	--					 case regsrc is			 		  	   
	--						 when A => regdata <= state.A;
	--						 when B => regdata <= state.B;
	--						 when C => regdata <= state.C;
	--						 when D => regdata <= state.D;
	--						 when I => regdata <= state.I;
	--						 when J => regdata <= state.J;
	--						 when ADR => regdata <= state.ADR;
	--						 when DAT => regdata <= state.DAT;
	--						 when others => null;
	--					end case;
	--				end if;
	--			end if;
	--		end if;
	--	end process;
	
	WR_PROCESS: process(CLK, RST, WR, regdst, DATA_SRC, regdata, aluresult, instruction, ramdata)
	begin		
		if rising_edge(CLK) then
			if WR = '1' then
				case DATA_SRC is
					when "00" => -- reg	  
						case regsrc is			 		  	   
							when A => case regdst is
								when A => state.A <= state.A;
								when B => state.B <= state.A;
								when C => state.C <= state.A;
								when D => state.D <= state.A;
								when I => state.I <= state.A;
								when J => state.J <= state.A;
								when ADR => state.ADR <= state.A;
								when DAT => state.DAT <= state.A; 
								when others => null;
							end case;
							when B => case regdst is
								when A => state.A <= state.B;
								when B => state.B <= state.B;
								when C => state.C <= state.B;
								when D => state.D <= state.B;
								when I => state.I <= state.B;
								when J => state.J <= state.B;
								when ADR => state.ADR <= state.B;
								when DAT => state.DAT <= state.B; 
								when others => null;
							end case;
							when C => case regdst is
								when A => state.A <= state.C;
								when B => state.B <= state.C;
								when C => state.C <= state.C;
								when D => state.D <= state.C;
								when I => state.I <= state.C;
								when J => state.J <= state.C;
								when ADR => state.ADR <= state.C;
								when DAT => state.DAT <= state.C; 
								when others => null;
							end case;
							when D => case regdst is
								when A => state.A <= state.D;
								when B => state.B <= state.D;
								when C => state.C <= state.D;
								when D => state.D <= state.D;
								when I => state.I <= state.D;
								when J => state.J <= state.D;
								when ADR => state.ADR <= state.D;
								when DAT => state.DAT <= state.D; 
								when others => null;
							end case;
							when I => case regdst is
								when A => state.A <= state.I;
								when B => state.B <= state.I;
								when C => state.C <= state.I;
								when D => state.D <= state.I;
								when I => state.I <= state.I;
								when J => state.J <= state.I;
								when ADR => state.ADR <= state.I;
								when DAT => state.DAT <= state.I; 
								when others => null;
							end case;
							when J => case regdst is
								when A => state.A <= state.J;
								when B => state.B <= state.J;
								when C => state.C <= state.J;
								when D => state.D <= state.J;
								when I => state.I <= state.J;
								when J => state.J <= state.J;
								when ADR => state.ADR <= state.J;
								when DAT => state.DAT <= state.J; 
								when others => null;
							end case;
							when ADR => case regdst is
								when A => state.A <= state.ADR;
								when B => state.B <= state.ADR;
								when C => state.C <= state.ADR;
								when D => state.D <= state.ADR;
								when I => state.I <= state.ADR;
								when J => state.J <= state.ADR;
								when ADR => state.ADR <= state.ADR;
								when DAT => state.DAT <= state.ADR; 
								when others => null;
							end case;
							when DAT => case regdst is
								when A => state.A <= state.DAT;
								when B => state.B <= state.DAT;
								when C => state.C <= state.DAT;
								when D => state.D <= state.DAT;
								when I => state.I <= state.DAT;
								when J => state.J <= state.DAT;
								when ADR => state.ADR <= state.DAT;
								when DAT => state.DAT <= state.DAT; 
								when others => null;
							end case;
							when others => null;
						end case;  
						
						
						--case regdst is
						--							when A => state.A <= regdata;
						--							when B => state.B <= regdata;
						--							when C => state.C <= regdata;
						--							when D => state.D <= regdata;
						--							when I => state.I <= regdata;
						--							when J => state.J <= regdata;
						--							when ADR => state.ADR <= regdata;
						--							when DAT => state.DAT <= regdata; 
						--							when others => null;  
					--end case;
					when "01" =>  -- ram data
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
					when "10" =>  -- instruction  
						case regdst is					  				
							when A => state.A <= "0000000" & instruction(0); -- 0 is correct (debugged)
							when B => state.B <= "0000000" & instruction(0);
							when C => state.C <= "0000000" & instruction(0);
							when D => state.D <= "0000000" & instruction(0);
							when I => state.I <= "0000000" & instruction(0);
							when J => state.J <= "0000000" & instruction(0);
							when ADR => state.ADR <= "0000000" & instruction(0);
							when DAT => state.DAT <= "0000000" & instruction(0); 
							when others => null;
					end case;
					when "11" =>  -- alu
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
