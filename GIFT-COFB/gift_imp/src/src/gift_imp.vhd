--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 



-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY AddConstKey IS
   GENERIC (withConst : integer);
	PORT ( -- CONST PORT -----------------------------------
			 CONST			: IN	STD_LOGIC_VECTOR(5 DOWNTO 0);
			 -- KEY PORT -------------------------------------
			 ROUND_KEY1		: IN	STD_LOGIC_VECTOR(127 DOWNTO 0);
			 ROUND_KEY2		: IN	STD_LOGIC_VECTOR(127 DOWNTO 0);
			 -- DATA PORTS -----------------------------------
			 DATA_IN			: IN	STD_LOGIC_VECTOR(127 DOWNTO 0);
			 DATA_OUT		: OUT STD_LOGIC_VECTOR(127 DOWNTO 0));
END AddConstKey;



-- ARCHITECTURE : MIXED
----------------------------------------------------------------------------------
ARCHITECTURE Parallel OF AddConstKey IS

	-- SIGNALS --------------------------------------------------------------------
	SIGNAL CONST_ADDITION	: STD_LOGIC_VECTOR(127 DOWNTO 0);

BEGIN
	
	GEN0: IF withConst = 0 GENERATE
		CONST_ADDITION	<= DATA_IN;
	END GENERATE;	

	GEN1: IF withConst /= 0 GENERATE
		-- CONSTANT ADDITION ----------------------------------------------------------
		CONST_ADDITION(127 DOWNTO 124) <= DATA_IN(127 DOWNTO 124);
		CONST_ADDITION(123 DOWNTO 120) <= DATA_IN(123 DOWNTO 120) XOR CONST(3 DOWNTO 0);
		CONST_ADDITION(119 DOWNTO  90) <= DATA_IN(119 DOWNTO  90);
		CONST_ADDITION( 89 DOWNTO  88) <= DATA_IN( 89 DOWNTO  88) XOR CONST(5 DOWNTO 4);
		CONST_ADDITION( 87 DOWNTO  58) <= DATA_IN( 87 DOWNTO  58);
		CONST_ADDITION( 57) 	    	    <= NOT(DATA_IN(57));
		CONST_ADDITION( 56 DOWNTO   0) <= DATA_IN( 56 DOWNTO   0);
		-------------------------------------------------------------------------------
	END GENERATE;	

	-- ROUNDKEY ADDITION ----------------------------------------------------------
	DATA_OUT(127 DOWNTO 96) <= CONST_ADDITION(127 DOWNTO 96) XOR ROUND_KEY1(127 DOWNTO 96) XOR ROUND_KEY2(127 DOWNTO 96);
	DATA_OUT( 95 DOWNTO 64) <= CONST_ADDITION( 95 DOWNTO 64) XOR ROUND_KEY1( 95 DOWNTO 64) XOR ROUND_KEY2( 95 DOWNTO 64);
	DATA_OUT( 63 DOWNTO 32) <= CONST_ADDITION( 63 DOWNTO 32);
	DATA_OUT( 31 DOWNTO  0) <= CONST_ADDITION( 31 DOWNTO  0);
	-------------------------------------------------------------------------------

END Parallel;

--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CompFGHI1 is -- x XOR (w NOR u)
    Port ( x : in  STD_LOGIC;
			  w : in  STD_LOGIC;
			  u : in  STD_LOGIC;
           z : out STD_LOGIC);
end CompFGHI1;

architecture Behavioral of CompFGHI1 is

begin

	z <= x XOR (w NOR u);
	
end Behavioral;


--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CompFGHI2 is -- x XNOR (w NAND u)
    Port ( x : in  STD_LOGIC;
			  w : in  STD_LOGIC;
			  u : in  STD_LOGIC;
           z : out STD_LOGIC);
end CompFGHI2;

architecture Behavioral of CompFGHI2 is

begin

	z <= x XNOR (w NAND u);
	
end Behavioral;


--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CompFGHICombine is -- (x(7 downto 4) & (x(3) xor y(1))  & (x(2) xor y(0)))  & x(1 downto 0)
    Port ( x : in  STD_LOGIC_VECTOR(7 downto 0);
			  y : in  STD_LOGIC_VECTOR(1 downto 0);
			  z : out STD_LOGIC_VECTOR(7 downto 0));
end CompFGHICombine;

architecture Behavioral of CompFGHICombine is

begin

	z <= (x(7 downto 4) & (x(3) xor y(1))  & (x(2) xor y(0)))  & x(1 downto 0);
	
end Behavioral;


--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CompFGHI_Inv_Combine is 
    Port ( x : in  STD_LOGIC_VECTOR(7 downto 0);
			  y : in  STD_LOGIC_VECTOR(1 downto 0);
			  z : out STD_LOGIC_VECTOR(7 downto 0));
end CompFGHI_Inv_Combine;

architecture Behavioral of CompFGHI_Inv_Combine is

begin

	z <= x(7) & (x(6) xor y(1)) & (x(5) xor y(0)) & x(4 downto 0);
	
end Behavioral;


--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CompFGHIp1 is -- (x NOR (NOT w))
    Port ( x : in  STD_LOGIC;
			  w : in  STD_LOGIC;
           z : out STD_LOGIC);
end CompFGHIp1;

architecture Behavioral of CompFGHIp1 is

begin

	z <= (x NOR (NOT w));
	
end Behavioral;


--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 


-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY ControlLogic IS
	PORT ( CLK			: IN	STD_LOGIC;
			 -- CONTROL PORTS --------------------------------
		  	 RESET		: IN  STD_LOGIC;
			 DECRYPT		: IN	STD_LOGIC;
		    DONE			: OUT STD_LOGIC;
			 FIRST		: OUT STD_LOGIC;
			 LAST			: OUT STD_LOGIC;
			 -- CONST PORT -----------------------------------
          ROUND_CST	: OUT STD_LOGIC_VECTOR (5 DOWNTO 0));
END ControlLogic;



-- ARCHITECTURE : ROUND
----------------------------------------------------------------------------------
ARCHITECTURE Round OF ControlLogic IS

	-- SIGNALS --------------------------------------------------------------------
	SIGNAL STATE, UPDATE : STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL COUNTER			: INTEGER RANGE 0 TO 4;
	SIGNAL COUNTERIS0		: STD_LOGIC;
	SIGNAL COUNTERIS4		: STD_LOGIC;

BEGIN

	-- CONTROL LOGIC --------------------------------------------------------------
	PROCESS(CLK) BEGIN
		IF RISING_EDGE(CLK) THEN
			IF (RESET = '1' OR COUNTER = 4) THEN
				COUNTER <= 0;
			ELSE
				COUNTER <= COUNTER + 1;
			END IF;
		END IF;
	END PROCESS;

	COUNTERIS0 	<= '1' WHEN (COUNTER = 0) ELSE '0';
	COUNTERIS4 	<= '1' WHEN (COUNTER = 4) ELSE '0';
	FIRST 		<= COUNTERIS0;
	LAST 			<= COUNTERIS4;

	-- STATE ----------------------------------------------------------------------
	REG : PROCESS(CLK) BEGIN
		IF RISING_EDGE(CLK) THEN
			IF (RESET = '1') THEN
				STATE <= "00" & DECRYPT & "00" & DECRYPT;
			ELSIF (COUNTER = 4) THEN
				STATE <= UPDATE;
			END IF;
		END IF;
	END PROCESS;
	-------------------------------------------------------------------------------

	-- UPDATE FUNCTION ------------------------------------------------------------
	UPDATE 	<= STATE(4 DOWNTO 0) & (STATE(5) XNOR STATE(4)) WHEN (DECRYPT = '0') ELSE (STATE(5) XNOR STATE(0)) & STATE(5 DOWNTO 1);

	-- CONSTANT -------------------------------------------------------------------
	ROUND_CST <= UPDATE;

	-- DONE SIGNAL ----------------------------------------------------------------
	DONE <= COUNTERIS4 WHEN (DECRYPT = '0' AND UPDATE = "000100") OR (DECRYPT = '1' AND UPDATE = "000001") ELSE '0';

END Round;


--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Controller is
	Generic (
		nl				 			: integer := 0;  -- 0: 128-bit nonce, 1: 96-bit nonce
		tl				 			: integer := 0); -- 0: 128-bit tag,   1: 64-bit tag
	Port(
		clk						: in  std_logic;
		rst						: in  std_logic;
		a_data					: in  std_logic;
		enc						: in  std_logic;
		dec						: in  std_logic;
		gen_tag					: in  std_logic;
		full_size				: in  std_logic;
		LFSR_rst					: out std_logic;
		LFSR_en					: out std_logic;
		Auth_rst					: out std_logic;
		Auth_en					: out std_logic;
		Tag_rst					: out std_logic;
		Tag_en					: out std_logic;
		Cipher_rst				: out std_logic;
		Cipher_dec				: out std_logic;
		Cipher_done				: in  std_logic;
		Domain_Separation		: out std_logic_vector(7 downto 0);
		done						: out std_logic);
end entity Controller;


architecture dfl of Controller is

	constant d0       			: STD_LOGIC_VECTOR(2 downto 0) := "000";
	constant d1       			: STD_LOGIC_VECTOR(2 downto 0) := "001";
	constant d2       			: STD_LOGIC_VECTOR(2 downto 0) := "010";
	constant d3      				: STD_LOGIC_VECTOR(2 downto 0) := "011";
	constant d4       			: STD_LOGIC_VECTOR(2 downto 0) := "100";
	constant d5       			: STD_LOGIC_VECTOR(2 downto 0) := "101";

	signal d							: STD_LOGIC_VECTOR(2 downto 0);

	signal encdec_started			: STD_LOGIC;
	signal encdec_started_update	: STD_LOGIC;

	type FSM_STATES is  (S_IDLE, S_Start_Cipher, S_Wait_for_Cipher_done, S_Wait_for_Idle);

  	signal fsm_state    : FSM_STATES := S_IDLE;
  	signal next_state   : FSM_STATES;

