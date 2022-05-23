----------------------------------------------------------------------------------
-- Copyright 2016:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
--
-- Copyright 2019 (for modifications):
--     Antoon Purnal for the ForkAE team
--     https://www.esat.kuleuven.be/cosic/forkae/
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
----------------------------------------------------------------------------------

package ForkSkinnyPKG is

	-- Define blocksize, tweakey size and key size --------------------------------
	type BLOCK_SIZE is (BLOCK_SIZE_64, BLOCK_SIZE_128);
	type TWEAK_SIZE is (TWEAK_SIZE_1N, TWEAK_SIZE_3o2N, TWEAK_SIZE_2N, TWEAK_SIZE_9o4N, TWEAK_SIZE_3N);
    constant KEY_SIZE : integer := 128;
	-------------------------------------------------------------------------------
		
    type ENC_DEC is (ENCRYPTION, ENCRYPTION_DECRYPTION);
    
    -- Function definitions -------------------------------------------------------
	function GET_WORD_SIZE  (BS : BLOCK_SIZE) return integer;		
	function GET_BLOCK_SIZE (BS : BLOCK_SIZE) return integer;
	function GET_TWEAK_FACT (TS : TWEAK_SIZE) return integer;
	function GET_TWEAK_SIZE (BS : BLOCK_SIZE; TS : TWEAK_SIZE) return integer;
	-------------------------------------------------------------------------------
	
end ForkSkinnyPKG;

package body ForkSkinnyPKG is

	-- FUNCTION: RETURN WORD SIZE -------------------------------------------------
	FUNCTION GET_WORD_SIZE (BS : BLOCK_SIZE) RETURN INTEGER IS
	BEGIN
			IF BS = BLOCK_SIZE_64 THEN
				RETURN 4;
			ELSE
				RETURN 8;
			END IF;
	END GET_WORD_SIZE;
	-------------------------------------------------------------------------------
	
	-- FUNCTION: RETURN BLOCK SIZE ------------------------------------------------
	FUNCTION GET_BLOCK_SIZE (BS : BLOCK_SIZE) RETURN INTEGER IS
	BEGIN
			IF BS = BLOCK_SIZE_64 THEN
				RETURN 64;
			ELSE
				RETURN 128;
			END IF;
	END GET_BLOCK_SIZE;
	-------------------------------------------------------------------------------
	
	-- FUNCTION: RETURN TWEAK FACTOR ----------------------------------------------
	FUNCTION GET_TWEAK_FACT (TS : TWEAK_SIZE) RETURN INTEGER IS
	BEGIN
			IF    TS = TWEAK_SIZE_1N THEN
				RETURN 1;
			ELSIF TS = TWEAK_SIZE_2N THEN
				RETURN 2;
			ELSE
				RETURN 3;
			END IF;
	END GET_TWEAK_FACT;
	-------------------------------------------------------------------------------
	
	-- FUNCTION: RETURN TWEAK SIZE ------------------------------------------------
	FUNCTION GET_TWEAK_SIZE (BS : BLOCK_SIZE; TS : TWEAK_SIZE) RETURN INTEGER IS
	BEGIN
        if TS = TWEAK_SIZE_3o2N then
            return 192;
        elsif TS = TWEAK_SIZE_9o4N then
            return 320; -- This implementation pads zeros to fill half of the TK3 state
        else
            RETURN GET_BLOCK_SIZE(BS) * GET_TWEAK_FACT(TS);
        end if;
			
	END GET_TWEAK_SIZE;
	-------------------------------------------------------------------------------
	
	
end ForkSkinnyPKG;


----------------------------------------------------------------------------------
-- Copyright 2019:
--     Antoon Purnal for the ForkAE team
--     https://www.esat.kuleuven.be/cosic/forkae/
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
----------------------------------------------------------------------------------


-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.FORKSKINNYPKG.ALL;

-- Explicit combinational implementation of the branch constant logic (using NOT gates)
entity BranchConstant is
    generic (
                BS: BLOCK_SIZE
    );
    port (
        L: in std_logic_vector((GET_BLOCK_SIZE(BS) - 1) downto 0);
        BRANCH_CONSTANT: out std_logic_vector((GET_BLOCK_SIZE(BS) - 1) downto 0)
    );
end entity BranchConstant;

architecture behav of BranchConstant is

begin
	BC64 : IF BS = BLOCK_SIZE_64 GENERATE
        BRANCH_CONSTANT(63) <= L(63);
        BRANCH_CONSTANT(62) <= L(62);
        BRANCH_CONSTANT(61) <= L(61);
        BRANCH_CONSTANT(60) <= not L(60);
        BRANCH_CONSTANT(59) <= L(59);
        BRANCH_CONSTANT(58) <= L(58);
        BRANCH_CONSTANT(57) <= not L(57);
        BRANCH_CONSTANT(56) <= L(56);
        BRANCH_CONSTANT(55) <= L(55);
        BRANCH_CONSTANT(54) <= not L(54);
        BRANCH_CONSTANT(53) <= L(53);
        BRANCH_CONSTANT(52) <= L(52);
        BRANCH_CONSTANT(51) <= not L(51);
        BRANCH_CONSTANT(50) <= L(50);
        BRANCH_CONSTANT(49) <= L(49);
        BRANCH_CONSTANT(48) <= not L(48);
        BRANCH_CONSTANT(47) <= L(47);
        BRANCH_CONSTANT(46) <= L(46);
        BRANCH_CONSTANT(45) <= not L(45);
        BRANCH_CONSTANT(44) <= not L(44);
        BRANCH_CONSTANT(43) <= L(43);
        BRANCH_CONSTANT(42) <= not L(42);
        BRANCH_CONSTANT(41) <= not L(41);
        BRANCH_CONSTANT(40) <= L(40);
        BRANCH_CONSTANT(39) <= not L(39);
        BRANCH_CONSTANT(38) <= not L(38);
        BRANCH_CONSTANT(37) <= L(37);
        BRANCH_CONSTANT(36) <= not L(36);
        BRANCH_CONSTANT(35) <= not L(35);
        BRANCH_CONSTANT(34) <= L(34);
        BRANCH_CONSTANT(33) <= not L(33);
        BRANCH_CONSTANT(32) <= L(32);
        BRANCH_CONSTANT(31) <= L(31);
        BRANCH_CONSTANT(30) <= not L(30);
        BRANCH_CONSTANT(29) <= L(29);
        BRANCH_CONSTANT(28) <= not L(28);
        BRANCH_CONSTANT(27) <= not L(27);
        BRANCH_CONSTANT(26) <= L(26);
        BRANCH_CONSTANT(25) <= not L(25);
        BRANCH_CONSTANT(24) <= not L(24);
        BRANCH_CONSTANT(23) <= L(23);
        BRANCH_CONSTANT(22) <= not L(22);
        BRANCH_CONSTANT(21) <= not L(21);
        BRANCH_CONSTANT(20) <= not L(20);
        BRANCH_CONSTANT(19) <= not L(19);
        BRANCH_CONSTANT(18) <= not L(18);
        BRANCH_CONSTANT(17) <= not L(17);
        BRANCH_CONSTANT(16) <= not L(16);
        BRANCH_CONSTANT(15) <= not L(15);
        BRANCH_CONSTANT(14) <= not L(14);
        BRANCH_CONSTANT(13) <= not L(13);
        BRANCH_CONSTANT(12) <= L(12);
        BRANCH_CONSTANT(11) <= not L(11);
        BRANCH_CONSTANT(10) <= not L(10);
        BRANCH_CONSTANT(9) <= L(9);
        BRANCH_CONSTANT(8) <= L(8);
        BRANCH_CONSTANT(7) <= not L(7);
        BRANCH_CONSTANT(6) <= L(6);
        BRANCH_CONSTANT(5) <= L(5);
        BRANCH_CONSTANT(4) <= L(4);
        BRANCH_CONSTANT(3) <= L(3);
        BRANCH_CONSTANT(2) <= L(2);
        BRANCH_CONSTANT(1) <= L(1);
        BRANCH_CONSTANT(0) <= not L(0);
	END GENERATE;

    BC128 : IF BS = BLOCK_SIZE_128 GENERATE
        BRANCH_CONSTANT(127) <= L(127);
        BRANCH_CONSTANT(126) <= L(126);
        BRANCH_CONSTANT(125) <= L(125);
        BRANCH_CONSTANT(124) <= L(124);
        BRANCH_CONSTANT(123) <= L(123);
        BRANCH_CONSTANT(122) <= L(122);
        BRANCH_CONSTANT(121) <= L(121);
        BRANCH_CONSTANT(120) <= not L(120);
        BRANCH_CONSTANT(119) <= L(119);
        BRANCH_CONSTANT(118) <= L(118);
        BRANCH_CONSTANT(117) <= L(117);
        BRANCH_CONSTANT(116) <= L(116);
        BRANCH_CONSTANT(115) <= L(115);
        BRANCH_CONSTANT(114) <= L(114);
        BRANCH_CONSTANT(113) <= not L(113);
        BRANCH_CONSTANT(112) <= L(112);
        BRANCH_CONSTANT(111) <= L(111);
        BRANCH_CONSTANT(110) <= L(110);
        BRANCH_CONSTANT(109) <= L(109);
        BRANCH_CONSTANT(108) <= L(108);
        BRANCH_CONSTANT(107) <= L(107);
        BRANCH_CONSTANT(106) <= not L(106);
        BRANCH_CONSTANT(105) <= L(105);
        BRANCH_CONSTANT(104) <= L(104);
        BRANCH_CONSTANT(103) <= L(103);
        BRANCH_CONSTANT(102) <= L(102);
        BRANCH_CONSTANT(101) <= L(101);
        BRANCH_CONSTANT(100) <= L(100);
        BRANCH_CONSTANT(99) <= not L(99);
        BRANCH_CONSTANT(98) <= L(98);
        BRANCH_CONSTANT(97) <= L(97);
        BRANCH_CONSTANT(96) <= L(96);
        BRANCH_CONSTANT(95) <= L(95);
        BRANCH_CONSTANT(94) <= L(94);
        BRANCH_CONSTANT(93) <= L(93);
        BRANCH_CONSTANT(92) <= not L(92);
        BRANCH_CONSTANT(91) <= L(91);
        BRANCH_CONSTANT(90) <= L(90);
        BRANCH_CONSTANT(89) <= L(89);
        BRANCH_CONSTANT(88) <= L(88);
        BRANCH_CONSTANT(87) <= L(87);
        BRANCH_CONSTANT(86) <= L(86);
        BRANCH_CONSTANT(85) <= not L(85);
        BRANCH_CONSTANT(84) <= L(84);
        BRANCH_CONSTANT(83) <= L(83);
        BRANCH_CONSTANT(82) <= L(82);
        BRANCH_CONSTANT(81) <= L(81);
        BRANCH_CONSTANT(80) <= L(80);
        BRANCH_CONSTANT(79) <= L(79);
        BRANCH_CONSTANT(78) <= not L(78);
        BRANCH_CONSTANT(77) <= L(77);
        BRANCH_CONSTANT(76) <= L(76);
        BRANCH_CONSTANT(75) <= L(75);
        BRANCH_CONSTANT(74) <= L(74);
        BRANCH_CONSTANT(73) <= L(73);
        BRANCH_CONSTANT(72) <= not L(72);
        BRANCH_CONSTANT(71) <= not L(71);
        BRANCH_CONSTANT(70) <= L(70);
        BRANCH_CONSTANT(69) <= L(69);
        BRANCH_CONSTANT(68) <= L(68);
        BRANCH_CONSTANT(67) <= L(67);
        BRANCH_CONSTANT(66) <= L(66);
        BRANCH_CONSTANT(65) <= not L(65);
        BRANCH_CONSTANT(64) <= L(64);
        BRANCH_CONSTANT(63) <= L(63);
        BRANCH_CONSTANT(62) <= L(62);
        BRANCH_CONSTANT(61) <= L(61);
        BRANCH_CONSTANT(60) <= L(60);
        BRANCH_CONSTANT(59) <= L(59);
        BRANCH_CONSTANT(58) <= not L(58);
        BRANCH_CONSTANT(57) <= L(57);
        BRANCH_CONSTANT(56) <= not L(56);
        BRANCH_CONSTANT(55) <= L(55);
        BRANCH_CONSTANT(54) <= L(54);
        BRANCH_CONSTANT(53) <= L(53);
        BRANCH_CONSTANT(52) <= L(52);
        BRANCH_CONSTANT(51) <= not L(51);
        BRANCH_CONSTANT(50) <= L(50);
        BRANCH_CONSTANT(49) <= not L(49);
        BRANCH_CONSTANT(48) <= L(48);
        BRANCH_CONSTANT(47) <= L(47);
        BRANCH_CONSTANT(46) <= L(46);
        BRANCH_CONSTANT(45) <= L(45);
        BRANCH_CONSTANT(44) <= not L(44);
        BRANCH_CONSTANT(43) <= L(43);
        BRANCH_CONSTANT(42) <= not L(42);
        BRANCH_CONSTANT(41) <= L(41);
        BRANCH_CONSTANT(40) <= L(40);
        BRANCH_CONSTANT(39) <= L(39);
        BRANCH_CONSTANT(38) <= L(38);
        BRANCH_CONSTANT(37) <= not L(37);
        BRANCH_CONSTANT(36) <= L(36);
        BRANCH_CONSTANT(35) <= not L(35);
        BRANCH_CONSTANT(34) <= L(34);
        BRANCH_CONSTANT(33) <= L(33);
        BRANCH_CONSTANT(32) <= L(32);
        BRANCH_CONSTANT(31) <= L(31);
        BRANCH_CONSTANT(30) <= not L(30);
        BRANCH_CONSTANT(29) <= L(29);
        BRANCH_CONSTANT(28) <= not L(28);
        BRANCH_CONSTANT(27) <= L(27);
        BRANCH_CONSTANT(26) <= L(26);
        BRANCH_CONSTANT(25) <= L(25);
        BRANCH_CONSTANT(24) <= not L(24);
        BRANCH_CONSTANT(23) <= not L(23);
        BRANCH_CONSTANT(22) <= L(22);
        BRANCH_CONSTANT(21) <= not L(21);
        BRANCH_CONSTANT(20) <= L(20);
        BRANCH_CONSTANT(19) <= L(19);
        BRANCH_CONSTANT(18) <= L(18);
        BRANCH_CONSTANT(17) <= not L(17);
        BRANCH_CONSTANT(16) <= L(16);
        BRANCH_CONSTANT(15) <= L(15);
        BRANCH_CONSTANT(14) <= not L(14);
        BRANCH_CONSTANT(13) <= L(13);
        BRANCH_CONSTANT(12) <= L(12);
        BRANCH_CONSTANT(11) <= L(11);
        BRANCH_CONSTANT(10) <= not L(10);
        BRANCH_CONSTANT(9) <= L(9);
        BRANCH_CONSTANT(8) <= L(8);
        BRANCH_CONSTANT(7) <= not L(7);
        BRANCH_CONSTANT(6) <= L(6);
        BRANCH_CONSTANT(5) <= L(5);
        BRANCH_CONSTANT(4) <= L(4);
        BRANCH_CONSTANT(3) <= not L(3);
        BRANCH_CONSTANT(2) <= L(2);
        BRANCH_CONSTANT(1) <= L(1);
        BRANCH_CONSTANT(0) <= L(0);
	END GENERATE;
end behav;



----------------------------------------------------------------------------------
-- Copyright 2019:
--     Antoon Purnal for the ForkAE team
--     https://www.esat.kuleuven.be/cosic/forkae/
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
----------------------------------------------------------------------------------

-------------------
--- FSM FORKSKINNY
-------------------
library ieee;
    use ieee.std_logic_1164.all;
    
entity FSM_ForkSkinny is 
    port (
        -- CLOCK
        CLK : in std_logic;

        -- CONTROL INPUTS
        GO: in std_logic;
        ENC_DEC_MODE: in std_logic;

        -- STATUS INPUTS
        DONE_FSM: in std_logic;

        -- CONTROL OUTPUTS
        MODE_DECRYPT: out std_logic;
        SET_DEC_KEY: out std_logic;
        WE_TK: out std_logic;
        INTERNAL_GO: out std_logic;
        LOAD_IS: out std_logic
    );
end entity FSM_ForkSkinny;

architecture rtl of FSM_ForkSkinny is

	-- Build an enumerated type for the state machine
	type state_type is (INIT, ENCRYPT, DECRYPTION_KEY, DECRYPT, DECRYPT1, RECONSTRUCT, RECONSTRUCT_KEY);
	
	-- Register to hold the current state
	signal state : state_type;

begin
    -- NEXT STATE
    process(clk)
    begin
        if(rising_edge(clk)) then
            case state is 
                when INIT =>
                    if GO = '0' then
                        state <= INIT;
                    elsif ENC_DEC_MODE = '1' then
                        state <= DECRYPTION_KEY;
                    else
                        state <= ENCRYPT;
                    end if;

                when ENCRYPT =>
                    if DONE_FSM = '1' then
                        state <= INIT;
                    else
                        state <= ENCRYPT;
                    end if;

                when DECRYPTION_KEY =>
                    state <= DECRYPT1;

                when DECRYPT1 =>
                    state <= DECRYPT;

                when DECRYPT =>
                    if DONE_FSM = '1' then
                        state <= RECONSTRUCT_KEY;
                    else
                        state <= DECRYPT;
                    end if;

                when RECONSTRUCT_KEY =>
                    state <= RECONSTRUCT;

                when RECONSTRUCT =>
                    if DONE_FSM = '1' then
                        state <= INIT;
                    else
                        state <= RECONSTRUCT;
                    end if;

                when others => -- Should have covered all cases
                    state <= INIT;
            end case;
        end if;
    end process;

    -- OUTPUT 
    process(state)
    begin
        case state is 
            when INIT =>
                MODE_DECRYPT <= '0';
                SET_DEC_KEY <= '0'; 
                WE_TK <= '0';
                INTERNAL_GO <= '1'; --0
                LOAD_IS <= '1';

            when ENCRYPT =>
                MODE_DECRYPT <= '0';
                SET_DEC_KEY <= '0';
                WE_TK <= '1';
                INTERNAL_GO <= '0';
                LOAD_IS <= '0';

            when DECRYPTION_KEY =>
                MODE_DECRYPT <= '1';
                SET_DEC_KEY <= '1';
                WE_TK <= '1';
                INTERNAL_GO <= '1';
                LOAD_IS <= '0';

            when DECRYPT1 => -- Sole purpose is to invert KS one extra
                MODE_DECRYPT <= '1';
                SET_DEC_KEY <= '0';
                WE_TK <= '1';
                INTERNAL_GO <= '1';
                LOAD_IS <= '1';

            when DECRYPT =>
                MODE_DECRYPT <= '1';
                SET_DEC_KEY <= '0';
                WE_TK <= '1';
                INTERNAL_GO <= '0';
                LOAD_IS <= '0';

            when RECONSTRUCT_KEY =>
                MODE_DECRYPT <= '1'; -- This is for the counter
                SET_DEC_KEY <= '1';
                WE_TK <= '1';
                INTERNAL_GO <= '1'; -- This is for the counter
                LOAD_IS <= '0';

            when RECONSTRUCT =>
                MODE_DECRYPT <= '0'; -- Encryption now
                SET_DEC_KEY <= '0';
                WE_TK <= '1';
                INTERNAL_GO <= '0'; -- This is for the counter
                LOAD_IS <= '0';

            when others => -- Should have covered all cases
                MODE_DECRYPT <= '0';
                SET_DEC_KEY <= '0';
                WE_TK <= '0';
                INTERNAL_GO <= '0';
                LOAD_IS <= '0';

        end case;
    end process;

end rtl;



----------------------------------------------------------------------------------
-- COPYRIGHT (c) 2016 ALL RIGHT RESERVED
--
-- COMPANY:					Ruhr-University Bochum, Chair for Embedded Security
-- AUTHOR:					Amir Moradi
--
-- CREATE DATA:			27/01/2016
-- MODULE NAME:			ScanFF
--
--	REVISION:				1.00 - File created
--
-- LICENCE: 				Please look at licence.txt
-- USAGE INFORMATION:	Please look at readme.txt. If licence.txt or readme.txt
--								are missing or	if you have questions regarding the code
--								please contact Amir Moradi(amir.moradi@rub.de)
--
-- THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY 
-- KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A
-- PARTICULAR PURPOSE.
----------------------------------------------------------------------------------




-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY ScanFF IS
    GENERIC (SIZE : INTEGER);
	PORT ( CLK	: IN  STD_LOGIC;
          SE 	: IN  STD_LOGIC;
          D  	: IN 	STD_LOGIC_VECTOR((SIZE - 1) DOWNTO 0);
          DS  	: IN 	STD_LOGIC_VECTOR((SIZE - 1) DOWNTO 0);
          Q  	: OUT 	STD_LOGIC_VECTOR((SIZE - 1) DOWNTO 0));
END ScanFF;



-- ARCHITECTURE
----------------------------------------------------------------------------------
ARCHITECTURE Structural OF ScanFF IS	

-- STRUCTURAL
----------------------------------------------------------------------------------
BEGIN
	
	-------------------------------------------------------------------------------
	PROCESS(CLK) BEGIN
		IF RISING_EDGE(CLK) THEN
			IF (SE = '0') THEN
				Q <= D;
			ELSE
				Q <= DS;
			END IF;
		END IF;
	END PROCESS;
	-------------------------------------------------------------------------------

END Structural;



----------------------------------------------------------------------------------
-- Copyright 2016:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
--
-- Copyright 2019 (for decryption and forkcipher):
--     Antoon Purnal for the ForkAE team
--     https://www.esat.kuleuven.be/cosic/forkae/
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
----------------------------------------------------------------------------------



----------------------------------------------------
-- RoundConstant for encryption-only implementation
----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity RoundConstantEnc is
    port (CLK    : in  std_logic;
          INIT	 : in  std_logic;
          CONST  : out std_logic_vector(6 downto 0));
end RoundConstantEnc;

architecture behav of RoundConstantEnc is

	-- Signals 
	signal STATE, UPDATE : std_logic_vector(6 downto 0);

BEGIN
	-- STATE ----------------------------------------------------------------------
	REG_X : process(CLK)
	begin
        if RISING_EDGE(CLK) then
			if (INIT = '1') then
				STATE <= (others => '0');
			else
				STATE <= UPDATE;
			end if;
		end if;
	end process;
	-------------------------------------------------------------------------------

	-- UPDATE FUNCTION ------------------------------------------------------------
    -- Apply update function before using the round constant
	UPDATE(6 downto 0) <= STATE(5 downto 0) & (STATE(6) xnor STATE(5));
	-------------------------------------------------------------------------------

	-- OUTPUT ---------------------------------------------------------------------
	CONST <= UPDATE;
	-------------------------------------------------------------------------------
  
END behav;


----------------------------------------------------------
-- RoundConstant for encryption-decryption implementation
----------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.forkskinnypkg.all;

entity RoundConstantEncDec is
    generic (BS: BLOCK_SIZE; TS: TWEAK_SIZE);
    port (CLK         : in  std_logic;
          INIT	      : in  std_logic;
          DECRYPT     : in  std_logic;
          CONST_ENC   : out std_logic_vector(6 downto 0);
          CONST_DEC   : out std_logic_vector(6 downto 0));
end RoundConstantEncDec;

architecture behav of RoundConstantEncDec is

	-- Signals 
	signal STATE, UPDATE, INV_UPDATE, DECRYPTION_RC : std_logic_vector(6 downto 0);

BEGIN
	-- STATE ----------------------------------------------------------------------
	REG_X : process(CLK)
	begin
        if RISING_EDGE(CLK) then
			if (INIT = '1' and DECRYPT='0') then
				STATE <= (others => '0');
			elsif (INIT = '1' and DECRYPT='1') then
                STATE <= DECRYPTION_RC;
            elsif (DECRYPT = '1') then
                STATE <= INV_UPDATE;
			else
				STATE <= UPDATE;
			end if;
		end if;
	end process;
	-------------------------------------------------------------------------------

	-- UPDATE, INVERSE UPDATE and DECRYPTION RC FUNCTIONS -------------------------

	UPDATE(6 downto 0) <= STATE(5 downto 0) & (STATE(6) xnor STATE(5));

	INV_UPDATE(6 downto 0) <= (STATE(6) xnor STATE(0)) & STATE(6 downto 1);

    GEN_SET_DECRYPTION_RC_0: if BS = BLOCK_SIZE_64 generate
        DECRYPTION_RC <= "1010011"; 
    end generate;

    GEN_SET_DECRYPTION_RC_1: if BS = BLOCK_SIZE_128 and (TS = TWEAK_SIZE_2N or TS = TWEAK_SIZE_3o2N) generate
        DECRYPTION_RC <= "0010101"; 
    end generate;

    GEN_SET_DECRYPTION_RC_2: if BS = BLOCK_SIZE_128 and (TS = TWEAK_SIZE_9o4N) generate
        DECRYPTION_RC <= "0000010"; 
    end generate;
	-------------------------------------------------------------------------------

	-- OUTPUT ---------------------------------------------------------------------

    -- Apply update function before using the round constant
	CONST_ENC <= UPDATE;

    -- Apply inverse update function AFTER using the round constant
    CONST_DEC <= STATE;
	-------------------------------------------------------------------------------
  
END behav;

------------------------------------------------------
-- RoundConstant Fast Forward for parallel encryption
------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.forkskinnypkg.all;

entity RoundConstantFF is
    generic (BS: BLOCK_SIZE; TS: TWEAK_SIZE);
    port ( CONST : in std_logic_vector (6 downto 0);
           CONST_FF : out std_logic_vector (6 downto 0)
          );
end RoundConstantFF;

architecture behav of RoundConstantFF is

begin

    -- FS-64-192
    RC_FF_64_192: IF (BS = BLOCK_SIZE_64 AND TS = TWEAK_SIZE_3N) GENERATE
        CONST_FF(6 downto 0) <= ( CONST(1) xor CONST(2) xor CONST(3) xor CONST(4) xor '1') & ( CONST(0) xor CONST(1) xor CONST(2) xor CONST(3) xor '1') & ( CONST(0) xor CONST(1) xor CONST(2) xor CONST(5) xor CONST(6) ) & ( CONST(0) xor CONST(1) xor CONST(4) xor CONST(6) xor '1') & ( CONST(0) xor CONST(3) xor CONST(6) ) & ( CONST(2) xor CONST(6) xor '1') & ( CONST(1) xor CONST(5) xor '1');
    end generate;

    -- FS-128-192 and FS-128-256
    RC_FF_128_256: IF (BS = BLOCK_SIZE_128 AND (TS = TWEAK_SIZE_2N or TS = TWEAK_SIZE_3o2N)) GENERATE
        CONST_FF(6 downto 0) <= ( CONST(0) xor CONST(3) xor CONST(6) ) & ( CONST(2) xor CONST(6) xor '1') & ( CONST(1) xor CONST(5) xor '1')  & ( CONST(0) xor CONST(4) xor '1' ) & ( CONST(3) xor CONST(5) xor CONST(6) ) & ( CONST(2) xor CONST(4) xor CONST(5) ) & ( CONST(1) xor CONST(3) xor CONST(4) );
    end generate;

    -- FS-128-288
    RC_FF_128_288: IF (BS = BLOCK_SIZE_128 AND (TS = TWEAK_SIZE_9o4N or TS = TWEAK_SIZE_3N)) GENERATE
        CONST_FF(6 downto 0) <= ( CONST(3) xor CONST(5) xor CONST(6) ) & ( CONST(2) xor CONST(4) xor CONST(5) ) & ( CONST(1) xor CONST(3) xor CONST(4) ) & ( CONST(0) xor CONST(2) xor CONST(3) ) & ( CONST(1) xor CONST(2) xor CONST(5) xor CONST(6) xor '1' ) & ( CONST(0) xor CONST(1) xor CONST(4) xor CONST(5) xor '1' ) & ( CONST(0) xor CONST(3) xor CONST(4) xor CONST(5) xor CONST(6) );
    end generate;

end behav;




