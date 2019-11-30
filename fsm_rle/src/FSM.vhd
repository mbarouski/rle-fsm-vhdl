-------------------------------------------------------------------------------
--
-- Title       : FSM
-- Design      : fsm_rle
-- Author      : Maxim
-- Company     : None
--
-------------------------------------------------------------------------------
--
-- File        : FSM.vhd
-- Generated   : Wed Nov 13 23:09:05 2019
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

entity FSM is
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
end FSM;									

architecture FSM of FSM is 
	
	type t_states is (
	s_IDLE,
	s_MOV,
	s_MOVDAT, 
	s_JEQ,
	s_JEG,
	s_JMP,
	s_MOV2D,
	s_MOVC2D,
	s_MOV2DAT,
	s_MOV2ADR,
	
	s_READ_ROM,
	s_WRITE_IR,
	s_DECODE, 
	s_ADD,
	s_INC,
	s_CMP,
	s_WR,
	s_RD,
	s_ALU_ADD,
	s_ALU_CMP,
	s_RAM_RD,
	s_RAM_WR,	  
	
	s_PC_NEW,
	s_HALT,
	s_ERROR,
	
	s_GPR_WR
	); 
	
	type t_fsm_state is record
		cur, nxt: t_states;
	end record;
	
	signal state: t_fsm_state;
	
	signal opcode: NIBBLE;
	signal args: NIBBLE;
	
