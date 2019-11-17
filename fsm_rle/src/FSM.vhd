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
use FSM_RLE.all;

entity FSM is
	port(
		CLK : in STD_LOGIC;
		RST : in STD_LOGIC;
		START : in STD_LOGIC;
		FSM_ROM_IN : out ROM_UNIT_INPUTS;
		FSM_RAM_IN : in std_logic;
		FSM_LIFO_IN : in FSM_LIFO_INPUTS;
		FSM_ALU_IN : in FSM_ALU_INPUTS;
		HALT : out STD_LOGIC;
		ERROR : out STD_LOGIC;
		FSM_ROM_OUT : in ROM_UNIT_OUTPUTS;
		FSM_RAM_OUT : out RAM_UNIT_OUTPUTS;
		FSM_LIFO_OUT : out STD_LOGIC;
		FSM_ALU_OUT : out STD_LOGIC
		);
end FSM;									

architecture FSM of FSM is 
	
	type t_states is (
	s_IDLE,
	s_READ_ROM,
	s_WRITE_IR,
	s_DECODE,
	s_PUSHV,
	s_PUSHC,
	s_ADD,
	s_INC,
	s_CMP,
	s_JL,
	s_WR,
	s_RD,
	s_ALU_ADD,
	s_ALU_CMP,
	s_RAM_RD,
	s_RAM_WR,
	s_LIFO_PUSH,
	s_LIFO_POP,
	s_LIFO_POP2,
	s_LIFO_TOSRW,
	s_PC_NEW,
	s_HALT,
	s_ERROR
	); 
	
	type t_fsm_state is record
		cur, nxt: t_states;
	end record;
	
	signal state: t_fsm_state;
	
	signal opcode: NIBBLE;
	
begin								   						  
	
	P_FSM_MEM: process(CLK, RST, state.nxt)
	begin
		if RST = '1' then
			state.cur <= s_IDLE;
		elsif rising_edge(CLK) then
			state.cur <= state.nxt;	
		end if;
	end process;  
	
	P_FSM_NXT: process(state.cur, START, opcode, FSM_LIFO_IN.EMPTY, FSM_LIFO_IN.FULL)
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
					when STOP => state.nxt <= s_HALT;
					when PUSHV => state.nxt <= s_PUSHV;
					when RD => state.nxt <= s_RD;
					when PUSHC => state.nxt <= s_PUSHC;
					when ADD => state.nxt <= s_ADD;
					when INC => state.nxt <= s_INC;	
					when WR => state.nxt <= s_WR;
					when CMP => state.nxt <= s_CMP;
					when JL => state.nxt <= s_JL;
					when others => state.nxt <= s_ERROR; 
			end case;							  					  
			when s_PUSHV => state.nxt <= s_RAM_RD;
			when s_RD => state.nxt <= s_RAM_RD;
			when s_PUSHC => state.nxt <= s_LIFO_PUSH; 
			when s_ADD => state.nxt <= s_ALU_ADD;
			when s_INC => state.nxt <= s_ALU_ADD;  
			when s_WR => state.nxt <= s_RAM_WR;		 	
			when s_CMP => state.nxt <= s_ALU_CMP;
			when s_JL => state.nxt <= s_PC_NEW;	
			when s_RAM_RD => if opcode = PUSHV then
					state.nxt <= s_LIFO_PUSH;
				elsif opcode = RD then
					state.nxt <= s_LIFO_TOSRW; 
				else   
					state.nxt <= s_ERROR;				
			end if;									  						  
			when s_LIFO_PUSH => state.nxt <= s_PC_NEW; 
			when s_LIFO_TOSRW => state.nxt <= s_PC_NEW;
			when s_ALU_ADD => if opcode = ADD then
					state.nxt <= s_LIFO_PUSH;
				elsif opcode = INC then
					state.nxt <= s_LIFO_TOSRW;
			end if;									  								 
			when s_RAM_WR => state.nxt <= s_LIFO_POP2; 
			when s_ALU_CMP => state.nxt <= s_LIFO_POP;	 
			when s_LIFO_POP2 => state.nxt <= s_PC_NEW;	 
			when s_LIFO_POP => state.nxt <= s_PC_NEW; 
			when s_HALT => state.nxt <= s_HALT;
			when s_PC_NEW => if FSM_LIFO_IN.EMPTY = '1' and FSM_LIFO_IN.FULL = '1' then
					state.nxt <= s_ERROR;
				else
					state.nxt <= s_READ_ROM;
			end if;
			when others => state.nxt <= s_ERROR;
		end case;
	end process; 
	
	P_OUT_ERROR: process(state.cur)
	begin
		if state.cur = s_ERROR then
			ERROR <= '1';
		else
			ERROR <= '0';
		end if;
	end process; 
	
	P_OUT_STOP: process(state.cur)
	begin
		if state.cur = s_HALT then
			HALT <= '1';
		else
			HALT <= '0';
		end if;
	end process; 
	
	FSM_ROM_IN.CLK <= CLK;	
	FSM_ROM_IN.RST <= RST;
	FSM_ROM_IN.L <= FSM_ALU_IN.L_FLAG;	
	
	P_OUT_ROM_IF: process(state.cur)
	begin
		case state.cur is 
			when s_READ_ROM => FSM_ROM_IN.EN <= '1';
				FSM_ROM_IN.IR_EN <= '0';	  
			FSM_ROM_IN.PC_EN <= '0';
			when s_WRITE_IR => FSM_ROM_IN.EN <= '0';  
				FSM_ROM_IN.EN <= '1';
			FSM_ROM_IN.EN <= '0'; 
			when s_PC_NEW => FSM_ROM_IN.EN <= '0';  
				FSM_ROM_IN.EN <= '0';
			FSM_ROM_IN.EN <= '1';
			when others => FSM_ROM_IN.EN <= '0';  
				FSM_ROM_IN.EN <= '0';
			FSM_ROM_IN.EN <= '0';
		end case;
	end process;  
						   				  
	FSM_RAM_OUT.CLK <= CLK;
	FSM_RAM_OUT.RST <= RST;
	FSM_RAM_OUT.TOS <= FSM_LIFO_IN.TOS(3 downto 0);
	FSM_RAM_OUT.TOS_1 <= FSM_LIFO_IN.TOS_1;
	FSM_RAM_OUT.IR <= FSM_ROM_OUT.IR(3 downto 0);
	
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
	
end FSM;