begin

	Auth_rst				<= rst;
	Tag_rst				<= rst;
	
	Domain_Separation	<=	"000" & std_logic_vector(to_unsigned(nl,1)) & std_logic_vector(to_unsigned(tl,1)) & d;
	
	Cipher_dec			<= dec and full_size;
	
	----------------------------------------------------
		
	FSM: process(clk, rst, next_state, encdec_started_update)
	begin
		if (rising_edge(clk)) then
			if (rst = '1') then
				fsm_state 	   <= S_IDLE;	
				encdec_started	<= '0';
			else
				fsm_state		<= next_state;
				encdec_started	<= encdec_started_update;
			end if;
		end if;
	end process;	
			
	----------------------------------------------------			
				
	state_change:	process(fsm_state, rst, a_data, enc, dec, gen_tag, full_size, encdec_started, Cipher_done)
	begin
		LFSR_rst						<= rst;
		LFSR_en						<= '0';
		Auth_en						<= '0';
		Tag_en						<= '0';
		Cipher_rst					<= '1';
		encdec_started_update	<= encdec_started;
		d								<= d0;
		done 			   			<= '0';
		
		next_state					<= fsm_state;
		
		case fsm_state is
		when S_IDLE =>
			if (rst = '0') then
				if ((enc = '1') or (dec = '1')) then
					LFSR_rst					<= not encdec_started;
					encdec_started_update<= '1';
				end if;	

				Tag_en						<= enc;
				
				if (gen_tag = '1') then
					LFSR_rst					<= not encdec_started;
				end if;

				if (a_data = '1') or (enc = '1') or (dec = '1') or (gen_tag = '1') then
					next_state				<= S_Start_Cipher;
				end if;
			end if;

		when S_Start_Cipher =>
			if (a_data = '1') then
				if (full_size = '1') then
					d						<= d2;
				else
					d						<= d3;
				end if;
			elsif (enc = '1') or (dec = '1') then
				if (full_size = '1') then
					d						<= d0;
				else
					d						<= d1;
				end if;
			elsif (gen_tag = '1') then
				if (full_size = '1') then
					d						<= d4;
				else
					d						<= d5;
				end if;
			end if;	

			next_state						<= S_Wait_for_Cipher_done;

		when S_Wait_for_Cipher_done =>
			Cipher_rst						<= '0';
			
			if (Cipher_done = '1') then
				LFSR_en						<= '1';
				Auth_en						<= a_data;
				Tag_en						<= dec;
				done							<= '1';
				next_state					<= S_Wait_for_Idle;
			end if;
		
		when S_Wait_for_Idle =>
			Cipher_rst						<= '0';

			if (a_data = '0') and (enc = '0') and (dec = '0') and (gen_tag = '0') then
				next_state 					<= S_IDLE;
			end if;
		end case;
	end process;	

end architecture;

--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FGHI_Combine is
    Port ( x1 : in  STD_LOGIC_VECTOR (7 downto 0);
			  x2 : in  STD_LOGIC_VECTOR (7 downto 0);
			  x3 : in  STD_LOGIC_VECTOR (1 downto 0);
           x4 : in  STD_LOGIC_VECTOR (1 downto 0);
           y1 : out STD_LOGIC_VECTOR (7 downto 0);
			  y2 : out STD_LOGIC_VECTOR (7 downto 0);
           z1 : out STD_LOGIC_VECTOR (7 downto 0);
			  z2 : out STD_LOGIC_VECTOR (7 downto 0));
end FGHI_Combine;

architecture Behavioral of FGHI_Combine is

	component CompFGHICombine is -- (x(7 downto 4) & (x(3) xor y(1))  & (x(2) xor y(0)))  & x(1 downto 0)
    Port ( x : in  STD_LOGIC_VECTOR(7 downto 0);
			  y : in  STD_LOGIC_VECTOR(1 downto 0);
			  z : out STD_LOGIC_VECTOR(7 downto 0));
	end component;	

	signal yy1 : STD_LOGIC_VECTOR (7 downto 0);
	signal yy2 : STD_LOGIC_VECTOR (7 downto 0);
	
begin
	
	Combine1: CompFGHICombine -- (x1(7 downto 4) & (x1(3) xor x3(1))  & (x1(2) xor x3(0)))  & x1(1 downto 0)
	port map(x1, x3, yy1);
	
	Combine2: CompFGHICombine -- (x2(7 downto 4) & (x2(3) xor x4(1))  & (x2(2) xor x4(0)))  & x2(1 downto 0)
	port map(x2, x4, yy2);

	y1	<= yy1;
	y2	<= yy2;

	z1(0) <= yy1(2);
	z1(2) <= yy1(6);
	z1(1) <= yy1(7);
	z1(3) <= yy1(1);
	z1(4) <= yy1(3);
	z1(5) <= yy1(0);
	z1(6) <= yy1(4);
	z1(7) <= yy1(5);

	z2(0) <= yy2(2);
	z2(2) <= yy2(6);
	z2(1) <= yy2(7);
	z2(3) <= yy2(1);
	z2(4) <= yy2(3);
	z2(5) <= yy2(0);
	z2(6) <= yy2(4);
	z2(7) <= yy2(5);

end Behavioral;

--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FGHI_Inv_Combine is
    Port ( x1 : in  STD_LOGIC_VECTOR (7 downto 0);
			  x2 : in  STD_LOGIC_VECTOR (7 downto 0);
			  x3 : in  STD_LOGIC_VECTOR (1 downto 0);
           x4 : in  STD_LOGIC_VECTOR (1 downto 0);
           y1 : out STD_LOGIC_VECTOR (7 downto 0);
			  y2 : out STD_LOGIC_VECTOR (7 downto 0);
           z1 : out STD_LOGIC_VECTOR (7 downto 0);
			  z2 : out STD_LOGIC_VECTOR (7 downto 0));
end FGHI_Inv_Combine;

architecture Behavioral of FGHI_Inv_Combine is

	signal yy1 : STD_LOGIC_VECTOR (7 downto 0);
	signal yy2 : STD_LOGIC_VECTOR (7 downto 0);
	
begin
	
	Combine1: entity work.CompFGHI_Inv_Combine
	port map(x1, x3, yy1);
	
	Combine2: entity work.CompFGHI_Inv_Combine
	port map(x2, x4, yy2);

	y1	<= yy1;
	y2	<= yy2;

	z1(2) <= yy1(0);
	z1(6) <= yy1(2);
	z1(7) <= yy1(1);
	z1(1) <= yy1(3);
	z1(3) <= yy1(4);
	z1(0) <= yy1(5);
	z1(4) <= yy1(6);
	z1(5) <= yy1(7);

	z2(2) <= yy2(0);
	z2(6) <= yy2(2);
	z2(7) <= yy2(1);
	z2(1) <= yy2(3);
	z2(3) <= yy2(4);
	z2(0) <= yy2(5);
	z2(4) <= yy2(6);
	z2(5) <= yy2(7);

end Behavioral;

--
-- SKINNY-AEAD Reference Hardware Implementation
-- aa
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FullKeySchedule1 is
	port(
		Input	  		: in  std_logic_vector(127 downto 0);
		Output		: out std_logic_vector(127 downto 0));
end entity FullKeySchedule1;

architecture dfl of FullKeySchedule1 is

	type INT_ARRAY is array (integer range <>) of integer;
	constant PT: INT_ARRAY(0 to 15) := (8,  9, 10, 11, 12, 13, 14, 15,  2,  0, 4,  7,  6,  3,  5,  1);

begin

	Gen_TK1: for i in 0 to 15 generate
		Output((15-i)*8+7 downto (15-i)*8) <= input((15-PT(i))*8+7 downto (15-PT(i))*8);
	end generate;

	--SKINNY-128-256:
	--Order:
	-- 8  9 10 11 12 13 14 15  2  0  4  7  6  3  5  1

end architecture;

--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FullKeySchedule2 is
	port(
		Input	  		: in  std_logic_vector(127 downto 0);
		Output		: out std_logic_vector(127 downto 0));
end entity FullKeySchedule2;

architecture dfl of FullKeySchedule2 is

	type INT_ARRAY is array (integer range <>) of integer;
	constant PT: INT_ARRAY(0 to 15) := (8,  9, 10, 11, 12, 13, 14, 15,  2,  0, 4,  7,  6,  3,  5,  1);

	signal TK2 : std_logic_vector(127 downto 0);

begin

	Gen_TK2_1: for i in 0 to 7 generate
		TK2((15-i)*8+7)	<= input((15-i)*8+0) XOR input((15-i)*8+2) XOR input((15-i)*8+4);
		TK2((15-i)*8+6)	<= input((15-i)*8+1) XOR input((15-i)*8+3) XOR input((15-i)*8+5) XOR input((15-i)*8+7);
		TK2((15-i)*8+5)	<= input((15-i)*8+0) XOR input((15-i)*8+2) XOR input((15-i)*8+4) XOR input((15-i)*8+6); 
		TK2((15-i)*8+4)	<= input((15-i)*8+1) XOR input((15-i)*8+3) XOR input((15-i)*8+7);
		TK2((15-i)*8+3)	<= input((15-i)*8+0) XOR input((15-i)*8+2) XOR input((15-i)*8+6); 
		TK2((15-i)*8+2)	<= input((15-i)*8+1) XOR input((15-i)*8+7);
		TK2((15-i)*8+1)	<= input((15-i)*8+0) XOR input((15-i)*8+6);
		TK2((15-i)*8+0)	<= input((15-i)*8+7);
	end generate;

	Gen_TK2_2: for i in 8 to 15 generate
		TK2((15-i)*8+7)	<= input((15-i)*8+1) XOR input((15-i)*8+3) XOR input((15-i)*8+5) XOR input((15-i)*8+7);
		TK2((15-i)*8+6)	<= input((15-i)*8+0) XOR input((15-i)*8+2) XOR input((15-i)*8+4) XOR input((15-i)*8+6);
		TK2((15-i)*8+5)	<= input((15-i)*8+1) XOR input((15-i)*8+3) XOR input((15-i)*8+7);
		TK2((15-i)*8+4)	<= input((15-i)*8+0) XOR input((15-i)*8+2) XOR input((15-i)*8+6);
		TK2((15-i)*8+3)	<= input((15-i)*8+1) XOR input((15-i)*8+7);
		TK2((15-i)*8+2)	<= input((15-i)*8+0) XOR input((15-i)*8+6);
		TK2((15-i)*8+1)	<= input((15-i)*8+7);
		TK2((15-i)*8+0)	<= input((15-i)*8+6);
	end generate;
		
	Gen_TK2: for i in 0 to 15 generate
		Output((15-i)*8+7 downto (15-i)*8) <= TK2((15-PT(i))*8+7 downto (15-PT(i))*8);
	end generate;

	--SKINNY-128-256:
	--Order:
	-- 8  9 10 11 12 13 14 15  2  0  4  7  6  3  5  1
	--
	--Number of applying LFSR:
	--23 23 23 23 23 23 23 23 24 24 24 24 24 24 24 24
	--
	--TK2:
	--After applying LFSR 23 times:
	--Bit 7: 0 2 4
	--Bit 6: 1 3 5 7
	--Bit 5: 0 2 4 6
	--Bit 4: 1 3 7
	--Bit 3: 0 2 6
	--Bit 2: 1 7
	--Bit 1: 0 6
	--Bit 0: 7
	
	--TK2:
	--After applying LFSR 24 times:
	--Bit 7: 1 3 5 7
	--Bit 6: 0 2 4 6
	--Bit 5: 1 3 7
	--Bit 4: 0 2 6
	--Bit 3: 1 7
	--Bit 2: 0 6
	--Bit 1: 7
	--Bit 0: 6

end architecture;

--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 


-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY ScanFF IS
	GENERIC (SIZE : INTEGER);
	PORT ( CLK	: IN 	STD_LOGIC;
          SE 	: IN 	STD_LOGIC;
          D  	: IN 	STD_LOGIC_VECTOR((SIZE - 1) DOWNTO 0);
          DS	: IN 	STD_LOGIC_VECTOR((SIZE - 1) DOWNTO 0);
          Q 	: OUT STD_LOGIC_VECTOR((SIZE - 1) DOWNTO 0));
END ScanFF;