---- IMPORTS
------------------------------------------------------------------------------------
--LIBRARY IEEE;
--USE IEEE.STD_LOGIC_1164.ALL;
--
--USE WORK.SKINNYPKG.ALL;
--
---- ENTITY
------------------------------------------------------------------------------------
--ENTITY ConstGeneratorFF IS
    --generic(BS: BLOCK_SIZE; TS: TWEAK_SIZE);
  --PORT (CLK    : IN  STD_LOGIC;
        --INIT	: IN  STD_LOGIC;
        --CONST  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        --FAST_FORWARD  : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
--END ConstGeneratorFF;
--
--
---- ARCHITECTURE : DATAFLOW
------------------------------------------------------------------------------------
--ARCHITECTURE Dataflow OF ConstGeneratorFF IS
--
	---- SIGNALS --------------------------------------------------------------------
	--SIGNAL STATE, UPDATE : STD_LOGIC_VECTOR(6 DOWNTO 0);
--
---- DATAFLOW
------------------------------------------------------------------------------------
--BEGIN
	---- STATE ----------------------------------------------------------------------
	--REG : PROCESS(CLK)
	--BEGIN
		--IF RISING_EDGE(CLK) THEN
			--IF (INIT = '1') THEN
				--STATE <= "0000000";
			--ELSE
				--STATE <= UPDATE;
			--END IF;
		--END IF;
	--END PROCESS;
	---------------------------------------------------------------------------------
--
	---- UPDATE FUNCTION ------------------------------------------------------------
    ---- Apply update function before using the round constant
	--UPDATE(6 DOWNTO 0) <= STATE(5 DOWNTO 0) & (STATE(6) XNOR STATE(5));
	---------------------------------------------------------------------------------
--
    ---- FAST FORWARD FUNCTION ------------------------------------------------------
    ---- Apply update function r1 times 
	--UPDATE(6 DOWNTO 0) <= STATE(5 DOWNTO 0) & (STATE(6) XNOR STATE(5));
--
    ---- FS-64-192
    --RC_FF_64_192: IF (BS = BLOCK_SIZE_64 AND TS = TWEAK_SIZE_3N) GENERATE
        --FAST_FORWARD(6 downto 0) <= ( UPDATE(1) xor UPDATE(2) xor UPDATE(3) xor UPDATE(4) xor '1') & ( UPDATE(0) xor UPDATE(1) xor UPDATE(2) xor UPDATE(3) xor '1') & ( UPDATE(0) xor UPDATE(1) xor UPDATE(2) xor UPDATE(5) xor UPDATE(6) ) & ( UPDATE(0) xor UPDATE(1) xor UPDATE(4) xor UPDATE(6) xor '1') & ( UPDATE(0) xor UPDATE(3) xor UPDATE(6) ) & ( UPDATE(2) xor UPDATE(6) xor '1') & ( UPDATE(1) xor UPDATE(5) xor '1');
    --end generate;
--
    ---- FS-128-256
    --RC_FF_128_256: IF (BS = BLOCK_SIZE_128 AND (TS = TWEAK_SIZE_2N or TS = TWEAK_SIZE_3o2N)) GENERATE
        --FAST_FORWARD(6 downto 0) <= ( UPDATE(0) xor UPDATE(3) xor UPDATE(6) ) & ( UPDATE(2) xor UPDATE(6) xor '1') & ( UPDATE(1) xor UPDATE(5) xor '1')  & ( UPDATE(0) xor UPDATE(4) xor '1' ) & ( UPDATE(3) xor UPDATE(5) xor UPDATE(6) ) & ( UPDATE(2) xor UPDATE(4) xor UPDATE(5) ) & ( UPDATE(1) xor UPDATE(3) xor UPDATE(4) );
    --end generate;
--
    ---- FS-128-288
    --RC_FF_128_288: IF (BS = BLOCK_SIZE_128 AND (TS = TWEAK_SIZE_9o4N or TS = TWEAK_SIZE_3N)) GENERATE
        --FAST_FORWARD(6 downto 0) <= ( UPDATE(3) xor UPDATE(5) xor UPDATE(6) ) & ( UPDATE(2) xor UPDATE(4) xor UPDATE(5) ) & ( UPDATE(1) xor UPDATE(3) xor UPDATE(4) ) & ( UPDATE(0) xor UPDATE(2) xor UPDATE(3) ) & ( UPDATE(1) xor UPDATE(2) xor UPDATE(5) xor UPDATE(6) xor '1' ) & ( UPDATE(0) xor UPDATE(1) xor UPDATE(4) xor UPDATE(5) xor '1' ) & ( UPDATE(0) xor UPDATE(3) xor UPDATE(4) xor UPDATE(5) xor UPDATE(6) );
    --end generate;
--
	---------------------------------------------------------------------------------
--
	---- OUTPUTS --------------------------------------------------------------------
	--CONST <= UPDATE;
	---------------------------------------------------------------------------------
  --
--END Dataflow;

----------------------------------------------------------------------------------
-- Copyright 2016:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
--
-- Copyright 2019 (for modifications):
--     Antoon Purnal for the ForkAE team
--     https://www.esat.kuleuven.be/cosic/forkae/
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
----------------------------------------------------------------------------------



-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.FORKSKINNYPKG.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY SBox IS	
	GENERIC (BS : BLOCK_SIZE);
	PORT ( X : IN	STD_LOGIC_VECTOR ((GET_WORD_SIZE(BS) - 1) DOWNTO 0);
          Y : OUT	STD_LOGIC_VECTOR ((GET_WORD_SIZE(BS) - 1) DOWNTO 0));
END SBox;



-- ARCHITECTURE : DATAFLOW
----------------------------------------------------------------------------------
ARCHITECTURE Dataflow OF SBox IS

	-- SIGNALS --------------------------------------------------------------------
	SIGNAL NO3, XO3, NO2, XO2, NO1, XO1, NO0, XO0 : STD_LOGIC;
	SIGNAL O, P												 : STD_LOGIC_VECTOR(39 DOWNTO 0);

-- DATAFLOW
----------------------------------------------------------------------------------
BEGIN

	-- 4-BIT S-BOX ----------------------------------------------------------------
	S4 : IF BS = BLOCK_SIZE_64 GENERATE
		NO3 <= X(3) NOR X(2);
		XO3 <= X(0) XOR NO3;
		
		NO2 <= X(2) NOR X(1);
		XO2 <= X(3) XOR NO2;
		
		NO1 <= X(1) NOR XO3;
		XO1 <= X(2) XOR NO1;
		
		NO0 <= XO3 NOR XO2;
		XO0 <= X(1) XOR NO0;
		
		Y <= XO3 & XO2 & XO1 & XO0;
	END GENERATE;
	-------------------------------------------------------------------------------
	
	-- 8-BIT S-BOX ----------------------------------------------------------------
	S8 : IF BS = BLOCK_SIZE_128 GENERATE
		P(7 DOWNTO 0) <= X;

		GEN : FOR I IN 0 TO 3 GENERATE
			O((8 * I +  7) DOWNTO (8 * I + 4)) <= P((8 * I + 7) DOWNTO (8 * I + 5)) & (P(8 * I + 4) XOR (P(8 * I + 7) NOR P(8 * I + 6)));
			O((8 * I +  3) DOWNTO (8 * I + 0)) <= P((8 * I + 3) DOWNTO (8 * I + 1)) & (P(8 * I + 0) XOR (P(8 * I + 3) NOR P(8 * I + 2)));		
			P((8 * I + 15) DOWNTO (8 * I + 8)) <= O((8 * I + 2)) & O((8 * I + 1)) & O((8 * I + 7)) & O((8 * I + 6)) & O((8 * I + 4)) & O((8 * I + 0)) & O((8 * I + 3)) & O((8 * I + 5));
		END GENERATE;

		Y <= O(31 DOWNTO 27) & O(25) & O(26) & O(24);	
	END GENERATE;
	-------------------------------------------------------------------------------
	
END Dataflow;

-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.FORKSKINNYPKG.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY SBoxInverse IS	
	GENERIC (BS : BLOCK_SIZE);
	PORT ( X : IN	STD_LOGIC_VECTOR ((GET_WORD_SIZE(BS) - 1) DOWNTO 0);
          Y : OUT	STD_LOGIC_VECTOR ((GET_WORD_SIZE(BS) - 1) DOWNTO 0));
END SBoxInverse;


-- ARCHITECTURE : DATAFLOW
----------------------------------------------------------------------------------
ARCHITECTURE Dataflow OF SBoxInverse IS

	-- SIGNALS --------------------------------------------------------------------
	SIGNAL NO3, XO3, NO2, XO2, NO1, XO1, NO0, XO0 : STD_LOGIC;
	SIGNAL O, P: STD_LOGIC_VECTOR(39 DOWNTO 0);

-- DATAFLOW
----------------------------------------------------------------------------------
BEGIN

	-- 4-BIT S-BOX ----------------------------------------------------------------
	S4 : IF BS = BLOCK_SIZE_64 GENERATE
        -- X1 = Y0+NOR(Y2, Y3)
		NO1 <= X(3) NOR X(2);
		XO1 <= X(0) XOR NO1;
		
        -- X2 = Y1+NOR(X1, Y3)
		NO2 <= XO1 NOR X(3);
		XO2 <= X(1) XOR NO2;
		
        -- X3 = Y2+NOR(X2, X1)
		NO3 <= XO2 NOR XO1;
		XO3 <= X(2) XOR NO3;
		
        -- X0 = Y3+NOR(X3, X2)
		NO0 <= XO3 NOR XO2;
		XO0 <= X(3) XOR NO0;
		
		Y <= XO3 & XO2 & XO1 & XO0; -- Computed bits separately, now concatenate
	END GENERATE;
	-------------------------------------------------------------------------------
	
	-- 8-BIT S-BOX ----------------------------------------------------------------
	S8 : IF BS = BLOCK_SIZE_128 GENERATE
        
        -- Bit swap between x1 and x2
        O(39 downto 32) <= X(7 DOWNTO 3) & X(1) & X(2) & X(0); -- Inverse permutation is its own inverse

		--GEN : FOR I IN 0 TO 3 GENERATE
		GEN : FOR I IN 3 DOWNTO 0 GENERATE

            -- Invert this one layer of transformation (is its own inverse)
			P((8 * I +  7) DOWNTO (8 * I + 4)) <= O((8 * I + 15) DOWNTO (8 * I + 13)) & (O(8 * I + 12) XOR (O(8 * I + 15) NOR O(8 * I + 14)));
			P((8 * I +  3) DOWNTO (8 * I + 0)) <= O((8 * I + 11) DOWNTO (8 * I + 9)) & (O(8 * I + 8) XOR (O(8 * I + 11) NOR O(8 * I + 10)));		

            -- Inverted bit permutation (last result is discarded)
			O((8 * I + 7) DOWNTO (8 * I + 0)) <= P((8 * I + 5)) & P((8 * I + 4)) & P((8 * I + 0)) & P((8 * I + 3)) & P((8 * I + 1)) & P((8 * I + 7)) & P((8 * I + 6)) & P((8 * I + 2));

		END GENERATE;

        Y <= P(7 downto 0);

	END GENERATE;
	-------------------------------------------------------------------------------
	
END Dataflow;

----------------------------------------------------------------------------------
-- Copyright 2016:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
--
-- Copyright 2019 (for modifications):
--     Antoon Purnal for the ForkAE team
--     https://www.esat.kuleuven.be/cosic/forkae/
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
----------------------------------------------------------------------------------

-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.FORKSKINNYPKG.ALL;


-- Round function, fully combinational
ENTITY RoundFunction IS
	GENERIC (BS : BLOCK_SIZE; TS : TWEAK_SIZE);
	PORT ( CLK				: IN  STD_LOGIC;
			 -- CONTROL PORTS --------------------------------
			 CONST				: IN	STD_LOGIC_VECTOR(6 downto 0);
			 -- KEY PORT -------------------------------------
			 ROUND_KEY		: IN	STD_LOGIC_VECTOR((GET_TWEAK_SIZE(BS, TS) - 1) DOWNTO 0);
			 ROUND_IN		: IN	STD_LOGIC_VECTOR((GET_BLOCK_SIZE(BS) 	  - 1) DOWNTO 0);
			 ROUND_OUT		: OUT	STD_LOGIC_VECTOR((GET_BLOCK_SIZE(BS)	  - 1) DOWNTO 0));
END RoundFunction;



-- ARCHITECTURE : MIXED
----------------------------------------------------------------------------------
ARCHITECTURE Mixed OF RoundFunction IS

	-- CONSTANTS ------------------------------------------------------------------
	CONSTANT N : INTEGER := GET_BLOCK_SIZE(BS);
	CONSTANT T : INTEGER := GET_TWEAK_SIZE(BS, TS);
	CONSTANT W : INTEGER := GET_WORD_SIZE(BS);
	
	-- SIGNALS --------------------------------------------------------------------
	SIGNAL NEXT_STATE, KEY_ADDITION,
			 CONST_ADDITION, SUBSTITUTION, SHIFTROWS	: STD_LOGIC_VECTOR((N - 1) DOWNTO 0);

	-- MixColumns -----------------------------------------------------------------
	SIGNAL C1_X2X0, C2_X2X0, C3_X2X0, C4_X2X0	: STD_LOGIC_VECTOR((W - 1) DOWNTO 0);
	SIGNAL C1_X2X1, C2_X2X1, C3_X2X1, C4_X2X1	: STD_LOGIC_VECTOR((W - 1) DOWNTO 0);

BEGIN

	-- S-BOX ----------------------------------------------------------------------
	GEN : FOR I IN 0 TO 15 GENERATE
		S : ENTITY work.SBox GENERIC MAP (BS => BS) PORT MAP (ROUND_IN((W * (I + 1) - 1) DOWNTO (W * I)), SUBSTITUTION((W * (I + 1) - 1) DOWNTO (W * I)));
	END GENERATE;
	-------------------------------------------------------------------------------

	-- ADD CONSTANTS --------------------------------------------------------------
	N64 : IF BS = BLOCK_SIZE_64 GENERATE
		CONST_ADDITION(63 DOWNTO 60) <= SUBSTITUTION(63 DOWNTO 60) XOR CONST(3 DOWNTO 0);
		CONST_ADDITION(59 DOWNTO 54) <= SUBSTITUTION(59 DOWNTO 54);
        CONST_ADDITION(53) 	     	  <= NOT(SUBSTITUTION(53)); -- Bit to indicate tweakey material
		CONST_ADDITION(52 DOWNTO 47) <= SUBSTITUTION(52 DOWNTO 47);
		CONST_ADDITION(46 DOWNTO 44) <= SUBSTITUTION(46 DOWNTO 44) XOR CONST(6 DOWNTO 4);
		CONST_ADDITION(43 DOWNTO 30) <= SUBSTITUTION(43 DOWNTO 30);
        CONST_ADDITION(29) 	     	  <= NOT(SUBSTITUTION(29)); -- This is the XOR with c2 = 2
		CONST_ADDITION(28 DOWNTO  0) <= SUBSTITUTION(28 DOWNTO  0);
	END GENERATE;
	
	N128 : IF BS = BLOCK_SIZE_128 GENERATE
		CONST_ADDITION(127 DOWNTO 124) <= SUBSTITUTION(127 DOWNTO 124);
		CONST_ADDITION(123 DOWNTO 120) <= SUBSTITUTION(123 DOWNTO 120) XOR CONST(3 DOWNTO 0);
		CONST_ADDITION(119 DOWNTO  106) <= SUBSTITUTION(119 DOWNTO  106);
        CONST_ADDITION(105) 	     	  <= NOT(SUBSTITUTION(105)); -- Bit to indicate tweakey material
		CONST_ADDITION(104 DOWNTO  91) <= SUBSTITUTION(104 DOWNTO  91);
		CONST_ADDITION( 90 DOWNTO  88) <= SUBSTITUTION( 90 DOWNTO  88) XOR CONST(6 DOWNTO 4);
		CONST_ADDITION( 87 DOWNTO  58) <= SUBSTITUTION( 87 DOWNTO  58);
		CONST_ADDITION(57) 	    	    <= NOT(SUBSTITUTION(57)); -- This is the XOR with c2 = 2
		CONST_ADDITION( 56 DOWNTO   0) <= SUBSTITUTION( 56 DOWNTO   0);	
	END GENERATE;
	-------------------------------------------------------------------------------


	-- SUBKEY ADDITION ------------------------------------------------------------
	T2N : IF TS = TWEAK_SIZE_2N GENERATE
		KEY_ADDITION((16 * W - 1) DOWNTO (12 * W)) <= CONST_ADDITION((16 * W - 1) DOWNTO (12 * W)) XOR ROUND_KEY((1 * N + 16 * W - 1) DOWNTO (1 * N + 12 * W)) XOR ROUND_KEY((16 * W - 1) DOWNTO (12 * W));
		KEY_ADDITION((12 * W - 1) DOWNTO ( 8 * W)) <= CONST_ADDITION((12 * W - 1) DOWNTO ( 8 * W)) XOR ROUND_KEY((1 * N + 12 * W - 1) DOWNTO (1 * N +  8 * W)) XOR ROUND_KEY((12 * W - 1) DOWNTO ( 8 * W));	
	END GENERATE;

    T3o2N: if TS = TWEAK_SIZE_3o2N generate
        -- ROUND_KEY = [TK1 & TK2], where TK1 is 191 downto 64; TK2 is 63 downto 0
        -- The TK2 part will be zeroed out for odd rounds (this happens in ForkSkinnyRB.vhd)
		KEY_ADDITION((16 * W - 1) DOWNTO (12 * W)) <= CONST_ADDITION((16 * W - 1) DOWNTO (12 * W)) XOR ROUND_KEY((1 * N + 8 * W - 1) DOWNTO (1 * N + 4 * W)) XOR ROUND_KEY((8 * W - 1) DOWNTO (4 * W));
		KEY_ADDITION((12 * W - 1) DOWNTO ( 8 * W)) <= CONST_ADDITION((12 * W - 1) DOWNTO ( 8 * W)) XOR ROUND_KEY((1 * N + 4 * W - 1) DOWNTO (1 * N +  0 * W)) XOR ROUND_KEY((4 * W - 1) DOWNTO ( 0 * W));	
    end generate;


    T9o4N: if TS = TWEAK_SIZE_9o4N generate
        -- ROUND_KEY = [TK1 & TK2 & TK3], where TK1 is 319 downto 192; TK2 is 191 downto 64; TK3 is 63 downto 0
        -- The TK3 part will be zeroed out for odd rounds (this happens in ForkSkinnyRB.vhd)
		KEY_ADDITION((16 * W - 1) DOWNTO (12 * W)) <= CONST_ADDITION((16 * W - 1) DOWNTO (12 * W)) XOR ROUND_KEY((2 * N + 8 * W - 1) DOWNTO (2 * N + 4 * W)) XOR ROUND_KEY((1 * N + 8 * W - 1) DOWNTO (1 * N + 4 * W)) XOR ROUND_KEY((8 * W - 1) DOWNTO (4 * W));
		KEY_ADDITION((12 * W - 1) DOWNTO ( 8 * W)) <= CONST_ADDITION((12 * W - 1) DOWNTO ( 8 * W)) XOR ROUND_KEY((2 * N + 4 * W - 1) DOWNTO (2 * N + 0 * W)) XOR ROUND_KEY((1 * N + 4 * W - 1) DOWNTO (1 * N +  0 * W)) XOR ROUND_KEY((4 * W - 1) DOWNTO ( 0 * W));	
    end generate;

	
	T3N : IF TS = TWEAK_SIZE_3N GENERATE 
		KEY_ADDITION((16 * W - 1) DOWNTO (12 * W)) <= CONST_ADDITION((16 * W - 1) DOWNTO (12 * W)) XOR ROUND_KEY((2 * N + 16 * W - 1) DOWNTO (2 * N + 12 * W)) XOR ROUND_KEY((1 * N + 16 * W - 1) DOWNTO (1 * N + 12 * W)) XOR ROUND_KEY((16 * W - 1) DOWNTO (12 * W));
		KEY_ADDITION((12 * W - 1) DOWNTO ( 8 * W)) <= CONST_ADDITION((12 * W - 1) DOWNTO ( 8 * W)) XOR ROUND_KEY((2 * N + 12 * W - 1) DOWNTO (2 * N +  8 * W)) XOR ROUND_KEY((1 * N + 12 * W - 1) DOWNTO (1 * N +  8 * W)) XOR ROUND_KEY((12 * W - 1) DOWNTO ( 8 * W));	
	END GENERATE;
	
	KEY_ADDITION(( 8 * W - 1) DOWNTO ( 4 * W)) <= CONST_ADDITION(( 8 * W - 1) DOWNTO ( 4 * W));
	KEY_ADDITION(( 4 * W - 1) DOWNTO ( 0 * W)) <= CONST_ADDITION(( 4 * W - 1) DOWNTO ( 0 * W));
	-------------------------------------------------------------------------------
	
	-- SHIFT ROWS -----------------------------------------------------------------
	SHIFTROWS((16 * W - 1) DOWNTO (12 * W)) <= KEY_ADDITION((16 * W - 1) DOWNTO (12 * W));
	SHIFTROWS((12 * W - 1) DOWNTO ( 8 * W)) <= KEY_ADDITION(( 9 * W - 1) DOWNTO ( 8 * W)) & KEY_ADDITION((12 * W - 1) DOWNTO ( 9 * W));
	SHIFTROWS(( 8 * W - 1) DOWNTO ( 4 * W)) <= KEY_ADDITION(( 6 * W - 1) DOWNTO ( 4 * W)) & KEY_ADDITION(( 8 * W - 1) DOWNTO ( 6 * W));
	SHIFTROWS(( 4 * W - 1) DOWNTO ( 0 * W)) <= KEY_ADDITION(( 3 * W - 1) DOWNTO ( 0 * W)) & KEY_ADDITION(( 4 * W - 1) DOWNTO ( 3 * W));
	-------------------------------------------------------------------------------


    -- MIX COLUMNS ----------------------------------------------------------------

	-- X2 XOR X1 
	C1_X2X1 <= SHIFTROWS((12 * W - 1) DOWNTO (11 * W)) XOR SHIFTROWS(( 8 * W - 1) DOWNTO ( 7 * W));
	C2_X2X1 <= SHIFTROWS((11 * W - 1) DOWNTO (10 * W)) XOR SHIFTROWS(( 7 * W - 1) DOWNTO ( 6 * W));
	C3_X2X1 <= SHIFTROWS((10 * W - 1) DOWNTO ( 9 * W)) XOR SHIFTROWS(( 6 * W - 1) DOWNTO ( 5 * W));
	C4_X2X1 <= SHIFTROWS(( 9 * W - 1) DOWNTO ( 8 * W)) XOR SHIFTROWS(( 5 * W - 1) DOWNTO ( 4 * W));

	-- X2 XOR X0 
	C1_X2X0 <= SHIFTROWS((16 * W - 1) DOWNTO (15 * W)) XOR SHIFTROWS(( 8 * W - 1) DOWNTO ( 7 * W));
	C2_X2X0 <= SHIFTROWS((15 * W - 1) DOWNTO (14 * W)) XOR SHIFTROWS(( 7 * W - 1) DOWNTO ( 6 * W));
	C3_X2X0 <= SHIFTROWS((14 * W - 1) DOWNTO (13 * W)) XOR SHIFTROWS(( 6 * W - 1) DOWNTO ( 5 * W));
	C4_X2X0 <= SHIFTROWS((13 * W - 1) DOWNTO (12 * W)) XOR SHIFTROWS(( 5 * W - 1) DOWNTO ( 4 * W));
	
	-- COLUMN 1
	NEXT_STATE((16 * W - 1) DOWNTO (15 * W)) <= C1_X2X0 XOR SHIFTROWS(( 4 * W - 1) DOWNTO ( 3 * W));
	NEXT_STATE((12 * W - 1) DOWNTO (11 * W)) <= SHIFTROWS((16 * W - 1) DOWNTO (15 * W));
	NEXT_STATE(( 8 * W - 1) DOWNTO ( 7 * W)) <= C1_X2X1;
	NEXT_STATE(( 4 * W - 1) DOWNTO ( 3 * W)) <= C1_X2X0;

	-- COLUMN 2
	NEXT_STATE((15 * W - 1) DOWNTO (14 * W)) <= C2_X2X0 XOR SHIFTROWS(( 3 * W - 1) DOWNTO ( 2 * W));
	NEXT_STATE((11 * W - 1) DOWNTO (10 * W)) <= SHIFTROWS((15 * W - 1) DOWNTO (14 * W));
	NEXT_STATE(( 7 * W - 1) DOWNTO ( 6 * W)) <= C2_X2X1;
	NEXT_STATE(( 3 * W - 1) DOWNTO ( 2 * W)) <= C2_X2X0;
	
	-- COLUMN 3
	NEXT_STATE((14 * W - 1) DOWNTO (13 * W)) <= C3_X2X0 XOR SHIFTROWS(( 2 * W - 1) DOWNTO ( 1 * W));
	NEXT_STATE((10 * W - 1) DOWNTO ( 9 * W)) <= SHIFTROWS((14 * W - 1) DOWNTO (13 * W));
	NEXT_STATE(( 6 * W - 1) DOWNTO ( 5 * W)) <= C3_X2X1;
	NEXT_STATE(( 2 * W - 1) DOWNTO ( 1 * W)) <= C3_X2X0;
	
	-- COLUMN 4
	NEXT_STATE((13 * W - 1) DOWNTO (12 * W)) <= C4_X2X0 XOR SHIFTROWS(( 1 * W - 1) DOWNTO ( 0 * W));
	NEXT_STATE(( 9 * W - 1) DOWNTO ( 8 * W)) <= SHIFTROWS((13 * W - 1) DOWNTO (12 * W));
	NEXT_STATE(( 5 * W - 1) DOWNTO ( 4 * W)) <= C4_X2X1;
	NEXT_STATE(( 1 * W - 1) DOWNTO ( 0 * W)) <= C4_X2X0;
	-------------------------------------------------------------------------------
	
	-- ROUND OUTPUT ---------------------------------------------------------------
	ROUND_OUT <= NEXT_STATE;
	-------------------------------------------------------------------------------
	
END Mixed;


----------------------------------------------------------------------------------
-- Copyright 2019 (for modifications):
--     Antoon Purnal for the ForkAE team
--     https://www.esat.kuleuven.be/cosic/forkae/
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
----------------------------------------------------------------------------------

-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.FORKSKINNYPKG.ALL;

-- Inverse round function, fully combinational
ENTITY InverseRoundFunction IS	
	GENERIC (BS : BLOCK_SIZE; TS : TWEAK_SIZE);
	PORT ( CLK				: IN  STD_LOGIC;
			 -- CONTROL PORTS --------------------------------
			 CONST			: IN  STD_LOGIC_VECTOR(6 DOWNTO 0);
			 -- KEY PORT -------------------------------------
			 ROUND_KEY		: IN	STD_LOGIC_VECTOR((GET_TWEAK_SIZE(BS, TS) - 1) DOWNTO 0);
			 ROUND_IN		: IN	STD_LOGIC_VECTOR((GET_BLOCK_SIZE(BS)	  - 1) DOWNTO 0);
			 ROUND_OUT		: OUT	STD_LOGIC_VECTOR((GET_BLOCK_SIZE(BS)	  - 1) DOWNTO 0));
END InverseRoundFunction;



-- ARCHITECTURE : MIXED
----------------------------------------------------------------------------------
ARCHITECTURE Mixed OF InverseRoundFunction IS

	-- CONSTANTS ------------------------------------------------------------------
	CONSTANT N : INTEGER := GET_BLOCK_SIZE(BS);
	CONSTANT W : INTEGER := GET_WORD_SIZE(BS);

	-- SIGNALS --------------------------------------------------------------------
	SIGNAL CONST_ADDITION, KEY_ADDITION, MIXCOLUMNS, SHIFTROWS	: STD_LOGIC_VECTOR((N - 1) DOWNTO 0); -- Intermediates
	SIGNAL C1_Y1Y3, C2_Y1Y3, C3_Y1Y3, C4_Y1Y3: STD_LOGIC_VECTOR((W - 1) DOWNTO 0);
	SIGNAL C1_Y0Y3, C2_Y0Y3, C3_Y0Y3, C4_Y0Y3: STD_LOGIC_VECTOR((W - 1) DOWNTO 0);

BEGIN

	-- INVERSE MIX COLUMNS ----------------------------------------------------------------

		-- Y0 XOR Y3 ---------------------------------------------------------------
		C1_Y0Y3 <= ROUND_IN((16 * W - 1) DOWNTO (15 * W)) XOR ROUND_IN(( 4 * W - 1) DOWNTO ( 3 * W));
		C2_Y0Y3 <= ROUND_IN((15 * W - 1) DOWNTO (14 * W)) XOR ROUND_IN(( 3 * W - 1) DOWNTO ( 2 * W));
		C3_Y0Y3 <= ROUND_IN((14 * W - 1) DOWNTO (13 * W)) XOR ROUND_IN(( 2 * W - 1) DOWNTO ( 1 * W));
		C4_Y0Y3 <= ROUND_IN((13 * W - 1) DOWNTO (12 * W)) XOR ROUND_IN(( 1 * W - 1) DOWNTO ( 0 * W));
		----------------------------------------------------------------------------

		-- Y1 XOR Y3 ---------------------------------------------------------------
		C1_Y1Y3 <= ROUND_IN((12 * W - 1) DOWNTO (11 * W)) XOR ROUND_IN(( 4 * W - 1) DOWNTO ( 3 * W));
		C2_Y1Y3 <= ROUND_IN((11 * W - 1) DOWNTO (10 * W)) XOR ROUND_IN(( 3 * W - 1) DOWNTO ( 2 * W));
		C3_Y1Y3 <= ROUND_IN((10 * W - 1) DOWNTO (9 * W)) XOR ROUND_IN(( 2 * W - 1) DOWNTO ( 1 * W));
		C4_Y1Y3 <= ROUND_IN((9 * W - 1) DOWNTO (8 * W)) XOR ROUND_IN(( 1 * W - 1) DOWNTO ( 0 * W));
		----------------------------------------------------------------------------
		
		-- COLUMN 1 ----------------------------------------------------------------
		MIXCOLUMNS((16 * W - 1) DOWNTO (15 * W)) <= ROUND_IN((12 * W - 1) DOWNTO (11 * W));
		MIXCOLUMNS((12 * W - 1) DOWNTO (11 * W)) <= C1_Y1Y3 XOR ROUND_IN(( 8 * W - 1) DOWNTO ( 7 * W));
		MIXCOLUMNS(( 8 * W - 1) DOWNTO ( 7 * W)) <= C1_Y1Y3;
		MIXCOLUMNS(( 4 * W - 1) DOWNTO ( 3 * W)) <= C1_Y0Y3;
		----------------------------------------------------------------------------

		-- COLUMN 2 ----------------------------------------------------------------
		MIXCOLUMNS((15 * W - 1) DOWNTO (14 * W)) <= ROUND_IN((11 * W - 1) DOWNTO (10 * W));
		MIXCOLUMNS((11 * W - 1) DOWNTO (10 * W)) <= C2_Y1Y3 XOR ROUND_IN(( 7 * W - 1) DOWNTO ( 6 * W));
		MIXCOLUMNS(( 7 * W - 1) DOWNTO ( 6 * W)) <= C2_Y1Y3;
		MIXCOLUMNS(( 3 * W - 1) DOWNTO ( 2 * W)) <= C2_Y0Y3;
		----------------------------------------------------------------------------
		
		-- COLUMN 3 ----------------------------------------------------------------
		MIXCOLUMNS((14 * W - 1) DOWNTO (13 * W)) <= ROUND_IN((10 * W - 1) DOWNTO (9 * W));
		MIXCOLUMNS((10 * W - 1) DOWNTO (9 * W)) <= C3_Y1Y3 XOR ROUND_IN(( 6 * W - 1) DOWNTO ( 5 * W));
		MIXCOLUMNS(( 6 * W - 1) DOWNTO ( 5 * W)) <= C3_Y1Y3;
		MIXCOLUMNS(( 2 * W - 1) DOWNTO ( 1 * W)) <= C3_Y0Y3;
		----------------------------------------------------------------------------

		-- COLUMN 4 ----------------------------------------------------------------
		MIXCOLUMNS((13 * W - 1) DOWNTO (12 * W)) <= ROUND_IN((9 * W - 1) DOWNTO (8 * W));
		MIXCOLUMNS((9 * W - 1) DOWNTO (8 * W)) <= C4_Y1Y3 XOR ROUND_IN(( 5 * W - 1) DOWNTO ( 4 * W));
		MIXCOLUMNS(( 5 * W - 1) DOWNTO ( 4 * W)) <= C4_Y1Y3;
		MIXCOLUMNS(( 1 * W - 1) DOWNTO ( 0 * W)) <= C4_Y0Y3;
		----------------------------------------------------------------------------

        -- INVERSE SHIFT ROWS -----------------------------------------------------------------
		-- ROW 1 --------------------------------------------------------------------
		-- No changes.
		SHIFTROWS((16 * W - 1) DOWNTO (12 * W)) <= MIXCOLUMNS((16 * W - 1) DOWNTO (12 * W));
		----------------------------------------------------------------------------
		
		-- ROW 2 -------------------------------------------------------------------
		-- Shift one cell to the LEFT.
		SHIFTROWS((12 * W - 1) DOWNTO ( 8 * W)) <= MIXCOLUMNS(( 11 * W - 1) DOWNTO ( 8 * W)) & MIXCOLUMNS((12 * W - 1) DOWNTO ( 11 * W));
		----------------------------------------------------------------------------
		
		-- ROW 3 -------------------------------------------------------------------
		-- Shift two cells to the LEFT.
		SHIFTROWS(( 8 * W - 1) DOWNTO ( 4 * W)) <= MIXCOLUMNS(( 6 * W - 1) DOWNTO ( 4 * W)) & MIXCOLUMNS(( 8 * W - 1) DOWNTO ( 6 * W));
		----------------------------------------------------------------------------
		
		-- ROW 4 -------------------------------------------------------------------
		-- Shift three cells to the LEFT.
		SHIFTROWS(( 4 * W - 1) DOWNTO ( 0 * W)) <= MIXCOLUMNS(( 1 * W - 1) DOWNTO ( 0 * W)) & MIXCOLUMNS(( 4 * W - 1) DOWNTO ( 1 * W));
		----------------------------------------------------------------------------
		
	-------------------------------------------------------------------------------

    -- INVERSE SUBKEY ADDITION ------------------------------------------------------------
    -- Note: identical to encryption.
    -- Add the round subkey to the top two rows. Depending on the tweakey size, XOR once twice or thrice.
	T2N : IF TS = TWEAK_SIZE_2N GENERATE
		KEY_ADDITION((16 * W - 1) DOWNTO (12 * W)) <= SHIFTROWS((16 * W - 1) DOWNTO (12 * W)) XOR ROUND_KEY((1 * N + 16 * W - 1) DOWNTO (1 * N + 12 * W)) XOR ROUND_KEY((16 * W - 1) DOWNTO (12 * W));
		KEY_ADDITION((12 * W - 1) DOWNTO ( 8 * W)) <= SHIFTROWS((12 * W - 1) DOWNTO ( 8 * W)) XOR ROUND_KEY((1 * N + 12 * W - 1) DOWNTO (1 * N +  8 * W)) XOR ROUND_KEY((12 * W - 1) DOWNTO ( 8 * W));	
	END GENERATE;

    T3o2N: if TS = TWEAK_SIZE_3o2N generate
        -- ROUND_KEY = [TK1 & TK2], where TK1 is 191 downto 64; TK2 is 63 downto 0
        -- The TK2 part will be zeroed out for odd rounds (this happens in ForkSkinnyRB.vhd)
		KEY_ADDITION((16 * W - 1) DOWNTO (12 * W)) <= SHIFTROWS((16 * W - 1) DOWNTO (12 * W)) XOR ROUND_KEY((1 * N + 8 * W - 1) DOWNTO (1 * N + 4 * W)) XOR ROUND_KEY((8 * W - 1) DOWNTO (4 * W));
		KEY_ADDITION((12 * W - 1) DOWNTO ( 8 * W)) <= SHIFTROWS((12 * W - 1) DOWNTO ( 8 * W)) XOR ROUND_KEY((1 * N + 4 * W - 1) DOWNTO (1 * N +  0 * W)) XOR ROUND_KEY((4 * W - 1) DOWNTO ( 0 * W));	
    end generate;

    T9o4N: if TS = TWEAK_SIZE_9o4N generate
        -- ROUND_KEY = [TK1 & TK2 & TK3], where TK1 is 319 downto 192; TK2 is 191 downto 64; TK3 is 63 downto 0
        -- The TK3 part will be zeroed out for odd rounds (this happens in ForkSkinnyRB.vhd)
		KEY_ADDITION((16 * W - 1) DOWNTO (12 * W)) <= SHIFTROWS((16 * W - 1) DOWNTO (12 * W)) XOR ROUND_KEY((2 * N + 8 * W - 1) DOWNTO (2 * N + 4 * W)) XOR ROUND_KEY((1 * N + 8 * W - 1) DOWNTO (1 * N + 4 * W)) XOR ROUND_KEY((8 * W - 1) DOWNTO (4 * W));
		KEY_ADDITION((12 * W - 1) DOWNTO ( 8 * W)) <= SHIFTROWS((12 * W - 1) DOWNTO ( 8 * W)) XOR ROUND_KEY((2 * N + 4 * W - 1) DOWNTO (2 * N + 0 * W)) XOR ROUND_KEY((1 * N + 4 * W - 1) DOWNTO (1 * N +  0 * W)) XOR ROUND_KEY((4 * W - 1) DOWNTO ( 0 * W));	
    end generate;
	
	T3N : IF TS = TWEAK_SIZE_3N GENERATE
		KEY_ADDITION((16 * W - 1) DOWNTO (12 * W)) <= SHIFTROWS((16 * W - 1) DOWNTO (12 * W)) XOR ROUND_KEY((2 * N + 16 * W - 1) DOWNTO (2 * N + 12 * W)) XOR ROUND_KEY((1 * N + 16 * W - 1) DOWNTO (1 * N + 12 * W)) XOR ROUND_KEY((16 * W - 1) DOWNTO (12 * W));
		KEY_ADDITION((12 * W - 1) DOWNTO ( 8 * W)) <= SHIFTROWS((12 * W - 1) DOWNTO ( 8 * W)) XOR ROUND_KEY((2 * N + 12 * W - 1) DOWNTO (2 * N +  8 * W)) XOR ROUND_KEY((1 * N + 12 * W - 1) DOWNTO (1 * N +  8 * W)) XOR ROUND_KEY((12 * W - 1) DOWNTO ( 8 * W));	
	END GENERATE;
	
    --  Bottom two rows are unchanged.
	KEY_ADDITION(( 8 * W - 1) DOWNTO ( 4 * W)) <= SHIFTROWS(( 8 * W - 1) DOWNTO ( 4 * W));
	KEY_ADDITION(( 4 * W - 1) DOWNTO ( 0 * W)) <= SHIFTROWS(( 4 * W - 1) DOWNTO ( 0 * W));
	-------------------------------------------------------------------------------

	-- INVERSE CONSTANT ADDITION ----------------------------------------------------------
    -- Note: identical to encryption.
    -- Add round constant (c0, c1, c2), where c2 is fixed and c0, c1 are contained in the input CONST
	N64 : IF BS = BLOCK_SIZE_64 GENERATE
		CONST_ADDITION(63 DOWNTO 60) <= KEY_ADDITION(63 DOWNTO 60) XOR CONST(3 DOWNTO 0); -- Round constant c0
		CONST_ADDITION(59 DOWNTO 54) <= KEY_ADDITION(59 DOWNTO 54);
        CONST_ADDITION(53) 	     	  <= NOT(KEY_ADDITION(53)); -- Bit to indicate tweakey material
		CONST_ADDITION(52 DOWNTO 47) <= KEY_ADDITION(52 DOWNTO 47);
		CONST_ADDITION(46 DOWNTO 44) <= KEY_ADDITION(46 DOWNTO 44) XOR CONST(6 DOWNTO 4); -- Round constant c1
		CONST_ADDITION(43 DOWNTO 30) <= KEY_ADDITION(43 DOWNTO 30);
        CONST_ADDITION(29) 	     	  <= NOT(KEY_ADDITION(29)); -- XOR with c2 = 2
		CONST_ADDITION(28 DOWNTO  0) <= KEY_ADDITION(28 DOWNTO  0);
	END GENERATE;
	
	N128 : IF BS = BLOCK_SIZE_128 GENERATE
		CONST_ADDITION(127 DOWNTO 124) <= KEY_ADDITION(127 DOWNTO 124);
		CONST_ADDITION(123 DOWNTO 120) <= KEY_ADDITION(123 DOWNTO 120) XOR CONST(3 DOWNTO 0);
		CONST_ADDITION(119 DOWNTO  106) <= KEY_ADDITION(119 DOWNTO  106);
        CONST_ADDITION(105) 	     	  <= NOT(KEY_ADDITION(105)); -- Bit to indicate tweakey material
		CONST_ADDITION(104 DOWNTO  91) <= KEY_ADDITION(104 DOWNTO  91);
		CONST_ADDITION( 90 DOWNTO  88) <= KEY_ADDITION( 90 DOWNTO  88) XOR CONST(6 DOWNTO 4);
		CONST_ADDITION( 87 DOWNTO  58) <= KEY_ADDITION( 87 DOWNTO  58);
		CONST_ADDITION(57) 	    	    <= NOT(KEY_ADDITION(57)); -- This is the XOR with c2 = 2
		CONST_ADDITION( 56 DOWNTO   0) <= KEY_ADDITION( 56 DOWNTO   0);	
	END GENERATE;
	-------------------------------------------------------------------------------

	-- INVERSE S-BOX ----------------------------------------------------------------------
	-- Simply apply inverse SBox to every cell of the state
	GEN : FOR I IN 0 TO 15 GENERATE
		S : ENTITY work.SBoxInverse GENERIC MAP (BS => BS) PORT MAP (CONST_ADDITION((W * (I + 1) - 1) DOWNTO (W * I)), ROUND_OUT((W * (I + 1) - 1) DOWNTO (W * I)));
	END GENERATE;
	-------------------------------------------------------------------------------

END Mixed;


----------------------------------------------------------------------------------
-- Copyright 2016:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
--
-- Copyright 2019 (for modifications):
--     Antoon Purnal for the ForkAE team
--     https://www.esat.kuleuven.be/cosic/forkae/
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
----------------------------------------------------------------------------------

-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.ForkSKINNYPKG.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY Permutation is
	GENERIC (BS : BLOCK_SIZE);
	PORT ( X : IN  STD_LOGIC_VECTOR ((GET_BLOCK_SIZE(BS) - 1) DOWNTO 0);
          Y : OUT STD_LOGIC_VECTOR ((GET_BLOCK_SIZE(BS) - 1) DOWNTO 0));
END Permutation;



-- ARCHITECTURE : DATAFLOW
----------------------------------------------------------------------------------
ARCHITECTURE Dataflow OF Permutation IS

	-- CONSTANTS ------------------------------------------------------------------
	CONSTANT W : INTEGER := GET_WORD_SIZE(BS);
	
BEGIN

	-- ROW 1 ----------------------------------------------------------------------
	Y((16 * W - 1) DOWNTO (15 * W)) <= X(( 7 * W - 1) DOWNTO ( 6 * W));
	Y((15 * W - 1) DOWNTO (14 * W)) <= X(( 1 * W - 1) DOWNTO ( 0 * W));
	Y((14 * W - 1) DOWNTO (13 * W)) <= X(( 8 * W - 1) DOWNTO ( 7 * W));
	Y((13 * W - 1) DOWNTO (12 * W)) <= X(( 3 * W - 1) DOWNTO ( 2 * W));
	-------------------------------------------------------------------------------

	-- ROW 2 ----------------------------------------------------------------------	
	Y((12 * W - 1) DOWNTO (11 * W)) <= X(( 6 * W - 1) DOWNTO ( 5 * W));
	Y((11 * W - 1) DOWNTO (10 * W)) <= X(( 2 * W - 1) DOWNTO ( 1 * W));
	Y((10 * W - 1) DOWNTO ( 9 * W)) <= X(( 4 * W - 1) DOWNTO ( 3 * W));
	Y(( 9 * W - 1) DOWNTO ( 8 * W)) <= X(( 5 * W - 1) DOWNTO ( 4 * W));
	-------------------------------------------------------------------------------

	-- ROW 3 ----------------------------------------------------------------------	
	Y(( 8 * W - 1) DOWNTO ( 7 * W)) <= X((16 * W - 1) DOWNTO (15 * W));
	Y(( 7 * W - 1) DOWNTO ( 6 * W)) <= X((15 * W - 1) DOWNTO (14 * W));
	Y(( 6 * W - 1) DOWNTO ( 5 * W)) <= X((14 * W - 1) DOWNTO (13 * W));
	Y(( 5 * W - 1) DOWNTO ( 4 * W)) <= X((13 * W - 1) DOWNTO (12 * W));
	-------------------------------------------------------------------------------

	-- ROW 4 ----------------------------------------------------------------------	
	Y(( 4 * W - 1) DOWNTO ( 3 * W)) <= X((12 * W - 1) DOWNTO (11 * W));
	Y(( 3 * W - 1) DOWNTO ( 2 * W)) <= X((11 * W - 1) DOWNTO (10 * W));
	Y(( 2 * W - 1) DOWNTO ( 1 * W)) <= X((10 * W - 1) DOWNTO ( 9 * W));
	Y(( 1 * W - 1) DOWNTO ( 0 * W)) <= X(( 9 * W - 1) DOWNTO ( 8 * W));
	-------------------------------------------------------------------------------

END Dataflow;


-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.ForkSKINNYPKG.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY InversePermutation is
	GENERIC (BS : BLOCK_SIZE);
	PORT ( X : IN  STD_LOGIC_VECTOR ((GET_BLOCK_SIZE(BS) - 1) DOWNTO 0);
          Y : OUT STD_LOGIC_VECTOR ((GET_BLOCK_SIZE(BS) - 1) DOWNTO 0));
END InversePermutation;



-- ARCHITECTURE : DATAFLOW
----------------------------------------------------------------------------------
-- This is permutation P_T. Mind the I/O order: cell 9 goes to 0, cell 15 goes to 1, ...
-- Recall also that state [0 1 2 3; 4 5 6 7; 8 9 10 11; 12 13 14 15] is encoded as [0 1 2 3 ... 14 15] where 0 has the highest indices.
ARCHITECTURE Dataflow OF InversePermutation IS

	-- CONSTANTS ------------------------------------------------------------------
	CONSTANT W : INTEGER := GET_WORD_SIZE(BS);
	
BEGIN


	-- ROW 1 ----------------------------------------------------------------------
	Y(( 16 * W - 1) DOWNTO ( 15 * W)) <= X((8 * W - 1) DOWNTO (7 * W));
	Y(( 15 * W - 1) DOWNTO ( 14 * W)) <= X((7 * W - 1) DOWNTO (6 * W));
	Y(( 14 * W - 1) DOWNTO ( 13 * W)) <= X((6 * W - 1) DOWNTO (5 * W));
	Y(( 13 * W - 1) DOWNTO ( 12 * W)) <= X((5 * W - 1) DOWNTO (4 * W));
	-------------------------------------------------------------------------------

	-- ROW 2 ----------------------------------------------------------------------	
	Y((12 * W - 1) DOWNTO (11 * W)) <= X(( 4 * W - 1) DOWNTO ( 3 * W));
	Y((11 * W - 1) DOWNTO (10 * W)) <= X(( 3 * W - 1) DOWNTO ( 2 * W));
	Y((10 * W - 1) DOWNTO ( 9 * W)) <= X(( 2 * W - 1) DOWNTO ( 1 * W));
	Y(( 9 * W - 1) DOWNTO ( 8 * W)) <= X(( 1 * W - 1) DOWNTO ( 0 * W));
	-------------------------------------------------------------------------------


	-- ROW 3 ----------------------------------------------------------------------	
	Y(( 8 * W - 1) DOWNTO ( 7 * W)) <= X((14 * W - 1) DOWNTO (13 * W));
	Y(( 7 * W - 1) DOWNTO ( 6 * W)) <= X((16 * W - 1) DOWNTO (15 * W));
	Y(( 6 * W - 1) DOWNTO ( 5 * W)) <= X((12 * W - 1) DOWNTO (11 * W));
	Y(( 5 * W - 1) DOWNTO ( 4 * W)) <= X((9 * W - 1) DOWNTO (8 * W));
	-------------------------------------------------------------------------------

	-- ROW 4 ----------------------------------------------------------------------	
	Y(( 4 * W - 1) DOWNTO ( 3 * W)) <= X((10 * W - 1) DOWNTO (9 * W));
	Y(( 3 * W - 1) DOWNTO ( 2 * W)) <= X((13 * W - 1) DOWNTO (12 * W));
	Y(( 2 * W - 1) DOWNTO ( 1 * W)) <= X((11 * W - 1) DOWNTO ( 10 * W));
	Y(( 1 * W - 1) DOWNTO ( 0 * W)) <= X((15 * W - 1) DOWNTO ( 14 * W));
	-------------------------------------------------------------------------------

END Dataflow;

-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.ForkSKINNYPKG.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY HalfPermutation is
	GENERIC (BS : BLOCK_SIZE);
	PORT ( X : IN  STD_LOGIC_VECTOR ((GET_BLOCK_SIZE(BS)/2 - 1) DOWNTO 0);
          Y : OUT STD_LOGIC_VECTOR ((GET_BLOCK_SIZE(BS)/2 - 1) DOWNTO 0));
END HalfPermutation;



-- ARCHITECTURE : DATAFLOW
----------------------------------------------------------------------------------
ARCHITECTURE Dataflow OF HalfPermutation IS

	-- CONSTANTS ------------------------------------------------------------------
	CONSTANT W : INTEGER := GET_WORD_SIZE(BS);
	
BEGIN

    -- Permutation: [1, 7, 0, 5, 2, 6, 4, 3]
	Y((8 * W - 1) downto (7 * W)) <= X((7 * W - 1) downto (6 * W));
	Y((7 * W - 1) downto (6 * W)) <= X((1 * W - 1) downto (0 * W));
	Y((6 * W - 1) downto (5 * W)) <= X((8 * W - 1) downto (7 * W));
	Y((5 * W - 1) downto (4 * W)) <= X((3 * W - 1) downto (2 * W));
	Y((4 * W - 1) downto (3 * W)) <= X((6 * W - 1) downto (5 * W));
	Y((3 * W - 1) downto (2 * W)) <= X((2 * W - 1) downto (1 * W));
	Y((2 * W - 1) downto (1 * W)) <= X((4 * W - 1) downto (3 * W));
	Y((1 * W - 1) downto (0 * W)) <= X((5 * W - 1) downto (4 * W));

END Dataflow;


-- IMPORTS
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

USE WORK.ForkSKINNYPKG.ALL;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY InverseHalfPermutation is
	GENERIC (BS : BLOCK_SIZE);
	PORT ( X : IN  STD_LOGIC_VECTOR ((GET_BLOCK_SIZE(BS)/2 - 1) DOWNTO 0);
          Y : OUT STD_LOGIC_VECTOR ((GET_BLOCK_SIZE(BS)/2 - 1) DOWNTO 0));
END InverseHalfPermutation;


-- ARCHITECTURE : DATAFLOW
----------------------------------------------------------------------------------
ARCHITECTURE Dataflow OF InverseHalfPermutation IS

	-- CONSTANTS ------------------------------------------------------------------
	CONSTANT W : INTEGER := GET_WORD_SIZE(BS);
	
BEGIN
    -- Permutation: [2, 0, 4, 7, 6, 3, 5, 1]
	Y((8 * W - 1) downto (7 * W)) <= X((6 * W - 1) downto (5 * W));
	Y((7 * W - 1) downto (6 * W)) <= X((8 * W - 1) downto (7 * W));
	Y((6 * W - 1) downto (5 * W)) <= X((4 * W - 1) downto (3 * W));
	Y((5 * W - 1) downto (4 * W)) <= X((1 * W - 1) downto (0 * W));
	Y((4 * W - 1) downto (3 * W)) <= X((2 * W - 1) downto (1 * W));
	Y((3 * W - 1) downto (2 * W)) <= X((5 * W - 1) downto (4 * W));
	Y((2 * W - 1) downto (1 * W)) <= X((3 * W - 1) downto (2 * W));
	Y((1 * W - 1) downto (0 * W)) <= X((7 * W - 1) downto (6 * W));
END Dataflow;



----------------------------------------------------------------------------------
-- Copyright 2016:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
--
-- Copyright 2019 (for decryption and forkcipher):
--     Antoon Purnal for the ForkAE team
--     https://www.esat.kuleuven.be/cosic/forkae/
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
----------------------------------------------------------------------------------


-- Key schedules: unrolled to give synthesis tool maximal freedom


------------------------
-- Forward Key Schedule
------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.Forkskinnypkg.all;

ENTITY ForwardKeySchedule IS
	GENERIC (BS : BLOCK_SIZE; TS : TWEAK_SIZE);
    PORT ( KEY			: IN  STD_LOGIC_VECTOR ((GET_TWEAK_SIZE(BS, TS) - 1) DOWNTO 0);
           NEXT_KEY	: OUT STD_LOGIC_VECTOR ((GET_TWEAK_SIZE(BS, TS) - 1) DOWNTO 0));
END ForwardKeySchedule;


ARCHITECTURE behav OF ForwardKeySchedule IS

	-- CONSTANTS ------------------------------------------------------------------
	CONSTANT N : INTEGER := GET_BLOCK_SIZE(BS);
	CONSTANT T : INTEGER := GET_TWEAK_SIZE(BS, TS);
	CONSTANT W : INTEGER := GET_WORD_SIZE(BS);
	
	-- SIGNALS --------------------------------------------------------------------
	SIGNAL PERMUTED_KEY: STD_LOGIC_VECTOR((T - 1) DOWNTO 0);

BEGIN

	-- TWEAKEY ARRAY PERMUTATIONS : TK1 -------------------------------------------

		-- PERMUTATION -------------------------------------------------------------
		P1 : ENTITY work.Permutation
		GENERIC MAP (BS => BS) PORT MAP (
			KEY ((T - 0 * N - 1) DOWNTO (T - 1 * N)), 
			PERMUTED_KEY((T - 0 * N - 1) DOWNTO (T - 1 * N))
		); 
		
		-- NO LFSR -----------------------------------------------------------------
		NEXT_KEY((T - 0 * N - 1) DOWNTO (T - 1 * N)) <= PERMUTED_KEY((T - 0 * N - 1) DOWNTO (T - 1 * N));
		
	-------------------------------------------------------------------------------
	
	-- TWEAKEY ARRAY PERMUTATIONS : TK2 -------------------------------------------
	TK2 : IF TS = TWEAK_SIZE_2N OR TS = TWEAK_SIZE_3N or TS = TWEAK_SIZE_9o4N GENERATE 
	
		-- PERMUTATION -------------------------------------------------------------
		P2 : ENTITY work.Permutation
		GENERIC MAP (BS => BS) PORT MAP (
			KEY ((T - 1 * N - 1) DOWNTO (T - 2 * N)), 
			PERMUTED_KEY((T - 1 * N - 1) DOWNTO (T - 2 * N))
		); 
		
		-- LFSR --------------------------------------------------------------------
		LFSR2 : FOR I IN 0 TO 3 GENERATE
			NEXT_KEY((T + W * (I + 13) - 2 * N - 1) DOWNTO (T + W * (I + 12) - 2 * N)) <= PERMUTED_KEY((T + W * (I + 13) - 2 * N - 2) DOWNTO (T + W * (I + 12) - 2 * N)) & (PERMUTED_KEY(T + W * (I + 13) - 2 * N - 1) XOR PERMUTED_KEY(T + W * (I + 13) - 2 * N - (W / 4) - 1));
			NEXT_KEY((T + W * (I +  9) - 2 * N - 1) DOWNTO (T + W * (I +  8) - 2 * N)) <= PERMUTED_KEY((T + W * (I +  9) - 2 * N - 2) DOWNTO (T + W * (I +  8) - 2 * N)) & (PERMUTED_KEY(T + W * (I +  9) - 2 * N - 1) XOR PERMUTED_KEY(T + W * (I +  9) - 2 * N - (W / 4) - 1));
			NEXT_KEY((T + W * (I +  5) - 2 * N - 1) DOWNTO (T + W * (I +  4) - 2 * N)) <= PERMUTED_KEY((T + W * (I +  5) - 2 * N - 1) DOWNTO (T + W * (I +  4) - 2 * N));
			NEXT_KEY((T + W * (I +  1) - 2 * N - 1) DOWNTO (T + W * (I +  0) - 2 * N)) <= PERMUTED_KEY((T + W * (I +  1) - 2 * N - 1) DOWNTO (T + W * (I +  0) - 2 * N));		
		END GENERATE;
		
	END GENERATE;

    TK3o2 : if TS = TWEAK_SIZE_3o2N generate 

		-- PERMUTATION -------------------------------------------------------------
		P2 : ENTITY work.HalfPermutation
		GENERIC MAP (BS => BS) PORT MAP (
			KEY (63 DOWNTO 0), 
			PERMUTED_KEY(63 DOWNTO 0)
		); 

		-- LFSR --------------------------------------------------------------------
		LFSR2 : FOR I IN 0 TO 3 GENERATE
        NEXT_KEY((W * (I + 5) - 1) DOWNTO (W * (I + 4))) <= PERMUTED_KEY((W * (I + 5) - 2) DOWNTO (W * (I + 4))) & (PERMUTED_KEY(W * (I + 5) - 1) XOR PERMUTED_KEY(W * (I + 5) - (W / 4) - 1));
        NEXT_KEY((W * (I + 1) - 1) DOWNTO (W * (I + 0))) <= PERMUTED_KEY((W * (I + 1) - 2) DOWNTO (W * (I + 0))) & (PERMUTED_KEY(W * (I + 1) - 1) XOR PERMUTED_KEY(W * (I + 1) - (W / 4) - 1));
		END GENERATE;

    end generate;
	-------------------------------------------------------------------------------
	
	-- TWEAKEY ARRAY PERMUTATIONS : TK3 -------------------------------------------
	TK3 : IF TS = TWEAK_SIZE_3N GENERATE 
	
		-- PERMUTATION -------------------------------------------------------------
		P3 : ENTITY work.Permutation
		GENERIC MAP (BS => BS) PORT MAP (
			KEY ((T - 2 * N - 1) DOWNTO (T - 3 * N)),
			PERMUTED_KEY((T - 2 * N - 1) DOWNTO (T - 3 * N))
		); 
	
		-- LFSR --------------------------------------------------------------------
		LFSR3 : FOR I IN 0 TO 3 GENERATE
			NEXT_KEY((T + W * (I + 13) - 3 * N - 1) DOWNTO (T + W * (I + 12) - 3 * N)) <= (PERMUTED_KEY(T + W * (I + 12) - 3 * N) XOR PERMUTED_KEY(T + W * (I + 13) - 3 * N - (W / 4))) & PERMUTED_KEY((T + W * (I + 13) - 3 * N - 1) DOWNTO (T + W * (I + 12) - 3 * N + 1));
			NEXT_KEY((T + W * (I +  9) - 3 * N - 1) DOWNTO (T + W * (I +  8) - 3 * N)) <= (PERMUTED_KEY(T + W * (I +  8) - 3 * N) XOR PERMUTED_KEY(T + W * (I +  9) - 3 * N - (W / 4))) & PERMUTED_KEY((T + W * (I +  9) - 3 * N - 1) DOWNTO (T + W * (I +  8) - 3 * N + 1));
			NEXT_KEY((T + W * (I +  5) - 3 * N - 1) DOWNTO (T + W * (I +  4) - 3 * N)) <= PERMUTED_KEY((T + W * (I +  5) - 3 * N - 1) DOWNTO (T + W * (I +  4) - 3 * N));
			NEXT_KEY((T + W * (I +  1) - 3 * N - 1) DOWNTO (T + W * (I +  0) - 3 * N)) <= PERMUTED_KEY((T + W * (I +  1) - 3 * N - 1) DOWNTO (T + W * (I +  0) - 3 * N));		
		END GENERATE;
		
	END GENERATE;


	TK9o4N : IF TS = TWEAK_SIZE_9o4N GENERATE 
	
		-- PERMUTATION -------------------------------------------------------------
		P3 : ENTITY work.HalfPermutation
		GENERIC MAP (BS => BS) PORT MAP (
			KEY (63 DOWNTO 0),
			PERMUTED_KEY(63 DOWNTO 0)
		); 
	
		-- LFSR --------------------------------------------------------------------
		LFSR3 : FOR I IN 0 TO 3 GENERATE
			NEXT_KEY((W * (I + 5) - 1) DOWNTO (W * (I + 4))) <= (PERMUTED_KEY(W * (I + 4)) XOR PERMUTED_KEY(W * (I + 5) - (W / 4))) & PERMUTED_KEY((W * (I + 5) - 1) DOWNTO (W * (I + 4) + 1));
			NEXT_KEY((W * (I + 1) - 1) DOWNTO (W * (I + 0))) <= (PERMUTED_KEY(W * (I + 0)) XOR PERMUTED_KEY(W * (I + 1) - (W / 4))) & PERMUTED_KEY((W * (I + 1) - 1) DOWNTO (W * (I + 0) + 1));
		END GENERATE;
		
	END GENERATE;
	-------------------------------------------------------------------------------
	
END behav;




------------------------
-- Inverse Key Schedule
------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.forkskinnypkg.all;

ENTITY InverseKeySchedule IS
	GENERIC (BS : BLOCK_SIZE; TS : TWEAK_SIZE);
    PORT ( KEY			: IN  STD_LOGIC_VECTOR ((GET_TWEAK_SIZE(BS, TS) - 1) DOWNTO 0);
           NEXT_KEY	: OUT STD_LOGIC_VECTOR ((GET_TWEAK_SIZE(BS, TS) - 1) DOWNTO 0));
END InverseKeySchedule;



-- ARCHITECTURE : MIXED
----------------------------------------------------------------------------------
ARCHITECTURE behav OF InverseKeySchedule IS

	-- CONSTANTS ------------------------------------------------------------------
	CONSTANT N : INTEGER := GET_BLOCK_SIZE(BS);
	CONSTANT T : INTEGER := GET_TWEAK_SIZE(BS, TS);
	CONSTANT W : INTEGER := GET_WORD_SIZE(BS);
	
	-- SIGNALS --------------------------------------------------------------------
	SIGNAL LFSR	: STD_LOGIC_VECTOR((T - 1) DOWNTO 0);

BEGIN

	-- TWEAKEY ARRAY PERMUTATIONS : TK1 -------------------------------------------

		-- NO LFSR -----------------------------------------------------------------
		
		-- INVERSE PERMUTATION ----------------------------------------------------
		P1 : ENTITY work.InversePermutation
		GENERIC MAP (BS => BS) PORT MAP (
			KEY ((T - 0 * N - 1) DOWNTO (T - 1 * N)), 
			NEXT_KEY((T - 0 * N - 1) DOWNTO (T - 1 * N))
		); 
		
		
	-------------------------------------------------------------------------------
	
	-- TWEAKEY ARRAY PERMUTATIONS : TK2 -------------------------------------------
	TK2 : IF TS = TWEAK_SIZE_2N OR TS = TWEAK_SIZE_3N or TS = TWEAK_SIZE_9o4N GENERATE 

        -- INVERSE LFSR 2 = FORWARD LFSR 3 ----------------------------------------
        -- LFSR one column I at a time.
		LFSR3 : FOR I IN 0 TO 3 GENERATE
            -- Top rows enter the LFSR
			LFSR((T + W * (I + 13) - 2 * N - 1) DOWNTO (T + W * (I + 12) - 2 * N)) <= (KEY(T + W * (I + 12) - 2 * N) XOR KEY(T + W * (I + 13) - 2 * N - (W / 4))) & KEY((T + W * (I + 13) - 2 * N - 1) DOWNTO (T + W * (I + 12) - 2 * N + 1));
			LFSR((T + W * (I +  9) - 2 * N - 1) DOWNTO (T + W * (I +  8) - 2 * N)) <= (KEY(T + W * (I +  8) - 2 * N) XOR KEY(T + W * (I +  9) - 2 * N - (W / 4))) & KEY((T + W * (I +  9) - 2 * N - 1) DOWNTO (T + W * (I +  8) - 2 * N + 1));
            -- Bottom rows don't enter the LFSR.
			LFSR((T + W * (I +  5) - 2 * N - 1) DOWNTO (T + W * (I +  4) - 2 * N)) <= KEY((T + W * (I +  5) - 2 * N - 1) DOWNTO (T + W * (I +  4) - 2 * N));
			LFSR((T + W * (I +  1) - 2 * N - 1) DOWNTO (T + W * (I +  0) - 2 * N)) <= KEY((T + W * (I +  1) - 2 * N - 1) DOWNTO (T + W * (I +  0) - 2 * N));		
		END GENERATE;
	
		-- INVERSE PERMUTATION ----------------------------------------------------
		P2 : ENTITY work.InversePermutation
		GENERIC MAP (BS => BS) PORT MAP (
			LFSR ((T - 1 * N - 1) DOWNTO (T - 2 * N)), 
			NEXT_KEY((T - 1 * N - 1) DOWNTO (T - 2 * N))
		); 
		
	END GENERATE;

    TK3o2 : IF TS = TWEAK_SIZE_3o2N GENERATE 

        -- INVERSE LFSR 2 = FORWARD LFSR 3 ----------------------------------------
		LFSR3 : FOR I IN 0 TO 3 GENERATE
			LFSR((W * (I + 5) - 1) DOWNTO (W * (I + 4))) <= (KEY(W * (I + 4)) XOR KEY(W * (I + 5) - (W / 4))) & KEY((W * (I + 5) - 1) DOWNTO (W * (I + 4) + 1));
			LFSR((W * (I + 1) - 1) DOWNTO (W * (I + 0))) <= (KEY(W * (I + 0)) XOR KEY(W * (I + 1) - (W / 4))) & KEY((W * (I + 1) - 1) DOWNTO (W * (I + 0) + 1));
		END GENERATE;
	
		-- INVERSE PERMUTATION ----------------------------------------------------
		P2 : ENTITY work.InverseHalfPermutation
		GENERIC MAP (BS => BS) PORT MAP (
			LFSR (63 downto 0), 
			NEXT_KEY(63 downto 0)
		); 
		
	END GENERATE;

	-------------------------------------------------------------------------------
	
	-- TWEAKEY ARRAY PERMUTATIONS : TK3 -------------------------------------------
	TK3 : IF TS = TWEAK_SIZE_3N GENERATE 
	
        -- INVERSE LFSR 3 = FORWARD LFSR 2 ----------------------------------------
        -- LFSR one column I at a time.
		LFSR2 : FOR I IN 0 TO 3 GENERATE
            -- Top rows enter the LFSR
			LFSR((T + W * (I + 13) - 3 * N - 1) DOWNTO (T + W * (I + 12) - 3 * N)) <= KEY((T + W * (I + 13) - 3 * N - 2) DOWNTO (T + W * (I + 12) - 3 * N)) & (KEY(T + W * (I + 13) - 3 * N - 1) XOR KEY(T + W * (I + 13) - 3 * N - (W / 4) - 1));
			LFSR((T + W * (I +  9) - 3 * N - 1) DOWNTO (T + W * (I +  8) - 3 * N)) <= KEY((T + W * (I +  9) - 3 * N - 2) DOWNTO (T + W * (I +  8) - 3 * N)) & (KEY(T + W * (I +  9) - 3 * N - 1) XOR KEY(T + W * (I +  9) - 3 * N - (W / 4) - 1));
            -- Bottom rows don't enter the LFSR.
			LFSR((T + W * (I +  5) - 3 * N - 1) DOWNTO (T + W * (I +  4) - 3 * N)) <= KEY((T + W * (I +  5) - 3 * N - 1) DOWNTO (T + W * (I +  4) - 3 * N));
			LFSR((T + W * (I +  1) - 3 * N - 1) DOWNTO (T + W * (I +  0) - 3 * N)) <= KEY((T + W * (I +  1) - 3 * N - 1) DOWNTO (T + W * (I +  0) - 3 * N));		
		END GENERATE;

		-- INVERSE PERMUTATION ----------------------------------------------------
		P3 : ENTITY work.InversePermutation
		GENERIC MAP (BS => BS) PORT MAP (
			LFSR ((T - 2 * N - 1) DOWNTO (T - 3 * N)),
			NEXT_KEY((T - 2 * N - 1) DOWNTO (T - 3 * N))
		); 
		
	END GENERATE;


    TK9o4 : IF TS = TWEAK_SIZE_9o4N GENERATE 

        -- INVERSE LFSR 3 = FORWARD LFSR 2 ----------------------------------------
		LFSR3 : FOR I IN 0 TO 3 GENERATE
            LFSR((W * (I + 5) - 1) DOWNTO (W * (I + 4))) <= KEY((W * (I + 5) - 2) DOWNTO (W * (I + 4))) & (KEY(W * (I + 5) - 1) XOR KEY(W * (I + 5) - (W / 4) - 1));
            LFSR((W * (I + 1) - 1) DOWNTO (W * (I + 0))) <= KEY((W * (I + 1) - 2) DOWNTO (W * (I + 0))) & (KEY(W * (I + 1) - 1) XOR KEY(W * (I + 1) - (W / 4) - 1));
		END GENERATE;
	
		-- INVERSE PERMUTATION ----------------------------------------------------
		P2 : ENTITY work.InverseHalfPermutation
		GENERIC MAP (BS => BS) PORT MAP (
			LFSR (63 downto 0), 
			NEXT_KEY(63 downto 0)
		); 
		
	END GENERATE;
	-------------------------------------------------------------------------------
	
END behav;




--------------------------
-- Compute decryption key
--------------------------
library ieee;
use ieee.std_logic_1164.all;

use work.forkskinnypkg.all;

ENTITY DecryptionKey IS
	GENERIC (BS : BLOCK_SIZE; TS : TWEAK_SIZE);
    PORT ( KEY			: IN  STD_LOGIC_VECTOR ((GET_TWEAK_SIZE(BS, TS) - 1) DOWNTO 0);
           NEXT_KEY	: OUT STD_LOGIC_VECTOR ((GET_TWEAK_SIZE(BS, TS) - 1) DOWNTO 0));
END DecryptionKey;


ARCHITECTURE behav OF DecryptionKey IS

	-- CONSTANTS ------------------------------------------------------------------
	CONSTANT N : INTEGER := GET_BLOCK_SIZE(BS);
	CONSTANT T : INTEGER := GET_TWEAK_SIZE(BS, TS);
	CONSTANT W : INTEGER := GET_WORD_SIZE(BS);
	
	-- SIGNALS --------------------------------------------------------------------
	SIGNAL TK1, TK2, TK2_PERMUTED, TK3, TK3_PERMUTED          : STD_LOGIC_VECTOR((N - 1) DOWNTO 0);

BEGIN
    B64T192: if BS = BLOCK_SIZE_64 generate

        -- TK1: compute TK1^40
		TK1 <= KEY(191 downto 128);

        -- Generating the following permutation: [5, 6, 3, 2, 7, 0, 1, 4, 13, 14, 11, 10, 15, 8, 9, 12]
        NEXT_KEY((128 + 16 * W - 1) downto (128 + 15 * W)) <= TK1((11 * W - 1) downto (10 * W));
        NEXT_KEY((128 + 15 * W - 1) downto (128 + 14 * W)) <= TK1((10 * W - 1) downto (9 * W));
        NEXT_KEY((128 + 14 * W - 1) downto (128 + 13 * W)) <= TK1((13 * W - 1) downto (12 * W));
        NEXT_KEY((128 + 13 * W - 1) downto (128 + 12 * W)) <= TK1((14 * W - 1) downto (13 * W));
        NEXT_KEY((128 + 12 * W - 1) downto (128 + 11 * W)) <= TK1((9 * W - 1) downto (8 * W));
        NEXT_KEY((128 + 11 * W - 1) downto (128 + 10 * W)) <= TK1((16 * W - 1) downto (15 * W));
        NEXT_KEY((128 + 10 * W - 1) downto (128 + 9 * W)) <= TK1((15 * W - 1) downto (14 * W));
        NEXT_KEY((128 + 9 * W - 1) downto (128 + 8 * W)) <= TK1((12 * W - 1) downto (11 * W));
        NEXT_KEY((128 + 8 * W - 1) downto (128 + 7 * W)) <= TK1((3 * W - 1) downto (2 * W));
        NEXT_KEY((128 + 7 * W - 1) downto (128 + 6 * W)) <= TK1((2 * W - 1) downto (1 * W));
        NEXT_KEY((128 + 6 * W - 1) downto (128 + 5 * W)) <= TK1((5 * W - 1) downto (4 * W));
        NEXT_KEY((128 + 5 * W - 1) downto (128 + 4 * W)) <= TK1((6 * W - 1) downto (5 * W));
        NEXT_KEY((128 + 4 * W - 1) downto (128 + 3 * W)) <= TK1((1 * W - 1) downto (0 * W));
        NEXT_KEY((128 + 3 * W - 1) downto (128 + 2 * W)) <= TK1((8 * W - 1) downto (7 * W));
        NEXT_KEY((128 + 2 * W - 1) downto (128 + 1 * W)) <= TK1((7 * W - 1) downto (6 * W));
        NEXT_KEY((128 + 1 * W - 1) downto (128 + 0 * W)) <= TK1((4 * W - 1) downto (3 * W));


        -- TK2: compute TK2^40
        TK2 <= KEY(127 downto 64);

        -- Generating the following permutation: [5, 6, 3, 2, 7, 0, 1, 4, 13, 14, 11, 10, 15, 8, 9, 12]
        TK2_PERMUTED((16 * W - 1) downto (15 * W)) <= TK2((11 * W - 1) downto (10 * W));
        TK2_PERMUTED((15 * W - 1) downto (14 * W)) <= TK2((10 * W - 1) downto (9 * W));
        TK2_PERMUTED((14 * W - 1) downto (13 * W)) <= TK2((13 * W - 1) downto (12 * W));
        TK2_PERMUTED((13 * W - 1) downto (12 * W)) <= TK2((14 * W - 1) downto (13 * W));
        TK2_PERMUTED((12 * W - 1) downto (11 * W)) <= TK2((9 * W - 1) downto (8 * W));
        TK2_PERMUTED((11 * W - 1) downto (10 * W)) <= TK2((16 * W - 1) downto (15 * W));
        TK2_PERMUTED((10 * W - 1) downto (9 * W)) <= TK2((15 * W - 1) downto (14 * W));
        TK2_PERMUTED((9 * W - 1) downto (8 * W)) <= TK2((12 * W - 1) downto (11 * W));
        TK2_PERMUTED((8 * W - 1) downto (7 * W)) <= TK2((3 * W - 1) downto (2 * W));
        TK2_PERMUTED((7 * W - 1) downto (6 * W)) <= TK2((2 * W - 1) downto (1 * W));
        TK2_PERMUTED((6 * W - 1) downto (5 * W)) <= TK2((5 * W - 1) downto (4 * W));
        TK2_PERMUTED((5 * W - 1) downto (4 * W)) <= TK2((6 * W - 1) downto (5 * W));
        TK2_PERMUTED((4 * W - 1) downto (3 * W)) <= TK2((1 * W - 1) downto (0 * W));
        TK2_PERMUTED((3 * W - 1) downto (2 * W)) <= TK2((8 * W - 1) downto (7 * W));
        TK2_PERMUTED((2 * W - 1) downto (1 * W)) <= TK2((7 * W - 1) downto (6 * W));
        TK2_PERMUTED((1 * W - 1) downto (0 * W)) <= TK2((4 * W - 1) downto (3 * W));

        -- Upper half of the state
        NEXT_KEY(99 downto 96) <= ( TK2_PERMUTED(33) xor TK2_PERMUTED(34) ) & ( TK2_PERMUTED(32) xor TK2_PERMUTED(33) ) & ( TK2_PERMUTED(32) xor TK2_PERMUTED(34) xor TK2_PERMUTED(35) ) & ( TK2_PERMUTED(33) xor TK2_PERMUTED(35) );
        NEXT_KEY(103 downto 100) <= ( TK2_PERMUTED(37) xor TK2_PERMUTED(38) ) & ( TK2_PERMUTED(36) xor TK2_PERMUTED(37) ) & ( TK2_PERMUTED(36) xor TK2_PERMUTED(38) xor TK2_PERMUTED(39) ) & ( TK2_PERMUTED(37) xor TK2_PERMUTED(39) );
        NEXT_KEY(107 downto 104) <= ( TK2_PERMUTED(41) xor TK2_PERMUTED(42) ) & ( TK2_PERMUTED(40) xor TK2_PERMUTED(41) ) & ( TK2_PERMUTED(40) xor TK2_PERMUTED(42) xor TK2_PERMUTED(43) ) & ( TK2_PERMUTED(41) xor TK2_PERMUTED(43) );
        NEXT_KEY(111 downto 108) <= ( TK2_PERMUTED(45) xor TK2_PERMUTED(46) ) & ( TK2_PERMUTED(44) xor TK2_PERMUTED(45) ) & ( TK2_PERMUTED(44) xor TK2_PERMUTED(46) xor TK2_PERMUTED(47) ) & ( TK2_PERMUTED(45) xor TK2_PERMUTED(47) );
        NEXT_KEY(115 downto 112) <= ( TK2_PERMUTED(49) xor TK2_PERMUTED(50) ) & ( TK2_PERMUTED(48) xor TK2_PERMUTED(49) ) & ( TK2_PERMUTED(48) xor TK2_PERMUTED(50) xor TK2_PERMUTED(51) ) & ( TK2_PERMUTED(49) xor TK2_PERMUTED(51) );
        NEXT_KEY(119 downto 116) <= ( TK2_PERMUTED(53) xor TK2_PERMUTED(54) ) & ( TK2_PERMUTED(52) xor TK2_PERMUTED(53) ) & ( TK2_PERMUTED(52) xor TK2_PERMUTED(54) xor TK2_PERMUTED(55) ) & ( TK2_PERMUTED(53) xor TK2_PERMUTED(55) );
        NEXT_KEY(123 downto 120) <= ( TK2_PERMUTED(57) xor TK2_PERMUTED(58) ) & ( TK2_PERMUTED(56) xor TK2_PERMUTED(57) ) & ( TK2_PERMUTED(56) xor TK2_PERMUTED(58) xor TK2_PERMUTED(59) ) & ( TK2_PERMUTED(57) xor TK2_PERMUTED(59) );
        NEXT_KEY(127 downto 124) <= ( TK2_PERMUTED(61) xor TK2_PERMUTED(62) ) & ( TK2_PERMUTED(60) xor TK2_PERMUTED(61) ) & ( TK2_PERMUTED(60) xor TK2_PERMUTED(62) xor TK2_PERMUTED(63) ) & ( TK2_PERMUTED(61) xor TK2_PERMUTED(63) );
        -- Lower half of the state
        NEXT_KEY(67 downto 64) <= ( TK2_PERMUTED(1) xor TK2_PERMUTED(2) ) & ( TK2_PERMUTED(0) xor TK2_PERMUTED(1) ) & ( TK2_PERMUTED(0) xor TK2_PERMUTED(2) xor TK2_PERMUTED(3) ) & ( TK2_PERMUTED(1) xor TK2_PERMUTED(3) );
        NEXT_KEY(71 downto 68) <= ( TK2_PERMUTED(5) xor TK2_PERMUTED(6) ) & ( TK2_PERMUTED(4) xor TK2_PERMUTED(5) ) & ( TK2_PERMUTED(4) xor TK2_PERMUTED(6) xor TK2_PERMUTED(7) ) & ( TK2_PERMUTED(5) xor TK2_PERMUTED(7) );
        NEXT_KEY(75 downto 72) <= ( TK2_PERMUTED(9) xor TK2_PERMUTED(10) ) & ( TK2_PERMUTED(8) xor TK2_PERMUTED(9) ) & ( TK2_PERMUTED(8) xor TK2_PERMUTED(10) xor TK2_PERMUTED(11) ) & ( TK2_PERMUTED(9) xor TK2_PERMUTED(11) );
        NEXT_KEY(79 downto 76) <= ( TK2_PERMUTED(13) xor TK2_PERMUTED(14) ) & ( TK2_PERMUTED(12) xor TK2_PERMUTED(13) ) & ( TK2_PERMUTED(12) xor TK2_PERMUTED(14) xor TK2_PERMUTED(15) ) & ( TK2_PERMUTED(13) xor TK2_PERMUTED(15) );
        NEXT_KEY(83 downto 80) <= ( TK2_PERMUTED(17) xor TK2_PERMUTED(18) ) & ( TK2_PERMUTED(16) xor TK2_PERMUTED(17) ) & ( TK2_PERMUTED(16) xor TK2_PERMUTED(18) xor TK2_PERMUTED(19) ) & ( TK2_PERMUTED(17) xor TK2_PERMUTED(19) );
        NEXT_KEY(87 downto 84) <= ( TK2_PERMUTED(21) xor TK2_PERMUTED(22) ) & ( TK2_PERMUTED(20) xor TK2_PERMUTED(21) ) & ( TK2_PERMUTED(20) xor TK2_PERMUTED(22) xor TK2_PERMUTED(23) ) & ( TK2_PERMUTED(21) xor TK2_PERMUTED(23) );
        NEXT_KEY(91 downto 88) <= ( TK2_PERMUTED(25) xor TK2_PERMUTED(26) ) & ( TK2_PERMUTED(24) xor TK2_PERMUTED(25) ) & ( TK2_PERMUTED(24) xor TK2_PERMUTED(26) xor TK2_PERMUTED(27) ) & ( TK2_PERMUTED(25) xor TK2_PERMUTED(27) );
        NEXT_KEY(95 downto 92) <= ( TK2_PERMUTED(29) xor TK2_PERMUTED(30) ) & ( TK2_PERMUTED(28) xor TK2_PERMUTED(29) ) & ( TK2_PERMUTED(28) xor TK2_PERMUTED(30) xor TK2_PERMUTED(31) ) & ( TK2_PERMUTED(29) xor TK2_PERMUTED(31) );
        

        -- TK3: compute TK3^40
        TK3 <= KEY(63 downto 0);

        -- Generating the following permutation: [5, 6, 3, 2, 7, 0, 1, 4, 13, 14, 11, 10, 15, 8, 9, 12]
        TK3_PERMUTED((16 * W - 1) downto (15 * W)) <= TK3((11 * W - 1) downto (10 * W));
        TK3_PERMUTED((15 * W - 1) downto (14 * W)) <= TK3((10 * W - 1) downto (9 * W));
        TK3_PERMUTED((14 * W - 1) downto (13 * W)) <= TK3((13 * W - 1) downto (12 * W));
        TK3_PERMUTED((13 * W - 1) downto (12 * W)) <= TK3((14 * W - 1) downto (13 * W));
        TK3_PERMUTED((12 * W - 1) downto (11 * W)) <= TK3((9 * W - 1) downto (8 * W));
        TK3_PERMUTED((11 * W - 1) downto (10 * W)) <= TK3((16 * W - 1) downto (15 * W));
        TK3_PERMUTED((10 * W - 1) downto (9 * W)) <= TK3((15 * W - 1) downto (14 * W));
        TK3_PERMUTED((9 * W - 1) downto (8 * W)) <= TK3((12 * W - 1) downto (11 * W));
        TK3_PERMUTED((8 * W - 1) downto (7 * W)) <= TK3((3 * W - 1) downto (2 * W));
        TK3_PERMUTED((7 * W - 1) downto (6 * W)) <= TK3((2 * W - 1) downto (1 * W));
        TK3_PERMUTED((6 * W - 1) downto (5 * W)) <= TK3((5 * W - 1) downto (4 * W));
        TK3_PERMUTED((5 * W - 1) downto (4 * W)) <= TK3((6 * W - 1) downto (5 * W));
        TK3_PERMUTED((4 * W - 1) downto (3 * W)) <= TK3((1 * W - 1) downto (0 * W));
        TK3_PERMUTED((3 * W - 1) downto (2 * W)) <= TK3((8 * W - 1) downto (7 * W));
        TK3_PERMUTED((2 * W - 1) downto (1 * W)) <= TK3((7 * W - 1) downto (6 * W));
        TK3_PERMUTED((1 * W - 1) downto (0 * W)) <= TK3((4 * W - 1) downto (3 * W));

        -- Upper half of the state
        NEXT_KEY(35 downto 32) <= ( TK3_PERMUTED(33) xor TK3_PERMUTED(34) xor TK3_PERMUTED(35) ) & ( TK3_PERMUTED(32) xor TK3_PERMUTED(33) xor TK3_PERMUTED(34) ) & ( TK3_PERMUTED(32) xor TK3_PERMUTED(33) xor TK3_PERMUTED(34) xor TK3_PERMUTED(35) ) & ( TK3_PERMUTED(32) xor TK3_PERMUTED(33) xor TK3_PERMUTED(35) );
        NEXT_KEY(39 downto 36) <= ( TK3_PERMUTED(37) xor TK3_PERMUTED(38) xor TK3_PERMUTED(39) ) & ( TK3_PERMUTED(36) xor TK3_PERMUTED(37) xor TK3_PERMUTED(38) ) & ( TK3_PERMUTED(36) xor TK3_PERMUTED(37) xor TK3_PERMUTED(38) xor TK3_PERMUTED(39) ) & ( TK3_PERMUTED(36) xor TK3_PERMUTED(37) xor TK3_PERMUTED(39) );
        NEXT_KEY(43 downto 40) <= ( TK3_PERMUTED(41) xor TK3_PERMUTED(42) xor TK3_PERMUTED(43) ) & ( TK3_PERMUTED(40) xor TK3_PERMUTED(41) xor TK3_PERMUTED(42) ) & ( TK3_PERMUTED(40) xor TK3_PERMUTED(41) xor TK3_PERMUTED(42) xor TK3_PERMUTED(43) ) & ( TK3_PERMUTED(40) xor TK3_PERMUTED(41) xor TK3_PERMUTED(43) );
        NEXT_KEY(47 downto 44) <= ( TK3_PERMUTED(45) xor TK3_PERMUTED(46) xor TK3_PERMUTED(47) ) & ( TK3_PERMUTED(44) xor TK3_PERMUTED(45) xor TK3_PERMUTED(46) ) & ( TK3_PERMUTED(44) xor TK3_PERMUTED(45) xor TK3_PERMUTED(46) xor TK3_PERMUTED(47) ) & ( TK3_PERMUTED(44) xor TK3_PERMUTED(45) xor TK3_PERMUTED(47) );
        NEXT_KEY(51 downto 48) <= ( TK3_PERMUTED(49) xor TK3_PERMUTED(50) xor TK3_PERMUTED(51) ) & ( TK3_PERMUTED(48) xor TK3_PERMUTED(49) xor TK3_PERMUTED(50) ) & ( TK3_PERMUTED(48) xor TK3_PERMUTED(49) xor TK3_PERMUTED(50) xor TK3_PERMUTED(51) ) & ( TK3_PERMUTED(48) xor TK3_PERMUTED(49) xor TK3_PERMUTED(51) );
        NEXT_KEY(55 downto 52) <= ( TK3_PERMUTED(53) xor TK3_PERMUTED(54) xor TK3_PERMUTED(55) ) & ( TK3_PERMUTED(52) xor TK3_PERMUTED(53) xor TK3_PERMUTED(54) ) & ( TK3_PERMUTED(52) xor TK3_PERMUTED(53) xor TK3_PERMUTED(54) xor TK3_PERMUTED(55) ) & ( TK3_PERMUTED(52) xor TK3_PERMUTED(53) xor TK3_PERMUTED(55) );
        NEXT_KEY(59 downto 56) <= ( TK3_PERMUTED(57) xor TK3_PERMUTED(58) xor TK3_PERMUTED(59) ) & ( TK3_PERMUTED(56) xor TK3_PERMUTED(57) xor TK3_PERMUTED(58) ) & ( TK3_PERMUTED(56) xor TK3_PERMUTED(57) xor TK3_PERMUTED(58) xor TK3_PERMUTED(59) ) & ( TK3_PERMUTED(56) xor TK3_PERMUTED(57) xor TK3_PERMUTED(59) );
        NEXT_KEY(63 downto 60) <= ( TK3_PERMUTED(61) xor TK3_PERMUTED(62) xor TK3_PERMUTED(63) ) & ( TK3_PERMUTED(60) xor TK3_PERMUTED(61) xor TK3_PERMUTED(62) ) & ( TK3_PERMUTED(60) xor TK3_PERMUTED(61) xor TK3_PERMUTED(62) xor TK3_PERMUTED(63) ) & ( TK3_PERMUTED(60) xor TK3_PERMUTED(61) xor TK3_PERMUTED(63) );
        -- Lower half of the state
        NEXT_KEY(3 downto 0) <= ( TK3_PERMUTED(1) xor TK3_PERMUTED(2) xor TK3_PERMUTED(3) ) & ( TK3_PERMUTED(0) xor TK3_PERMUTED(1) xor TK3_PERMUTED(2) ) & ( TK3_PERMUTED(0) xor TK3_PERMUTED(1) xor TK3_PERMUTED(2) xor TK3_PERMUTED(3) ) & ( TK3_PERMUTED(0) xor TK3_PERMUTED(1) xor TK3_PERMUTED(3) );
        NEXT_KEY(7 downto 4) <= ( TK3_PERMUTED(5) xor TK3_PERMUTED(6) xor TK3_PERMUTED(7) ) & ( TK3_PERMUTED(4) xor TK3_PERMUTED(5) xor TK3_PERMUTED(6) ) & ( TK3_PERMUTED(4) xor TK3_PERMUTED(5) xor TK3_PERMUTED(6) xor TK3_PERMUTED(7) ) & ( TK3_PERMUTED(4) xor TK3_PERMUTED(5) xor TK3_PERMUTED(7) );
        NEXT_KEY(11 downto 8) <= ( TK3_PERMUTED(9) xor TK3_PERMUTED(10) xor TK3_PERMUTED(11) ) & ( TK3_PERMUTED(8) xor TK3_PERMUTED(9) xor TK3_PERMUTED(10) ) & ( TK3_PERMUTED(8) xor TK3_PERMUTED(9) xor TK3_PERMUTED(10) xor TK3_PERMUTED(11) ) & ( TK3_PERMUTED(8) xor TK3_PERMUTED(9) xor TK3_PERMUTED(11) );
        NEXT_KEY(15 downto 12) <= ( TK3_PERMUTED(13) xor TK3_PERMUTED(14) xor TK3_PERMUTED(15) ) & ( TK3_PERMUTED(12) xor TK3_PERMUTED(13) xor TK3_PERMUTED(14) ) & ( TK3_PERMUTED(12) xor TK3_PERMUTED(13) xor TK3_PERMUTED(14) xor TK3_PERMUTED(15) ) & ( TK3_PERMUTED(12) xor TK3_PERMUTED(13) xor TK3_PERMUTED(15) );
        NEXT_KEY(19 downto 16) <= ( TK3_PERMUTED(17) xor TK3_PERMUTED(18) xor TK3_PERMUTED(19) ) & ( TK3_PERMUTED(16) xor TK3_PERMUTED(17) xor TK3_PERMUTED(18) ) & ( TK3_PERMUTED(16) xor TK3_PERMUTED(17) xor TK3_PERMUTED(18) xor TK3_PERMUTED(19) ) & ( TK3_PERMUTED(16) xor TK3_PERMUTED(17) xor TK3_PERMUTED(19) );
        NEXT_KEY(23 downto 20) <= ( TK3_PERMUTED(21) xor TK3_PERMUTED(22) xor TK3_PERMUTED(23) ) & ( TK3_PERMUTED(20) xor TK3_PERMUTED(21) xor TK3_PERMUTED(22) ) & ( TK3_PERMUTED(20) xor TK3_PERMUTED(21) xor TK3_PERMUTED(22) xor TK3_PERMUTED(23) ) & ( TK3_PERMUTED(20) xor TK3_PERMUTED(21) xor TK3_PERMUTED(23) );
        NEXT_KEY(27 downto 24) <= ( TK3_PERMUTED(25) xor TK3_PERMUTED(26) xor TK3_PERMUTED(27) ) & ( TK3_PERMUTED(24) xor TK3_PERMUTED(25) xor TK3_PERMUTED(26) ) & ( TK3_PERMUTED(24) xor TK3_PERMUTED(25) xor TK3_PERMUTED(26) xor TK3_PERMUTED(27) ) & ( TK3_PERMUTED(24) xor TK3_PERMUTED(25) xor TK3_PERMUTED(27) );
        NEXT_KEY(31 downto 28) <= ( TK3_PERMUTED(29) xor TK3_PERMUTED(30) xor TK3_PERMUTED(31) ) & ( TK3_PERMUTED(28) xor TK3_PERMUTED(29) xor TK3_PERMUTED(30) ) & ( TK3_PERMUTED(28) xor TK3_PERMUTED(29) xor TK3_PERMUTED(30) xor TK3_PERMUTED(31) ) & ( TK3_PERMUTED(28) xor TK3_PERMUTED(29) xor TK3_PERMUTED(31) );



    end generate;

    B128T256: if BS = BLOCK_SIZE_128 and TS = TWEAK_SIZE_2N generate

        -- TK1: compute TK1^48 === do nothing
		NEXT_KEY((T - 0 * N - 1) DOWNTO (T - 1 * N)) <= KEY((T - 0 * N - 1) DOWNTO (T - 1 * N));

            -- TK2: compute TK2^48 ===  no permutation, 48 LFSR applications
        TK2 <= KEY((T - 1 * N - 1) DOWNTO (T - 2 * N));

        -- Upper half of the state
        NEXT_KEY(71 downto 64) <= ( TK2(65) xor TK2(67) xor TK2(69) xor TK2(71) ) & ( TK2(64) xor TK2(66) xor TK2(68) xor TK2(70) ) & ( TK2(65) xor TK2(67) xor TK2(71) ) & ( TK2(64) xor TK2(66) xor TK2(70) ) & ( TK2(65) xor TK2(71) ) & ( TK2(64) xor TK2(70) ) & TK2(71) & TK2(70);
        NEXT_KEY(79 downto 72) <= ( TK2(73) xor TK2(75) xor TK2(77) xor TK2(79) ) & ( TK2(72) xor TK2(74) xor TK2(76) xor TK2(78) ) & ( TK2(73) xor TK2(75) xor TK2(79) ) & ( TK2(72) xor TK2(74) xor TK2(78) ) & ( TK2(73) xor TK2(79) ) & ( TK2(72) xor TK2(78) ) & TK2(79) & TK2(78);
        NEXT_KEY(87 downto 80) <= ( TK2(81) xor TK2(83) xor TK2(85) xor TK2(87) ) & ( TK2(80) xor TK2(82) xor TK2(84) xor TK2(86) ) & ( TK2(81) xor TK2(83) xor TK2(87) ) & ( TK2(80) xor TK2(82) xor TK2(86) ) & ( TK2(81) xor TK2(87) ) & ( TK2(80) xor TK2(86) ) & TK2(87) & TK2(86);
        NEXT_KEY(95 downto 88) <= ( TK2(89) xor TK2(91) xor TK2(93) xor TK2(95) ) & ( TK2(88) xor TK2(90) xor TK2(92) xor TK2(94) ) & ( TK2(89) xor TK2(91) xor TK2(95) ) & ( TK2(88) xor TK2(90) xor TK2(94) ) & ( TK2(89) xor TK2(95) ) & ( TK2(88) xor TK2(94) ) & TK2(95) & TK2(94);
        NEXT_KEY(103 downto 96) <= ( TK2(97) xor TK2(99) xor TK2(101) xor TK2(103) ) & ( TK2(96) xor TK2(98) xor TK2(100) xor TK2(102) ) & ( TK2(97) xor TK2(99) xor TK2(103) ) & ( TK2(96) xor TK2(98) xor TK2(102) ) & ( TK2(97) xor TK2(103) ) & ( TK2(96) xor TK2(102) ) & TK2(103) & TK2(102);
        NEXT_KEY(111 downto 104) <= ( TK2(105) xor TK2(107) xor TK2(109) xor TK2(111) ) & ( TK2(104) xor TK2(106) xor TK2(108) xor TK2(110) ) & ( TK2(105) xor TK2(107) xor TK2(111) ) & ( TK2(104) xor TK2(106) xor TK2(110) ) & ( TK2(105) xor TK2(111) ) & ( TK2(104) xor TK2(110) ) & TK2(111) & TK2(110);
        NEXT_KEY(119 downto 112) <= ( TK2(113) xor TK2(115) xor TK2(117) xor TK2(119) ) & ( TK2(112) xor TK2(114) xor TK2(116) xor TK2(118) ) & ( TK2(113) xor TK2(115) xor TK2(119) ) & ( TK2(112) xor TK2(114) xor TK2(118) ) & ( TK2(113) xor TK2(119) ) & ( TK2(112) xor TK2(118) ) & TK2(119) & TK2(118);
        NEXT_KEY(127 downto 120) <= ( TK2(121) xor TK2(123) xor TK2(125) xor TK2(127) ) & ( TK2(120) xor TK2(122) xor TK2(124) xor TK2(126) ) & ( TK2(121) xor TK2(123) xor TK2(127) ) & ( TK2(120) xor TK2(122) xor TK2(126) ) & ( TK2(121) xor TK2(127) ) & ( TK2(120) xor TK2(126) ) & TK2(127) & TK2(126);
        -- Lower half of the state
        NEXT_KEY(7 downto 0) <= ( TK2(1) xor TK2(3) xor TK2(5) xor TK2(7) ) & ( TK2(0) xor TK2(2) xor TK2(4) xor TK2(6) ) & ( TK2(1) xor TK2(3) xor TK2(7) ) & ( TK2(0) xor TK2(2) xor TK2(6) ) & ( TK2(1) xor TK2(7) ) & ( TK2(0) xor TK2(6) ) & TK2(7) & TK2(6);
        NEXT_KEY(15 downto 8) <= ( TK2(9) xor TK2(11) xor TK2(13) xor TK2(15) ) & ( TK2(8) xor TK2(10) xor TK2(12) xor TK2(14) ) & ( TK2(9) xor TK2(11) xor TK2(15) ) & ( TK2(8) xor TK2(10) xor TK2(14) ) & ( TK2(9) xor TK2(15) ) & ( TK2(8) xor TK2(14) ) & TK2(15) & TK2(14);
        NEXT_KEY(23 downto 16) <= ( TK2(17) xor TK2(19) xor TK2(21) xor TK2(23) ) & ( TK2(16) xor TK2(18) xor TK2(20) xor TK2(22) ) & ( TK2(17) xor TK2(19) xor TK2(23) ) & ( TK2(16) xor TK2(18) xor TK2(22) ) & ( TK2(17) xor TK2(23) ) & ( TK2(16) xor TK2(22) ) & TK2(23) & TK2(22);
        NEXT_KEY(31 downto 24) <= ( TK2(25) xor TK2(27) xor TK2(29) xor TK2(31) ) & ( TK2(24) xor TK2(26) xor TK2(28) xor TK2(30) ) & ( TK2(25) xor TK2(27) xor TK2(31) ) & ( TK2(24) xor TK2(26) xor TK2(30) ) & ( TK2(25) xor TK2(31) ) & ( TK2(24) xor TK2(30) ) & TK2(31) & TK2(30);
        NEXT_KEY(39 downto 32) <= ( TK2(33) xor TK2(35) xor TK2(37) xor TK2(39) ) & ( TK2(32) xor TK2(34) xor TK2(36) xor TK2(38) ) & ( TK2(33) xor TK2(35) xor TK2(39) ) & ( TK2(32) xor TK2(34) xor TK2(38) ) & ( TK2(33) xor TK2(39) ) & ( TK2(32) xor TK2(38) ) & TK2(39) & TK2(38);
        NEXT_KEY(47 downto 40) <= ( TK2(41) xor TK2(43) xor TK2(45) xor TK2(47) ) & ( TK2(40) xor TK2(42) xor TK2(44) xor TK2(46) ) & ( TK2(41) xor TK2(43) xor TK2(47) ) & ( TK2(40) xor TK2(42) xor TK2(46) ) & ( TK2(41) xor TK2(47) ) & ( TK2(40) xor TK2(46) ) & TK2(47) & TK2(46);
        NEXT_KEY(55 downto 48) <= ( TK2(49) xor TK2(51) xor TK2(53) xor TK2(55) ) & ( TK2(48) xor TK2(50) xor TK2(52) xor TK2(54) ) & ( TK2(49) xor TK2(51) xor TK2(55) ) & ( TK2(48) xor TK2(50) xor TK2(54) ) & ( TK2(49) xor TK2(55) ) & ( TK2(48) xor TK2(54) ) & TK2(55) & TK2(54);
        NEXT_KEY(63 downto 56) <= ( TK2(57) xor TK2(59) xor TK2(61) xor TK2(63) ) & ( TK2(56) xor TK2(58) xor TK2(60) xor TK2(62) ) & ( TK2(57) xor TK2(59) xor TK2(63) ) & ( TK2(56) xor TK2(58) xor TK2(62) ) & ( TK2(57) xor TK2(63) ) & ( TK2(56) xor TK2(62) ) & TK2(63) & TK2(62);


        end generate;

    B128T192: if BS = BLOCK_SIZE_128 and TS = TWEAK_SIZE_3o2N generate

        -- TK1: compute TK1^48 === do nothing
		NEXT_KEY((T - 0 * N - 1) DOWNTO (T - 1 * N)) <= KEY((T - 0 * N - 1) DOWNTO (T - 1 * N));

        -- TK2: compute TK2^24 ===  no permutatation,  (24 because of half-state)
        TK2(63 downto 0) <= KEY(63 downto 0);

        -- LFSR only on half a state
        NEXT_KEY(7 downto 0) <= ( TK2(1) xor TK2(3) xor TK2(5) xor TK2(7) ) & ( TK2(0) xor TK2(2) xor TK2(4) xor TK2(6) ) & ( TK2(1) xor TK2(3) xor TK2(7) ) & ( TK2(0) xor TK2(2) xor TK2(6) ) & ( TK2(1) xor TK2(7) ) & ( TK2(0) xor TK2(6) ) & TK2(7) & TK2(6);
        NEXT_KEY(15 downto 8) <= ( TK2(9) xor TK2(11) xor TK2(13) xor TK2(15) ) & ( TK2(8) xor TK2(10) xor TK2(12) xor TK2(14) ) & ( TK2(9) xor TK2(11) xor TK2(15) ) & ( TK2(8) xor TK2(10) xor TK2(14) ) & ( TK2(9) xor TK2(15) ) & ( TK2(8) xor TK2(14) ) & TK2(15) & TK2(14);
        NEXT_KEY(23 downto 16) <= ( TK2(17) xor TK2(19) xor TK2(21) xor TK2(23) ) & ( TK2(16) xor TK2(18) xor TK2(20) xor TK2(22) ) & ( TK2(17) xor TK2(19) xor TK2(23) ) & ( TK2(16) xor TK2(18) xor TK2(22) ) & ( TK2(17) xor TK2(23) ) & ( TK2(16) xor TK2(22) ) & TK2(23) & TK2(22);
        NEXT_KEY(31 downto 24) <= ( TK2(25) xor TK2(27) xor TK2(29) xor TK2(31) ) & ( TK2(24) xor TK2(26) xor TK2(28) xor TK2(30) ) & ( TK2(25) xor TK2(27) xor TK2(31) ) & ( TK2(24) xor TK2(26) xor TK2(30) ) & ( TK2(25) xor TK2(31) ) & ( TK2(24) xor TK2(30) ) & TK2(31) & TK2(30);
        NEXT_KEY(39 downto 32) <= ( TK2(33) xor TK2(35) xor TK2(37) xor TK2(39) ) & ( TK2(32) xor TK2(34) xor TK2(36) xor TK2(38) ) & ( TK2(33) xor TK2(35) xor TK2(39) ) & ( TK2(32) xor TK2(34) xor TK2(38) ) & ( TK2(33) xor TK2(39) ) & ( TK2(32) xor TK2(38) ) & TK2(39) & TK2(38);
        NEXT_KEY(47 downto 40) <= ( TK2(41) xor TK2(43) xor TK2(45) xor TK2(47) ) & ( TK2(40) xor TK2(42) xor TK2(44) xor TK2(46) ) & ( TK2(41) xor TK2(43) xor TK2(47) ) & ( TK2(40) xor TK2(42) xor TK2(46) ) & ( TK2(41) xor TK2(47) ) & ( TK2(40) xor TK2(46) ) & TK2(47) & TK2(46);
        NEXT_KEY(55 downto 48) <= ( TK2(49) xor TK2(51) xor TK2(53) xor TK2(55) ) & ( TK2(48) xor TK2(50) xor TK2(52) xor TK2(54) ) & ( TK2(49) xor TK2(51) xor TK2(55) ) & ( TK2(48) xor TK2(50) xor TK2(54) ) & ( TK2(49) xor TK2(55) ) & ( TK2(48) xor TK2(54) ) & TK2(55) & TK2(54);
        NEXT_KEY(63 downto 56) <= ( TK2(57) xor TK2(59) xor TK2(61) xor TK2(63) ) & ( TK2(56) xor TK2(58) xor TK2(60) xor TK2(62) ) & ( TK2(57) xor TK2(59) xor TK2(63) ) & ( TK2(56) xor TK2(58) xor TK2(62) ) & ( TK2(57) xor TK2(63) ) & ( TK2(56) xor TK2(62) ) & TK2(63) & TK2(62);

    end generate;
        

    B128T288: if BS = BLOCK_SIZE_128 and TS = TWEAK_SIZE_9o4N generate

    -- TK1^56
    -- Generating the following permutation: [5, 6, 3, 2, 7, 0, 1, 4, 13, 14, 11, 10, 15, 8, 9, 12]
    TK1 <= KEY(T-1 downto T-N);
	NEXT_KEY((T-N + 16 * W - 1) downto (T-N + 15 * W)) <= TK1((11 * W - 1) downto (10 * W));
	NEXT_KEY((T-N + 15 * W - 1) downto (T-N + 14 * W)) <= TK1((10 * W - 1) downto (9 * W));
	NEXT_KEY((T-N + 14 * W - 1) downto (T-N + 13 * W)) <= TK1((13 * W - 1) downto (12 * W));
	NEXT_KEY((T-N + 13 * W - 1) downto (T-N + 12 * W)) <= TK1((14 * W - 1) downto (13 * W));
	NEXT_KEY((T-N + 12 * W - 1) downto (T-N + 11 * W)) <= TK1((9 * W - 1) downto (8 * W));
	NEXT_KEY((T-N + 11 * W - 1) downto (T-N + 10 * W)) <= TK1((16 * W - 1) downto (15 * W));
	NEXT_KEY((T-N + 10 * W - 1) downto (T-N + 9 * W)) <= TK1((15 * W - 1) downto (14 * W));
	NEXT_KEY((T-N + 9 * W - 1) downto (T-N + 8 * W)) <= TK1((12 * W - 1) downto (11 * W));
	NEXT_KEY((T-N + 8 * W - 1) downto (T-N + 7 * W)) <= TK1((3 * W - 1) downto (2 * W));
	NEXT_KEY((T-N + 7 * W - 1) downto (T-N + 6 * W)) <= TK1((2 * W - 1) downto (1 * W));
	NEXT_KEY((T-N + 6 * W - 1) downto (T-N + 5 * W)) <= TK1((5 * W - 1) downto (4 * W));
	NEXT_KEY((T-N + 5 * W - 1) downto (T-N + 4 * W)) <= TK1((6 * W - 1) downto (5 * W));
	NEXT_KEY((T-N + 4 * W - 1) downto (T-N + 3 * W)) <= TK1((1 * W - 1) downto (0 * W));
	NEXT_KEY((T-N + 3 * W - 1) downto (T-N + 2 * W)) <= TK1((8 * W - 1) downto (7 * W));
	NEXT_KEY((T-N + 2 * W - 1) downto (T-N + 1 * W)) <= TK1((7 * W - 1) downto (6 * W));
	NEXT_KEY((T-N + 1 * W - 1) downto (T-N + 0 * W)) <= TK1((4 * W - 1) downto (3 * W));

    -- TK2^56
	-- Generating the following permutation: [5, 6, 3, 2, 7, 0, 1, 4, 13, 14, 11, 10, 15, 8, 9, 12]
    TK2 <= KEY((T - 1 * N - 1) DOWNTO (T - 2 * N));
	TK2_PERMUTED((16 * W - 1) downto (15 * W)) <= TK2((11 * W - 1) downto (10 * W));
	TK2_PERMUTED((15 * W - 1) downto (14 * W)) <= TK2((10 * W - 1) downto (9 * W));
	TK2_PERMUTED((14 * W - 1) downto (13 * W)) <= TK2((13 * W - 1) downto (12 * W));
	TK2_PERMUTED((13 * W - 1) downto (12 * W)) <= TK2((14 * W - 1) downto (13 * W));
	TK2_PERMUTED((12 * W - 1) downto (11 * W)) <= TK2((9 * W - 1) downto (8 * W));
	TK2_PERMUTED((11 * W - 1) downto (10 * W)) <= TK2((16 * W - 1) downto (15 * W));
	TK2_PERMUTED((10 * W - 1) downto (9 * W)) <= TK2((15 * W - 1) downto (14 * W));
	TK2_PERMUTED((9 * W - 1) downto (8 * W)) <= TK2((12 * W - 1) downto (11 * W));
	TK2_PERMUTED((8 * W - 1) downto (7 * W)) <= TK2((3 * W - 1) downto (2 * W));
	TK2_PERMUTED((7 * W - 1) downto (6 * W)) <= TK2((2 * W - 1) downto (1 * W));
	TK2_PERMUTED((6 * W - 1) downto (5 * W)) <= TK2((5 * W - 1) downto (4 * W));
	TK2_PERMUTED((5 * W - 1) downto (4 * W)) <= TK2((6 * W - 1) downto (5 * W));
	TK2_PERMUTED((4 * W - 1) downto (3 * W)) <= TK2((1 * W - 1) downto (0 * W));
	TK2_PERMUTED((3 * W - 1) downto (2 * W)) <= TK2((8 * W - 1) downto (7 * W));
	TK2_PERMUTED((2 * W - 1) downto (1 * W)) <= TK2((7 * W - 1) downto (6 * W));
	TK2_PERMUTED((1 * W - 1) downto (0 * W)) <= TK2((4 * W - 1) downto (3 * W));

    -- Upper half of the state
    NEXT_KEY(135 downto 128) <= ( TK2_PERMUTED(65) xor TK2_PERMUTED(71) ) & ( TK2_PERMUTED(64) xor TK2_PERMUTED(70) ) & TK2_PERMUTED(71) & TK2_PERMUTED(70) & TK2_PERMUTED(69) & TK2_PERMUTED(68) & TK2_PERMUTED(67) & TK2_PERMUTED(66);
    NEXT_KEY(143 downto 136) <= ( TK2_PERMUTED(73) xor TK2_PERMUTED(79) ) & ( TK2_PERMUTED(72) xor TK2_PERMUTED(78) ) & TK2_PERMUTED(79) & TK2_PERMUTED(78) & TK2_PERMUTED(77) & TK2_PERMUTED(76) & TK2_PERMUTED(75) & TK2_PERMUTED(74);
    NEXT_KEY(151 downto 144) <= ( TK2_PERMUTED(81) xor TK2_PERMUTED(87) ) & ( TK2_PERMUTED(80) xor TK2_PERMUTED(86) ) & TK2_PERMUTED(87) & TK2_PERMUTED(86) & TK2_PERMUTED(85) & TK2_PERMUTED(84) & TK2_PERMUTED(83) & TK2_PERMUTED(82);
    NEXT_KEY(159 downto 152) <= ( TK2_PERMUTED(89) xor TK2_PERMUTED(95) ) & ( TK2_PERMUTED(88) xor TK2_PERMUTED(94) ) & TK2_PERMUTED(95) & TK2_PERMUTED(94) & TK2_PERMUTED(93) & TK2_PERMUTED(92) & TK2_PERMUTED(91) & TK2_PERMUTED(90);
    NEXT_KEY(167 downto 160) <= ( TK2_PERMUTED(97) xor TK2_PERMUTED(103) ) & ( TK2_PERMUTED(96) xor TK2_PERMUTED(102) ) & TK2_PERMUTED(103) & TK2_PERMUTED(102) & TK2_PERMUTED(101) & TK2_PERMUTED(100) & TK2_PERMUTED(99) & TK2_PERMUTED(98);
    NEXT_KEY(175 downto 168) <= ( TK2_PERMUTED(105) xor TK2_PERMUTED(111) ) & ( TK2_PERMUTED(104) xor TK2_PERMUTED(110) ) & TK2_PERMUTED(111) & TK2_PERMUTED(110) & TK2_PERMUTED(109) & TK2_PERMUTED(108) & TK2_PERMUTED(107) & TK2_PERMUTED(106);
    NEXT_KEY(183 downto 176) <= ( TK2_PERMUTED(113) xor TK2_PERMUTED(119) ) & ( TK2_PERMUTED(112) xor TK2_PERMUTED(118) ) & TK2_PERMUTED(119) & TK2_PERMUTED(118) & TK2_PERMUTED(117) & TK2_PERMUTED(116) & TK2_PERMUTED(115) & TK2_PERMUTED(114);
    NEXT_KEY(191 downto 184) <= ( TK2_PERMUTED(121) xor TK2_PERMUTED(127) ) & ( TK2_PERMUTED(120) xor TK2_PERMUTED(126) ) & TK2_PERMUTED(127) & TK2_PERMUTED(126) & TK2_PERMUTED(125) & TK2_PERMUTED(124) & TK2_PERMUTED(123) & TK2_PERMUTED(122);

    -- Lower half of the state
    NEXT_KEY(71 downto 64) <= ( TK2_PERMUTED(1) xor TK2_PERMUTED(7) ) & ( TK2_PERMUTED(0) xor TK2_PERMUTED(6) ) & TK2_PERMUTED(7) & TK2_PERMUTED(6) & TK2_PERMUTED(5) & TK2_PERMUTED(4) & TK2_PERMUTED(3) & TK2_PERMUTED(2);
    NEXT_KEY(79 downto 72) <= ( TK2_PERMUTED(9) xor TK2_PERMUTED(15) ) & ( TK2_PERMUTED(8) xor TK2_PERMUTED(14) ) & TK2_PERMUTED(15) & TK2_PERMUTED(14) & TK2_PERMUTED(13) & TK2_PERMUTED(12) & TK2_PERMUTED(11) & TK2_PERMUTED(10);
    NEXT_KEY(87 downto 80) <= ( TK2_PERMUTED(17) xor TK2_PERMUTED(23) ) & ( TK2_PERMUTED(16) xor TK2_PERMUTED(22) ) & TK2_PERMUTED(23) & TK2_PERMUTED(22) & TK2_PERMUTED(21) & TK2_PERMUTED(20) & TK2_PERMUTED(19) & TK2_PERMUTED(18);
    NEXT_KEY(95 downto 88) <= ( TK2_PERMUTED(25) xor TK2_PERMUTED(31) ) & ( TK2_PERMUTED(24) xor TK2_PERMUTED(30) ) & TK2_PERMUTED(31) & TK2_PERMUTED(30) & TK2_PERMUTED(29) & TK2_PERMUTED(28) & TK2_PERMUTED(27) & TK2_PERMUTED(26);
    NEXT_KEY(103 downto 96) <= ( TK2_PERMUTED(33) xor TK2_PERMUTED(39) ) & ( TK2_PERMUTED(32) xor TK2_PERMUTED(38) ) & TK2_PERMUTED(39) & TK2_PERMUTED(38) & TK2_PERMUTED(37) & TK2_PERMUTED(36) & TK2_PERMUTED(35) & TK2_PERMUTED(34);
    NEXT_KEY(111 downto 104) <= ( TK2_PERMUTED(41) xor TK2_PERMUTED(47) ) & ( TK2_PERMUTED(40) xor TK2_PERMUTED(46) ) & TK2_PERMUTED(47) & TK2_PERMUTED(46) & TK2_PERMUTED(45) & TK2_PERMUTED(44) & TK2_PERMUTED(43) & TK2_PERMUTED(42);
    NEXT_KEY(119 downto 112) <= ( TK2_PERMUTED(49) xor TK2_PERMUTED(55) ) & ( TK2_PERMUTED(48) xor TK2_PERMUTED(54) ) & TK2_PERMUTED(55) & TK2_PERMUTED(54) & TK2_PERMUTED(53) & TK2_PERMUTED(52) & TK2_PERMUTED(51) & TK2_PERMUTED(50);
    NEXT_KEY(127 downto 120) <= ( TK2_PERMUTED(57) xor TK2_PERMUTED(63) ) & ( TK2_PERMUTED(56) xor TK2_PERMUTED(62) ) & TK2_PERMUTED(63) & TK2_PERMUTED(62) & TK2_PERMUTED(61) & TK2_PERMUTED(60) & TK2_PERMUTED(59) & TK2_PERMUTED(58);

    -- TK3^28
    TK3(63 downto 0) <= KEY(63 DOWNTO 0);
    -- Generating the following permutation: [5, 6, 3, 2, 7, 0, 1, 4, 13, 14, 11, 10, 15, 8, 9, 12]
	TK3_PERMUTED((8 * W - 1) downto (7 * W)) <= TK3((3 * W - 1) downto (2 * W));
	TK3_PERMUTED((7 * W - 1) downto (6 * W)) <= TK3((2 * W - 1) downto (1 * W));
	TK3_PERMUTED((6 * W - 1) downto (5 * W)) <= TK3((5 * W - 1) downto (4 * W));
	TK3_PERMUTED((5 * W - 1) downto (4 * W)) <= TK3((6 * W - 1) downto (5 * W));
	TK3_PERMUTED((4 * W - 1) downto (3 * W)) <= TK3((1 * W - 1) downto (0 * W));
	TK3_PERMUTED((3 * W - 1) downto (2 * W)) <= TK3((8 * W - 1) downto (7 * W));
	TK3_PERMUTED((2 * W - 1) downto (1 * W)) <= TK3((7 * W - 1) downto (6 * W));
	TK3_PERMUTED((1 * W - 1) downto (0 * W)) <= TK3((4 * W - 1) downto (3 * W));

    -- Lower half of the state
    NEXT_KEY(7 downto 0) <= TK3_PERMUTED(5) & TK3_PERMUTED(4) & TK3_PERMUTED(3) & TK3_PERMUTED(2) & TK3_PERMUTED(1) & TK3_PERMUTED(0) & ( TK3_PERMUTED(5) xor TK3_PERMUTED(7) ) & ( TK3_PERMUTED(4) xor TK3_PERMUTED(6) );
    NEXT_KEY(15 downto 8) <= TK3_PERMUTED(13) & TK3_PERMUTED(12) & TK3_PERMUTED(11) & TK3_PERMUTED(10) & TK3_PERMUTED(9) & TK3_PERMUTED(8) & ( TK3_PERMUTED(13) xor TK3_PERMUTED(15) ) & ( TK3_PERMUTED(12) xor TK3_PERMUTED(14) );
    NEXT_KEY(23 downto 16) <= TK3_PERMUTED(21) & TK3_PERMUTED(20) & TK3_PERMUTED(19) & TK3_PERMUTED(18) & TK3_PERMUTED(17) & TK3_PERMUTED(16) & ( TK3_PERMUTED(21) xor TK3_PERMUTED(23) ) & ( TK3_PERMUTED(20) xor TK3_PERMUTED(22) );
    NEXT_KEY(31 downto 24) <= TK3_PERMUTED(29) & TK3_PERMUTED(28) & TK3_PERMUTED(27) & TK3_PERMUTED(26) & TK3_PERMUTED(25) & TK3_PERMUTED(24) & ( TK3_PERMUTED(29) xor TK3_PERMUTED(31) ) & ( TK3_PERMUTED(28) xor TK3_PERMUTED(30) );
    NEXT_KEY(39 downto 32) <= TK3_PERMUTED(37) & TK3_PERMUTED(36) & TK3_PERMUTED(35) & TK3_PERMUTED(34) & TK3_PERMUTED(33) & TK3_PERMUTED(32) & ( TK3_PERMUTED(37) xor TK3_PERMUTED(39) ) & ( TK3_PERMUTED(36) xor TK3_PERMUTED(38) );
    NEXT_KEY(47 downto 40) <= TK3_PERMUTED(45) & TK3_PERMUTED(44) & TK3_PERMUTED(43) & TK3_PERMUTED(42) & TK3_PERMUTED(41) & TK3_PERMUTED(40) & ( TK3_PERMUTED(45) xor TK3_PERMUTED(47) ) & ( TK3_PERMUTED(44) xor TK3_PERMUTED(46) );
    NEXT_KEY(55 downto 48) <= TK3_PERMUTED(53) & TK3_PERMUTED(52) & TK3_PERMUTED(51) & TK3_PERMUTED(50) & TK3_PERMUTED(49) & TK3_PERMUTED(48) & ( TK3_PERMUTED(53) xor TK3_PERMUTED(55) ) & ( TK3_PERMUTED(52) xor TK3_PERMUTED(54) );
    NEXT_KEY(63 downto 56) <= TK3_PERMUTED(61) & TK3_PERMUTED(60) & TK3_PERMUTED(59) & TK3_PERMUTED(58) & TK3_PERMUTED(57) & TK3_PERMUTED(56) & ( TK3_PERMUTED(61) xor TK3_PERMUTED(63) ) & ( TK3_PERMUTED(60) xor TK3_PERMUTED(62) );
    end generate;

	
END behav;



-----------------------------
-- Fast Forward Key Schedule
-----------------------------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

use work.Forkskinnypkg.all;



-- ENTITY
----------------------------------------------------------------------------------
ENTITY KeyExpansionFF IS
	GENERIC (BS : BLOCK_SIZE; TS : TWEAK_SIZE);
	PORT (KEY			: IN  STD_LOGIC_VECTOR ((GET_TWEAK_SIZE(BS, TS) - 1) DOWNTO 0);
          KEY_FF	: OUT STD_LOGIC_VECTOR ((GET_TWEAK_SIZE(BS, TS) - 1) DOWNTO 0));
END KeyExpansionFF;

ARCHITECTURE Mixed OF KeyExpansionFF IS

	-- CONSTANTS ------------------------------------------------------------------
	CONSTANT N : INTEGER := GET_BLOCK_SIZE(BS);
	CONSTANT T : INTEGER := GET_TWEAK_SIZE(BS, TS);
	CONSTANT W : INTEGER := GET_WORD_SIZE(BS);
	
	-- SIGNALS --------------------------------------------------------------------
	SIGNAL TK1, TK1_FF, TK2, TK2_FF, TK2_PERMUTED : STD_LOGIC_VECTOR((N - 1) DOWNTO 0);
	SIGNAL TK3, TK3_FF, TK3_PERMUTED : STD_LOGIC_VECTOR((N - 1) DOWNTO 0);

begin

    -- Input assigment
    TK1 <= KEY(T-1 downto T-N);

    -- Assign to output
    KEY_FF(T-1 downto T-N) <= TK1_FF;

    ASSIGN_TK2: if TS = TWEAK_SIZE_2N or TS = TWEAK_SIZE_3o2N generate
        TK2(T-N-1 downto 0) <= KEY(T-N-1 downto 0);
        KEY_FF(T-N-1 downto 0) <= TK2_FF(T-N-1 downto 0);
    end generate;

    ASSIGN_TK3: if TS = TWEAK_SIZE_3N or TS = TWEAK_SIZE_9o4N generate
        TK2 <= KEY(T-N-1 downto T-2*N);
        TK3(T-2*N-1 downto 0) <= KEY(T-2*N-1 downto 0);
        KEY_FF(T-N-1 downto T-2*N) <= TK2_FF;
        KEY_FF(T-2*N-1 downto 0) <= TK3_FF(T-2*N-1 downto 0);
    end generate;


    FF_64_192 : IF (BS = BLOCK_SIZE_64 AND TS = TWEAK_SIZE_3N) GENERATE

        -- Generating the following permutation: [13, 14, 11, 10, 15, 8, 9, 12, 3, 5, 7, 4, 1, 2, 0, 6]
        TK1_FF((16 * W - 1) downto (15 * W)) <= TK1((3 * W - 1) downto (2 * W));
        TK1_FF((15 * W - 1) downto (14 * W)) <= TK1((2 * W - 1) downto (1 * W));
        TK1_FF((14 * W - 1) downto (13 * W)) <= TK1((5 * W - 1) downto (4 * W));
        TK1_FF((13 * W - 1) downto (12 * W)) <= TK1((6 * W - 1) downto (5 * W));
        TK1_FF((12 * W - 1) downto (11 * W)) <= TK1((1 * W - 1) downto (0 * W));
        TK1_FF((11 * W - 1) downto (10 * W)) <= TK1((8 * W - 1) downto (7 * W));
        TK1_FF((10 * W - 1) downto (9 * W)) <= TK1((7 * W - 1) downto (6 * W));
        TK1_FF((9 * W - 1) downto (8 * W)) <= TK1((4 * W - 1) downto (3 * W));
        TK1_FF((8 * W - 1) downto (7 * W)) <= TK1((13 * W - 1) downto (12 * W));
        TK1_FF((7 * W - 1) downto (6 * W)) <= TK1((11 * W - 1) downto (10 * W));
        TK1_FF((6 * W - 1) downto (5 * W)) <= TK1((9 * W - 1) downto (8 * W));
        TK1_FF((5 * W - 1) downto (4 * W)) <= TK1((12 * W - 1) downto (11 * W));
        TK1_FF((4 * W - 1) downto (3 * W)) <= TK1((15 * W - 1) downto (14 * W));
        TK1_FF((3 * W - 1) downto (2 * W)) <= TK1((14 * W - 1) downto (13 * W));
        TK1_FF((2 * W - 1) downto (1 * W)) <= TK1((16 * W - 1) downto (15 * W));
        TK1_FF((1 * W - 1) downto (0 * W)) <= TK1((10 * W - 1) downto (9 * W));

        -- Generating the following permutation: [13, 14, 11, 10, 15, 8, 9, 12, 3, 5, 7, 4, 1, 2, 0, 6]
        TK2_PERMUTED((16 * W - 1) downto (15 * W)) <= TK2((3 * W - 1) downto (2 * W));
        TK2_PERMUTED((15 * W - 1) downto (14 * W)) <= TK2((2 * W - 1) downto (1 * W));
        TK2_PERMUTED((14 * W - 1) downto (13 * W)) <= TK2((5 * W - 1) downto (4 * W));
        TK2_PERMUTED((13 * W - 1) downto (12 * W)) <= TK2((6 * W - 1) downto (5 * W));
        TK2_PERMUTED((12 * W - 1) downto (11 * W)) <= TK2((1 * W - 1) downto (0 * W));
        TK2_PERMUTED((11 * W - 1) downto (10 * W)) <= TK2((8 * W - 1) downto (7 * W));
        TK2_PERMUTED((10 * W - 1) downto (9 * W)) <= TK2((7 * W - 1) downto (6 * W));
        TK2_PERMUTED((9 * W - 1) downto (8 * W)) <= TK2((4 * W - 1) downto (3 * W));
        TK2_PERMUTED((8 * W - 1) downto (7 * W)) <= TK2((13 * W - 1) downto (12 * W));
        TK2_PERMUTED((7 * W - 1) downto (6 * W)) <= TK2((11 * W - 1) downto (10 * W));
        TK2_PERMUTED((6 * W - 1) downto (5 * W)) <= TK2((9 * W - 1) downto (8 * W));
        TK2_PERMUTED((5 * W - 1) downto (4 * W)) <= TK2((12 * W - 1) downto (11 * W));
        TK2_PERMUTED((4 * W - 1) downto (3 * W)) <= TK2((15 * W - 1) downto (14 * W));
        TK2_PERMUTED((3 * W - 1) downto (2 * W)) <= TK2((14 * W - 1) downto (13 * W));
        TK2_PERMUTED((2 * W - 1) downto (1 * W)) <= TK2((16 * W - 1) downto (15 * W));
        TK2_PERMUTED((1 * W - 1) downto (0 * W)) <= TK2((10 * W - 1) downto (9 * W));

    -- Upper half of the state
    TK2_FF(35 downto 32) <= ( TK2_PERMUTED(32) xor TK2_PERMUTED(33) xor TK2_PERMUTED(34) xor TK2_PERMUTED(35) ) & ( TK2_PERMUTED(32) xor TK2_PERMUTED(33) xor TK2_PERMUTED(35) ) & ( TK2_PERMUTED(32) xor TK2_PERMUTED(35) ) & TK2_PERMUTED(35);
    TK2_FF(39 downto 36) <= ( TK2_PERMUTED(36) xor TK2_PERMUTED(37) xor TK2_PERMUTED(38) xor TK2_PERMUTED(39) ) & ( TK2_PERMUTED(36) xor TK2_PERMUTED(37) xor TK2_PERMUTED(39) ) & ( TK2_PERMUTED(36) xor TK2_PERMUTED(39) ) & TK2_PERMUTED(39);
    TK2_FF(43 downto 40) <= ( TK2_PERMUTED(40) xor TK2_PERMUTED(41) xor TK2_PERMUTED(42) xor TK2_PERMUTED(43) ) & ( TK2_PERMUTED(40) xor TK2_PERMUTED(41) xor TK2_PERMUTED(43) ) & ( TK2_PERMUTED(40) xor TK2_PERMUTED(43) ) & TK2_PERMUTED(43);
    TK2_FF(47 downto 44) <= ( TK2_PERMUTED(44) xor TK2_PERMUTED(45) xor TK2_PERMUTED(46) xor TK2_PERMUTED(47) ) & ( TK2_PERMUTED(44) xor TK2_PERMUTED(45) xor TK2_PERMUTED(47) ) & ( TK2_PERMUTED(44) xor TK2_PERMUTED(47) ) & TK2_PERMUTED(47);
    TK2_FF(51 downto 48) <= ( TK2_PERMUTED(48) xor TK2_PERMUTED(49) xor TK2_PERMUTED(50) xor TK2_PERMUTED(51) ) & ( TK2_PERMUTED(48) xor TK2_PERMUTED(49) xor TK2_PERMUTED(51) ) & ( TK2_PERMUTED(48) xor TK2_PERMUTED(51) ) & TK2_PERMUTED(51);
    TK2_FF(55 downto 52) <= ( TK2_PERMUTED(52) xor TK2_PERMUTED(53) xor TK2_PERMUTED(54) xor TK2_PERMUTED(55) ) & ( TK2_PERMUTED(52) xor TK2_PERMUTED(53) xor TK2_PERMUTED(55) ) & ( TK2_PERMUTED(52) xor TK2_PERMUTED(55) ) & TK2_PERMUTED(55);
    TK2_FF(59 downto 56) <= ( TK2_PERMUTED(56) xor TK2_PERMUTED(57) xor TK2_PERMUTED(58) xor TK2_PERMUTED(59) ) & ( TK2_PERMUTED(56) xor TK2_PERMUTED(57) xor TK2_PERMUTED(59) ) & ( TK2_PERMUTED(56) xor TK2_PERMUTED(59) ) & TK2_PERMUTED(59);
    TK2_FF(63 downto 60) <= ( TK2_PERMUTED(60) xor TK2_PERMUTED(61) xor TK2_PERMUTED(62) xor TK2_PERMUTED(63) ) & ( TK2_PERMUTED(60) xor TK2_PERMUTED(61) xor TK2_PERMUTED(63) ) & ( TK2_PERMUTED(60) xor TK2_PERMUTED(63) ) & TK2_PERMUTED(63);
    -- Lower half of the state
    TK2_FF(3 downto 0) <= ( TK2_PERMUTED(0) xor TK2_PERMUTED(1) xor TK2_PERMUTED(2) ) & ( TK2_PERMUTED(0) xor TK2_PERMUTED(1) xor TK2_PERMUTED(2) xor TK2_PERMUTED(3) ) & ( TK2_PERMUTED(0) xor TK2_PERMUTED(1) xor TK2_PERMUTED(3) ) & ( TK2_PERMUTED(0) xor TK2_PERMUTED(3) );
    TK2_FF(7 downto 4) <= ( TK2_PERMUTED(4) xor TK2_PERMUTED(5) xor TK2_PERMUTED(6) ) & ( TK2_PERMUTED(4) xor TK2_PERMUTED(5) xor TK2_PERMUTED(6) xor TK2_PERMUTED(7) ) & ( TK2_PERMUTED(4) xor TK2_PERMUTED(5) xor TK2_PERMUTED(7) ) & ( TK2_PERMUTED(4) xor TK2_PERMUTED(7) );
    TK2_FF(11 downto 8) <= ( TK2_PERMUTED(8) xor TK2_PERMUTED(9) xor TK2_PERMUTED(10) ) & ( TK2_PERMUTED(8) xor TK2_PERMUTED(9) xor TK2_PERMUTED(10) xor TK2_PERMUTED(11) ) & ( TK2_PERMUTED(8) xor TK2_PERMUTED(9) xor TK2_PERMUTED(11) ) & ( TK2_PERMUTED(8) xor TK2_PERMUTED(11) );
    TK2_FF(15 downto 12) <= ( TK2_PERMUTED(12) xor TK2_PERMUTED(13) xor TK2_PERMUTED(14) ) & ( TK2_PERMUTED(12) xor TK2_PERMUTED(13) xor TK2_PERMUTED(14) xor TK2_PERMUTED(15) ) & ( TK2_PERMUTED(12) xor TK2_PERMUTED(13) xor TK2_PERMUTED(15) ) & ( TK2_PERMUTED(12) xor TK2_PERMUTED(15) );
    TK2_FF(19 downto 16) <= ( TK2_PERMUTED(16) xor TK2_PERMUTED(17) xor TK2_PERMUTED(18) ) & ( TK2_PERMUTED(16) xor TK2_PERMUTED(17) xor TK2_PERMUTED(18) xor TK2_PERMUTED(19) ) & ( TK2_PERMUTED(16) xor TK2_PERMUTED(17) xor TK2_PERMUTED(19) ) & ( TK2_PERMUTED(16) xor TK2_PERMUTED(19) );
    TK2_FF(23 downto 20) <= ( TK2_PERMUTED(20) xor TK2_PERMUTED(21) xor TK2_PERMUTED(22) ) & ( TK2_PERMUTED(20) xor TK2_PERMUTED(21) xor TK2_PERMUTED(22) xor TK2_PERMUTED(23) ) & ( TK2_PERMUTED(20) xor TK2_PERMUTED(21) xor TK2_PERMUTED(23) ) & ( TK2_PERMUTED(20) xor TK2_PERMUTED(23) );
    TK2_FF(27 downto 24) <= ( TK2_PERMUTED(24) xor TK2_PERMUTED(25) xor TK2_PERMUTED(26) ) & ( TK2_PERMUTED(24) xor TK2_PERMUTED(25) xor TK2_PERMUTED(26) xor TK2_PERMUTED(27) ) & ( TK2_PERMUTED(24) xor TK2_PERMUTED(25) xor TK2_PERMUTED(27) ) & ( TK2_PERMUTED(24) xor TK2_PERMUTED(27) );
    TK2_FF(31 downto 28) <= ( TK2_PERMUTED(28) xor TK2_PERMUTED(29) xor TK2_PERMUTED(30) ) & ( TK2_PERMUTED(28) xor TK2_PERMUTED(29) xor TK2_PERMUTED(30) xor TK2_PERMUTED(31) ) & ( TK2_PERMUTED(28) xor TK2_PERMUTED(29) xor TK2_PERMUTED(31) ) & ( TK2_PERMUTED(28) xor TK2_PERMUTED(31) );


    -- Generating the following permutation: [13, 14, 11, 10, 15, 8, 9, 12, 3, 5, 7, 4, 1, 2, 0, 6]
	TK3_PERMUTED((16 * W - 1) downto (15 * W)) <= TK3((3 * W - 1) downto (2 * W));
	TK3_PERMUTED((15 * W - 1) downto (14 * W)) <= TK3((2 * W - 1) downto (1 * W));
	TK3_PERMUTED((14 * W - 1) downto (13 * W)) <= TK3((5 * W - 1) downto (4 * W));
	TK3_PERMUTED((13 * W - 1) downto (12 * W)) <= TK3((6 * W - 1) downto (5 * W));
	TK3_PERMUTED((12 * W - 1) downto (11 * W)) <= TK3((1 * W - 1) downto (0 * W));
	TK3_PERMUTED((11 * W - 1) downto (10 * W)) <= TK3((8 * W - 1) downto (7 * W));
	TK3_PERMUTED((10 * W - 1) downto (9 * W)) <= TK3((7 * W - 1) downto (6 * W));
	TK3_PERMUTED((9 * W - 1) downto (8 * W)) <= TK3((4 * W - 1) downto (3 * W));
	TK3_PERMUTED((8 * W - 1) downto (7 * W)) <= TK3((13 * W - 1) downto (12 * W));
	TK3_PERMUTED((7 * W - 1) downto (6 * W)) <= TK3((11 * W - 1) downto (10 * W));
	TK3_PERMUTED((6 * W - 1) downto (5 * W)) <= TK3((9 * W - 1) downto (8 * W));
	TK3_PERMUTED((5 * W - 1) downto (4 * W)) <= TK3((12 * W - 1) downto (11 * W));
	TK3_PERMUTED((4 * W - 1) downto (3 * W)) <= TK3((15 * W - 1) downto (14 * W));
	TK3_PERMUTED((3 * W - 1) downto (2 * W)) <= TK3((14 * W - 1) downto (13 * W));
	TK3_PERMUTED((2 * W - 1) downto (1 * W)) <= TK3((16 * W - 1) downto (15 * W));
	TK3_PERMUTED((1 * W - 1) downto (0 * W)) <= TK3((10 * W - 1) downto (9 * W));
    
    -- Upper half of the state
    TK3_FF(35 downto 32) <= TK3_PERMUTED(32) & ( TK3_PERMUTED(34) xor TK3_PERMUTED(35) ) & ( TK3_PERMUTED(33) xor TK3_PERMUTED(34) ) & ( TK3_PERMUTED(32) xor TK3_PERMUTED(33) );
    TK3_FF(39 downto 36) <= TK3_PERMUTED(36) & ( TK3_PERMUTED(38) xor TK3_PERMUTED(39) ) & ( TK3_PERMUTED(37) xor TK3_PERMUTED(38) ) & ( TK3_PERMUTED(36) xor TK3_PERMUTED(37) );
    TK3_FF(43 downto 40) <= TK3_PERMUTED(40) & ( TK3_PERMUTED(42) xor TK3_PERMUTED(43) ) & ( TK3_PERMUTED(41) xor TK3_PERMUTED(42) ) & ( TK3_PERMUTED(40) xor TK3_PERMUTED(41) );
    TK3_FF(47 downto 44) <= TK3_PERMUTED(44) & ( TK3_PERMUTED(46) xor TK3_PERMUTED(47) ) & ( TK3_PERMUTED(45) xor TK3_PERMUTED(46) ) & ( TK3_PERMUTED(44) xor TK3_PERMUTED(45) );
    TK3_FF(51 downto 48) <= TK3_PERMUTED(48) & ( TK3_PERMUTED(50) xor TK3_PERMUTED(51) ) & ( TK3_PERMUTED(49) xor TK3_PERMUTED(50) ) & ( TK3_PERMUTED(48) xor TK3_PERMUTED(49) );
    TK3_FF(55 downto 52) <= TK3_PERMUTED(52) & ( TK3_PERMUTED(54) xor TK3_PERMUTED(55) ) & ( TK3_PERMUTED(53) xor TK3_PERMUTED(54) ) & ( TK3_PERMUTED(52) xor TK3_PERMUTED(53) );
    TK3_FF(59 downto 56) <= TK3_PERMUTED(56) & ( TK3_PERMUTED(58) xor TK3_PERMUTED(59) ) & ( TK3_PERMUTED(57) xor TK3_PERMUTED(58) ) & ( TK3_PERMUTED(56) xor TK3_PERMUTED(57) );
    TK3_FF(63 downto 60) <= TK3_PERMUTED(60) & ( TK3_PERMUTED(62) xor TK3_PERMUTED(63) ) & ( TK3_PERMUTED(61) xor TK3_PERMUTED(62) ) & ( TK3_PERMUTED(60) xor TK3_PERMUTED(61) );
    -- Lower half of the state
    TK3_FF(3 downto 0) <= ( TK3_PERMUTED(2) xor TK3_PERMUTED(3) ) & ( TK3_PERMUTED(1) xor TK3_PERMUTED(2) ) & ( TK3_PERMUTED(0) xor TK3_PERMUTED(1) ) & ( TK3_PERMUTED(0) xor TK3_PERMUTED(2) xor TK3_PERMUTED(3) );
    TK3_FF(7 downto 4) <= ( TK3_PERMUTED(6) xor TK3_PERMUTED(7) ) & ( TK3_PERMUTED(5) xor TK3_PERMUTED(6) ) & ( TK3_PERMUTED(4) xor TK3_PERMUTED(5) ) & ( TK3_PERMUTED(4) xor TK3_PERMUTED(6) xor TK3_PERMUTED(7) );
    TK3_FF(11 downto 8) <= ( TK3_PERMUTED(10) xor TK3_PERMUTED(11) ) & ( TK3_PERMUTED(9) xor TK3_PERMUTED(10) ) & ( TK3_PERMUTED(8) xor TK3_PERMUTED(9) ) & ( TK3_PERMUTED(8) xor TK3_PERMUTED(10) xor TK3_PERMUTED(11) );
    TK3_FF(15 downto 12) <= ( TK3_PERMUTED(14) xor TK3_PERMUTED(15) ) & ( TK3_PERMUTED(13) xor TK3_PERMUTED(14) ) & ( TK3_PERMUTED(12) xor TK3_PERMUTED(13) ) & ( TK3_PERMUTED(12) xor TK3_PERMUTED(14) xor TK3_PERMUTED(15) );
    TK3_FF(19 downto 16) <= ( TK3_PERMUTED(18) xor TK3_PERMUTED(19) ) & ( TK3_PERMUTED(17) xor TK3_PERMUTED(18) ) & ( TK3_PERMUTED(16) xor TK3_PERMUTED(17) ) & ( TK3_PERMUTED(16) xor TK3_PERMUTED(18) xor TK3_PERMUTED(19) );
    TK3_FF(23 downto 20) <= ( TK3_PERMUTED(22) xor TK3_PERMUTED(23) ) & ( TK3_PERMUTED(21) xor TK3_PERMUTED(22) ) & ( TK3_PERMUTED(20) xor TK3_PERMUTED(21) ) & ( TK3_PERMUTED(20) xor TK3_PERMUTED(22) xor TK3_PERMUTED(23) );
    TK3_FF(27 downto 24) <= ( TK3_PERMUTED(26) xor TK3_PERMUTED(27) ) & ( TK3_PERMUTED(25) xor TK3_PERMUTED(26) ) & ( TK3_PERMUTED(24) xor TK3_PERMUTED(25) ) & ( TK3_PERMUTED(24) xor TK3_PERMUTED(26) xor TK3_PERMUTED(27) );
    TK3_FF(31 downto 28) <= ( TK3_PERMUTED(30) xor TK3_PERMUTED(31) ) & ( TK3_PERMUTED(29) xor TK3_PERMUTED(30) ) & ( TK3_PERMUTED(28) xor TK3_PERMUTED(29) ) & ( TK3_PERMUTED(28) xor TK3_PERMUTED(30) xor TK3_PERMUTED(31) );
    end generate;


    FF_128_192 : IF (BS = BLOCK_SIZE_128 AND TS = TWEAK_SIZE_3o2N) GENERATE



        -- 27-times FORWARD application of TK1 schedule
        -- Generating the following permutation: [12, 10, 14, 9, 13, 15, 11, 8, 6, 4, 5, 0, 3, 1, 7, 2]
        TK1_FF((16 * W - 1) downto (15 * W)) <= TK1((4 * W - 1) downto (3 * W));
        TK1_FF((15 * W - 1) downto (14 * W)) <= TK1((6 * W - 1) downto (5 * W));
        TK1_FF((14 * W - 1) downto (13 * W)) <= TK1((2 * W - 1) downto (1 * W));
        TK1_FF((13 * W - 1) downto (12 * W)) <= TK1((7 * W - 1) downto (6 * W));
        TK1_FF((12 * W - 1) downto (11 * W)) <= TK1((3 * W - 1) downto (2 * W));
        TK1_FF((11 * W - 1) downto (10 * W)) <= TK1((1 * W - 1) downto (0 * W));
        TK1_FF((10 * W - 1) downto (9 * W)) <= TK1((5 * W - 1) downto (4 * W));
        TK1_FF((9 * W - 1) downto (8 * W)) <= TK1((8 * W - 1) downto (7 * W));
        TK1_FF((8 * W - 1) downto (7 * W)) <= TK1((10 * W - 1) downto (9 * W));
        TK1_FF((7 * W - 1) downto (6 * W)) <= TK1((12 * W - 1) downto (11 * W));
        TK1_FF((6 * W - 1) downto (5 * W)) <= TK1((11 * W - 1) downto (10 * W));
        TK1_FF((5 * W - 1) downto (4 * W)) <= TK1((16 * W - 1) downto (15 * W));
        TK1_FF((4 * W - 1) downto (3 * W)) <= TK1((13 * W - 1) downto (12 * W));
        TK1_FF((3 * W - 1) downto (2 * W)) <= TK1((15 * W - 1) downto (14 * W));
        TK1_FF((2 * W - 1) downto (1 * W)) <= TK1((9 * W - 1) downto (8 * W));
        TK1_FF((1 * W - 1) downto (0 * W)) <= TK1((14 * W - 1) downto (13 * W));



        -- 26-times FORWARD application of TK2 schedule (note the 26 instead of 27)
        -- Generating the following permutation: [6, 4, 5, 0, 3, 1, 7, 2]
        TK2_PERMUTED((8 * W - 1) downto (7 * W)) <= TK2((2 * W - 1) downto (1 * W));
        TK2_PERMUTED((7 * W - 1) downto (6 * W)) <= TK2((4 * W - 1) downto (3 * W));
        TK2_PERMUTED((6 * W - 1) downto (5 * W)) <= TK2((3 * W - 1) downto (2 * W));
        TK2_PERMUTED((5 * W - 1) downto (4 * W)) <= TK2((8 * W - 1) downto (7 * W));
        TK2_PERMUTED((4 * W - 1) downto (3 * W)) <= TK2((5 * W - 1) downto (4 * W));
        TK2_PERMUTED((3 * W - 1) downto (2 * W)) <= TK2((7 * W - 1) downto (6 * W));
        TK2_PERMUTED((2 * W - 1) downto (1 * W)) <= TK2((1 * W - 1) downto (0 * W));
        TK2_PERMUTED((1 * W - 1) downto (0 * W)) <= TK2((6 * W - 1) downto (5 * W));
        
        -- Half of the state
        TK2_FF(7 downto 0) <= ( TK2_PERMUTED(0) xor TK2_PERMUTED(2) ) & ( TK2_PERMUTED(1) xor TK2_PERMUTED(5) xor TK2_PERMUTED(7) ) & ( TK2_PERMUTED(0) xor TK2_PERMUTED(4) xor TK2_PERMUTED(6) ) & ( TK2_PERMUTED(3) xor TK2_PERMUTED(7) ) & ( TK2_PERMUTED(2) xor TK2_PERMUTED(6) ) & ( TK2_PERMUTED(1) xor TK2_PERMUTED(5) ) & ( TK2_PERMUTED(0) xor TK2_PERMUTED(4) ) & ( TK2_PERMUTED(3) xor TK2_PERMUTED(5) xor TK2_PERMUTED(7) );
        TK2_FF(15 downto 8) <= ( TK2_PERMUTED(8) xor TK2_PERMUTED(10) ) & ( TK2_PERMUTED(9) xor TK2_PERMUTED(13) xor TK2_PERMUTED(15) ) & ( TK2_PERMUTED(8) xor TK2_PERMUTED(12) xor TK2_PERMUTED(14) ) & ( TK2_PERMUTED(11) xor TK2_PERMUTED(15) ) & ( TK2_PERMUTED(10) xor TK2_PERMUTED(14) ) & ( TK2_PERMUTED(9) xor TK2_PERMUTED(13) ) & ( TK2_PERMUTED(8) xor TK2_PERMUTED(12) ) & ( TK2_PERMUTED(11) xor TK2_PERMUTED(13) xor TK2_PERMUTED(15) );
        TK2_FF(23 downto 16) <= ( TK2_PERMUTED(16) xor TK2_PERMUTED(18) ) & ( TK2_PERMUTED(17) xor TK2_PERMUTED(21) xor TK2_PERMUTED(23) ) & ( TK2_PERMUTED(16) xor TK2_PERMUTED(20) xor TK2_PERMUTED(22) ) & ( TK2_PERMUTED(19) xor TK2_PERMUTED(23) ) & ( TK2_PERMUTED(18) xor TK2_PERMUTED(22) ) & ( TK2_PERMUTED(17) xor TK2_PERMUTED(21) ) & ( TK2_PERMUTED(16) xor TK2_PERMUTED(20) ) & ( TK2_PERMUTED(19) xor TK2_PERMUTED(21) xor TK2_PERMUTED(23) );
        TK2_FF(31 downto 24) <= ( TK2_PERMUTED(24) xor TK2_PERMUTED(26) ) & ( TK2_PERMUTED(25) xor TK2_PERMUTED(29) xor TK2_PERMUTED(31) ) & ( TK2_PERMUTED(24) xor TK2_PERMUTED(28) xor TK2_PERMUTED(30) ) & ( TK2_PERMUTED(27) xor TK2_PERMUTED(31) ) & ( TK2_PERMUTED(26) xor TK2_PERMUTED(30) ) & ( TK2_PERMUTED(25) xor TK2_PERMUTED(29) ) & ( TK2_PERMUTED(24) xor TK2_PERMUTED(28) ) & ( TK2_PERMUTED(27) xor TK2_PERMUTED(29) xor TK2_PERMUTED(31) );
        TK2_FF(39 downto 32) <= ( TK2_PERMUTED(32) xor TK2_PERMUTED(34) ) & ( TK2_PERMUTED(33) xor TK2_PERMUTED(37) xor TK2_PERMUTED(39) ) & ( TK2_PERMUTED(32) xor TK2_PERMUTED(36) xor TK2_PERMUTED(38) ) & ( TK2_PERMUTED(35) xor TK2_PERMUTED(39) ) & ( TK2_PERMUTED(34) xor TK2_PERMUTED(38) ) & ( TK2_PERMUTED(33) xor TK2_PERMUTED(37) ) & ( TK2_PERMUTED(32) xor TK2_PERMUTED(36) ) & ( TK2_PERMUTED(35) xor TK2_PERMUTED(37) xor TK2_PERMUTED(39) );
        TK2_FF(47 downto 40) <= ( TK2_PERMUTED(40) xor TK2_PERMUTED(42) ) & ( TK2_PERMUTED(41) xor TK2_PERMUTED(45) xor TK2_PERMUTED(47) ) & ( TK2_PERMUTED(40) xor TK2_PERMUTED(44) xor TK2_PERMUTED(46) ) & ( TK2_PERMUTED(43) xor TK2_PERMUTED(47) ) & ( TK2_PERMUTED(42) xor TK2_PERMUTED(46) ) & ( TK2_PERMUTED(41) xor TK2_PERMUTED(45) ) & ( TK2_PERMUTED(40) xor TK2_PERMUTED(44) ) & ( TK2_PERMUTED(43) xor TK2_PERMUTED(45) xor TK2_PERMUTED(47) );
        TK2_FF(55 downto 48) <= ( TK2_PERMUTED(48) xor TK2_PERMUTED(50) ) & ( TK2_PERMUTED(49) xor TK2_PERMUTED(53) xor TK2_PERMUTED(55) ) & ( TK2_PERMUTED(48) xor TK2_PERMUTED(52) xor TK2_PERMUTED(54) ) & ( TK2_PERMUTED(51) xor TK2_PERMUTED(55) ) & ( TK2_PERMUTED(50) xor TK2_PERMUTED(54) ) & ( TK2_PERMUTED(49) xor TK2_PERMUTED(53) ) & ( TK2_PERMUTED(48) xor TK2_PERMUTED(52) ) & ( TK2_PERMUTED(51) xor TK2_PERMUTED(53) xor TK2_PERMUTED(55) );
        TK2_FF(63 downto 56) <= ( TK2_PERMUTED(56) xor TK2_PERMUTED(58) ) & ( TK2_PERMUTED(57) xor TK2_PERMUTED(61) xor TK2_PERMUTED(63) ) & ( TK2_PERMUTED(56) xor TK2_PERMUTED(60) xor TK2_PERMUTED(62) ) & ( TK2_PERMUTED(59) xor TK2_PERMUTED(63) ) & ( TK2_PERMUTED(58) xor TK2_PERMUTED(62) ) & ( TK2_PERMUTED(57) xor TK2_PERMUTED(61) ) & ( TK2_PERMUTED(56) xor TK2_PERMUTED(60) ) & ( TK2_PERMUTED(59) xor TK2_PERMUTED(61) xor TK2_PERMUTED(63) );




    end generate;


    FF_128_256 : IF (BS = BLOCK_SIZE_128 AND TS = TWEAK_SIZE_2N) GENERATE

        -- Generating the following permutation: [12, 10, 14, 9, 13, 15, 11, 8, 6, 4, 5, 0, 3, 1, 7, 2]
        TK1_FF((16 * W - 1) downto (15 * W)) <= TK1((4 * W - 1) downto (3 * W));
        TK1_FF((15 * W - 1) downto (14 * W)) <= TK1((6 * W - 1) downto (5 * W));
        TK1_FF((14 * W - 1) downto (13 * W)) <= TK1((2 * W - 1) downto (1 * W));
        TK1_FF((13 * W - 1) downto (12 * W)) <= TK1((7 * W - 1) downto (6 * W));
        TK1_FF((12 * W - 1) downto (11 * W)) <= TK1((3 * W - 1) downto (2 * W));
        TK1_FF((11 * W - 1) downto (10 * W)) <= TK1((1 * W - 1) downto (0 * W));
        TK1_FF((10 * W - 1) downto (9 * W)) <= TK1((5 * W - 1) downto (4 * W));
        TK1_FF((9 * W - 1) downto (8 * W)) <= TK1((8 * W - 1) downto (7 * W));
        TK1_FF((8 * W - 1) downto (7 * W)) <= TK1((10 * W - 1) downto (9 * W));
        TK1_FF((7 * W - 1) downto (6 * W)) <= TK1((12 * W - 1) downto (11 * W));
        TK1_FF((6 * W - 1) downto (5 * W)) <= TK1((11 * W - 1) downto (10 * W));
        TK1_FF((5 * W - 1) downto (4 * W)) <= TK1((16 * W - 1) downto (15 * W));
        TK1_FF((4 * W - 1) downto (3 * W)) <= TK1((13 * W - 1) downto (12 * W));
        TK1_FF((3 * W - 1) downto (2 * W)) <= TK1((15 * W - 1) downto (14 * W));
        TK1_FF((2 * W - 1) downto (1 * W)) <= TK1((9 * W - 1) downto (8 * W));
        TK1_FF((1 * W - 1) downto (0 * W)) <= TK1((14 * W - 1) downto (13 * W));

        -- Generating the following permutation: [12, 10, 14, 9, 13, 15, 11, 8, 6, 4, 5, 0, 3, 1, 7, 2]
        TK2_PERMUTED((16 * W - 1) downto (15 * W)) <= TK2((4 * W - 1) downto (3 * W));
        TK2_PERMUTED((15 * W - 1) downto (14 * W)) <= TK2((6 * W - 1) downto (5 * W));
        TK2_PERMUTED((14 * W - 1) downto (13 * W)) <= TK2((2 * W - 1) downto (1 * W));
        TK2_PERMUTED((13 * W - 1) downto (12 * W)) <= TK2((7 * W - 1) downto (6 * W));
        TK2_PERMUTED((12 * W - 1) downto (11 * W)) <= TK2((3 * W - 1) downto (2 * W));
        TK2_PERMUTED((11 * W - 1) downto (10 * W)) <= TK2((1 * W - 1) downto (0 * W));
        TK2_PERMUTED((10 * W - 1) downto (9 * W)) <= TK2((5 * W - 1) downto (4 * W));
        TK2_PERMUTED((9 * W - 1) downto (8 * W)) <= TK2((8 * W - 1) downto (7 * W));
        TK2_PERMUTED((8 * W - 1) downto (7 * W)) <= TK2((10 * W - 1) downto (9 * W));
        TK2_PERMUTED((7 * W - 1) downto (6 * W)) <= TK2((12 * W - 1) downto (11 * W));
        TK2_PERMUTED((6 * W - 1) downto (5 * W)) <= TK2((11 * W - 1) downto (10 * W));
        TK2_PERMUTED((5 * W - 1) downto (4 * W)) <= TK2((16 * W - 1) downto (15 * W));
        TK2_PERMUTED((4 * W - 1) downto (3 * W)) <= TK2((13 * W - 1) downto (12 * W));
        TK2_PERMUTED((3 * W - 1) downto (2 * W)) <= TK2((15 * W - 1) downto (14 * W));
        TK2_PERMUTED((2 * W - 1) downto (1 * W)) <= TK2((9 * W - 1) downto (8 * W));
        TK2_PERMUTED((1 * W - 1) downto (0 * W)) <= TK2((14 * W - 1) downto (13 * W));

        -- Upper half of the state
        TK2_FF(71 downto 64) <= ( TK2_PERMUTED(65) xor TK2_PERMUTED(69) xor TK2_PERMUTED(71) ) & ( TK2_PERMUTED(64) xor TK2_PERMUTED(68) xor TK2_PERMUTED(70) ) & ( TK2_PERMUTED(67) xor TK2_PERMUTED(71) ) & ( TK2_PERMUTED(66) xor TK2_PERMUTED(70) ) & ( TK2_PERMUTED(65) xor TK2_PERMUTED(69) ) & ( TK2_PERMUTED(64) xor TK2_PERMUTED(68) ) & ( TK2_PERMUTED(67) xor TK2_PERMUTED(69) xor TK2_PERMUTED(71) ) & ( TK2_PERMUTED(66) xor TK2_PERMUTED(68) xor TK2_PERMUTED(70) );
        TK2_FF(79 downto 72) <= ( TK2_PERMUTED(73) xor TK2_PERMUTED(77) xor TK2_PERMUTED(79) ) & ( TK2_PERMUTED(72) xor TK2_PERMUTED(76) xor TK2_PERMUTED(78) ) & ( TK2_PERMUTED(75) xor TK2_PERMUTED(79) ) & ( TK2_PERMUTED(74) xor TK2_PERMUTED(78) ) & ( TK2_PERMUTED(73) xor TK2_PERMUTED(77) ) & ( TK2_PERMUTED(72) xor TK2_PERMUTED(76) ) & ( TK2_PERMUTED(75) xor TK2_PERMUTED(77) xor TK2_PERMUTED(79) ) & ( TK2_PERMUTED(74) xor TK2_PERMUTED(76) xor TK2_PERMUTED(78) );
        TK2_FF(87 downto 80) <= ( TK2_PERMUTED(81) xor TK2_PERMUTED(85) xor TK2_PERMUTED(87) ) & ( TK2_PERMUTED(80) xor TK2_PERMUTED(84) xor TK2_PERMUTED(86) ) & ( TK2_PERMUTED(83) xor TK2_PERMUTED(87) ) & ( TK2_PERMUTED(82) xor TK2_PERMUTED(86) ) & ( TK2_PERMUTED(81) xor TK2_PERMUTED(85) ) & ( TK2_PERMUTED(80) xor TK2_PERMUTED(84) ) & ( TK2_PERMUTED(83) xor TK2_PERMUTED(85) xor TK2_PERMUTED(87) ) & ( TK2_PERMUTED(82) xor TK2_PERMUTED(84) xor TK2_PERMUTED(86) );
        TK2_FF(95 downto 88) <= ( TK2_PERMUTED(89) xor TK2_PERMUTED(93) xor TK2_PERMUTED(95) ) & ( TK2_PERMUTED(88) xor TK2_PERMUTED(92) xor TK2_PERMUTED(94) ) & ( TK2_PERMUTED(91) xor TK2_PERMUTED(95) ) & ( TK2_PERMUTED(90) xor TK2_PERMUTED(94) ) & ( TK2_PERMUTED(89) xor TK2_PERMUTED(93) ) & ( TK2_PERMUTED(88) xor TK2_PERMUTED(92) ) & ( TK2_PERMUTED(91) xor TK2_PERMUTED(93) xor TK2_PERMUTED(95) ) & ( TK2_PERMUTED(90) xor TK2_PERMUTED(92) xor TK2_PERMUTED(94) );
        TK2_FF(103 downto 96) <= ( TK2_PERMUTED(97) xor TK2_PERMUTED(101) xor TK2_PERMUTED(103) ) & ( TK2_PERMUTED(96) xor TK2_PERMUTED(100) xor TK2_PERMUTED(102) ) & ( TK2_PERMUTED(99) xor TK2_PERMUTED(103) ) & ( TK2_PERMUTED(98) xor TK2_PERMUTED(102) ) & ( TK2_PERMUTED(97) xor TK2_PERMUTED(101) ) & ( TK2_PERMUTED(96) xor TK2_PERMUTED(100) ) & ( TK2_PERMUTED(99) xor TK2_PERMUTED(101) xor TK2_PERMUTED(103) ) & ( TK2_PERMUTED(98) xor TK2_PERMUTED(100) xor TK2_PERMUTED(102) );
        TK2_FF(111 downto 104) <= ( TK2_PERMUTED(105) xor TK2_PERMUTED(109) xor TK2_PERMUTED(111) ) & ( TK2_PERMUTED(104) xor TK2_PERMUTED(108) xor TK2_PERMUTED(110) ) & ( TK2_PERMUTED(107) xor TK2_PERMUTED(111) ) & ( TK2_PERMUTED(106) xor TK2_PERMUTED(110) ) & ( TK2_PERMUTED(105) xor TK2_PERMUTED(109) ) & ( TK2_PERMUTED(104) xor TK2_PERMUTED(108) ) & ( TK2_PERMUTED(107) xor TK2_PERMUTED(109) xor TK2_PERMUTED(111) ) & ( TK2_PERMUTED(106) xor TK2_PERMUTED(108) xor TK2_PERMUTED(110) );
        TK2_FF(119 downto 112) <= ( TK2_PERMUTED(113) xor TK2_PERMUTED(117) xor TK2_PERMUTED(119) ) & ( TK2_PERMUTED(112) xor TK2_PERMUTED(116) xor TK2_PERMUTED(118) ) & ( TK2_PERMUTED(115) xor TK2_PERMUTED(119) ) & ( TK2_PERMUTED(114) xor TK2_PERMUTED(118) ) & ( TK2_PERMUTED(113) xor TK2_PERMUTED(117) ) & ( TK2_PERMUTED(112) xor TK2_PERMUTED(116) ) & ( TK2_PERMUTED(115) xor TK2_PERMUTED(117) xor TK2_PERMUTED(119) ) & ( TK2_PERMUTED(114) xor TK2_PERMUTED(116) xor TK2_PERMUTED(118) );
        TK2_FF(127 downto 120) <= ( TK2_PERMUTED(121) xor TK2_PERMUTED(125) xor TK2_PERMUTED(127) ) & ( TK2_PERMUTED(120) xor TK2_PERMUTED(124) xor TK2_PERMUTED(126) ) & ( TK2_PERMUTED(123) xor TK2_PERMUTED(127) ) & ( TK2_PERMUTED(122) xor TK2_PERMUTED(126) ) & ( TK2_PERMUTED(121) xor TK2_PERMUTED(125) ) & ( TK2_PERMUTED(120) xor TK2_PERMUTED(124) ) & ( TK2_PERMUTED(123) xor TK2_PERMUTED(125) xor TK2_PERMUTED(127) ) & ( TK2_PERMUTED(122) xor TK2_PERMUTED(124) xor TK2_PERMUTED(126) );
        -- Lower half of the state
        TK2_FF(7 downto 0) <= ( TK2_PERMUTED(0) xor TK2_PERMUTED(2) ) & ( TK2_PERMUTED(1) xor TK2_PERMUTED(5) xor TK2_PERMUTED(7) ) & ( TK2_PERMUTED(0) xor TK2_PERMUTED(4) xor TK2_PERMUTED(6) ) & ( TK2_PERMUTED(3) xor TK2_PERMUTED(7) ) & ( TK2_PERMUTED(2) xor TK2_PERMUTED(6) ) & ( TK2_PERMUTED(1) xor TK2_PERMUTED(5) ) & ( TK2_PERMUTED(0) xor TK2_PERMUTED(4) ) & ( TK2_PERMUTED(3) xor TK2_PERMUTED(5) xor TK2_PERMUTED(7) );
        TK2_FF(15 downto 8) <= ( TK2_PERMUTED(8) xor TK2_PERMUTED(10) ) & ( TK2_PERMUTED(9) xor TK2_PERMUTED(13) xor TK2_PERMUTED(15) ) & ( TK2_PERMUTED(8) xor TK2_PERMUTED(12) xor TK2_PERMUTED(14) ) & ( TK2_PERMUTED(11) xor TK2_PERMUTED(15) ) & ( TK2_PERMUTED(10) xor TK2_PERMUTED(14) ) & ( TK2_PERMUTED(9) xor TK2_PERMUTED(13) ) & ( TK2_PERMUTED(8) xor TK2_PERMUTED(12) ) & ( TK2_PERMUTED(11) xor TK2_PERMUTED(13) xor TK2_PERMUTED(15) );
        TK2_FF(23 downto 16) <= ( TK2_PERMUTED(16) xor TK2_PERMUTED(18) ) & ( TK2_PERMUTED(17) xor TK2_PERMUTED(21) xor TK2_PERMUTED(23) ) & ( TK2_PERMUTED(16) xor TK2_PERMUTED(20) xor TK2_PERMUTED(22) ) & ( TK2_PERMUTED(19) xor TK2_PERMUTED(23) ) & ( TK2_PERMUTED(18) xor TK2_PERMUTED(22) ) & ( TK2_PERMUTED(17) xor TK2_PERMUTED(21) ) & ( TK2_PERMUTED(16) xor TK2_PERMUTED(20) ) & ( TK2_PERMUTED(19) xor TK2_PERMUTED(21) xor TK2_PERMUTED(23) );
        TK2_FF(31 downto 24) <= ( TK2_PERMUTED(24) xor TK2_PERMUTED(26) ) & ( TK2_PERMUTED(25) xor TK2_PERMUTED(29) xor TK2_PERMUTED(31) ) & ( TK2_PERMUTED(24) xor TK2_PERMUTED(28) xor TK2_PERMUTED(30) ) & ( TK2_PERMUTED(27) xor TK2_PERMUTED(31) ) & ( TK2_PERMUTED(26) xor TK2_PERMUTED(30) ) & ( TK2_PERMUTED(25) xor TK2_PERMUTED(29) ) & ( TK2_PERMUTED(24) xor TK2_PERMUTED(28) ) & ( TK2_PERMUTED(27) xor TK2_PERMUTED(29) xor TK2_PERMUTED(31) );
        TK2_FF(39 downto 32) <= ( TK2_PERMUTED(32) xor TK2_PERMUTED(34) ) & ( TK2_PERMUTED(33) xor TK2_PERMUTED(37) xor TK2_PERMUTED(39) ) & ( TK2_PERMUTED(32) xor TK2_PERMUTED(36) xor TK2_PERMUTED(38) ) & ( TK2_PERMUTED(35) xor TK2_PERMUTED(39) ) & ( TK2_PERMUTED(34) xor TK2_PERMUTED(38) ) & ( TK2_PERMUTED(33) xor TK2_PERMUTED(37) ) & ( TK2_PERMUTED(32) xor TK2_PERMUTED(36) ) & ( TK2_PERMUTED(35) xor TK2_PERMUTED(37) xor TK2_PERMUTED(39) );
        TK2_FF(47 downto 40) <= ( TK2_PERMUTED(40) xor TK2_PERMUTED(42) ) & ( TK2_PERMUTED(41) xor TK2_PERMUTED(45) xor TK2_PERMUTED(47) ) & ( TK2_PERMUTED(40) xor TK2_PERMUTED(44) xor TK2_PERMUTED(46) ) & ( TK2_PERMUTED(43) xor TK2_PERMUTED(47) ) & ( TK2_PERMUTED(42) xor TK2_PERMUTED(46) ) & ( TK2_PERMUTED(41) xor TK2_PERMUTED(45) ) & ( TK2_PERMUTED(40) xor TK2_PERMUTED(44) ) & ( TK2_PERMUTED(43) xor TK2_PERMUTED(45) xor TK2_PERMUTED(47) );
        TK2_FF(55 downto 48) <= ( TK2_PERMUTED(48) xor TK2_PERMUTED(50) ) & ( TK2_PERMUTED(49) xor TK2_PERMUTED(53) xor TK2_PERMUTED(55) ) & ( TK2_PERMUTED(48) xor TK2_PERMUTED(52) xor TK2_PERMUTED(54) ) & ( TK2_PERMUTED(51) xor TK2_PERMUTED(55) ) & ( TK2_PERMUTED(50) xor TK2_PERMUTED(54) ) & ( TK2_PERMUTED(49) xor TK2_PERMUTED(53) ) & ( TK2_PERMUTED(48) xor TK2_PERMUTED(52) ) & ( TK2_PERMUTED(51) xor TK2_PERMUTED(53) xor TK2_PERMUTED(55) );
        TK2_FF(63 downto 56) <= ( TK2_PERMUTED(56) xor TK2_PERMUTED(58) ) & ( TK2_PERMUTED(57) xor TK2_PERMUTED(61) xor TK2_PERMUTED(63) ) & ( TK2_PERMUTED(56) xor TK2_PERMUTED(60) xor TK2_PERMUTED(62) ) & ( TK2_PERMUTED(59) xor TK2_PERMUTED(63) ) & ( TK2_PERMUTED(58) xor TK2_PERMUTED(62) ) & ( TK2_PERMUTED(57) xor TK2_PERMUTED(61) ) & ( TK2_PERMUTED(56) xor TK2_PERMUTED(60) ) & ( TK2_PERMUTED(59) xor TK2_PERMUTED(61) xor TK2_PERMUTED(63) );
    end generate;



    FF_128_288 : IF (BS = BLOCK_SIZE_128 AND (TS = TWEAK_SIZE_3N or TS = TWEAK_SIZE_9o4N)) GENERATE

        -- 31-times FORWARD application of TK1 schedule
        -- Generating the following permutation: [8, 9, 10, 11, 12, 13, 14, 15, 2, 0, 4, 7, 6, 3, 5, 1]
        TK1_FF((16 * W - 1) downto (15 * W)) <= TK1((8 * W - 1) downto (7 * W));
        TK1_FF((15 * W - 1) downto (14 * W)) <= TK1((7 * W - 1) downto (6 * W));
        TK1_FF((14 * W - 1) downto (13 * W)) <= TK1((6 * W - 1) downto (5 * W));
        TK1_FF((13 * W - 1) downto (12 * W)) <= TK1((5 * W - 1) downto (4 * W));
        TK1_FF((12 * W - 1) downto (11 * W)) <= TK1((4 * W - 1) downto (3 * W));
        TK1_FF((11 * W - 1) downto (10 * W)) <= TK1((3 * W - 1) downto (2 * W));
        TK1_FF((10 * W - 1) downto (9 * W)) <= TK1((2 * W - 1) downto (1 * W));
        TK1_FF((9 * W - 1) downto (8 * W)) <= TK1((1 * W - 1) downto (0 * W));
        TK1_FF((8 * W - 1) downto (7 * W)) <= TK1((14 * W - 1) downto (13 * W));
        TK1_FF((7 * W - 1) downto (6 * W)) <= TK1((16 * W - 1) downto (15 * W));
        TK1_FF((6 * W - 1) downto (5 * W)) <= TK1((12 * W - 1) downto (11 * W));
        TK1_FF((5 * W - 1) downto (4 * W)) <= TK1((9 * W - 1) downto (8 * W));
        TK1_FF((4 * W - 1) downto (3 * W)) <= TK1((10 * W - 1) downto (9 * W));
        TK1_FF((3 * W - 1) downto (2 * W)) <= TK1((13 * W - 1) downto (12 * W));
        TK1_FF((2 * W - 1) downto (1 * W)) <= TK1((11 * W - 1) downto (10 * W));
        TK1_FF((1 * W - 1) downto (0 * W)) <= TK1((15 * W - 1) downto (14 * W));

        -- 31-times FORWARD application of TK2 schedule
        -- Generating the following permutation: [8, 9, 10, 11, 12, 13, 14, 15, 2, 0, 4, 7, 6, 3, 5, 1]
        TK2_PERMUTED((16 * W - 1) downto (15 * W)) <= TK2((8 * W - 1) downto (7 * W));
        TK2_PERMUTED((15 * W - 1) downto (14 * W)) <= TK2((7 * W - 1) downto (6 * W));
        TK2_PERMUTED((14 * W - 1) downto (13 * W)) <= TK2((6 * W - 1) downto (5 * W));
        TK2_PERMUTED((13 * W - 1) downto (12 * W)) <= TK2((5 * W - 1) downto (4 * W));
        TK2_PERMUTED((12 * W - 1) downto (11 * W)) <= TK2((4 * W - 1) downto (3 * W));
        TK2_PERMUTED((11 * W - 1) downto (10 * W)) <= TK2((3 * W - 1) downto (2 * W));
        TK2_PERMUTED((10 * W - 1) downto (9 * W)) <= TK2((2 * W - 1) downto (1 * W));
        TK2_PERMUTED((9 * W - 1) downto (8 * W)) <= TK2((1 * W - 1) downto (0 * W));
        TK2_PERMUTED((8 * W - 1) downto (7 * W)) <= TK2((14 * W - 1) downto (13 * W));
        TK2_PERMUTED((7 * W - 1) downto (6 * W)) <= TK2((16 * W - 1) downto (15 * W));
        TK2_PERMUTED((6 * W - 1) downto (5 * W)) <= TK2((12 * W - 1) downto (11 * W));
        TK2_PERMUTED((5 * W - 1) downto (4 * W)) <= TK2((9 * W - 1) downto (8 * W));
        TK2_PERMUTED((4 * W - 1) downto (3 * W)) <= TK2((10 * W - 1) downto (9 * W));
        TK2_PERMUTED((3 * W - 1) downto (2 * W)) <= TK2((13 * W - 1) downto (12 * W));
        TK2_PERMUTED((2 * W - 1) downto (1 * W)) <= TK2((11 * W - 1) downto (10 * W));
        TK2_PERMUTED((1 * W - 1) downto (0 * W)) <= TK2((15 * W - 1) downto (14 * W));

        -- Upper half of the state
        TK2_FF(71 downto 64) <= ( TK2_PERMUTED(67) xor TK2_PERMUTED(71) ) & ( TK2_PERMUTED(66) xor TK2_PERMUTED(70) ) & ( TK2_PERMUTED(65) xor TK2_PERMUTED(69) ) & ( TK2_PERMUTED(64) xor TK2_PERMUTED(68) ) & ( TK2_PERMUTED(67) xor TK2_PERMUTED(69) xor TK2_PERMUTED(71) ) & ( TK2_PERMUTED(66) xor TK2_PERMUTED(68) xor TK2_PERMUTED(70) ) & ( TK2_PERMUTED(65) xor TK2_PERMUTED(67) xor TK2_PERMUTED(69) ) & ( TK2_PERMUTED(64) xor TK2_PERMUTED(66) xor TK2_PERMUTED(68) );
        TK2_FF(79 downto 72) <= ( TK2_PERMUTED(75) xor TK2_PERMUTED(79) ) & ( TK2_PERMUTED(74) xor TK2_PERMUTED(78) ) & ( TK2_PERMUTED(73) xor TK2_PERMUTED(77) ) & ( TK2_PERMUTED(72) xor TK2_PERMUTED(76) ) & ( TK2_PERMUTED(75) xor TK2_PERMUTED(77) xor TK2_PERMUTED(79) ) & ( TK2_PERMUTED(74) xor TK2_PERMUTED(76) xor TK2_PERMUTED(78) ) & ( TK2_PERMUTED(73) xor TK2_PERMUTED(75) xor TK2_PERMUTED(77) ) & ( TK2_PERMUTED(72) xor TK2_PERMUTED(74) xor TK2_PERMUTED(76) );
        TK2_FF(87 downto 80) <= ( TK2_PERMUTED(83) xor TK2_PERMUTED(87) ) & ( TK2_PERMUTED(82) xor TK2_PERMUTED(86) ) & ( TK2_PERMUTED(81) xor TK2_PERMUTED(85) ) & ( TK2_PERMUTED(80) xor TK2_PERMUTED(84) ) & ( TK2_PERMUTED(83) xor TK2_PERMUTED(85) xor TK2_PERMUTED(87) ) & ( TK2_PERMUTED(82) xor TK2_PERMUTED(84) xor TK2_PERMUTED(86) ) & ( TK2_PERMUTED(81) xor TK2_PERMUTED(83) xor TK2_PERMUTED(85) ) & ( TK2_PERMUTED(80) xor TK2_PERMUTED(82) xor TK2_PERMUTED(84) );
        TK2_FF(95 downto 88) <= ( TK2_PERMUTED(91) xor TK2_PERMUTED(95) ) & ( TK2_PERMUTED(90) xor TK2_PERMUTED(94) ) & ( TK2_PERMUTED(89) xor TK2_PERMUTED(93) ) & ( TK2_PERMUTED(88) xor TK2_PERMUTED(92) ) & ( TK2_PERMUTED(91) xor TK2_PERMUTED(93) xor TK2_PERMUTED(95) ) & ( TK2_PERMUTED(90) xor TK2_PERMUTED(92) xor TK2_PERMUTED(94) ) & ( TK2_PERMUTED(89) xor TK2_PERMUTED(91) xor TK2_PERMUTED(93) ) & ( TK2_PERMUTED(88) xor TK2_PERMUTED(90) xor TK2_PERMUTED(92) );
        TK2_FF(103 downto 96) <= ( TK2_PERMUTED(99) xor TK2_PERMUTED(103) ) & ( TK2_PERMUTED(98) xor TK2_PERMUTED(102) ) & ( TK2_PERMUTED(97) xor TK2_PERMUTED(101) ) & ( TK2_PERMUTED(96) xor TK2_PERMUTED(100) ) & ( TK2_PERMUTED(99) xor TK2_PERMUTED(101) xor TK2_PERMUTED(103) ) & ( TK2_PERMUTED(98) xor TK2_PERMUTED(100) xor TK2_PERMUTED(102) ) & ( TK2_PERMUTED(97) xor TK2_PERMUTED(99) xor TK2_PERMUTED(101) ) & ( TK2_PERMUTED(96) xor TK2_PERMUTED(98) xor TK2_PERMUTED(100) );
        TK2_FF(111 downto 104) <= ( TK2_PERMUTED(107) xor TK2_PERMUTED(111) ) & ( TK2_PERMUTED(106) xor TK2_PERMUTED(110) ) & ( TK2_PERMUTED(105) xor TK2_PERMUTED(109) ) & ( TK2_PERMUTED(104) xor TK2_PERMUTED(108) ) & ( TK2_PERMUTED(107) xor TK2_PERMUTED(109) xor TK2_PERMUTED(111) ) & ( TK2_PERMUTED(106) xor TK2_PERMUTED(108) xor TK2_PERMUTED(110) ) & ( TK2_PERMUTED(105) xor TK2_PERMUTED(107) xor TK2_PERMUTED(109) ) & ( TK2_PERMUTED(104) xor TK2_PERMUTED(106) xor TK2_PERMUTED(108) );
        TK2_FF(119 downto 112) <= ( TK2_PERMUTED(115) xor TK2_PERMUTED(119) ) & ( TK2_PERMUTED(114) xor TK2_PERMUTED(118) ) & ( TK2_PERMUTED(113) xor TK2_PERMUTED(117) ) & ( TK2_PERMUTED(112) xor TK2_PERMUTED(116) ) & ( TK2_PERMUTED(115) xor TK2_PERMUTED(117) xor TK2_PERMUTED(119) ) & ( TK2_PERMUTED(114) xor TK2_PERMUTED(116) xor TK2_PERMUTED(118) ) & ( TK2_PERMUTED(113) xor TK2_PERMUTED(115) xor TK2_PERMUTED(117) ) & ( TK2_PERMUTED(112) xor TK2_PERMUTED(114) xor TK2_PERMUTED(116) );
        TK2_FF(127 downto 120) <= ( TK2_PERMUTED(123) xor TK2_PERMUTED(127) ) & ( TK2_PERMUTED(122) xor TK2_PERMUTED(126) ) & ( TK2_PERMUTED(121) xor TK2_PERMUTED(125) ) & ( TK2_PERMUTED(120) xor TK2_PERMUTED(124) ) & ( TK2_PERMUTED(123) xor TK2_PERMUTED(125) xor TK2_PERMUTED(127) ) & ( TK2_PERMUTED(122) xor TK2_PERMUTED(124) xor TK2_PERMUTED(126) ) & ( TK2_PERMUTED(121) xor TK2_PERMUTED(123) xor TK2_PERMUTED(125) ) & ( TK2_PERMUTED(120) xor TK2_PERMUTED(122) xor TK2_PERMUTED(124) );
        -- Lower half of the state
        TK2_FF(7 downto 0) <= ( TK2_PERMUTED(0) xor TK2_PERMUTED(4) xor TK2_PERMUTED(6) ) & ( TK2_PERMUTED(3) xor TK2_PERMUTED(7) ) & ( TK2_PERMUTED(2) xor TK2_PERMUTED(6) ) & ( TK2_PERMUTED(1) xor TK2_PERMUTED(5) ) & ( TK2_PERMUTED(0) xor TK2_PERMUTED(4) ) & ( TK2_PERMUTED(3) xor TK2_PERMUTED(5) xor TK2_PERMUTED(7) ) & ( TK2_PERMUTED(2) xor TK2_PERMUTED(4) xor TK2_PERMUTED(6) ) & ( TK2_PERMUTED(1) xor TK2_PERMUTED(3) xor TK2_PERMUTED(5) );
        TK2_FF(15 downto 8) <= ( TK2_PERMUTED(8) xor TK2_PERMUTED(12) xor TK2_PERMUTED(14) ) & ( TK2_PERMUTED(11) xor TK2_PERMUTED(15) ) & ( TK2_PERMUTED(10) xor TK2_PERMUTED(14) ) & ( TK2_PERMUTED(9) xor TK2_PERMUTED(13) ) & ( TK2_PERMUTED(8) xor TK2_PERMUTED(12) ) & ( TK2_PERMUTED(11) xor TK2_PERMUTED(13) xor TK2_PERMUTED(15) ) & ( TK2_PERMUTED(10) xor TK2_PERMUTED(12) xor TK2_PERMUTED(14) ) & ( TK2_PERMUTED(9) xor TK2_PERMUTED(11) xor TK2_PERMUTED(13) );
        TK2_FF(23 downto 16) <= ( TK2_PERMUTED(16) xor TK2_PERMUTED(20) xor TK2_PERMUTED(22) ) & ( TK2_PERMUTED(19) xor TK2_PERMUTED(23) ) & ( TK2_PERMUTED(18) xor TK2_PERMUTED(22) ) & ( TK2_PERMUTED(17) xor TK2_PERMUTED(21) ) & ( TK2_PERMUTED(16) xor TK2_PERMUTED(20) ) & ( TK2_PERMUTED(19) xor TK2_PERMUTED(21) xor TK2_PERMUTED(23) ) & ( TK2_PERMUTED(18) xor TK2_PERMUTED(20) xor TK2_PERMUTED(22) ) & ( TK2_PERMUTED(17) xor TK2_PERMUTED(19) xor TK2_PERMUTED(21) );
        TK2_FF(31 downto 24) <= ( TK2_PERMUTED(24) xor TK2_PERMUTED(28) xor TK2_PERMUTED(30) ) & ( TK2_PERMUTED(27) xor TK2_PERMUTED(31) ) & ( TK2_PERMUTED(26) xor TK2_PERMUTED(30) ) & ( TK2_PERMUTED(25) xor TK2_PERMUTED(29) ) & ( TK2_PERMUTED(24) xor TK2_PERMUTED(28) ) & ( TK2_PERMUTED(27) xor TK2_PERMUTED(29) xor TK2_PERMUTED(31) ) & ( TK2_PERMUTED(26) xor TK2_PERMUTED(28) xor TK2_PERMUTED(30) ) & ( TK2_PERMUTED(25) xor TK2_PERMUTED(27) xor TK2_PERMUTED(29) );
        TK2_FF(39 downto 32) <= ( TK2_PERMUTED(32) xor TK2_PERMUTED(36) xor TK2_PERMUTED(38) ) & ( TK2_PERMUTED(35) xor TK2_PERMUTED(39) ) & ( TK2_PERMUTED(34) xor TK2_PERMUTED(38) ) & ( TK2_PERMUTED(33) xor TK2_PERMUTED(37) ) & ( TK2_PERMUTED(32) xor TK2_PERMUTED(36) ) & ( TK2_PERMUTED(35) xor TK2_PERMUTED(37) xor TK2_PERMUTED(39) ) & ( TK2_PERMUTED(34) xor TK2_PERMUTED(36) xor TK2_PERMUTED(38) ) & ( TK2_PERMUTED(33) xor TK2_PERMUTED(35) xor TK2_PERMUTED(37) );
        TK2_FF(47 downto 40) <= ( TK2_PERMUTED(40) xor TK2_PERMUTED(44) xor TK2_PERMUTED(46) ) & ( TK2_PERMUTED(43) xor TK2_PERMUTED(47) ) & ( TK2_PERMUTED(42) xor TK2_PERMUTED(46) ) & ( TK2_PERMUTED(41) xor TK2_PERMUTED(45) ) & ( TK2_PERMUTED(40) xor TK2_PERMUTED(44) ) & ( TK2_PERMUTED(43) xor TK2_PERMUTED(45) xor TK2_PERMUTED(47) ) & ( TK2_PERMUTED(42) xor TK2_PERMUTED(44) xor TK2_PERMUTED(46) ) & ( TK2_PERMUTED(41) xor TK2_PERMUTED(43) xor TK2_PERMUTED(45) );
        TK2_FF(55 downto 48) <= ( TK2_PERMUTED(48) xor TK2_PERMUTED(52) xor TK2_PERMUTED(54) ) & ( TK2_PERMUTED(51) xor TK2_PERMUTED(55) ) & ( TK2_PERMUTED(50) xor TK2_PERMUTED(54) ) & ( TK2_PERMUTED(49) xor TK2_PERMUTED(53) ) & ( TK2_PERMUTED(48) xor TK2_PERMUTED(52) ) & ( TK2_PERMUTED(51) xor TK2_PERMUTED(53) xor TK2_PERMUTED(55) ) & ( TK2_PERMUTED(50) xor TK2_PERMUTED(52) xor TK2_PERMUTED(54) ) & ( TK2_PERMUTED(49) xor TK2_PERMUTED(51) xor TK2_PERMUTED(53) );
        TK2_FF(63 downto 56) <= ( TK2_PERMUTED(56) xor TK2_PERMUTED(60) xor TK2_PERMUTED(62) ) & ( TK2_PERMUTED(59) xor TK2_PERMUTED(63) ) & ( TK2_PERMUTED(58) xor TK2_PERMUTED(62) ) & ( TK2_PERMUTED(57) xor TK2_PERMUTED(61) ) & ( TK2_PERMUTED(56) xor TK2_PERMUTED(60) ) & ( TK2_PERMUTED(59) xor TK2_PERMUTED(61) xor TK2_PERMUTED(63) ) & ( TK2_PERMUTED(58) xor TK2_PERMUTED(60) xor TK2_PERMUTED(62) ) & ( TK2_PERMUTED(57) xor TK2_PERMUTED(59) xor TK2_PERMUTED(61) );


    -- 30-times FORWARD application of TK3 schedule (note the 30, not 31)
    -- Generating the following permutation: [2, 0, 4, 7, 6, 3, 5, 1, 10, 8, 12, 15, 14, 11, 13, 9]
	TK3_PERMUTED((8 * W - 1) downto (7 * W)) <= TK3((6 * W - 1) downto (5 * W));
	TK3_PERMUTED((7 * W - 1) downto (6 * W)) <= TK3((8 * W - 1) downto (7 * W));
	TK3_PERMUTED((6 * W - 1) downto (5 * W)) <= TK3((4 * W - 1) downto (3 * W));
	TK3_PERMUTED((5 * W - 1) downto (4 * W)) <= TK3((1 * W - 1) downto (0 * W));
	TK3_PERMUTED((4 * W - 1) downto (3 * W)) <= TK3((2 * W - 1) downto (1 * W));
	TK3_PERMUTED((3 * W - 1) downto (2 * W)) <= TK3((5 * W - 1) downto (4 * W));
	TK3_PERMUTED((2 * W - 1) downto (1 * W)) <= TK3((3 * W - 1) downto (2 * W));
	TK3_PERMUTED((1 * W - 1) downto (0 * W)) <= TK3((7 * W - 1) downto (6 * W));

    -- Lower half of the state
    TK3_FF(7 downto 0) <= ( TK3_PERMUTED(0) xor TK3_PERMUTED(4) xor TK3_PERMUTED(6) ) & ( TK3_PERMUTED(3) xor TK3_PERMUTED(7) ) & ( TK3_PERMUTED(2) xor TK3_PERMUTED(6) ) & ( TK3_PERMUTED(1) xor TK3_PERMUTED(5) ) & ( TK3_PERMUTED(0) xor TK3_PERMUTED(4) ) & ( TK3_PERMUTED(3) xor TK3_PERMUTED(5) xor TK3_PERMUTED(7) ) & ( TK3_PERMUTED(2) xor TK3_PERMUTED(4) xor TK3_PERMUTED(6) ) & ( TK3_PERMUTED(1) xor TK3_PERMUTED(3) xor TK3_PERMUTED(5) );
    TK3_FF(15 downto 8) <= ( TK3_PERMUTED(8) xor TK3_PERMUTED(12) xor TK3_PERMUTED(14) ) & ( TK3_PERMUTED(11) xor TK3_PERMUTED(15) ) & ( TK3_PERMUTED(10) xor TK3_PERMUTED(14) ) & ( TK3_PERMUTED(9) xor TK3_PERMUTED(13) ) & ( TK3_PERMUTED(8) xor TK3_PERMUTED(12) ) & ( TK3_PERMUTED(11) xor TK3_PERMUTED(13) xor TK3_PERMUTED(15) ) & ( TK3_PERMUTED(10) xor TK3_PERMUTED(12) xor TK3_PERMUTED(14) ) & ( TK3_PERMUTED(9) xor TK3_PERMUTED(11) xor TK3_PERMUTED(13) );
    TK3_FF(23 downto 16) <= ( TK3_PERMUTED(16) xor TK3_PERMUTED(20) xor TK3_PERMUTED(22) ) & ( TK3_PERMUTED(19) xor TK3_PERMUTED(23) ) & ( TK3_PERMUTED(18) xor TK3_PERMUTED(22) ) & ( TK3_PERMUTED(17) xor TK3_PERMUTED(21) ) & ( TK3_PERMUTED(16) xor TK3_PERMUTED(20) ) & ( TK3_PERMUTED(19) xor TK3_PERMUTED(21) xor TK3_PERMUTED(23) ) & ( TK3_PERMUTED(18) xor TK3_PERMUTED(20) xor TK3_PERMUTED(22) ) & ( TK3_PERMUTED(17) xor TK3_PERMUTED(19) xor TK3_PERMUTED(21) );
    TK3_FF(31 downto 24) <= ( TK3_PERMUTED(24) xor TK3_PERMUTED(28) xor TK3_PERMUTED(30) ) & ( TK3_PERMUTED(27) xor TK3_PERMUTED(31) ) & ( TK3_PERMUTED(26) xor TK3_PERMUTED(30) ) & ( TK3_PERMUTED(25) xor TK3_PERMUTED(29) ) & ( TK3_PERMUTED(24) xor TK3_PERMUTED(28) ) & ( TK3_PERMUTED(27) xor TK3_PERMUTED(29) xor TK3_PERMUTED(31) ) & ( TK3_PERMUTED(26) xor TK3_PERMUTED(28) xor TK3_PERMUTED(30) ) & ( TK3_PERMUTED(25) xor TK3_PERMUTED(27) xor TK3_PERMUTED(29) );
    TK3_FF(39 downto 32) <= ( TK3_PERMUTED(32) xor TK3_PERMUTED(36) xor TK3_PERMUTED(38) ) & ( TK3_PERMUTED(35) xor TK3_PERMUTED(39) ) & ( TK3_PERMUTED(34) xor TK3_PERMUTED(38) ) & ( TK3_PERMUTED(33) xor TK3_PERMUTED(37) ) & ( TK3_PERMUTED(32) xor TK3_PERMUTED(36) ) & ( TK3_PERMUTED(35) xor TK3_PERMUTED(37) xor TK3_PERMUTED(39) ) & ( TK3_PERMUTED(34) xor TK3_PERMUTED(36) xor TK3_PERMUTED(38) ) & ( TK3_PERMUTED(33) xor TK3_PERMUTED(35) xor TK3_PERMUTED(37) );
    TK3_FF(47 downto 40) <= ( TK3_PERMUTED(40) xor TK3_PERMUTED(44) xor TK3_PERMUTED(46) ) & ( TK3_PERMUTED(43) xor TK3_PERMUTED(47) ) & ( TK3_PERMUTED(42) xor TK3_PERMUTED(46) ) & ( TK3_PERMUTED(41) xor TK3_PERMUTED(45) ) & ( TK3_PERMUTED(40) xor TK3_PERMUTED(44) ) & ( TK3_PERMUTED(43) xor TK3_PERMUTED(45) xor TK3_PERMUTED(47) ) & ( TK3_PERMUTED(42) xor TK3_PERMUTED(44) xor TK3_PERMUTED(46) ) & ( TK3_PERMUTED(41) xor TK3_PERMUTED(43) xor TK3_PERMUTED(45) );
    TK3_FF(55 downto 48) <= ( TK3_PERMUTED(48) xor TK3_PERMUTED(52) xor TK3_PERMUTED(54) ) & ( TK3_PERMUTED(51) xor TK3_PERMUTED(55) ) & ( TK3_PERMUTED(50) xor TK3_PERMUTED(54) ) & ( TK3_PERMUTED(49) xor TK3_PERMUTED(53) ) & ( TK3_PERMUTED(48) xor TK3_PERMUTED(52) ) & ( TK3_PERMUTED(51) xor TK3_PERMUTED(53) xor TK3_PERMUTED(55) ) & ( TK3_PERMUTED(50) xor TK3_PERMUTED(52) xor TK3_PERMUTED(54) ) & ( TK3_PERMUTED(49) xor TK3_PERMUTED(51) xor TK3_PERMUTED(53) );
    TK3_FF(63 downto 56) <= ( TK3_PERMUTED(56) xor TK3_PERMUTED(60) xor TK3_PERMUTED(62) ) & ( TK3_PERMUTED(59) xor TK3_PERMUTED(63) ) & ( TK3_PERMUTED(58) xor TK3_PERMUTED(62) ) & ( TK3_PERMUTED(57) xor TK3_PERMUTED(61) ) & ( TK3_PERMUTED(56) xor TK3_PERMUTED(60) ) & ( TK3_PERMUTED(59) xor TK3_PERMUTED(61) xor TK3_PERMUTED(63) ) & ( TK3_PERMUTED(58) xor TK3_PERMUTED(60) xor TK3_PERMUTED(62) ) & ( TK3_PERMUTED(57) xor TK3_PERMUTED(59) xor TK3_PERMUTED(61) );


    end generate;


end ARCHITECTURE;


----------------------------------------------------------------------------------
-- Copyright 2016:
--     Amir Moradi & Pascal Sasdrich for the SKINNY Team
--     https://sites.google.com/site/skinnycipher/
--
-- Copyright 2019 (for decryption and forkcipher):
--     Antoon Purnal for the ForkAE team
--     https://www.esat.kuleuven.be/cosic/forkae/
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
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

use work.forkskinnypkg.all;


entity ForkSkinnyRB IS
    GENERIC (   BS : BLOCK_SIZE := BLOCK_SIZE_64; -- Block size: see ForkSkinnyPKG
                TS : TWEAK_SIZE := TWEAK_SIZE_3N; -- Tweakey size: see ForkSkinnyPKG
                ARCH: ENC_DEC := ENCRYPTION_DECRYPTION; -- Encryption-only (ENCRYPTION) or encryption-decryption (ENCRYPTION_DECRYPTION) architecture?
                PARALLEL_ENC : std_logic := '1'; -- Branches after forking in parallel?
                INSTANCE_SPECIFIC : std_logic := '1' -- Enable or disable instance-specific optimization (trades off area for critical path)
                );
    PORT ( CLK			    : in  std_logic;
           -- CONTROL PORTS --------------------------------
           GO		        : in  std_logic;
           ENC_DEC_MODE     : in  std_logic; -- Encryption (0) or decryption (1)
           DONE			    : out std_logic;
           -- DATA PORTS -----------------------------------
           KEY			    : in  std_logic_vector ((GET_TWEAK_SIZE(BS, TS) - 1) downto 0); 
           PLAINTEXT	    : in  std_logic_vector ((GET_BLOCK_SIZE(BS) - 1) downto 0); -- Input for M (or C0 in case of decryption)
           C1	            : out std_logic_vector ((GET_BLOCK_SIZE(BS)	- 1) downto 0); -- Output for C1
           C0	            : out std_logic_vector ((GET_BLOCK_SIZE(BS)	- 1) downto 0)); -- Output for C0 (or M in case of decryption)
END ForkSkinnyRB;



ARCHITECTURE behav OF ForkSkinnyRB IS

	-- CONSTANTS ------------------------------------------------------------------
	constant N : integer := GET_BLOCK_SIZE(BS);
	constant T : integer := GET_TWEAK_SIZE(BS, TS);

	
	-- SIGNALS --------------------------------------------------------------------

    -- State intermediates
    SIGNAL CURRENT_STATE, NEXT_STATE, FORWARD_ROUND_OUT, INVERSE_ROUND_OUT, BRANCH_CONSTANT, BRANCH_CONSTANT2, FORWARD_ROUND_OUT2 : STD_LOGIC_VECTOR((N - 1) DOWNTO 0);
    signal FORKING_STATE, FORKING_IN: std_logic_vector(N-1 downto 0);
    signal MUX_FORWARD_INVERSE: std_logic_vector(N-1 downto 0);

    -- Keys
    signal CURRENT_KEY, NEXT_KEY, KEY_FORWARD, KEY_INVERSE, KEY_DECRYPT, KEY_FF, KEY_FF_INTERMEDIATE: std_logic_vector(T-1 downto 0);
    signal ROUND_KEY: std_logic_vector(T-1 downto 0);
    signal ZEROIZED, ZEROIZED_FF: std_logic_vector(63 downto 0);
    signal TK1, NEXT_TK1 : std_logic_vector (N-1 downto 0);
    signal TK2, NEXT_TK2 : std_logic_vector (N-1 downto 0);
    signal TK3, NEXT_TK3 : std_logic_vector (N-1 downto 0);
	
    -- Control
    signal MODE_DECRYPT, WE_FORK, WE_TK, WE_TK_AUGMENTED, SET_DECRYPTION_KEY, SET_DECRYPTION_KEY_AUGMENTED, INTERNAL_GO, LOAD_IS, SEL_IS: std_logic;
    signal IS_SELECT, KEY_SELECT : std_logic_vector(1 downto 0); -- 2-bit MUX select
    signal FORK_CONDITION : std_logic;
    signal EVEN_ROUND, UNEVEN_ROUND: std_logic;
    signal WE_TK1_AUGMENTED, WE_TK2_AUGMENTED, WE_TK3_AUGMENTED: std_logic;

    -- Status 
    signal DONE_BEFORE_FORK, DONE_C1_BRANCH, DONE_C0_BRANCH_ENC, DONE_C0_BRANCH_DEC, DONE_PLAINTEXT, DONE_FSM : std_logic;
    signal DONE_PLAINTEXT_INTERNAL: std_logic; 

    -- Round constant
    signal CONST_ENC, CONST_DEC, CONST_FF : std_logic_vector(6 downto 0);

BEGIN

    
    ------------------
    -- FSM for EncDec
    ------------------

    FSM_EncDec_X: if ARCH = ENCRYPTION_DECRYPTION generate

        FSM_X: entity work.FSM_ForkSkinny
        port map(CLK => CLK,
                 GO => GO,
                 ENC_DEC_MODE => ENC_DEC_MODE,
                 DONE_FSM => DONE_FSM,
                 MODE_DECRYPT => MODE_DECRYPT,
                 SET_DEC_KEY => SET_DECRYPTION_KEY,
                 WE_TK => WE_TK,
                 INTERNAL_GO => INTERNAL_GO,
                 LOAD_IS => LOAD_IS
                );
    end generate;


    -------------------------
    -- Internal cipher state
    -------------------------

    -- State register in encryption architecure
    GEN_IS_ENC_X: if ARCH = ENCRYPTION generate
        REG_INTERNAL_STATE : ENTITY work.ScanFF
        GENERIC MAP (SIZE => N)
        PORT MAP (
            CLK 	=> CLK,
            SE		=> SEL_IS, 
            D		=> FORWARD_ROUND_OUT,
            DS		=> NEXT_STATE,
            Q		=> CURRENT_STATE
        );
    end generate;

    -- State register in encryption architecure
    GEN_IS_ENCDEC_X: if ARCH = ENCRYPTION_DECRYPTION generate
        REG_INTERNAL_STATE : ENTITY work.ScanFF
        GENERIC MAP (SIZE => N)
        PORT MAP (
            CLK 	=> CLK,
            SE		=> SEL_IS, 
            D		=> NEXT_STATE,
            DS		=> INVERSE_ROUND_OUT,
            Q		=> CURRENT_STATE
        );
    end generate;


    ------------------
    -- Round Constant
    ------------------

    -- Encryption only
    CONSTANT_ENC_X: if ARCH = ENCRYPTION generate
        ConstGen : ENTITY work.RoundConstantEnc
        PORT MAP (
            CLK	=> CLK,
            INIT	=> GO,
            CONST	=> CONST_ENC
        );
    end generate;

    -- Encryption/Decryption
    CONSTANT_ENC_DEC_X: if ARCH = ENCRYPTION_DECRYPTION generate
        ConstGen : ENTITY work.RoundConstantEncDec
        generic map (BS => BS, TS => TS)
        PORT MAP (
            CLK	=> CLK,
            INIT	=> INTERNAL_GO,
            DECRYPT	=> MODE_DECRYPT,
            CONST_ENC	=> CONST_ENC,
            CONST_DEC	=> CONST_DEC
        );
    end generate;

    -- Fast Forward functionality in case parallel encryption is enabled
    GEN_RC_FF_X: if PARALLEL_ENC = '1' generate
        RC_FF_X: entity work.RoundConstantFF 
        generic map (BS => BS, TS => TS)
        port map(CONST => CONST_ENC,
                 CONST_FF => CONST_FF);
    end generate;

    
    -----------------
    -- Forking state
    -----------------

    GEN_FORKING_STATE_SPECIAL: if PARALLEL_ENC = '1' and ARCH = ENCRYPTION generate 
        -- Register at the fork
        L : ENTITY work.ScanFF -- For the encryption-only and parallel architecture, the forking state does not require a WE.
        GENERIC MAP (SIZE => N)
        PORT MAP (
            CLK 	=> CLK,
            SE		=> DONE_BEFORE_FORK,
            D		=> FORWARD_ROUND_OUT2,
            DS		=> BRANCH_CONSTANT,
            Q		=> FORKING_STATE
        );
    end generate; 

    GEN_FORKING_STATE_REGULAR: if PARALLEL_ENC = '0' or ARCH = ENCRYPTION_DECRYPTION generate
        -- Register at the fork
        L : ENTITY work.ScanFF -- All other architectures require write enable at the forking stage
        GENERIC MAP (SIZE => N)
        PORT MAP (
            CLK 	=> CLK,
            SE		=> WE_FORK,
            D		=> FORKING_STATE,
            DS		=> FORKING_IN,
            Q		=> FORKING_STATE
        );
    end generate; 


    -- Second forward round function for parallel versions
    FORK_PARALLEL_X: if PARALLEL_ENC = '1' generate
        RoundFunction2_X : ENTITY work.RoundFunction 
        GENERIC MAP (BS => BS, TS => TS)
        PORT MAP (
            CLK			=> CLK,
            CONST			=> CONST_FF,
            ROUND_KEY	=> KEY_FF,
            ROUND_IN		=> FORKING_STATE,
            ROUND_OUT	=> FORWARD_ROUND_OUT2
        );
    end generate;

    
    --------------------
    -- Tweakey schedule
    --------------------

    -- Register for TK1, present for all ForkSkinny members
    REG_TK1 : ENTITY work.ScanFF
    GENERIC MAP (SIZE => N)
    PORT MAP (
        CLK 	=> CLK,
        SE		=> WE_TK1_AUGMENTED, 
        D		=> TK1,
        DS		=> NEXT_TK1,
        Q		=> TK1
    );

    -- Full TK2?
    GEN_FULL_TK2_X: if TS = TWEAK_SIZE_2N or TS = TWEAK_SIZE_9o4N or TS = TWEAK_SIZE_3N generate
        REG_TK2 : ENTITY work.ScanFF
        GENERIC MAP (SIZE => N)
        PORT MAP (
            CLK 	=> CLK,
            SE		=> WE_TK2_AUGMENTED, 
            D		=> TK2,
            DS		=> NEXT_TK2,
            Q		=> TK2
        );
    end generate;

    -- Half full TK2?
    GEN_HALF_TK2_X: if TS = TWEAK_SIZE_3o2N generate
        REG_TK2 : ENTITY work.ScanFF
        GENERIC MAP (SIZE => N/2)
        PORT MAP (
            CLK 	=> CLK,
            SE		=> WE_TK2_AUGMENTED, 
            D		=> TK2(N/2 - 1 downto 0),
            DS		=> NEXT_TK2(N/2 - 1 downto 0),
            Q		=> TK2(N/2 - 1 downto 0)
        );
    end generate;

    -- Full TK3?
    GEN_FULL_TK3_X: if TS = TWEAK_SIZE_3N generate
        REG_TK2 : ENTITY work.ScanFF
        GENERIC MAP (SIZE => N)
        PORT MAP (
            CLK 	=> CLK,
            SE		=> WE_TK3_AUGMENTED, 
            D		=> TK3,
            DS		=> NEXT_TK3,
            Q		=> TK3
        );
    end generate;

    -- Half full TK3?
    GEN_HALF_TK3_X: if TS = TWEAK_SIZE_9o4N generate
        REG_TK3 : ENTITY work.ScanFF
        GENERIC MAP (SIZE => N/2)
        PORT MAP (
            CLK 	=> CLK,
            SE		=> WE_TK3_AUGMENTED, 
            D		=> TK3(N/2 - 1 downto 0),
            DS		=> NEXT_TK3(N/2 - 1 downto 0),
            Q		=> TK3(N/2 - 1 downto 0)
        );
    end generate;


    -- Assignment of TK inputs and outputs
    NEXT_TK1 <= NEXT_KEY(T-1 downto T - N);

    GEN_TK2_X: if TS = TWEAK_SIZE_2N or TS = TWEAK_SIZE_3o2N generate
        NEXT_TK2(T-N-1 downto 0) <= NEXT_KEY(T-N-1 downto 0);
        CURRENT_KEY <= TK1 & TK2(T-N-1 downto 0);
    end generate;

    GEN_TK3_X: if TS = TWEAK_SIZE_3N or TS = TWEAK_SIZE_9o4N generate
        NEXT_TK2 <= NEXT_KEY(T-N-1 downto T-2*N);
        NEXT_TK3(T-2*N-1 downto 0) <= NEXT_KEY(T-2*N-1 downto 0);
        CURRENT_KEY <= TK1 & TK2 & TK3(T-2*N-1 downto 0);
    end generate;


    --------------------------------------
    -- Forward and Inverse Round Function
    --------------------------------------

	RoundFunction : ENTITY work.RoundFunction
	GENERIC MAP (BS => BS, TS => TS)
	PORT MAP (
		CLK			=> CLK,
		CONST			=> CONST_ENC,
        ROUND_KEY	=> ROUND_KEY,
		ROUND_IN		=> CURRENT_STATE,
        ROUND_OUT	=> FORWARD_ROUND_OUT
	);
    
    INVERSE_ROUND_FUNCTION_X: if ARCH = ENCRYPTION_DECRYPTION generate
        InverseRoundFunction_X : ENTITY work.InverseRoundFunction  -- Inverse Round Function if necessary (EncDec architecture)
            GENERIC MAP (BS => BS, TS => TS)
            PORT MAP (
                CLK			=> CLK,
                CONST			=> CONST_DEC,
                ROUND_KEY	=> ROUND_KEY,
                ROUND_IN		=> CURRENT_STATE,
                ROUND_OUT	=> INVERSE_ROUND_OUT
            );
    end generate;


    -------------------
    -- Branch Constant
    -------------------

    GEN_BC_BEFORE: if ARCH = ENCRYPTION and PARALLEL_ENC = '1' generate
        -- Branch constant BEFORE forking state
        BranchConstant: entity work.BranchConstant
        generic map (BS => BS)
        port map (
            L => FORWARD_ROUND_OUT,
            BRANCH_CONSTANT => BRANCH_CONSTANT 
        );
    end generate;

    GEN_BC_DOUBLE: if ARCH = ENCRYPTION_DECRYPTION and PARALLEL_ENC = '1' generate
         
        BranchConstant: entity work.BranchConstant -- Branch constant BEFORE forking state for encryption
        generic map (BS => BS)
        port map (
            L => FORWARD_ROUND_OUT,
            BRANCH_CONSTANT => BRANCH_CONSTANT
        );

        BranchConstant2: entity work.BranchConstant -- Branch constant AFTER forking state for decryption
        generic map (BS => BS)
        port map (
            L => FORKING_STATE,
            BRANCH_CONSTANT => BRANCH_CONSTANT2
        );
    end generate;

    GEN_BC_AFTER: if PARALLEL_ENC = '0' generate
        -- Branch constant AFTER forking state
        BranchConstant: entity work.BranchConstant
        generic map (BS => BS)
        port map (
            L => FORKING_STATE,
            BRANCH_CONSTANT => BRANCH_CONSTANT 
        );
    end generate;
	

    -----------------
	-- Key Expansion 
    -----------------

    -- Forward Key Schedule
    KS_Forward_X : ENTITY work.ForwardKeySchedule
	GENERIC MAP (BS => BS, TS => TS)
	PORT MAP (
		KEY			=> KEY, -------------@@@@@@@@@@@@@@@@@@CURRENT_KEY
		NEXT_KEY	=> KEY_FORWARD
	);

    KS_DEC_X: if ARCH = ENCRYPTION_DECRYPTION generate

        -- Inverse Key Schedule
        KS_Inverse_X : ENTITY work.InverseKeySchedule
        GENERIC MAP (BS => BS, TS => TS)
        PORT MAP (
            KEY			=> CURRENT_KEY,
            NEXT_KEY	=> KEY_INVERSE
        );

        -- Compute decryption key
        KS_Decryption_Key_X : ENTITY work.DecryptionKey
        GENERIC MAP (BS => BS, TS => TS)
        PORT MAP (
            KEY			=> CURRENT_KEY,
            NEXT_KEY	=> KEY_DECRYPT
        );

    end generate;





    -----------------------------------------------------
    -- State reduction for FSki-128-192 and FSki-128-288
    -----------------------------------------------------

    -- Keep track of EVEN rounds, zeroize TK2 (for 128-192) or TK3 (for 128-288) in odd rounds
    GEN_EVEN_ROUNDS_X: if BS = BLOCK_SIZE_128 and (TS = TWEAK_SIZE_3o2N or TS = TWEAK_SIZE_9o4N) generate

       GEN_EVEN_ROUNDS_ENC_DEC: if ARCH = ENCRYPTION_DECRYPTION generate
           process (clk)
           begin
               if (rising_edge (clk)) then
                   if GO = '1' and INTERNAL_GO = '1' then
                       EVEN_ROUND <= not ENC_DEC_MODE; 
                   elsif ((DONE_PLAINTEXT and MODE_DECRYPT) = '1') then
                       EVEN_ROUND <= EVEN_ROUND;
                   else 
                       EVEN_ROUND <= not EVEN_ROUND;
                   end if;
               end if;
           end process;

           process (clk)
           begin
               if (rising_edge (clk)) then
                   if GO = '1' and INTERNAL_GO = '1' then
                      UNEVEN_ROUND <= ENC_DEC_MODE; 
                   elsif ((DONE_PLAINTEXT and MODE_DECRYPT) = '1') then
                      UNEVEN_ROUND <= UNEVEN_ROUND;
                   else 
                      UNEVEN_ROUND <= EVEN_ROUND; 
                   end if;
               end if;
           end process;

       end generate;

       GEN_EVEN_ROUNDS_ENC: if ARCH = ENCRYPTION generate
           process (clk)
           begin
               if (rising_edge (clk)) then
                   if GO = '1' then
                       EVEN_ROUND <= '1'; 
                   else 
                       EVEN_ROUND <= not EVEN_ROUND;
                   end if;
               end if;
           end process;

           process (clk)
           begin
               if (rising_edge (clk)) then
                   if GO = '1' then
                       UNEVEN_ROUND <= '0'; 
                   else
                       UNEVEN_ROUND <= EVEN_ROUND; 
                   end if;
               end if;
           end process;
       end generate;

       


       Control_EncDec_X: if ARCH = ENCRYPTION_DECRYPTION generate

           GEN_EVEN_ROUNDS_192: if TS = TWEAK_SIZE_3o2N generate
               WE_TK2_AUGMENTED <= (GO and not MODE_DECRYPT) or SET_DECRYPTION_KEY or EVEN_ROUND; 
           end generate;

           GEN_EVEN_ROUNDS_288: if TS = TWEAK_SIZE_9o4N generate
               WE_TK1_AUGMENTED <= WE_TK_AUGMENTED; -- TK1 can always be written
               WE_TK2_AUGMENTED <= WE_TK_AUGMENTED;
               WE_TK3_AUGMENTED <= (GO and not MODE_DECRYPT) or SET_DECRYPTION_KEY or EVEN_ROUND; 
           end generate;

       end generate;

       Control_Enc_X: if ARCH = ENCRYPTION generate
            INTERNAL_GO <= '1';

            GEN_EVEN_ROUNDS_192: if TS = TWEAK_SIZE_3o2N generate
                WE_TK2_AUGMENTED <= GO or EVEN_ROUND; 
            end generate;

           GEN_EVEN_ROUNDS_288: if TS = TWEAK_SIZE_9o4N generate
                WE_TK2_AUGMENTED <= WE_TK_AUGMENTED; 
                WE_TK3_AUGMENTED <= GO or EVEN_ROUND; 
            end generate;
        end generate;

       ZEROIZED <= CURRENT_KEY(63 downto 0) when UNEVEN_ROUND = '0' else (others => '0'); -- Synthesized to AND, not MUX
       ROUND_KEY <= CURRENT_KEY(T-1 downto 64) & ZEROIZED;

    end generate;

    -- FS-128-192 parallel encryption: zeroization logic for the second branch
    GEN_ZEROIZATION: if PARALLEL_ENC = '1' and (TS = TWEAK_SIZE_3o2N or TS = TWEAK_SIZE_9o4N) generate
        ZEROIZED_FF <= KEY_FF_INTERMEDIATE(63 downto 0) when EVEN_ROUND = '0' else (others => '0');
        KEY_FF <= KEY_FF_INTERMEDIATE(T-1 downto 64) & ZEROIZED_FF;
    end generate;
    GEN_NO_ZEROIZATION: if PARALLEL_ENC = '1' and (TS /= TWEAK_SIZE_3o2N and TS /= TWEAK_SIZE_9o4N) generate
        KEY_FF <= KEY_FF_INTERMEDIATE;
    end generate;


    -------------------------------
    -- Selection signals and MUXes
    -------------------------------

    SELECTION_ENC: if ARCH = ENCRYPTION generate

        NEXT_KEY <= KEY when GO = '1' else KEY_FORWARD;

        SELECTION_ENC_PARA: if PARALLEL_ENC = '1' generate
            NEXT_STATE <= PLAINTEXT; -- Parallel encryption: no mux
            SEL_IS <= GO; -- NO FSM, so assign this manually
            KEY_FF_X: entity work.KeyExpansionFF generic map (BS => BS, TS => TS) port map(KEY => CURRENT_KEY, KEY_FF => KEY_FF_INTERMEDIATE); -- Fast-forwarding the key schedule
        end generate;


        SELECTION_ENC_NOT_PARA: if PARALLEL_ENC = '0' generate
            NEXT_STATE <= BRANCH_CONSTANT when DONE_C0_BRANCH_ENC = '1' else PLAINTEXT; -- Non-parallel encryption: MUX to load forking state when needed
            SEL_IS <= GO or DONE_C0_BRANCH_ENC; 
            FORKING_IN <= FORWARD_ROUND_OUT; -- No MUX
            WE_FORK <= DONE_BEFORE_FORK or DONE_C0_BRANCH_ENC; -- Write enable
        end generate;

    end generate;

    SELECTION_ENCDEC: if ARCH = ENCRYPTION_DECRYPTION generate

        SET_DECRYPTION_KEY_AUGMENTED <= (MODE_DECRYPT and (SET_DECRYPTION_KEY or DONE_PLAINTEXT));
        KEY_SELECT <= (SET_DECRYPTION_KEY or (MODE_DECRYPT and not GO)) & (SET_DECRYPTION_KEY_AUGMENTED or GO); -- Uses external GO, SET_DECRYPTION_KEY takes preference
        WE_TK_AUGMENTED <= WE_TK or GO;

        -- For TK1 of FS-128-192 and FS-128-256, the set decryption key operation is equal to doing nothing
        GEN_REDUCED_TK_MUX: if BS = BLOCK_SIZE_128 and (TS = TWEAK_SIZE_2N or TS = TWEAK_SIZE_3o2N) generate

            NO_GEN_INST_SPECIFIC: if INSTANCE_SPECIFIC = '0' generate
                WITH KEY_SELECT select
                    NEXT_KEY <= KEY_INVERSE when "10",
                                KEY_DECRYPT when "11",
                                KEY_FORWARD when "00",
                                KEY when others; -- 01
            end generate;

            -- Save multiplexer
            GEN_INST_SPECIFIC: if INSTANCE_SPECIFIC = '1' generate
                WITH KEY_SELECT select
                    NEXT_KEY(T - 1 downto T - N) <= KEY_INVERSE(T - 1 downto T - N) when "10",
                                KEY_FORWARD(T - 1 downto T - N) when "00",
                                KEY(T - 1 downto T - N) when others; -- 01 (WE_TK1 should be 0 when 11)
                WITH KEY_SELECT select
                    NEXT_KEY(T - N - 1 downto 0) <= KEY_INVERSE(T - N - 1 downto 0) when "10",
                                KEY_DECRYPT(T - N - 1 downto 0) when "11",
                                KEY_FORWARD(T - N - 1 downto 0) when "00",
                                KEY(T - N - 1 downto 0) when others; -- 01
            end generate;
        end generate;

        -- For the other instances, we do need the extra MUX option
        GEN_FULL_TK_MUX: if BS = BLOCK_SIZE_64 or TS = TWEAK_SIZE_9o4N generate
            WITH KEY_SELECT select
                NEXT_KEY <= KEY_INVERSE when "10",
                            KEY_DECRYPT when "11",
                            KEY_FORWARD when "00",
                            KEY when others; -- 01
        end generate;

        SELECTION_ENCDEC_PARA: if PARALLEL_ENC = '1' generate

            SEL_IS <= not LOAD_IS and (MODE_DECRYPT and not DONE_PLAINTEXT);
            IS_SELECT <= (LOAD_IS or (MODE_DECRYPT and DONE_PLAINTEXT)) & LOAD_IS;
            with IS_SELECT select
                NEXT_STATE <= FORWARD_ROUND_OUT when "00",
                          BRANCH_CONSTANT2 when "10",
                          PLAINTEXT when others; 
            FORK_CONDITION <= (not MODE_DECRYPT and DONE_BEFORE_FORK) or (MODE_DECRYPT and (DONE_C0_BRANCH_DEC or DONE_PLAINTEXT)); -- Mux selection signal
            MUX_FORWARD_INVERSE <= BRANCH_CONSTANT when MODE_DECRYPT = '0' else INVERSE_ROUND_OUT; -- MUX
            FORKING_IN <= MUX_FORWARD_INVERSE when FORK_CONDITION = '1' else FORWARD_ROUND_OUT2; -- MUX
            WE_FORK <= not MODE_DECRYPT or (MODE_DECRYPT and (DONE_C0_BRANCH_DEC or DONE_PLAINTEXT)); -- WE always on when encrypting parallel, only for storage when decrypting

            KEY_FF_X: entity work.KeyExpansionFF generic map (BS => BS, TS => TS) port map(KEY => CURRENT_KEY, KEY_FF => KEY_FF_INTERMEDIATE); 

        end generate;

        SELECTION_ENCDEC_NOT_PARA: if PARALLEL_ENC = '0' generate

            SEL_IS <= not LOAD_IS and (MODE_DECRYPT and not DONE_PLAINTEXT);
            IS_SELECT <= LOAD_IS & ((not MODE_DECRYPT and DONE_C0_BRANCH_ENC) or (MODE_DECRYPT and DONE_PLAINTEXT));
            with IS_SELECT select
                NEXT_STATE <= FORWARD_ROUND_OUT when "00",
                              BRANCH_CONSTANT when "01",
                              PLAINTEXT when others;

            FORKING_IN <= FORWARD_ROUND_OUT when MODE_DECRYPT = '0' else INVERSE_ROUND_OUT; -- MUX
            WE_FORK <= (MODE_DECRYPT and (DONE_C0_BRANCH_DEC or DONE_PLAINTEXT)) or (not MODE_DECRYPT and (DONE_BEFORE_FORK or DONE_C0_BRANCH_ENC)); -- WE
            
        end generate;

    end generate;


    WE_TK1_128: if BS = BLOCK_SIZE_128 and (TS = TWEAK_SIZE_3o2N or TS = TWEAK_SIZE_2N) generate
        WE_TK1_AUGMENTED <= not SET_DECRYPTION_KEY_AUGMENTED; -- TK1^48 === not updating the key schedule
    end generate;

    NORMAL_TK_X: if (TS /= TWEAK_SIZE_3o2N and TS /= TWEAK_SIZE_9o4N) generate
       GEN_ENC_WE_TK1: if ARCH = ENCRYPTION or BS = BLOCK_SIZE_64 generate
           WE_TK_AUGMENTED <= WE_TK_AUGMENTED;
       end generate;
       WE_TK2_AUGMENTED <= WE_TK_AUGMENTED; 
       WE_TK3_AUGMENTED <= WE_TK_AUGMENTED;
       ROUND_KEY <= CURRENT_KEY;
    end generate;



    ------------------
    -- Status signals
    ------------------

    STATUS_64 : IF BS = BLOCK_SIZE_64 AND TS = TWEAK_SIZE_3N GENERATE
        -- Encryption
        DONE_BEFORE_FORK <= '1' WHEN (CONST_ENC = "1100111") ELSE '0'; -- RC 17
        DONE_C0_BRANCH_ENC <= '1' WHEN (CONST_ENC = "1010011") ELSE '0'; -- RC 40
        DONE_C1_BRANCH <= '1' WHEN (CONST_ENC = "1110001") ELSE '0'; -- RC 63 + 1 (+1 because we the output is now register and not next_round)
        
        -- Decryption (if necessary)
        STATUS_DEC_X: if ARCH = ENCRYPTION_DECRYPTION generate 
            DONE_C0_BRANCH_DEC <= '1' WHEN (CONST_DEC = "1001111") ELSE '0'; -- RC 18
            DONE_PLAINTEXT <= '1' WHEN (CONST_DEC = "0000001") ELSE '0'; -- RC 1
            DONE_PLAINTEXT_INTERNAL <= '1' WHEN (CONST_DEC = "0000011") ELSE '0'; -- RC 2
        end generate;
    end generate;

    STATUS_128_2 : IF BS = BLOCK_SIZE_128 AND (TS = TWEAK_SIZE_2N or TS = TWEAK_SIZE_3o2N) GENERATE
        -- Encryption
        DONE_BEFORE_FORK <= '1' WHEN (CONST_ENC = "1111010") ELSE '0'; -- RC 21
        DONE_C0_BRANCH_ENC <= '1' WHEN (CONST_ENC = "0010101") ELSE '0'; -- RC 48 
        DONE_C1_BRANCH <= '1' WHEN (CONST_ENC = "0110010") ELSE '0'; -- RC 75 + 1 (+1 because we the output is now register and not next_round)

        -- Decryption (if necessary)
        STATUS_DEC_X: if ARCH = ENCRYPTION_DECRYPTION generate
            DONE_C0_BRANCH_DEC <= '1' WHEN (CONST_DEC = "1110101") ELSE '0'; -- RC 22
            DONE_PLAINTEXT <= '1' WHEN (CONST_DEC = "0000001") ELSE '0'; -- RC 1
            DONE_PLAINTEXT_INTERNAL <= '1' WHEN (CONST_DEC = "0000011") ELSE '0'; -- RC 2
        end generate;
    end generate;

	STATUS_128_3 : IF BS = BLOCK_SIZE_128 AND (TS = TWEAK_SIZE_9o4N or TS = TWEAK_SIZE_3N) GENERATE 
        -- Encryption
        DONE_BEFORE_FORK <= '1' WHEN (CONST_ENC = "0101110") ELSE '0'; -- RC 25
        DONE_C0_BRANCH_ENC <= '1' WHEN (CONST_ENC = "0000010") ELSE '0'; -- RC 56
        DONE_C1_BRANCH <= '1' WHEN (CONST_ENC = "0100001") ELSE '0'; -- RC 87 + 1 (+1 because we the output is now register and not next_round)

        -- Decryption (if necessary)
        STATUS_DEC_X: if ARCH = ENCRYPTION_DECRYPTION generate
            DONE_C0_BRANCH_DEC <= '1' WHEN (CONST_DEC = "1011100") ELSE '0'; -- RC 26
            DONE_PLAINTEXT <= '1' WHEN (CONST_DEC = "0000001") ELSE '0'; -- RC 1
            DONE_PLAINTEXT_INTERNAL <= '1' WHEN (CONST_DEC = "0000011") ELSE '0'; -- RC 2
        end generate;
    end generate;


    -----------
    -- Outputs 
    -----------

    -- Encapsulate the fact that different architectures produce the outputs at different locations in the circuit
    NO_OUTPUT_REMAP: if PARALLEL_ENC = '0' generate
        C1 <= CURRENT_STATE;
        C0 <= FORKING_STATE;
        end generate;
    GEN_OUTPUT_REMAP: if PARALLEL_ENC = '1' generate
        C1 <= FORKING_STATE;
        C0 <= CURRENT_STATE;
    end generate;
    ------

    -- Generate DONE signals
    DONE_X: if ARCH = ENCRYPTION generate
        DONE <= DONE_C1_BRANCH or DONE_C0_BRANCH_ENC;
    end generate;

    DONE_ED_X: if ARCH = ENCRYPTION_DECRYPTION generate

        DONE <= (DONE_PLAINTEXT and MODE_DECRYPT) or ((DONE_C1_BRANCH or DONE_C0_BRANCH_ENC) and not MODE_DECRYPT);
        DONE_ED_NP: if PARALLEL_ENC = '0' generate
            DONE_FSM <= DONE_C1_BRANCH or (DONE_PLAINTEXT_INTERNAL and MODE_DECRYPT); 
        end generate;

        DONE_ED_P: if PARALLEL_ENC = '1' generate
            DONE_FSM <= (not MODE_DECRYPT and (DONE_C0_BRANCH_ENC or DONE_C1_BRANCH)) or (DONE_PLAINTEXT_INTERNAL and MODE_DECRYPT); 
        end generate;

    end generate;

end behav;


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


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
--use work.std_logic_1164_additions.all;
USE WORK.FORKSKINNYPKG.ALL;

entity forkAE_imp IS
    GENERIC (
        G_W             : integer := 64;
        G_SW            : integer := 192;
        size_int        : integer := 64;        
        BS : BLOCK_SIZE := BLOCK_SIZE_64; 
        TS : TWEAK_SIZE := TWEAK_SIZE_3N
    );
    port (
        --! Global ports
        clk             : in  std_logic;--
        rst             : in  std_logic;--
		en_c	: in  std_logic;--
		
		ld_rec             : in  std_logic; --
		IDt             : in  std_logic_vector(size_int-1  downto 0);--
        IDst             : in  std_logic_vector(size_int-1  downto 0);--
          key             : in  std_logic_vector((2*size_int)-1 downto 0);--
        DtSel             : in  std_logic;--
        rand_in        : in  std_logic_vector(size_int-1 downto 0);--
        
		MuxSel2		: in  std_logic;--
        GO		        : in  std_logic;--
        ENC_DEC_MODE    : in  std_logic; -- Encryption (0) or decryption (1)
        DONE            : out std_logic;--
        
		PLAINTEXT 	: in STD_LOGIC_VECTOR(63 DOWNTO 0);
        C1	            : out std_logic_vector ((GET_BLOCK_SIZE(BS)	- 1) downto 0); -- Output for C1
        C0              : out std_logic_vector ((GET_BLOCK_SIZE(BS)    - 1) downto 0) -- Output for C0 (or M in case of decryption)
    );
end forkAE_imp;
	
architecture structural of forkAE_imp is  
signal comxor           : std_logic_vector (size_int-1 downto 0);--
signal secxor           : std_logic_vector (size_int-1 downto 0);--
signal conc1           : std_logic_vector ((2*size_int)-1 downto 0);--
signal conc2           : std_logic_vector ((2*size_int)-1 downto 0);--

signal randd           : std_logic_vector (size_int-1 downto 0);--
signal IDtReg           : std_logic_vector (size_int-1 downto 0);--
signal IDstReg           : std_logic_vector (size_int-1 downto 0);--

signal xor_in           : std_logic_vector (size_int-1 downto 0);--

signal keytt           : std_logic_vector ((2*size_int)-1 downto 0);--

    SIGNAL TWEAKEY 			: STD_LOGIC_VECTOR(191 DOWNTO 0);


begin  

Inst_forkAE:  entity work.ForkSkinnyRB(behav)
   GENERIC MAP (BS => BS, TS => TS, ARCH => ENCRYPTION_DECRYPTION, PARALLEL_ENC => '1', INSTANCE_SPECIFIC => '1')
	PORT MAP (
		CLK => clk,
        GO => GO,
        ENC_DEC_MODE => ENC_DEC_MODE,
        KEY => TWEAKEY,
        PLAINTEXT => PLAINTEXT,
        C1 => C1,
        C0 => C0,
        DONE => DONE
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
    
    Inst_key:  entity work.Regis(behavioral)
        generic map  (
            datasize            => 128         
        )
        port map (
            rst          => rst,
            clk          => clk,
            di     => key,
            load    => ld_rec,
            do    => keytt
        );

xor_in <= IDtReg when (DtSel = '1') else IDstReg;
	
comxor <= rand_in xor xor_in;
secxor <= randd xor IDtReg;
conc1 <= comxor & secxor;
conc2 <= comxor & randd;
       
TWEAKEY(127 downto 0) <= conc1 when (MuxSel2 = '1') else conc2;
TWEAKEY(191 downto 128) <= (OTHERS =>'0');	

end architecture structural;