begin															
	opcode <= FSM_ROM_IN.IR(7 downto 4);
	args <= FSM_ROM_IN.IR(3 downto 0);
	
	-- shift next instruction into current or reset current state into s_IDLE
	P_FSM_MEM: process(CLK, RST, state.nxt)
	begin
		if RST = '1' then
			state.cur <= s_IDLE;
		elsif rising_edge(CLK) then
			state.cur <= state.nxt;	
		end if;
	end process;  	
	
	FSM_ROM_OUT.D <= FSM_GPR_IN.D;
	
	-- defines the next state
	P_FSM_NXT: process(state.cur, START, opcode)
	begin
		case state.cur is 
			when s_IDLE => if START = '1' then
					state.nxt <= s_READ_ROM;
				else
					state.nxt <= S_IDLE;
			end if;
			when s_READ_ROM => state.nxt <= s_WRITE_IR;
			when s_WRITE_IR => state.nxt <= s_DECODE;
			when s_DECODE => case opcode is			  
					when RD => state.nxt <= s_RD;
					when WR => state.nxt <= s_WR; 
					
					when ADD => state.nxt <= s_ADD;
					when INC => state.nxt <= s_INC;	 
					when CMP => state.nxt <= s_CMP;	 
					
					when JEQ => state.nxt <= s_JEQ;
					when JEG => state.nxt <= s_JEG;
					when JMP => state.nxt <= s_JMP;
					
					when MOV => state.nxt <= s_MOV;
					when MOVDAT => state.nxt <= s_MOVDAT;
					when MOV2D => state.nxt <= s_MOV2D;	
					when MOVC2D => state.nxt <= s_MOVC2D;
					when MOV2DAT => state.nxt <= s_MOV2DAT;
					when MOV2ADR => state.nxt <= s_MOV2ADR;    
					when NONE => state.nxt <= s_PC_NEW; 	   
					when STOP => state.nxt <= s_HALT; 	
					when others => state.nxt <= s_ERROR; 
			end case;
			when s_RD => state.nxt <= s_RAM_RD; 
			when s_WR => state.nxt <= s_RAM_WR;
			
			when s_ADD => state.nxt <= s_ALU_ADD;
			when s_INC => state.nxt <= s_ALU_ADD; 		 	
			when s_CMP => state.nxt <= s_ALU_CMP;
			
			when s_JEQ => state.nxt <= s_PC_NEW;
			when s_JEG => state.nxt <= s_PC_NEW; 
			when s_JMP => state.nxt <= s_PC_NEW;  
			
			when s_MOV => state.nxt <= s_GPR_WR;
			when s_MOVDAT => state.nxt <= s_GPR_WR;
			when s_MOV2D => state.nxt <= s_GPR_WR; 
			when s_MOVC2D => state.nxt <= s_GPR_WR;
			when s_MOV2DAT => state.nxt <= s_GPR_WR;
			when s_MOV2ADR => state.nxt <= s_GPR_WR;
			
			when s_RAM_RD => state.nxt <= s_GPR_WR;	
			when s_RAM_WR => state.nxt <= s_PC_NEW;	
			
			when s_ALU_CMP => state.nxt <= s_PC_NEW;  -- after comparing we fetch new instruction
			
			when s_ALU_ADD => if opcode = ADD then
					state.nxt <= s_GPR_WR;
				elsif opcode = INC then
					state.nxt <= s_GPR_WR;
				end if;	  
			
			when s_GPR_WR => state.nxt <= s_PC_NEW;
			
			when s_PC_NEW => state.nxt <= s_READ_ROM;
			when s_HALT => state.nxt <= s_HALT;
			when others => state.nxt <= s_ERROR;
		end case;
	end process; 
	
	-- if current state is s_ERROR then outputs '1' for ERROR out
	P_OUT_ERROR: process(state.cur)
	begin
		if state.cur = s_ERROR then
			ERROR <= '1';
		else
			ERROR <= '0';
		end if;
	end process; 
	
	-- if current state is s_HALT then outputs '1' for HALT out
	P_OUT_STOP: process(state.cur)
	begin
		if state.cur = s_HALT then
			HALT <= '1';
		else
			HALT <= '0';
		end if;
	end process; 
	
	FSM_ROM_OUT.CLK <= CLK;	
	FSM_ROM_OUT.RST <= RST;
	-- set EQ and GT falgs into ROM to resolve JEQ and JEG
	FSM_ROM_OUT.EQ <= FSM_ALU_IN.EQ_FLAG;
	FSM_ROM_OUT.GT <= FSM_ALU_IN.GT_FLAG;
	
	-- manage rom's enable pins depending on the current state
	P_OUT_ROM_IF: process(state.cur)
	begin
		case state.cur is 
			when s_READ_ROM => FSM_ROM_OUT.EN <= '1';
				FSM_ROM_OUT.IR_EN <= '0';	  
			FSM_ROM_OUT.PC_EN <= '0';
			when s_WRITE_IR => FSM_ROM_OUT.EN <= '0';  
				FSM_ROM_OUT.IR_EN <= '1';
			FSM_ROM_OUT.PC_EN <= '0'; 
			when s_PC_NEW => FSM_ROM_OUT.EN <= '0';  
				FSM_ROM_OUT.IR_EN <= '0';
			FSM_ROM_OUT.PC_EN <= '1';
			when others => FSM_ROM_OUT.EN <= '0';  
				FSM_ROM_OUT.IR_EN <= '0';
			FSM_ROM_OUT.PC_EN <= '0';
		end case;
	end process; 
	
	FSM_RAM_OUT.CLK <= CLK;
	FSM_RAM_OUT.RST <= RST;
	FSM_RAM_OUT.ADR <= FSM_GPR_IN.ADR;
	FSM_RAM_OUT.DATA <= FSM_GPR_IN.DAT;
	FSM_RAM_OUT.IR <= FSM_ROM_IN.IR(3 downto 0);
	
	-- manage ram's enable pins depending on the current state
	P_OUT_RAM_IF_1: process(state.cur)
	begin		
		case state.cur is					
			when s_RAM_RD => FSM_RAM_OUT.R_EN <= '1';
			FSM_RAM_OUT.W_EN <= '0';
			when s_RAM_WR => FSM_RAM_OUT.R_EN <= '0';
			FSM_RAM_OUT.W_EN <= '1';
			when others => FSM_RAM_OUT.R_EN <= '0';
			FSM_RAM_OUT.W_EN <= '0';
		end case;
	end process; 
	
	FSM_GPR_OUT.CLK <= CLK;
	FSM_GPR_OUT.RST <= RST; 						 				 
	
	-- manages GPR enable pin
	P_OUT_GPR_IF_1: process(state.cur)
	begin
		case state.cur is							  
			when s_GPR_WR => FSM_GPR_OUT.W_EN <= '1';
			when others => FSM_GPR_OUT.W_EN <= '0';
		end case;
	end process;  						 				 
	
	-- manages GPR registers inputs	
	P_OUT_GPR_IF_2: process(state.cur, opcode)
	begin
		case opcode is							   
			when MOV2D =>
				FSM_GPR_OUT.REG_DST <= D;
				FSM_GPR_OUT.REG_SRC <= args(3 downto 1); -- or constant from instruction 
										   
			when MOVC2D =>
				FSM_GPR_OUT.REG_DST <= D;
				FSM_GPR_OUT.REG_SRC <= (others => '0'); -- or constant from instruction 
			
			when MOV2DAT =>
				FSM_GPR_OUT.REG_DST <= DAT;	
				FSM_GPR_OUT.REG_SRC <= args(3 downto 1); -- or constant from instruction 
			
			when MOV2ADR =>
				FSM_GPR_OUT.REG_DST <= ADR;
				FSM_GPR_OUT.REG_SRC <= args(3 downto 1); -- or constant from instruction 	   
			
			when MOV =>						
				FSM_GPR_OUT.REG_DST <= args(3 downto 1);
				FSM_GPR_OUT.REG_SRC <= (others => '0');	
			
			when MOVDAT =>				  
				FSM_GPR_OUT.REG_DST <= args(3 downto 1);
				FSM_GPR_OUT.REG_SRC <= DAT;	
			
			when RD =>				  
				FSM_GPR_OUT.REG_DST <= DAT;
				FSM_GPR_OUT.REG_SRC <= (others => '0');				 
			
			when others =>			   
				FSM_GPR_OUT.REG_DST <= (others => '0');
			FSM_GPR_OUT.REG_SRC <= (others => '0');	 
		end case;
	end process;  
	
	-- manages GPR data input source
	P_OUT_GPR_IF_3: process(opcode)
	begin
		case opcode is
			when RD => FSM_GPR_OUT.PUSHDATA <= "01"; -- ram				  
			when MOV => FSM_GPR_OUT.PUSHDATA <= "10"; -- instruction	   
			when MOVDAT => FSM_GPR_OUT.PUSHDATA <= "00"; -- reg	
			when MOV2DAT => if args(3 downto 1) = DAT then
					FSM_GPR_OUT.PUSHDATA <= "10"; -- instruction
				else
					FSM_GPR_OUT.PUSHDATA <= "00"; -- reg
			end if;
			when MOV2ADR => if args(3 downto 1) = ADR then
					FSM_GPR_OUT.PUSHDATA <= "10"; -- instruction
				else
					FSM_GPR_OUT.PUSHDATA <= "00"; -- reg
			end if;
			when MOV2D => if args(3 downto 1) = D then
					FSM_GPR_OUT.PUSHDATA <= "10"; -- instruction
				else
					FSM_GPR_OUT.PUSHDATA <= "00"; -- reg
			end if;
			when MOVC2D => FSM_GPR_OUT.PUSHDATA <= "10"; -- instruction
			when ADD | INC => FSM_GPR_OUT.PUSHDATA <= "11"; -- alu
			when others => FSM_GPR_OUT.PUSHDATA <= "00";
		end case;
	end process;
	
	-- setting gpr data for writing into certain register
	FSM_GPR_OUT.IR <= FSM_ROM_IN.IR;
	FSM_GPR_OUT.ALU_RESULT <= FSM_ALU_IN.DATA;
	FSM_GPR_OUT.RAM_DATA <= FSM_RAM_IN.DATA;
	
	-- manages ALU's arg_2 input
	P_ALU_ARG_2: process(opcode)
	begin		   																 
		case args(3 downto 1) is										  
			when A => FSM_ALU_OUT.ARG_2 <= FSM_GPR_IN.A;				  
			when B => FSM_ALU_OUT.ARG_2 <= FSM_GPR_IN.B;				  
			when C => FSM_ALU_OUT.ARG_2 <= FSM_GPR_IN.C;				  
			when D => FSM_ALU_OUT.ARG_2 <= FSM_GPR_IN.D;				  
			when I => FSM_ALU_OUT.ARG_2 <= FSM_GPR_IN.I;				  
			when J => FSM_ALU_OUT.ARG_2 <= FSM_GPR_IN.J;				  
			when ADR => FSM_ALU_OUT.ARG_2 <= FSM_GPR_IN.ADR;				  
			when DAT => FSM_ALU_OUT.ARG_2 <= FSM_GPR_IN.DAT;
			when others => FSM_ALU_OUT.ARG_2 <= (others => '0');
		end case;
	end process;	
	
	FSM_ALU_OUT.CLK <= CLK;
	FSM_ALU_OUT.RST <= RST;
	FSM_ALU_OUT.ARG_1 <= FSM_GPR_IN.D;  										 
	FSM_ALU_OUT.OPCODE <= opcode;
	
	P_OUT_ALU_IF: process(state.cur)
	begin
		case state.cur is
			when s_ALU_ADD | s_ALU_CMP => FSM_ALU_OUT.EN <= '1';
			when others => FSM_ALU_OUT.EN <= '0'; 
		end case;
	end process;
end FSM;