-- ARCHITECTURE : STRUCTURAL
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF ScanFF IS

	-- COMPONENTS -----------------------------------------------------------------
	COMPONENT dflipfloplw IS
	PORT ( CLK  : IN  STD_LOGIC;
			 SEL	: IN  STD_LOGIC;
			 D0   : IN  STD_LOGIC;
			 D1   : IN  STD_LOGIC;
			 Q    : OUT STD_LOGIC);
	END COMPONENT;
	-------------------------------------------------------------------------------

BEGIN

	GEN : FOR I IN 0 TO (SIZE - 1) GENERATE
		SFF : dflipfloplw PORT MAP (CLK, SE, D(I), DS(I), Q(I));
	END GENERATE;

END Structural;

--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 



-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY Permutation is
	PORT ( X : IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
          Y : OUT STD_LOGIC_VECTOR (127 DOWNTO 0));
END Permutation;



-- ARCHITECTURE : PARALLEL
----------------------------------------------------------------------------------
ARCHITECTURE Parallel OF Permutation IS


BEGIN

	-- ROW 1 ----------------------------------------------------------------------
	Y((16 * 8 - 1) DOWNTO (15 * 8)) <= X(( 7 * 8 - 1) DOWNTO ( 6 * 8));
	Y((15 * 8 - 1) DOWNTO (14 * 8)) <= X(( 1 * 8 - 1) DOWNTO ( 0 * 8));
	Y((14 * 8 - 1) DOWNTO (13 * 8)) <= X(( 8 * 8 - 1) DOWNTO ( 7 * 8));
	Y((13 * 8 - 1) DOWNTO (12 * 8)) <= X(( 3 * 8 - 1) DOWNTO ( 2 * 8));

	-- ROW 2 ----------------------------------------------------------------------
	Y((12 * 8 - 1) DOWNTO (11 * 8)) <= X(( 6 * 8 - 1) DOWNTO ( 5 * 8));
	Y((11 * 8 - 1) DOWNTO (10 * 8)) <= X(( 2 * 8 - 1) DOWNTO ( 1 * 8));
	Y((10 * 8 - 1) DOWNTO ( 9 * 8)) <= X(( 4 * 8 - 1) DOWNTO ( 3 * 8));
	Y(( 9 * 8 - 1) DOWNTO ( 8 * 8)) <= X(( 5 * 8 - 1) DOWNTO ( 4 * 8));

	-- ROW 3 ----------------------------------------------------------------------
	Y(( 8 * 8 - 1) DOWNTO ( 7 * 8)) <= X((16 * 8 - 1) DOWNTO (15 * 8));
	Y(( 7 * 8 - 1) DOWNTO ( 6 * 8)) <= X((15 * 8 - 1) DOWNTO (14 * 8));
	Y(( 6 * 8 - 1) DOWNTO ( 5 * 8)) <= X((14 * 8 - 1) DOWNTO (13 * 8));
	Y(( 5 * 8 - 1) DOWNTO ( 4 * 8)) <= X((13 * 8 - 1) DOWNTO (12 * 8));

	-- ROW 4 ----------------------------------------------------------------------
	Y(( 4 * 8 - 1) DOWNTO ( 3 * 8)) <= X((12 * 8 - 1) DOWNTO (11 * 8));
	Y(( 3 * 8 - 1) DOWNTO ( 2 * 8)) <= X((11 * 8 - 1) DOWNTO (10 * 8));
	Y(( 2 * 8 - 1) DOWNTO ( 1 * 8)) <= X((10 * 8 - 1) DOWNTO ( 9 * 8));
	Y(( 1 * 8 - 1) DOWNTO ( 0 * 8)) <= X(( 9 * 8 - 1) DOWNTO ( 8 * 8));

END Parallel;


--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 



-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY PermutationInv is
	PORT ( X : IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
          Y : OUT STD_LOGIC_VECTOR (127 DOWNTO 0));
END PermutationInv;



-- ARCHITECTURE : PARALLEL
----------------------------------------------------------------------------------
ARCHITECTURE Parallel OF PermutationInv IS


BEGIN

	-- ROW 1 ----------------------------------------------------------------------
	Y((16 * 8 - 1) DOWNTO (15 * 8)) <= X(( 8 * 8 - 1) DOWNTO ( 7 * 8));
	Y((15 * 8 - 1) DOWNTO (14 * 8)) <= X(( 7 * 8 - 1) DOWNTO ( 6 * 8));
	Y((14 * 8 - 1) DOWNTO (13 * 8)) <= X(( 6 * 8 - 1) DOWNTO ( 5 * 8));
	Y((13 * 8 - 1) DOWNTO (12 * 8)) <= X(( 5 * 8 - 1) DOWNTO ( 4 * 8));

	-- ROW 2 ----------------------------------------------------------------------
	Y((12 * 8 - 1) DOWNTO (11 * 8)) <= X(( 4 * 8 - 1) DOWNTO ( 3 * 8));
	Y((11 * 8 - 1) DOWNTO (10 * 8)) <= X(( 3 * 8 - 1) DOWNTO ( 2 * 8));
	Y((10 * 8 - 1) DOWNTO ( 9 * 8)) <= X(( 2 * 8 - 1) DOWNTO ( 1 * 8));
	Y(( 9 * 8 - 1) DOWNTO ( 8 * 8)) <= X(( 1 * 8 - 1) DOWNTO ( 0 * 8));

	-- ROW 3 ----------------------------------------------------------------------
	Y(( 8 * 8 - 1) DOWNTO ( 7 * 8)) <= X((14 * 8 - 1) DOWNTO (13 * 8));
	Y(( 7 * 8 - 1) DOWNTO ( 6 * 8)) <= X((16 * 8 - 1) DOWNTO (15 * 8));
	Y(( 6 * 8 - 1) DOWNTO ( 5 * 8)) <= X((12 * 8 - 1) DOWNTO (11 * 8));
	Y(( 5 * 8 - 1) DOWNTO ( 4 * 8)) <= X(( 9 * 8 - 1) DOWNTO ( 8 * 8));

	-- ROW 4 ----------------------------------------------------------------------
	Y(( 4 * 8 - 1) DOWNTO ( 3 * 8)) <= X((10 * 8 - 1) DOWNTO ( 9 * 8));
	Y(( 3 * 8 - 1) DOWNTO ( 2 * 8)) <= X((13 * 8 - 1) DOWNTO (12 * 8));
	Y(( 2 * 8 - 1) DOWNTO ( 1 * 8)) <= X((11 * 8 - 1) DOWNTO (10 * 8));
	Y(( 1 * 8 - 1) DOWNTO ( 0 * 8)) <= X((15 * 8 - 1) DOWNTO (14 * 8));
	
END Parallel;	

--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 



-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY KeyExpansion IS
	PORT ( CLK			: IN  STD_LOGIC;
			 -- CONTROL PORTS --------------------------------
          RESET		: IN  STD_LOGIC;
			 DECRYPT		: IN	STD_LOGIC;
			 LAST			: IN	STD_LOGIC;
		    -- KEY PORT -------------------------------------
			 TK1			: IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
			 TK2_1		: IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
			 TK2_2		: IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
			 ROUND_TK1	: OUT STD_LOGIC_VECTOR (127 DOWNTO 0);
			 ROUND_TK2_1: OUT STD_LOGIC_VECTOR (127 DOWNTO 0);
			 ROUND_TK2_2: OUT STD_LOGIC_VECTOR (127 DOWNTO 0));
END KeyExpansion;



-- ARCHITECTURE : ROUND
----------------------------------------------------------------------------------
ARCHITECTURE Round OF KeyExpansion IS

	-- SIGNALS --------------------------------------------------------------------
	SIGNAL KEY_STATE1,   KEY_NEXT1,   KEY_PERM1,   KEY_PERM1_Inv	: STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL KEY_STATE2_1, KEY_NEXT2_1, KEY_PERM2_1, KEY_PERM2_1_Inv	: STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL KEY_STATE2_2, KEY_NEXT2_2, KEY_PERM2_2, KEY_PERM2_2_Inv	: STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL CLK_CE_K, CLK_GATE_K, CLK_K		: STD_LOGIC;

BEGIN

	-- CLOCK GATING ---------------------------------------------------------------
	CLK_CE_K <= '1' WHEN (RESET = '1' OR LAST = '1') ELSE '0';

	GATE : PROCESS(CLK, CLK_CE_K) BEGIN
		IF (NOT(CLK) = '1') THEN
			CLK_GATE_K	<= CLK_CE_K;
		END IF;
	END PROCESS;

	CLK_K <= CLK AND CLK_GATE_K;

	-- REGISTER STAGE -------------------------------------------------------------
	RS1   : ENTITY work.ScanFF GENERIC MAP (SIZE => 128) PORT MAP (CLK_K, RESET, KEY_NEXT1,   TK1,   KEY_STATE1);
	RS2_1 : ENTITY work.ScanFF GENERIC MAP (SIZE => 128) PORT MAP (CLK_K, RESET, KEY_NEXT2_1, TK2_1, KEY_STATE2_1);
	RS2_2 : ENTITY work.ScanFF GENERIC MAP (SIZE => 128) PORT MAP (CLK_K, RESET, KEY_NEXT2_2, TK2_2, KEY_STATE2_2);

	-- TK1: PERMUTATION -----------------------------------------------------------
	P1    : ENTITY work.Permutation    PORT MAP (KEY_STATE1, KEY_PERM1);
	PInv1 : ENTITY work.PermutationInv PORT MAP (KEY_STATE1, KEY_PERM1_Inv);

	-- TK1: NO LFSR ---------------------------------------------------------------
	KEY_NEXT1 <= KEY_PERM1 WHEN (DECRYPT = '0') ELSE KEY_PERM1_Inv;


	-- TK2: PERMUTATION -----------------------------------------------------------
	P2_1    : ENTITY work.Permutation    PORT MAP (KEY_STATE2_1, KEY_PERM2_1);
	P2_2    : ENTITY work.Permutation    PORT MAP (KEY_STATE2_2, KEY_PERM2_2);
	PInv2_1 : ENTITY work.PermutationInv PORT MAP (KEY_STATE2_1, KEY_PERM2_1_Inv);
	PInv2_2 : ENTITY work.PermutationInv PORT MAP (KEY_STATE2_2, KEY_PERM2_2_Inv);

	-- TK2: LFSR ------------------------------------------------------------------
	LFSR2 : FOR I IN 0 TO 3 GENERATE
		KEY_NEXT2_1((8 * I + 103) DOWNTO (8 * I + 96)) <= KEY_PERM2_1_Inv((8 * I + 103) DOWNTO (8 * I + 96)) WHEN (DECRYPT = '1') ELSE KEY_PERM2_1((8 * I + 102) DOWNTO (8 * I + 96)) & (KEY_PERM2_1(8 * I + 103) XOR KEY_PERM2_1(8 * I + 101));
		KEY_NEXT2_1((8 * I +  71) DOWNTO (8 * I + 64)) <= KEY_PERM2_1_Inv((8 * I +  71) DOWNTO (8 * I + 64)) WHEN (DECRYPT = '1') ELSE KEY_PERM2_1((8 * I +  70) DOWNTO (8 * I + 64)) & (KEY_PERM2_1(8 * I +  71) XOR KEY_PERM2_1(8 * I +  69));
		KEY_NEXT2_1((8 * I +  39) DOWNTO (8 * I + 32)) <= KEY_PERM2_1    ((8 * I +  39) DOWNTO (8 * I + 32)) WHEN (DECRYPT = '0') ELSE (KEY_PERM2_1_Inv(8 * I +  38) XOR KEY_PERM2_1_Inv(8 * I + 32)) & KEY_PERM2_1_Inv((8 * I + 39) DOWNTO (8 * I + 33));
		KEY_NEXT2_1((8 * I +   7) DOWNTO (8 * I +  0)) <= KEY_PERM2_1    ((8 * I +   7) DOWNTO (8 * I +  0)) WHEN (DECRYPT = '0') ELSE (KEY_PERM2_1_Inv(8 * I +   6) XOR KEY_PERM2_1_Inv(8 * I +  0)) & KEY_PERM2_1_Inv((8 * I +  7) DOWNTO (8 * I +  1));

		KEY_NEXT2_2((8 * I + 103) DOWNTO (8 * I + 96)) <= KEY_PERM2_2_Inv((8 * I + 103) DOWNTO (8 * I + 96)) WHEN (DECRYPT = '1') ELSE KEY_PERM2_2((8 * I + 102) DOWNTO (8 * I + 96)) & (KEY_PERM2_2(8 * I + 103) XOR KEY_PERM2_2(8 * I + 101));
		KEY_NEXT2_2((8 * I +  71) DOWNTO (8 * I + 64)) <= KEY_PERM2_2_Inv((8 * I +  71) DOWNTO (8 * I + 64)) WHEN (DECRYPT = '1') ELSE KEY_PERM2_2((8 * I +  70) DOWNTO (8 * I + 64)) & (KEY_PERM2_2(8 * I +  71) XOR KEY_PERM2_2(8 * I +  69));
		KEY_NEXT2_2((8 * I +  39) DOWNTO (8 * I + 32)) <= KEY_PERM2_2    ((8 * I +  39) DOWNTO (8 * I + 32)) WHEN (DECRYPT = '0') ELSE (KEY_PERM2_2_Inv(8 * I +  38) XOR KEY_PERM2_2_Inv(8 * I + 32)) & KEY_PERM2_2_Inv((8 * I + 39) DOWNTO (8 * I + 33));
		KEY_NEXT2_2((8 * I +   7) DOWNTO (8 * I +  0)) <= KEY_PERM2_2    ((8 * I +   7) DOWNTO (8 * I +  0)) WHEN (DECRYPT = '0') ELSE (KEY_PERM2_2_Inv(8 * I +   6) XOR KEY_PERM2_2_Inv(8 * I +  0)) & KEY_PERM2_2_Inv((8 * I +  7) DOWNTO (8 * I +  1));
	END GENERATE;

	-- KEY OUTPUT -----------------------------------------------------------------
	ROUND_TK1 	<= KEY_STATE1;
	ROUND_TK2_1 <= KEY_STATE2_1;
	ROUND_TK2_2 <= KEY_STATE2_2;
	
END Round;

--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LFSR is
	port(
		clk		: in  std_logic;
		rst		: in  std_logic;
		en	   	: in  std_logic;
		Output	: out std_logic_vector(23 downto 0));
end entity LFSR;


architecture dfl of LFSR is

	signal Update	: std_logic_vector(23 downto 0);
	signal Reg   	: std_logic_vector(23 downto 0);
	
begin

	Update <= Reg(22 downto 4) & (Reg(3) XOR Reg(23)) & (Reg(2) XOR Reg(23)) & Reg(1) & (Reg(0) XOR Reg(23)) & Reg(23);

	GenReg:	Process(clk, en)
	begin
		if (clk'event AND clk = '1') then
			if (rst = '1') then
				Reg	<= x"000001";
			elsif (en = '1') then
				Reg	<= Update;
			end if;	
		end if;
	end process;

	Output	<= Reg;
	

end architecture;

--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Padding is
   generic (withConstant : integer);
	port(
		Input	  		: in  std_logic_vector(127 downto 0);
		Block_Size	: in  std_logic_vector(  3 downto 0);
		Output		: out std_logic_vector(127 downto 0));
end entity Padding;


architecture dfl of Padding is

	signal size	: unsigned(3 downto 0);

	constant v0	 : unsigned(3 downto 0) := "0000";
	constant v1	 : unsigned(3 downto 0) := "0001";
	constant v2	 : unsigned(3 downto 0) := "0010";
	constant v3	 : unsigned(3 downto 0) := "0011";
	constant v4	 : unsigned(3 downto 0) := "0100";
	constant v5	 : unsigned(3 downto 0) := "0101";
	constant v6	 : unsigned(3 downto 0) := "0110";
	constant v7	 : unsigned(3 downto 0) := "0111";
	constant v8	 : unsigned(3 downto 0) := "1000";
	constant v9	 : unsigned(3 downto 0) := "1001";
	constant v10 : unsigned(3 downto 0) := "1010";
	constant v11 : unsigned(3 downto 0) := "1011";
	constant v12 : unsigned(3 downto 0) := "1100";
	constant v13 : unsigned(3 downto 0) := "1101";
	constant v14 : unsigned(3 downto 0) := "1110";
	constant v15 : unsigned(3 downto 0) := "1111";
	
	
	signal 	C80 : std_logic_vector(7 downto 0);

	
begin

	GEN0: IF withConstant = 0 GENERATE
		C80 <= x"00";
	END GENERATE;	

	GEN1: IF withConstant /= 0 GENERATE
		C80 <= x"80";
	END GENERATE;
	
	size	<= unsigned(Block_Size);

	Output(16*8-1 downto 15*8)	<= Input(16*8-1 downto 15*8);
	Output(15*8-1 downto 14*8)	<= Input(15*8-1 downto 14*8) when size > v0  else C80;
	Output(14*8-1 downto 13*8)	<= Input(14*8-1 downto 13*8) when size > v1  else C80 when size = v1  else x"00";
	Output(13*8-1 downto 12*8)	<= Input(13*8-1 downto 12*8) when size > v2  else C80 when size = v2  else x"00";
	Output(12*8-1 downto 11*8)	<= Input(12*8-1 downto 11*8) when size > v3  else C80 when size = v3  else x"00";
	Output(11*8-1 downto 10*8)	<= Input(11*8-1 downto 10*8) when size > v4  else C80 when size = v4  else x"00";
	Output(10*8-1 downto  9*8)	<= Input(10*8-1 downto  9*8) when size > v5  else C80 when size = v5  else x"00";
	Output( 9*8-1 downto  8*8)	<= Input( 9*8-1 downto  8*8) when size > v6  else C80 when size = v6  else x"00";
	Output( 8*8-1 downto  7*8)	<= Input( 8*8-1 downto  7*8) when size > v7  else C80 when size = v7  else x"00";
	Output( 7*8-1 downto  6*8)	<= Input( 7*8-1 downto  6*8) when size > v8  else C80 when size = v8  else x"00";
	Output( 6*8-1 downto  5*8)	<= Input( 6*8-1 downto  5*8) when size > v9  else C80 when size = v9  else x"00";
	Output( 5*8-1 downto  4*8)	<= Input( 5*8-1 downto  4*8) when size > v10 else C80 when size = v10 else x"00";
	Output( 4*8-1 downto  3*8)	<= Input( 4*8-1 downto  3*8) when size > v11 else C80 when size = v11 else x"00";
	Output( 3*8-1 downto  2*8)	<= Input( 3*8-1 downto  2*8) when size > v12 else C80 when size = v12 else x"00";
	Output( 2*8-1 downto  1*8)	<= Input( 2*8-1 downto  1*8) when size > v13 else C80 when size = v13 else x"00";
	Output( 1*8-1 downto  0*8)	<= Input( 1*8-1 downto  0*8) when size > v14 else C80 when size = v14 else x"00";

end architecture;


--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg_en_clr is
	generic (size: integer);
	port(
		clk		: in  std_logic;
		rst		: in  std_logic;
		en	   	: in  std_logic;
		Input		: in  std_logic_vector(size-1 downto 0);
		Output	: out std_logic_vector(size-1 downto 0));
end entity Reg_en_clr;


architecture dfl of Reg_en_clr is
begin

	GenReg:	Process(clk, en, rst, Input)
	begin
		if (clk'event AND clk = '1') then
			if (rst = '1') then
				Output	<= (others => '0');
			elsif (en = '1') then
				Output	<= Input;
			end if;	
		end if;
	end process;

end architecture;


--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MainPart is
Generic (
	tl				 : integer := 0; -- 0: 128-bit tag,   1: 64-bit tag
	withConstant : integer);
Port (  
	clk          : in  std_logic;
	a_data		 : in  std_logic;
	dec			 : in  std_logic;
	gen_tag		 : in  std_logic;
	Block_Size	 : in  std_logic_vector(  3 downto 0);
	full_size	 : in  std_logic;
	Auth_Reg_rst : in  std_logic;
	Auth_Reg_en  : in  std_logic;
	Tag_Reg_rst  : in  std_logic;
	Tag_Reg_en   : in  std_logic;
	Input			 : in  std_logic_vector(127 downto 0);
	Cipher_Input : out std_logic_vector(127 downto 0);
	Cipher_Output: in  std_logic_vector(127 downto 0);
	Output		 : out std_logic_vector(127 downto 0);
	Tag			 : out STD_LOGIC_VECTOR (127-tl*64 downto 0));
end MainPart;

architecture dfl of MainPart is

	signal Auth_Reg_Input		: STD_LOGIC_VECTOR(127 downto 0);
	signal Auth_Reg_Output		: STD_LOGIC_VECTOR(127 downto 0);
	
	signal Tag_Reg_Input			: STD_LOGIC_VECTOR(127 downto 0);
	signal Tag_Reg_Output		: STD_LOGIC_VECTOR(127 downto 0);
	
	signal Input_for_Padding	: STD_LOGIC_VECTOR(127 downto 0);
	signal Input_Padded			: STD_LOGIC_VECTOR(127 downto 0);
	signal Input_FullSize		: STD_LOGIC_VECTOR(127 downto 0);
	signal Input_NotFullSize	: STD_LOGIC_VECTOR(127 downto 0);

	signal Cipher_Output_Final	: STD_LOGIC_VECTOR(127 downto 0);

begin
		
	PaddingInst: entity work.Padding
	Generic Map (withConstant)
	Port Map ( 
		Input_for_Padding,
		Block_Size,
		Input_Padded);

	AuthRegInst: entity work.Reg_en_clr
	Generic Map (128)
	Port Map (
		clk,
		Auth_Reg_rst,
		Auth_Reg_en,
		Auth_Reg_Input,
		Auth_Reg_Output);

	TagRegInst: entity work.Reg_en_clr
	Generic Map (128)
	Port Map (
		clk,
		Tag_Reg_rst,
		Tag_Reg_en,
		Tag_Reg_Input,
		Tag_Reg_Output);

	Input_FullSize				<= Input when full_size = '1' else (others => '0');
	Input_NotFullSize			<= Input when full_size = '0' else (others => '0');
	
	Input_for_Padding			<= Cipher_Output_Final when dec = '1' else Input;
	
	Cipher_Input				<= Input_Padded when a_data = '1' else Tag_Reg_Output when gen_tag = '1' else Input_FullSize;
	
	Tag_Reg_Input				<=	Input_Padded XOR Tag_Reg_Output;
	
	Auth_Reg_Input				<= Cipher_Output XOR Auth_Reg_Output;
	
	Cipher_Output_Final		<= Input_NotFullSize XOR Cipher_Output;
	
	Output						<= Cipher_Output_Final;
	
	Gen_Tag128: IF tl = 0 GENERATE -- 128-bit
		Tag						<= Auth_Reg_Input;
	END GENERATE;	

	Gen_Tag64: IF tl = 1 GENERATE -- 64-bit
		Tag						<= Auth_Reg_Input(127 downto 64);
	END GENERATE;	
	
end dfl;


--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 



-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY MixColumns is
	PORT ( X : IN	STD_LOGIC_VECTOR (127 DOWNTO 0);
          Y : OUT	STD_LOGIC_VECTOR (127 DOWNTO 0));
END MixColumns;



-- ARCHITECTURE : PARALLEL
----------------------------------------------------------------------------------
ARCHITECTURE Parallel of MixColumns is


	-- SIGNALS --------------------------------------------------------------------
	SIGNAL C1_X2X0, C2_X2X0, C3_X2X0, C4_X2X0	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL C1_X2X1, C2_X2X1, C3_X2X1, C4_X2X1	: STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

	-- X2 XOR X1 (ENCRYPT) --------------------------------------------------------
	C1_X2X1 <= X(95 DOWNTO 88) XOR X(63 DOWNTO 56);
	C2_X2X1 <= X(87 DOWNTO 80) XOR X(55 DOWNTO 48);
	C3_X2X1 <= X(79 DOWNTO 72) XOR X(47 DOWNTO 40);
	C4_X2X1 <= X(71 DOWNTO 64) XOR X(39 DOWNTO 32);
	-------------------------------------------------------------------------------

	-- X2 XOR X0 (ENCRYPT) --------------------------------------------------------
	C1_X2X0 <= X(127 DOWNTO 120) XOR X(63 DOWNTO 56);
	C2_X2X0 <= X(119 DOWNTO 112) XOR X(55 DOWNTO 48);
	C3_X2X0 <= X(111 DOWNTO 104) XOR X(47 DOWNTO 40);
	C4_X2X0 <= X(103 DOWNTO  96) XOR X(39 DOWNTO 32);
	-------------------------------------------------------------------------------

	-- COLUMN 1 -------------------------------------------------------------------
	Y(127 DOWNTO 120) <= C1_X2X0 XOR X(31 DOWNTO 24);
	Y( 95 DOWNTO  88) <= X(127 DOWNTO 120);
	Y( 63 DOWNTO  56) <= C1_X2X1;
	Y( 31 DOWNTO  24) <= C1_X2X0;
	-------------------------------------------------------------------------------

	-- COLUMN 2 -------------------------------------------------------------------
	Y(119 DOWNTO 112) <= C2_X2X0 XOR X(23 DOWNTO 16);
	Y( 87 DOWNTO  80) <= X(119 DOWNTO 112);
	Y( 55 DOWNTO  48) <= C2_X2X1;
	Y( 23 DOWNTO  16) <= C2_X2X0;
	-------------------------------------------------------------------------------

	-- COLUMN 3 -------------------------------------------------------------------
	Y(111 DOWNTO 104) <= C3_X2X0 XOR X(15 DOWNTO 8);
	Y( 79 DOWNTO  72) <= X(111 DOWNTO 104);
	Y( 47 DOWNTO  40) <= C3_X2X1;
	Y( 15 DOWNTO   8) <= C3_X2X0;
	-------------------------------------------------------------------------------

	-- COLUMN 4 -------------------------------------------------------------------
	Y(103 DOWNTO 96) <= C4_X2X0 XOR X(7 DOWNTO 0);
	Y( 71 DOWNTO 64) <= X(103 DOWNTO 96);
	Y( 39 DOWNTO 32) <= C4_X2X1;
	Y(  7 DOWNTO  0) <= C4_X2X0;
	-------------------------------------------------------------------------------

END Parallel;

--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 



-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY MixColumnsInv is
	PORT ( X : IN	STD_LOGIC_VECTOR (127 DOWNTO 0);
          Y : OUT	STD_LOGIC_VECTOR (127 DOWNTO 0));
END MixColumnsInv;



-- ARCHITECTURE : PARALLEL
----------------------------------------------------------------------------------
ARCHITECTURE Parallel of MixColumnsInv is


	-- SIGNALS --------------------------------------------------------------------
	SIGNAL C1_X3X0, C2_X3X0, C3_X3X0, C4_X3X0	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL C1_X3X1, C2_X3X1, C3_X3X1, C4_X3X1	: STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

	-- X3 XOR X1 (DECRYPT) --------------------------------------------------------
	C1_X3X1 <= X(95 DOWNTO 88) XOR X(31 DOWNTO 24);
	C2_X3X1 <= X(87 DOWNTO 80) XOR X(23 DOWNTO 16);
	C3_X3X1 <= X(79 DOWNTO 72) XOR X(15 DOWNTO  8);
	C4_X3X1 <= X(71 DOWNTO 64) XOR X( 7 DOWNTO  0);
	-------------------------------------------------------------------------------

	-- X3 XOR X0 (ENCRYPT) --------------------------------------------------------
	C1_X3X0 <= X(127 DOWNTO 120) XOR X(31 DOWNTO 24);
	C2_X3X0 <= X(119 DOWNTO 112) XOR X(23 DOWNTO 16);
	C3_X3X0 <= X(111 DOWNTO 104) XOR X(15 DOWNTO  8);
	C4_X3X0 <= X(103 DOWNTO  96) XOR X( 7 DOWNTO  0);
	-------------------------------------------------------------------------------

	-- COLUMN 1 -------------------------------------------------------------------
	Y(127 DOWNTO 120) <= X(95 DOWNTO 88);
	Y( 95 DOWNTO  88) <= C1_X3X1 XOR X(63 DOWNTO 56);
	Y( 63 DOWNTO  56) <= C1_X3X1;
	Y( 31 DOWNTO  24) <= C1_X3X0;
	-------------------------------------------------------------------------------

	-- COLUMN 2 -------------------------------------------------------------------
	Y(119 DOWNTO 112) <= X(87 DOWNTO 80);
	Y( 87 DOWNTO  80) <= C2_X3X1 XOR X(55 DOWNTO 48);
	Y( 55 DOWNTO  48) <= C2_X3X1;
	Y( 23 DOWNTO  16) <= C2_X3X0;
	-------------------------------------------------------------------------------

	-- COLUMN 3 -------------------------------------------------------------------
	Y(111 DOWNTO 104) <= X(79 DOWNTO 72);
	Y( 79 DOWNTO  72) <= C3_X3X1 XOR X(47 DOWNTO 40);
	Y( 47 DOWNTO  40) <= C3_X3X1;
	Y( 15 DOWNTO   8) <= C3_X3X0;
	-------------------------------------------------------------------------------

	-- COLUMN 4 -------------------------------------------------------------------
	Y(103 DOWNTO 96) <= X(71 DOWNTO 64);
	Y( 71 DOWNTO 64) <= C4_X3X1 XOR X(39 DOWNTO 32);
	Y( 39 DOWNTO 32) <= C4_X3X1;
	Y(  7 DOWNTO  0) <= C4_X3X0;
	-------------------------------------------------------------------------------

END Parallel;

--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg_clr is
	generic (size: integer);
	port(
		clk		: in  std_logic;
		rst		: in  std_logic;
		Input		: in  std_logic_vector(size-1 downto 0);
		Output	: out std_logic_vector(size-1 downto 0));
end entity Reg_clr;


architecture dfl of Reg_clr is
begin

	GenReg:	Process(clk, rst, Input)
	begin
		if (clk'event AND clk = '1') then
			if (rst = '1') then
				Output	<= (others => '0');
			else
				Output	<= Input;
			end if;	
		end if;
	end process;

end architecture;

--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SboxFGHI_dp1 is
    Port ( x1 : in  STD_LOGIC_VECTOR (7 downto 0);
			  x2 : in  STD_LOGIC_VECTOR (7 downto 0);
           y1 : out STD_LOGIC_VECTOR (7 downto 0);
           y2 : out STD_LOGIC_VECTOR (7 downto 0);
           y3 : out STD_LOGIC_VECTOR (1 downto 0);
           y4 : out STD_LOGIC_VECTOR (1 downto 0));
end SboxFGHI_dp1;

architecture Behavioral of SboxFGHI_dp1 is

	component CompFGHI1 is -- x XOR (w NOR u)
    Port ( x : in  STD_LOGIC;
			  w : in  STD_LOGIC;
			  u : in  STD_LOGIC;
           z : out STD_LOGIC);
	end component;	

	component CompFGHI2 is -- x XNOR (w NAND u)
    Port ( x : in  STD_LOGIC;
			  w : in  STD_LOGIC;
			  u : in  STD_LOGIC;
           z : out STD_LOGIC);
	end component;	

	component CompFGHIp1 is -- (x NOR (NOT w))
    Port ( x : in  STD_LOGIC;
			  w : in  STD_LOGIC;
           z : out STD_LOGIC);
	end component;	

	signal yy1 : STD_LOGIC_VECTOR(7 downto 0);
	signal yy2 : STD_LOGIC_VECTOR(7 downto 0);
	
begin

	c_f1: CompFGHI1
	port map(x1(0), x1(2), x1(3), yy1(0)); -- x1(0) XOR  (x1(2)  NOR x1(3)) 
	
	c_fp1: CompFGHIp1
	port map(x1(2), x2(3), y3(0)); -- (x1(2) NOR (not x2(3))
		
	yy1(1) <= x1(1);
	yy1(2) <= x1(2);
	yy1(3) <= x1(3);

	c_f3: CompFGHI1
	port map(x1(4), x1(6), x1(7), yy1(4)); --	x1(4) XOR  (x1(6)  NOR x1(7))
	
	c_fp3: CompFGHIp1
	port map(x1(6), x2(7), y3(1)); -- (x1(6) NOR (not x2(7))

	yy1(5) <= x1(5);
	yy1(6) <= x1(6);
	yy1(7) <= x1(7);

	------------------------------------

	c_f2: CompFGHI2
	port map(x2(0), x2(2), x2(3), yy2(0)); -- x2(0) XNOR (x2(2) NAND x2(3)) 
	
	c_fp2: CompFGHIp1
	port map(x1(3), x2(2), y4(0)); -- (x1(3) NOR (not x2(2))
	
	yy2(1) <= x2(1);
	yy2(2) <= x2(2);
	yy2(3) <= x2(3);

	c_f4: CompFGHI2
	port map(x2(4), x2(6), x2(7), yy2(4)); -- x2(4) XNOR (x2(6) NAND x2(7))

	c_fp34: CompFGHIp1
	port map(x1(7), x2(6), y4(1)); -- (x1(7) NOR (not x2(6))
	
	yy2(5) <= x2(5);
	yy2(6) <= x2(6);
	yy2(7) <= x2(7);
	
	------------------------------------

	y1(2) <= yy1(0);
	y1(6) <= yy1(1);
	y1(7) <= yy1(2);
	y1(1) <= yy1(3);
	y1(3) <= yy1(4);
	y1(0) <= yy1(5);
	y1(4) <= yy1(6);
	y1(5) <= yy1(7);

	y2(2) <= yy2(0);
	y2(6) <= yy2(1);
	y2(7) <= yy2(2);
	y2(1) <= yy2(3);
	y2(3) <= yy2(4);
	y2(0) <= yy2(5);
	y2(4) <= yy2(6);
	y2(5) <= yy2(7);
	
end Behavioral;




--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 



-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY ShiftRows IS
	PORT ( X : IN	STD_LOGIC_VECTOR (127 DOWNTO 0);
          Y : OUT	STD_LOGIC_VECTOR (127 DOWNTO 0));
END ShiftRows;



-- ARCHITECTURE : PARALLEL
----------------------------------------------------------------------------------
ARCHITECTURE Parallel OF ShiftRows IS

BEGIN

	-- ROW 1 ----------------------------------------------------------------------
	Y(127 DOWNTO 96) <= X(127 DOWNTO 96);

	-- ROW 2 ----------------------------------------------------------------------
	Y( 95 DOWNTO 64) <= X(71 DOWNTO 64) & X(95 DOWNTO 72);

	-- ROW 3 ----------------------------------------------------------------------
	Y( 63 DOWNTO 32) <= X(47 DOWNTO 32) & X(63 DOWNTO 48);

	-- ROW 4 ----------------------------------------------------------------------
	Y( 31 DOWNTO  0) <= X(23 DOWNTO 0) & X(31 DOWNTO 24);

END Parallel;


--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 



-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY ShiftRowsInv IS
	PORT ( X : IN	STD_LOGIC_VECTOR (127 DOWNTO 0);
          Y : OUT	STD_LOGIC_VECTOR (127 DOWNTO 0));
END ShiftRowsInv;



-- ARCHITECTURE : PARALLEL
----------------------------------------------------------------------------------
ARCHITECTURE Parallel OF ShiftRowsInv IS

BEGIN

	-- ROW 1 ----------------------------------------------------------------------
	Y(127 DOWNTO 96) <= X(127 DOWNTO 96);

	-- ROW 2 ----------------------------------------------------------------------
	Y( 95 DOWNTO 64) <= X(87 DOWNTO 64) & X(95 DOWNTO 88);

	-- ROW 3 ----------------------------------------------------------------------
	Y( 63 DOWNTO 32) <= X(47 DOWNTO 32) & X(63 DOWNTO 48);

	-- ROW 4 ----------------------------------------------------------------------
	Y( 31 DOWNTO  0) <= X(7 DOWNTO 0) & X(31 DOWNTO 8);

END Parallel;


--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SboxFGHI_Inv_dp1 is
    Port ( x1 : in  STD_LOGIC_VECTOR (7 downto 0);
			  x2 : in  STD_LOGIC_VECTOR (7 downto 0);
           y1 : out STD_LOGIC_VECTOR (7 downto 0);
           y2 : out STD_LOGIC_VECTOR (7 downto 0);
           y3 : out STD_LOGIC_VECTOR (1 downto 0);
           y4 : out STD_LOGIC_VECTOR (1 downto 0));
end SboxFGHI_Inv_dp1;

architecture Behavioral of SboxFGHI_Inv_dp1 is

	component CompFGHI1 is -- x XOR (w NOR u)
    Port ( x : in  STD_LOGIC;
			  w : in  STD_LOGIC;
			  u : in  STD_LOGIC;
           z : out STD_LOGIC);
	end component;	

	component CompFGHI2 is -- x XNOR (w NAND u)
    Port ( x : in  STD_LOGIC;
			  w : in  STD_LOGIC;
			  u : in  STD_LOGIC;
           z : out STD_LOGIC);
	end component;	

	component CompFGHIp1 is -- (x NOR (NOT w))
    Port ( x : in  STD_LOGIC;
			  w : in  STD_LOGIC;
           z : out STD_LOGIC);
	end component;	

	signal xx1 : STD_LOGIC_VECTOR(7 downto 0);
	signal xx2 : STD_LOGIC_VECTOR(7 downto 0);

	signal yy1 : STD_LOGIC_VECTOR(7 downto 0);
	signal yy2 : STD_LOGIC_VECTOR(7 downto 0);

begin

	xx1(0) <= x1(0);
	xx1(1) <= x1(2);
	xx1(2) <= x1(1);
	xx1(3) <= x1(3);
	xx1(4) <= x1(4);
	xx1(5) <= x1(5);
	xx1(6) <= x1(6);
	xx1(7) <= x1(7);

	xx2(0) <= x2(0);
	xx2(1) <= x2(2);
	xx2(2) <= x2(1);
	xx2(3) <= x2(3);
	xx2(4) <= x2(4);
	xx2(5) <= x2(5);
	xx2(6) <= x2(6);
	xx2(7) <= x2(7);

	c_f1: CompFGHI1
	port map(xx1(0), xx1(2), xx1(3), yy1(0)); -- x1(0) XOR  (x1(2)  NOR x1(3)) 
	
	c_fp1: CompFGHIp1
	port map(xx1(2), xx2(3), y3(0)); -- (x1(2) NOR (not x2(3))
		
	yy1(1) <= xx1(1);
	yy1(2) <= xx1(2);
	yy1(3) <= xx1(3);

	c_f3: CompFGHI1
	port map(xx1(4), xx1(6), xx1(7), yy1(4)); --	x1(4) XOR  (x1(6)  NOR x1(7))
	
	c_fp3: CompFGHIp1
	port map(xx1(6), xx2(7), y3(1)); -- (x1(6) NOR (not x2(7))

	yy1(5) <= xx1(5);
	yy1(6) <= xx1(6);
	yy1(7) <= xx1(7);

	------------------------------------

	c_f2: CompFGHI2
	port map(xx2(0), xx2(2), xx2(3), yy2(0)); -- x2(0) XNOR (x2(2) NAND x2(3)) 
	
	c_fp2: CompFGHIp1
	port map(xx1(3), xx2(2), y4(0)); -- (x1(3) NOR (not x2(2))
	
	yy2(1) <= xx2(1);
	yy2(2) <= xx2(2);
	yy2(3) <= xx2(3);

	c_f4: CompFGHI2
	port map(xx2(4), xx2(6), xx2(7), yy2(4)); -- x2(4) XNOR (x2(6) NAND x2(7))

	c_fp34: CompFGHIp1
	port map(xx1(7), xx2(6), y4(1)); -- (x1(7) NOR (not x2(6))
	
	yy2(5) <= xx2(5);
	yy2(6) <= xx2(6);
	yy2(7) <= xx2(7);
	
	------------------------------------

	y1(5) <= yy1(0);
	y1(3) <= yy1(1);
	y1(0) <= yy1(2);
	y1(4) <= yy1(3);
	y1(6) <= yy1(4);
	y1(7) <= yy1(5);
	y1(2) <= yy1(6);
	y1(1) <= yy1(7);

	y2(5) <= yy2(0);
	y2(3) <= yy2(1);
	y2(0) <= yy2(2);
	y2(4) <= yy2(3);
	y2(6) <= yy2(4);
	y2(7) <= yy2(5);
	y2(2) <= yy2(6);
	y2(1) <= yy2(7);
	
end Behavioral;



--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 



-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY RoundFunction IS
   PORT ( CLK        : IN  STD_LOGIC;
   		 -- CONTROL PORTS --------------------------------
          RESET      : IN  STD_LOGIC;
			 DECRYPT		: IN	STD_LOGIC;
			 FIRST		: IN	STD_LOGIC;
			 LAST			: IN	STD_LOGIC;
   	    -- CONSTANT PORT --------------------------------
          ROUND_CST  : IN  STD_LOGIC_VECTOR (  5 DOWNTO 0);
   	    -- KEY PORT -------------------------------------
          ROUND_TK1  : IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
          ROUND_TK2_1: IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
          ROUND_TK2_2: IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
   	    -- DATA PORTS -----------------------------------
          SHARE1_IN  : IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
          SHARE2_IN  : IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
          SHARE1_OUT : OUT STD_LOGIC_VECTOR (127 DOWNTO 0);
          SHARE2_OUT : OUT STD_LOGIC_VECTOR (127 DOWNTO 0));
END RoundFunction;



-- ARCHITECTURE : ROUND
----------------------------------------------------------------------------------
ARCHITECTURE Round OF RoundFunction IS

	-- SIGNALS --------------------------------------------------------------------
	SIGNAL STATE1, STATE1_NEXT, SUB1_OUT, ADD1_OUT, SHIFT1_OUT, MIX1_OUT, S_MID_A1, S_MID_C1	: STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL STATE2, STATE2_NEXT, SUB2_OUT, ADD2_OUT, SHIFT2_OUT, MIX2_OUT, S_MID_A2, S_MID_C2	: STD_LOGIC_VECTOR(127 DOWNTO 0);

	SIGNAL S_MID_B1, S_MID_F1, STATE_EX1, STATE_EX1_NEXT	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL S_MID_B2, S_MID_F2, STATE_EX2, STATE_EX2_NEXT	: STD_LOGIC_VECTOR(31 DOWNTO 0);

	SIGNAL MIXInv1_OUT, SHIFTInv1_OUT, ADDInv1_OUT : STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL MIXInv2_OUT, SHIFTInv2_OUT, ADDInv2_OUT : STD_LOGIC_VECTOR(127 DOWNTO 0);

	SIGNAL S_MID_D1, S_MID_E1, SUB_Inv1_IN, SUB_Inv1_OUT : STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL S_MID_D2, S_MID_E2, SUB_Inv2_IN, SUB_Inv2_OUT : STD_LOGIC_VECTOR(127 DOWNTO 0);

	SIGNAL RESET_OR_LAST			: STD_LOGIC;

BEGIN

	-- REGISTER STAGE -------------------------------------------------------------
	RS1 : ENTITY work.ScanFF GENERIC MAP (SIZE => 128) PORT MAP (CLK, RESET, STATE1_NEXT, SHARE1_IN, STATE1);
	RS2 : ENTITY work.ScanFF GENERIC MAP (SIZE => 128) PORT MAP (CLK, RESET, STATE2_NEXT, SHARE2_IN, STATE2);

	RESET_OR_LAST 	 <= RESET OR LAST;

	STATE_EX1_NEXT  <= S_MID_B1 WHEN DECRYPT = '0' ELSE S_MID_F1;
	STATE_EX2_NEXT  <= S_MID_B2 WHEN DECRYPT = '0' ELSE S_MID_F2;

	RS_EX1 : ENTITY work.Reg_clr GENERIC MAP (SIZE => 32) PORT MAP (CLK, RESET_OR_LAST, STATE_EX1_NEXT, STATE_EX1);
	RS_EX2 : ENTITY work.Reg_clr GENERIC MAP (SIZE => 32) PORT MAP (CLK, RESET_OR_LAST, STATE_EX2_NEXT, STATE_EX2);

	-- ENCRYPTION -----------------------------------------------------------------

	-- SUBSTITUTION ---------------------------------------------------------------
	SB : FOR I IN 0 TO 15 GENERATE
		S_Com: entity work.FGHI_Combine
		port map(
			STATE1    ((8 * I + 7) DOWNTO (8 * I)), 
			STATE2    ((8 * I + 7) DOWNTO (8 * I)),
			STATE_EX1 ((2 * I + 1) DOWNTO (2 * I)),
			STATE_EX2 ((2 * I + 1) DOWNTO (2 * I)),
			S_MID_A1  ((8 * I + 7) DOWNTO (8 * I)),
			S_MID_A2  ((8 * I + 7) DOWNTO (8 * I)),
			SUB1_OUT  ((8 * I + 7) DOWNTO (8 * I)),
			SUB2_OUT  ((8 * I + 7) DOWNTO (8 * I)));

		S_TI: entity work.SboxFGHI_dp1
		port map(
			S_MID_A1  ((8 * I + 7) DOWNTO (8 * I)),
			S_MID_A2  ((8 * I + 7) DOWNTO (8 * I)),
			S_MID_C1  ((8 * I + 7) DOWNTO (8 * I)),
			S_MID_C2  ((8 * I + 7) DOWNTO (8 * I)),
			S_MID_B1  ((2 * I + 1) DOWNTO (2 * I)),
			S_MID_B2  ((2 * I + 1) DOWNTO (2 * I)));	
	END GENERATE;
	

	-- CONSTANT AND KEY ADDITION --------------------------------------------------
	KA1 : ENTITY work.AddConstKey Generic Map (1) PORT MAP (ROUND_CST,       ROUND_TK1,       ROUND_TK2_1, SUB1_OUT, ADD1_OUT);
	KA2 : ENTITY work.AddConstKey Generic Map (0) PORT MAP ((others => '0'), (others => '0'), ROUND_TK2_2, SUB2_OUT, ADD2_OUT);

	-- SHIFT ROWS -----------------------------------------------------------------
	SR1 : ENTITY work.ShiftRows PORT MAP (ADD1_OUT, SHIFT1_OUT);
	SR2 : ENTITY work.ShiftRows PORT MAP (ADD2_OUT, SHIFT2_OUT);

	-- MIX COLUMNS ----------------------------------------------------------------
	MC1 : ENTITY work.MixColumns PORT MAP (SHIFT1_OUT, MIX1_OUT);
	MC2 : ENTITY work.MixColumns PORT MAP (SHIFT2_OUT, MIX2_OUT);

	-------------------------------------------------------------------------------

	-- DECRYPTION -----------------------------------------------------------------
	-------------------------------------------------------------------------------

	-- MIX COLUMNS Inv ------------------------------------------------------------
	MCInv1 : ENTITY work.MixColumnsInv PORT MAP (STATE1, MIXInv1_OUT);
	MCInv2 : ENTITY work.MixColumnsInv PORT MAP (STATE2, MIXInv2_OUT);

	-- SHIFT ROWS Inv -------------------------------------------------------------
	SRInv1 : ENTITY work.ShiftRowsInv PORT MAP (MIXInv1_OUT, SHIFTInv1_OUT);
	SRInv2 : ENTITY work.ShiftRowsInv PORT MAP (MIXInv2_OUT, SHIFTInv2_OUT);

	-- CONSTANT AND KEY ADDITION Inv ----------------------------------------------
	KAInv1 : ENTITY work.AddConstKey Generic Map (1) PORT MAP (ROUND_CST,       ROUND_TK1,       ROUND_TK2_1, SHIFTInv1_OUT, ADDInv1_OUT);
	KAInv2 : ENTITY work.AddConstKey Generic Map (0) PORT MAP ((others => '0'), (others => '0'), ROUND_TK2_2, SHIFTInv2_OUT, ADDInv2_OUT);

	SUB_Inv1_IN <= ADDInv1_OUT WHEN FIRST = '1' ELSE S_MID_D1;
	SUB_Inv2_IN <= ADDInv2_OUT WHEN FIRST = '1' ELSE S_MID_D2;
	

	-- SUBSTITUTION ---------------------------------------------------------------
	SBInv : FOR I IN 0 TO 15 GENERATE
		S_Com: entity work.FGHI_Inv_Combine
		port map(
			STATE1    ((8 * I + 7) DOWNTO (8 * I)), 
			STATE2    ((8 * I + 7) DOWNTO (8 * I)),
			STATE_EX1 ((2 * I + 1) DOWNTO (2 * I)),
			STATE_EX2 ((2 * I + 1) DOWNTO (2 * I)),
			S_MID_D1  ((8 * I + 7) DOWNTO (8 * I)),
			S_MID_D2  ((8 * I + 7) DOWNTO (8 * I)),
			S_MID_E1  ((8 * I + 7) DOWNTO (8 * I)),
			S_MID_E2  ((8 * I + 7) DOWNTO (8 * I)));

		S_TI: entity work.SboxFGHI_Inv_dp1
		port map(
			SUB_Inv1_IN  ((8 * I + 7) DOWNTO (8 * I)),
			SUB_Inv2_IN  ((8 * I + 7) DOWNTO (8 * I)),
			SUB_Inv1_OUT ((8 * I + 7) DOWNTO (8 * I)),
			SUB_Inv2_OUT ((8 * I + 7) DOWNTO (8 * I)),
			S_MID_F1     ((2 * I + 1) DOWNTO (2 * I)),
			S_MID_F2     ((2 * I + 1) DOWNTO (2 * I)));	
	END GENERATE;

	-------------------------------------------------------------------------------
	-------------------------------------------------------------------------------

	-- ROUND OUTPUT ---------------------------------------------------------------
	STATE1_NEXT <= MIX1_OUT WHEN (DECRYPT = '0' AND LAST = '1') ELSE S_MID_C1 WHEN (DECRYPT = '0') ELSE S_MID_E1 WHEN (DECRYPT = '1' AND LAST = '1') ELSE SUB_Inv1_OUT;
	STATE2_NEXT <= MIX2_OUT WHEN (DECRYPT = '0' AND LAST = '1') ELSE S_MID_C2 WHEN (DECRYPT = '0') ELSE S_MID_E2 WHEN (DECRYPT = '1' AND LAST = '1') ELSE SUB_Inv2_OUT;

	SHARE1_OUT <= STATE1_NEXT;
	SHARE2_OUT <= STATE2_NEXT;

END Round;


--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 


-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY Skinny256 IS
   PORT ( CLK        : IN  STD_LOGIC;
   		 -- CONTROL PORTS --------------------------------
          RESET      : IN  STD_LOGIC;
		    DECRYPT		: IN	STD_LOGIC;
          DONE       : OUT STD_LOGIC;
   	    -- KEY PORT -------------------------------------
          TK1        : IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
          TK2_1      : IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
          TK2_2      : IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
   	    -- DATA PORTS -----------------------------------
          SHARE1_IN  : IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
          SHARE2_IN  : IN  STD_LOGIC_VECTOR (127 DOWNTO 0);
          SHARE1_OUT : OUT STD_LOGIC_VECTOR (127 DOWNTO 0);
          SHARE2_OUT : OUT STD_LOGIC_VECTOR (127 DOWNTO 0));
END Skinny256;



-- ARCHITECTURE : ROUND
----------------------------------------------------------------------------------
ARCHITECTURE Round OF Skinny256 IS

	-- SIGNALS --------------------------------------------------------------------
	SIGNAL ROUND_TK1  : STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL ROUND_TK2_1: STD_LOGIC_VECTOR(127 DOWNTO 0);
	SIGNAL ROUND_TK2_2: STD_LOGIC_VECTOR(127 DOWNTO 0);

	SIGNAL ROUND_CST  : STD_LOGIC_VECTOR(  5 DOWNTO 0);
	SIGNAL FIRST  	   : STD_LOGIC;
	SIGNAL LAST   	   : STD_LOGIC;

	SIGNAL TK1_DEC   		: STD_LOGIC_VECTOR (127 DOWNTO 0);
	SIGNAL TK2_1_DEC 		: STD_LOGIC_VECTOR (127 DOWNTO 0);
	SIGNAL TK2_2_DEC 		: STD_LOGIC_VECTOR (127 DOWNTO 0);

	SIGNAL SELECTED_TK1	: STD_LOGIC_VECTOR (127 DOWNTO 0);
	SIGNAL SELECTED_TK2_1: STD_LOGIC_VECTOR (127 DOWNTO 0);
	SIGNAL SELECTED_TK2_2: STD_LOGIC_VECTOR (127 DOWNTO 0);

BEGIN

	FullKeyScheuleInst1:   entity work. FullKeySchedule1 Port Map (TK1,   TK1_DEC);
	FullKeyScheuleInst2_1: entity work. FullKeySchedule2 Port Map (TK2_1, TK2_1_DEC);
	FullKeyScheuleInst2_2: entity work. FullKeySchedule2 Port Map (TK2_2, TK2_2_DEC);

	SELECTED_TK1	<= TK1   WHEN DECRYPT = '0' ELSE TK1_DEC;
	SELECTED_TK2_1	<= TK2_1 WHEN DECRYPT = '0' ELSE TK2_1_DEC;
	SELECTED_TK2_2	<= TK2_2 WHEN DECRYPT = '0' ELSE TK2_2_DEC;
	
	-- ROUND FUNCTION -------------------------------------------------------------
	RF : ENTITY work.RoundFunction PORT MAP (CLK, RESET, DECRYPT, FIRST, LAST, ROUND_CST, ROUND_TK1, ROUND_TK2_1, ROUND_TK2_2, SHARE1_IN, SHARE2_IN, SHARE1_OUT, SHARE2_OUT);
	-------------------------------------------------------------------------------

   -- KEY EXPANSION --------------------------------------------------------------
   KE : ENTITY work.KeyExpansion  PORT MAP (CLK, RESET, DECRYPT, LAST, SELECTED_TK1, SELECTED_TK2_1, SELECTED_TK2_2, ROUND_TK1, ROUND_TK2_1, ROUND_TK2_2);
	-------------------------------------------------------------------------------

   -- CONTROL LOGIC --------------------------------------------------------------
   CL : ENTITY work.ControlLogic  PORT MAP (CLK, RESET, DECRYPT, DONE, FIRST, LAST, ROUND_CST);
	-------------------------------------------------------------------------------

END Round;


--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SKINNY_tk2_AEAD is
Generic (
	tl				 : integer := 0); -- 0: 128-bit tag,   1: 64-bit tag
Port (  
	clk          : in  STD_LOGIC;
	rst      	 : in  STD_LOGIC;
	a_data       : in  STD_LOGIC;
	enc          : in  STD_LOGIC;
	dec          : in  STD_LOGIC;
	gen_tag      : in  std_logic;
	Input1       : in  STD_LOGIC_VECTOR (127       downto 0);  -- Message or Associated Data (share 1)
	Input2       : in  STD_LOGIC_VECTOR (127       downto 0);  -- Message or Associated Data (share 2)
	N            : in  STD_LOGIC_VECTOR ( 95       downto 0);
	K1           : in  STD_LOGIC_VECTOR (127       downto 0); -- Key (share 1)
	K2				 : in  STD_LOGIC_VECTOR (127       downto 0); -- Key (share 2)
	Block_Size	 : in  STD_LOGIC_VECTOR (  3       downto 0); -- Size of the given block as Input (in BYTES) - 1
	Output1      : out STD_LOGIC_VECTOR (127       downto 0); -- Ciphertext (share 1)
	Output2      : out STD_LOGIC_VECTOR (127       downto 0); -- Ciphertext (share 2) 
	Tag1			 : out STD_LOGIC_VECTOR (127-tl*64 downto 0); -- Tag (share 1)
	Tag2			 : out STD_LOGIC_VECTOR (127-tl*64 downto 0); -- Tag (share 2)
	done         : out STD_LOGIC);
end SKINNY_tk2_AEAD;

architecture dfl of SKINNY_tk2_AEAD is

	constant nl				 		: integer := 1;  -- 96-bit nonce

	signal full_size				: STD_LOGIC;

	signal Cipher_Input1			: STD_LOGIC_VECTOR(127 downto 0);
	signal Cipher_Input2			: STD_LOGIC_VECTOR(127 downto 0);
	signal Cipher_Output1		: STD_LOGIC_VECTOR(127 downto 0);
	signal Cipher_Output2		: STD_LOGIC_VECTOR(127 downto 0);
	signal tk1 		 				: STD_LOGIC_VECTOR(127 downto 0);
	signal tk2_1	 				: STD_LOGIC_VECTOR(127 downto 0);
	signal tk2_2	 				: STD_LOGIC_VECTOR(127 downto 0);
	
	signal LFSR_Output			: STD_LOGIC_VECTOR( 23 downto 0);
	signal LFSR_rst         	: STD_LOGIC;
	signal LFSR_en          	: STD_LOGIC;
		
	signal Auth_Reg_rst			: STD_LOGIC;
	signal Auth_Reg_en			: STD_LOGIC;
	
	signal Tag_Reg_rst			: STD_LOGIC;
	signal Tag_Reg_en				: STD_LOGIC;
	
	signal Domain_Separation	: STD_LOGIC_VECTOR(  7 downto 0);
	
	signal Cipher_rst				: STD_LOGIC;
	signal Cipher_dec				: STD_LOGIC;
	signal Cipher_done			: STD_LOGIC;
	
begin
		
	LFSRInst: entity work.LFSR
	Port Map (
		clk,
		LFSR_rst,
		LFSR_en,
		LFSR_Output);

	CipherInst: entity work.Skinny256
	Port Map (
		clk,
		Cipher_rst,
		Cipher_dec,
		Cipher_done,
		tk1,
		tk2_1,
		tk2_2,
		Cipher_Input1,
		Cipher_Input2,
		Cipher_Output1,
		Cipher_Output2);

	ControlInst: entity work.Controller
	Generic Map (nl, tl)
	Port Map (
		clk,
		rst,
		a_data,
		enc,
		dec,
		gen_tag,
		full_size,
		LFSR_rst,
		LFSR_en,
		Auth_Reg_rst,
		Auth_Reg_en,
		Tag_Reg_rst,
		Tag_Reg_en,
		Cipher_rst,
		Cipher_dec,
		Cipher_done,
		Domain_Separation,
		done);
	
	-----------------------------------------------------

	full_size					<= '1' when Block_Size  = "1111" else '0';
	
	tk1							<= LFSR_Output( 7 downto  0) & LFSR_Output(15 downto  8) & LFSR_Output(23 downto 16) &
										Domain_Separation & N;
										
	tk2_1							<= K1;
	tk2_2							<= K2;

	-----------------------------------------------------

	MainPart1: entity work.MainPart
	Generic Map (tl, 1)
	Port Map (
		clk,
		a_data,
		dec,
		gen_tag,
		Block_Size,
		full_size,
		Auth_Reg_rst,
		Auth_Reg_en,
		Tag_Reg_rst,
		Tag_Reg_en,
		Input1,
		Cipher_Input1,
		Cipher_Output1,
		Output1,
		Tag1);

	MainPart2: entity work.MainPart
	Generic Map (tl, 0)
	Port Map (
		clk,
		a_data,
		dec,
		gen_tag,
		Block_Size,
		full_size,
		Auth_Reg_rst,
		Auth_Reg_en,
		Tag_Reg_rst,
		Tag_Reg_en,
		Input2,
		Cipher_Input2,
		Cipher_Output2,
		Output2,
		Tag2);
		
end dfl;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity UP_COUNTER is
generic(
  datasize             : integer           := 128          );
    Port ( clk: in std_logic; -- clock input
           rst: in std_logic; -- reset input
			en : in std_logic;
           counter: out std_logic_vector(datasize-1 downto 0) -- output 4-bit counter
     );
end UP_COUNTER;

architecture Behavioral of UP_COUNTER is
signal counter_up: std_logic_vector(datasize-1 downto 0);
begin
-- up counter
process(clk,rst, en)
begin
if(rising_edge(clk)) then
    if(rst='1') then
         counter_up <= (others => '0');
    elsif(en='1') then 
			counter_up <= counter_up + '1';
    end if;
 end if;
end process;
 counter <= counter_up;

end Behavioral;


library ieee; 
use ieee.std_logic_1164.all;
entity Regis is 
generic(
  datasize             : integer           := 7          );
port (
  clk           : in  std_logic;
  rst          : in  std_logic;
    di          : in  std_logic_vector (datasize-1 downto 0);
    load            : in  std_logic;
    do          : out std_logic_vector (datasize-1 downto 0));
end Regis;
architecture behavioral of Regis is  
begin  

registering : process (clk,rst) begin 
  if (rst = '1') then 
    do   <= (others=>'0');
  elsif rising_edge(clk) then 
    if(load='1') then
      do <=di;
    end if; 
  end if; 
end process registering; 
end architecture behavioral;

--
-- SKINNY-AEAD Reference Hardware Implementation
-- 
-- Copyright 2019:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
-- 
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License as
-- published by the Free Software Foundation; either version 2 of the
-- License, or (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
-- General Public License for more details.
-- 




-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY dflipfloplw IS
	PORT ( CLK  : IN  STD_LOGIC;
			 SEL	: IN  STD_LOGIC;
			 D0   : IN  STD_LOGIC;
			 D1   : IN  STD_LOGIC;
			 Q    : OUT STD_LOGIC);
END dflipfloplw;



-- ARCHITECTURE : STRUCTURAL
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF dflipfloplw IS
BEGIN

	GenFF: Process(CLK, SEL, D0, D1)
	begin
		if rising_edge(CLK) then
			if (SEL = '1') then
				Q	<= D1;
			else
				Q	<= D0;
			end if;	
		end if;
	end process;

END Structural;

--------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Skinny_Imp IS
    GENERIC (
        size_int        : integer := 64;
        tl				 : integer := 0 -- 0: 128-bit tag,   1: 64-bit tag
    );
    port (
        --! Global ports
      clk             : in  std_logic;--
       rst             : in  std_logic;--
		en_c	: in  std_logic;--
		
		ld_rec             : in  std_logic; --
		IDt             : in  std_logic_vector(size_int-1  downto 0);--
        IDst             : in  std_logic_vector(size_int-1  downto 0);--
        DtSel             : in  std_logic;--
        rand_in        : in  std_logic_vector(size_int-1 downto 0);--
        
		MuxSel2		: in  std_logic;--


    a_data       : in  STD_LOGIC;
	enc          : in  STD_LOGIC;
	dec          : in  STD_LOGIC;
	gen_tag      : in  std_logic;
	Input1       : in  STD_LOGIC_VECTOR (127       downto 0);  -- Message or Associated Data (share 1)
	Input2       : in  STD_LOGIC_VECTOR (127       downto 0);  -- Message or Associated Data (share 2)
	N            : in  STD_LOGIC_VECTOR ( 95       downto 0);
	K1           : in  STD_LOGIC_VECTOR (127       downto 0); -- Key (share 1)
	K2			: in  STD_LOGIC_VECTOR (127       downto 0); -- Key (share 2)
	Block_Size	 : in  STD_LOGIC_VECTOR (  3       downto 0); -- Size of the given block as Input (in BYTES) - 1
    
	Output1      : out STD_LOGIC_VECTOR (127       downto 0); -- Ciphertext (share 1)
	Output2      : out STD_LOGIC_VECTOR (127       downto 0); -- Ciphertext (share 2) 
	Tag1		: out STD_LOGIC_VECTOR (127-tl*64 downto 0); -- Tag (share 1)
	Tag2		: out STD_LOGIC_VECTOR (127-tl*64 downto 0); -- Tag (share 2)
	done         : out STD_LOGIC
    );
end Skinny_Imp;
	
architecture structural of Skinny_Imp IS  
signal comxor           : std_logic_vector (size_int-1 downto 0);--
signal secxor           : std_logic_vector (size_int-1 downto 0);--
signal conc1           : std_logic_vector ((2*size_int)-1 downto 0);--
signal conc2           : std_logic_vector ((2*size_int)-1 downto 0);--

signal randd           : std_logic_vector (size_int-1 downto 0);--
signal IDtReg           : std_logic_vector (size_int-1 downto 0);--
signal IDstReg           : std_logic_vector (size_int-1 downto 0);--

signal xor_in           : std_logic_vector (size_int-1 downto 0);--

signal keytt           : std_logic_vector ((2*size_int)-1 downto 0);--

    SIGNAL Keyt 			: STD_LOGIC_VECTOR(127 DOWNTO 0);

begin  

Inst_forkAE:  entity work.SKINNY_tk2_AEAD(dfl)
GENERIC MAP (0)
	PORT MAP (
		clk  => clk,
        rst  => rst,
        a_data => a_data,
        enc   => enc,
        dec    => dec,
        gen_tag  => gen_tag,
        Input1  => Input1,
        Input2  => Input2,
        N      => N,
        K1     => K1,
        K2      => K1,
        Block_Size  => Block_Size,
        Output1   => Output1,
        Output2   => Output2,
        Tag1      => Tag1,
        Tag2      => Tag2,
        done      => done
	);
	
	Inst_lfsr:  entity work.UP_COUNTER(Behavioral)--
    generic map  (
        datasize            => 64	
    )
    port map (
        clk          => clk,
        rst          => rst,
        en     => en_c,
        counter    => randd
    );
	
	Inst_RegIDt:  entity work.Regis(behavioral)--
    generic map  (
       datasize            => size_int           
    )
    port map (
        rst          => rst,
        clk          => clk,
        di     => IDt,
        load    => ld_rec,
		do    => IDtReg
		
    );
	
	Inst_REgIDst:  entity work.Regis(behavioral)
    generic map  (
        datasize            => size_int          
    )
    port map (
        rst          => rst,
        clk          => clk,
        di     => IDst,
        load    => ld_rec,
		do    => IDstReg
    );
    

xor_in <= IDtReg when (DtSel = '1') else IDstReg;
	
comxor <= rand_in xor xor_in;
secxor <= randd xor IDtReg;
conc1 <= comxor & secxor;
conc2 <= comxor & randd;
       
Keyt(127 downto 0) <= conc1 when (MuxSel2 = '1') else conc2;

end architecture structural;


