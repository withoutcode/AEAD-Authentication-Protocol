-------------------------------------------------------------------------------
--! @file       AEAD_pkg.vhd
--! @brief      Package used for authenticated encyryption
--! @project    CAESAR Candidate Evaluation
--! @author     Ekawat (ice) Homsirikamol
--! @copyright  Copyright (c) 2015 Cryptographic Engineering Research Group
--!             ECE Department, George Mason University Fairfax, VA, U.S.A.
--!             All rights Reserved.
--! @license    This project is released under the GNU Public License.
--!             The license and distribution terms for this file may be
--!             found in the file LICENSE in this distribution or at
--!             http://www.gnu.org/licenses/gpl-3.0.txt
--! @note       This is publicly available encryption source code that falls
--!             under the License Exception TSU (Technology and software-
--!             —unrestricted)
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

package AEAD_pkg is
    --! =======================================================================
    --! BDI Type Encoding for CipherCore (based on SegmentType(3 downto 1))
    constant BDI_TYPE_ASS   : std_logic_vector(3    -1 downto 1) := "00";
    constant BDI_TYPE_ASS0  : std_logic_vector(3    -1 downto 0) := "000";
    constant BDI_TYPE_ASS1  : std_logic_vector(3    -1 downto 0) := "001";
    constant BDI_TYPE_DAT   : std_logic_vector(3    -1 downto 1) := "01";
    constant BDI_TYPE_DAT0  : std_logic_vector(3    -1 downto 0) := "010";
    constant BDI_TYPE_DAT1  : std_logic_vector(3    -1 downto 0) := "011";
    constant BDI_TYPE_TAG   : std_logic_vector(3    -1 downto 0) := "100";
    constant BDI_TYPE_LEN   : std_logic_vector(3    -1 downto 0) := "101";
    constant BDI_TYPE_NPUB  : std_logic_vector(3    -1 downto 0) := "110";
    constant BDI_TYPE_NSEC  : std_logic_vector(3    -1 downto 0) := "111";
    --! =======================================================================
    --! Opcode (used by Pre- and Post-Processors)
	constant OP_ENCDEC      : std_logic_vector(3    -1 downto 0) := "001";
    constant OP_ENC         : std_logic_vector(4    -1 downto 0) := "0010";
    constant OP_DEC         : std_logic_vector(4    -1 downto 0) := "0011";
    constant OP_LDKEY       : std_logic_vector(4    -1 downto 0) := "0100";
    constant OP_ACTKEY      : std_logic_vector(4    -1 downto 0) := "0111";
    --! =======================================================================
    --! Status (used by Pre- and Post-Processors)
    constant STAT_SUCCESS   : std_logic_vector(4    -1 downto 0) := "1110";
    constant STAT_FAILURE   : std_logic_vector(4    -1 downto 0) := "1111";
    --! =======================================================================
    --! Segment Type Encoding (used by Pre- and Post-Processors)
    --! 00XX
    constant ST_A           : std_logic_vector(2    -1 downto 0) := "00";
    constant ST_AD          : std_logic_vector(4    -1 downto 0) := "0001";
    constant ST_NPUB_AD     : std_logic_vector(4    -1 downto 0) := "0010";
    constant ST_AD_NPUB     : std_logic_vector(4    -1 downto 0) := "0011";
    --! 01XX
    constant ST_D           : std_logic_vector(2    -1 downto 0) := "01";
    constant ST_PT          : std_logic_vector(4    -1 downto 0) := "0100";
    constant ST_CT          : std_logic_vector(4    -1 downto 0) := "0101";
    constant ST_CT_TAG      : std_logic_vector(4    -1 downto 0) := "0110";
    --! 10XX
    constant ST_TAG         : std_logic_vector(4    -1 downto 0) := "1000";
    constant ST_LEN         : std_logic_vector(4    -1 downto 0) := "1010";
    --! 11XX
    constant ST_KEY         : std_logic_vector(4    -1 downto 0) := "1100";
    constant ST_NPUB        : std_logic_vector(4    -1 downto 0) := "1101";
    constant ST_NSEC        : std_logic_vector(3    -1 downto 0) := "111";
    constant ST_NSEC_PT     : std_logic_vector(4    -1 downto 0) := "1110";
    constant ST_NSEC_CT     : std_logic_vector(4    -1 downto 0) := "1111";
    --! =======================================================================
    --! Maximum supported length
    constant SINGLE_PASS_MAX  : integer := 32;
    constant TWO_PASS_MAX     : integer := 11;
    --! =======================================================================
    --! Functions
    function log2_ceil (N: natural) return natural;                                         --! Log(2) ceil
end AEAD_pkg;

package body AEAD_pkg is
    --! Log of base 2
    function log2_ceil (N: natural) return natural is
	begin
		 if ( N = 0 ) then
			 return 0;
		 elsif N <= 2 then
			 return 1;
		 else
			if (N mod 2 = 0) then
				return 1 + log2_ceil(N/2);
			else
				return 1 + log2_ceil((N+1)/2);
			end if;
		 end if;
	end function log2_ceil;
end package body AEAD_pkg;


-------------------------------------------------------------------------------
--! @file       AEAD.vhd
--! @author     Ekawat (ice) Homsirikamol
--! @brief      AEAD Entity for ASCON
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.AEAD_pkg.all;

entity AEAD is
    generic (
        --! I/O width (bits)
        G_W             : integer := 32;    --! Public data input
        G_SW            : integer := 32;    --! Secret data input
        --! Reset behavior
        G_ASYNC_RSTN    : boolean := False; --! Async active low reset
        --! Special features parameters
        G_ENABLE_PAD    : boolean := True;  --! Enable padding
        G_CIPH_EXP      : boolean := False; --! Ciphertext expansion
        G_REVERSE_CIPH  : boolean := False; --! Reversed ciphertext
        G_MERGE_TAG     : boolean := False; --! Merge tag with data segment
        --! Block size (bits)
        G_ABLK_SIZE     : integer := 64;    --! Associated data
        G_DBLK_SIZE     : integer := 64;    --! Data
        G_KEY_SIZE      : integer := 32;    --! Key
        G_TAG_SIZE      : integer := 128;   --! Tag
        --! Padding options
        G_PAD_STYLE     : integer := 1;     --! Pad style
        G_PAD_AD        : integer := 3;     --! Padding behavior for AD
        G_PAD_D         : integer := 4;     --! Padding behavior for Data
        --! Maximum supported AD/message/ciphertext length = 2^G_MAX_LEN-1
        G_MAX_LEN       : integer := SINGLE_PASS_MAX
    );
    port (
        --! Global ports
        clk             : in  std_logic;
        rst             : in  std_logic;
        --! Publica data ports
        pdi_data        : in  std_logic_vector(G_W              -1 downto 0);
        pdi_valid       : in  std_logic;
        pdi_ready       : out std_logic;
        --! Secret data ports
        sdi_data        : in  std_logic_vector(G_SW             -1 downto 0);
        sdi_valid       : in  std_logic;
        sdi_ready       : out std_logic;
        --! Data out ports
        do_data         : out std_logic_vector(G_W              -1 downto 0);
        do_ready        : in  std_logic;
        do_valid        : out std_logic
    );
end AEAD;

-------------------------------------------------------------------------------
--! @file       PreProcessor.vhd
--! @brief      Pre-processing unit for an authenticated encryption module.
--! @project    CAESAR Candidate Evaluation
--! @author     Ekawat (ice) Homsirikamol
--! @copyright  Copyright (c) 2015 Cryptographic Engineering Research Group
--!             ECE Department, George Mason University Fairfax, VA, U.S.A.
--!             All rights Reserved.
--! @license    This project is released under the GNU Public License.
--!             The license and distribution terms for this file may be
--!             found in the file LICENSE in this distribution or at
--!             http://www.gnu.org/licenses/gpl-3.0.txt
--! @note       This is publicly available encryption source code that falls
--!             under the License Exception TSU (Technology and software-
--!             —unrestricted)
--! SIPO used within this unit follows the following convention:
--! > Order in the test vector file (left to right):  A(0) A(1) A(2) … A(N-1)
--! > Order at the SIPO input (time 0 to time N-1) :  A(0) A(1) A(2) … A(N-1)
--! > Order at the SIPO output (left to right)     :  A(0) A(1) A(2) … A(N-1)
--! where A is a single I/O word.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AEAD_pkg.all;

entity PreProcessor is
    generic (
        --! I/O size (bits)
        G_W                 : integer := 32;    --! Public data input
        G_SW                : integer := 32;    --! Secret data input
        --! Reset behavior
        G_ASYNC_RSTN        : boolean := False; --! Async active low reset
        --! Special features activation
        G_ENABLE_PAD        : boolean := False; --! Enable padding
        G_CIPH_EXP          : boolean := False; --! Ciphertext expansion
        G_REVERSE_CIPH      : boolean := False; --! Reversed ciphertext
        G_MERGE_TAG         : boolean := False; --! Merge tag with data segment
        --! Block size (bits)
        G_ABLK_SIZE         : integer := 128;   --! Associated data
        G_DBLK_SIZE         : integer := 128;   --! Data
        G_KEY_SIZE          : integer := 128;   --! Key
        --! The number of bits required to hold block size expressed in
        --! bytes = log2_ceil(G_DBLK_SIZE/8)
        G_LBS_BYTES         : integer := 4;
        --! Padding options
        G_PAD_STYLE         : integer := 0;     --! Pad style
        G_PAD_AD            : integer := 1;     --! Padding behavior for AD
        G_PAD_D             : integer := 1      --! Padding behavior for Data
    );
    port (
        --! Global ports
        clk                 : in  std_logic;
        rst                 : in  std_logic;
        --! Publica data ports
        pdi_data            : in  std_logic_vector(G_W          -1 downto 0);
        pdi_valid           : in  std_logic;
        pdi_ready           : out std_logic;
        --! Secret data ports
        sdi_data            : in  std_logic_vector(G_SW         -1 downto 0);
        sdi_valid           : in  std_logic;
        sdi_ready           : out std_logic;
        --! CipherCore
        --!     Key
        key                 : out std_logic_vector(G_KEY_SIZE   -1 downto 0);
        key_ready           : in  std_logic;
        key_valid           : out std_logic;
        key_update          : out std_logic;
        --!     BDI
        bdi                 : out std_logic_vector(G_DBLK_SIZE  -1 downto 0);
        decrypt             : out std_logic;
        bdi_ready           : in  std_logic;
        bdi_valid           : out std_logic;
        bdi_type            : out std_logic_vector(3            -1 downto 0);
        bdi_partial         : out std_logic;
        bdi_eot             : out std_logic;
        bdi_eoi             : out std_logic;
        bdi_size            : out std_logic_vector(G_LBS_BYTES+1-1 downto 0);
        bdi_valid_bytes     : out std_logic_vector(G_DBLK_SIZE/8-1 downto 0);
        bdi_pad_loc         : out std_logic_vector(G_DBLK_SIZE/8-1 downto 0);
        --! CMD FIFO
        cmd                 : out std_logic_vector(24           -1 downto 0);
        cmd_ready           : in  std_logic;
        cmd_valid           : out std_logic
    );
end entity PreProcessor;

architecture structure of PreProcessor is
    constant DSIZE          : integer := G_DBLK_SIZE;
    constant ASIZE          : integer := G_ABLK_SIZE;
    constant WB             : integer := G_W/8; --! Word bytes
    constant LOG2_WB        : integer := log2_ceil(WB);
    constant LOG2_KEYBYTES  : integer := log2_ceil(512/8);
    constant CNT_AWORDS     : integer := (G_ABLK_SIZE+(G_W-1))/G_W;
    constant CNT_DWORDS     : integer := (G_DBLK_SIZE+(G_W-1))/G_W;
    constant CNT_KWORDS     : integer := (G_KEY_SIZE+(G_SW-1))/G_SW;
    constant A_EQ_D         : boolean := (DSIZE = ASIZE);
    constant P_IS_BUFFER    : boolean := not (G_W = DSIZE);
    constant S_IS_BUFFER    : boolean := not (G_SW = G_KEY_SIZE);
    constant NEW_AD         : boolean := (G_PAD_AD = 2) or (G_PAD_AD = 4);
    constant NEW_D          : boolean := (G_PAD_D = 2) or (G_PAD_D = 4);
    --! =======================================================================
    type t_lookup is array (0 to (WB-1))
        of std_logic_vector(WB-1 downto 0);
    function getVbytesLookup(size: integer) return t_lookup is
        variable ret : t_lookup;
    begin
        for i in 0 to ((size/8)-1) loop
            if (i = 0) then
                ret(i) := (others => '0');
            else
                ret(i)(size/8-1   downto size/8-i) := (others => '1');
                ret(i)(size/8-i-1 downto 0)        := (others => '0');
            end if;
        end loop;
        return ret;
    end function getVbytesLookup;
    function getPlocLookup(size: integer) return t_lookup is
        variable ret : t_lookup;
    begin
        for i in 0 to ((size/8)-1) loop
            ret(i) := (others => '0');
            ret(i)((size/8-i)-1) := '1';
        end loop;
        return ret;
    end function getPlocLookup;
    constant VBYTES_LOOKUP  : t_lookup := getVbytesLookup(G_W);
    constant PLOC_LOOKUP    : t_lookup := getPlocLookup(G_W);
    --! =======================================================================
    --! Control status registers
    --!     Public
    signal sgmt_type        : std_logic_vector(4                -1 downto 0);
    signal sgmt_pt          : std_logic;
    signal sgmt_eoi         : std_logic;
    signal sgmt_eot         : std_logic;
    signal sgmt_lst         : std_logic;
    signal sgmt_len         : std_logic_vector(16               -1 downto 0);
    signal is_decrypt       : std_logic;
    --!     Secret
    signal reg_key_update   : std_logic;
    signal reg_key_valid    : std_logic;
    --! =======================================================================
    --! Control signals
    --!     Pad
    signal set_extra        : std_logic;
    signal set_req_pad      : std_logic;
    signal req_pad          : std_logic;
    signal is_extra         : std_logic;
    signal sel_pad          : std_logic;
    signal is_pad           : std_logic;
    signal en_len           : std_logic;
    signal en_zero          : std_logic;
    signal reg_sel_zero     : std_logic;
    --!     Public
    signal pdi_rdy          : std_logic;
    signal bdi_vld          : std_logic;
    signal set_key_upd      : std_logic;
    signal ld_sgmt_info     : std_logic;
    signal ld_ctr           : std_logic;
    signal en_ctr           : std_logic;
    signal en_ps            : std_logic;
    signal en_data          : std_logic;
    signal ctr              : std_logic_vector
        (log2_ceil(CNT_DWORDS)-1 downto 0);
    signal sel_end          : std_logic;
    signal ld_end           : std_logic;
    --!     (unused)
    signal sel_last_word    : std_logic;

    --!     Secret
    signal sdi_rdy          : std_logic;
    signal ld_ctr2          : std_logic;
    signal ld_slen          : std_logic;
    signal en_ctr2          : std_logic;
    signal en_slen          : std_logic;
    signal en_ss            : std_logic;
    signal en_key           : std_logic;
    signal slen             : std_logic_vector(LOG2_KEYBYTES+1  -1 downto 0);
    signal ctr2             : std_logic_vector
        (log2_ceil(CNT_KWORDS)-1 downto 0);
    --!     Cmd
    signal wr_cmd           : std_logic;
    --! =======================================================================
    --! State
    type t_ps is (S_WAIT_INSTR, S_WAIT_HDR, S_PREP, S_DATA, S_WAIT_READY);
    type t_ss is (S_WAIT_INSTR, S_WAIT_HDR, S_DATA, S_WAIT_READY);
    signal ps               : t_ps; --! Public State
    signal nps              : t_ps; --! Next Public State
    signal ss               : t_ss; --! Next Secret State
    signal nss              : t_ss; --! Next Secret State
    --! =======================================================================
    --! Data padding
    signal word_size        : std_logic_vector(LOG2_WB          -1 downto 0);
    signal data             : std_logic_vector(G_W              -1 downto 0);
    --!     Incoming data word
    signal pdata            : std_logic_vector(G_W              -1 downto 0);
    signal vbytes           : std_logic_vector(WB               -1 downto 0);
    signal ploc             : std_logic_vector(WB               -1 downto 0);
    --!     Additional padding selection when ASIZE /= DSIZE
    signal pdata2           : std_logic_vector(G_W              -1 downto 0);
    signal vbytes2          : std_logic_vector(WB               -1 downto 0);
    signal ploc2            : std_logic_vector(WB               -1 downto 0);

    --! Output regs
    --!     Prep status
    signal mux_vbytes       : std_logic_vector(WB               -1 downto 0);
    signal mux_ploc         : std_logic_vector(WB               -1 downto 0);
    signal mux_size         : std_logic_vector(LOG2_WB+1        -1 downto 0);
    signal size             : std_logic_vector(LOG2_WB+1        -1 downto 0);
    --!     Status
    signal reg_bdi_valid    : std_logic;
    signal reg_size         : std_logic_vector(G_LBS_BYTES+1    -1 downto 0);
    signal reg_vbytes       : std_logic_vector(G_DBLK_SIZE/8    -1 downto 0);
    signal reg_ploc         : std_logic_vector(G_DBLK_SIZE/8    -1 downto 0);
    --!     Data / info
    signal reg_key          : std_logic_vector(G_KEY_SIZE       -1 downto 0);
    signal reg_data         : std_logic_vector(G_DBLK_SIZE      -1 downto 0);
    --! =======================================================================
    --! Signal aliases
    signal p_instr_opcode   : std_logic_vector(4                -1 downto 0);
    signal p_sgmt_type      : std_logic_vector(4                -1 downto 0);
    signal p_sgmt_pt        : std_logic;
    signal p_sgmt_eoi       : std_logic;
    signal p_sgmt_eot       : std_logic;
    signal p_sgmt_lst       : std_logic;
    signal p_sgmt_len       : std_logic_vector(16               -1 downto 0);
    signal s_instr_opcode   : std_logic_vector(4                -1 downto 0);
    signal s_sgmt_type      : std_logic_vector(4                -1 downto 0);
    signal s_sgmt_eot       : std_logic;
    signal s_sgmt_lst       : std_logic;
    signal s_sgmt_len       : std_logic_vector(LOG2_KEYBYTES+1   -1 downto 0);
begin
    --! =======================================================================
    --! Datapath (Core)
    --! =======================================================================
    data    <= pdi_data when reg_sel_zero = '0' else (others => '0');

    gPad0: if (not G_ENABLE_PAD) generate
        pdata <= data;
    end generate;
    gPad1: if (G_ENABLE_PAD) generate
    begin
        gPadMode0: if (G_PAD_STYLE = 0) generate
            pdata <= data;
        end generate;
        --! Standard padding scheme (pad10*)
        gPadMode1: if (G_PAD_STYLE = 1) generate
            gLoop: for i in WB-1 downto 0 generate
                pdata(i*8+7)            <= ploc(i) or data(i*8+7);
                pdata(i*8+6 downto i*8) <= data(i*8+6 downto i*8);
            end generate;
        end generate;
        --! ICEPOLE padding scheme
        gPadMode2: if (G_PAD_STYLE = 2) generate
            signal add_pad : std_logic;
        begin
            add_pad <= '1' when (sgmt_type(3 downto 2) = ST_A
                                    and sgmt_eot = '1')
                                or (sgmt_type(3 downto 2) /= ST_A
                                    and sgmt_eot = '0')
                           else '0';
            gLoop: for i in WB-1 downto 0 generate
                pdata(i*8+7 downto i*8+2) <= data(i*8+7 downto i*8+2);
                pdata(i*8+1) <= ploc(i) or data(i*8+1);
                pdata(i*8+0) <= data(i*8+0) or (ploc(i) and add_pad);
            end generate;
        end generate;
        --! STRIBOB padding scheme (padx"01"0*)
        gPadMode3: if (G_PAD_STYLE = 3) generate
        begin
            gLoop: for i in WB-1 downto 0 generate
                pdata(i*8+7 downto i*8+1) <= data(i*8+7 downto i*8+1);
                pdata(i*8+0)              <= ploc(i) or data(i*8+0);
            end generate;
        end generate;
    end generate;

    mux_vbytes <= VBYTES_LOOKUP(to_integer(unsigned(word_size)))
        when sel_pad = '1'
        else (others => '1');
    mux_ploc <= PLOC_LOOKUP(to_integer(unsigned(word_size)))
        when (sel_pad = '1' and req_pad = '1')
        else (others => '0');
    mux_size <= '0' & word_size
        when sel_pad = '1'
        else std_logic_vector(to_unsigned(G_W/8, LOG2_WB+1));

    process(clk)
    begin
        if rising_edge(clk) then
            if (en_len = '1') then
                vbytes <= mux_vbytes;
                ploc   <= mux_ploc;
                size   <= mux_size;
            end if;

            if (en_data = '1') then
                if ((DSIZE > G_W) and (DSIZE MOD G_W)  = 0)  then
                    reg_data  <= reg_data(DSIZE-G_W-1 downto 0) & pdata;
                    reg_vbytes<= reg_vbytes(DSIZE/8-WB-1 downto 0) & vbytes;
                    reg_ploc  <= reg_ploc  (DSIZE/8-WB-1 downto 0) & ploc;
                elsif ((DSIZE MOD G_W) /= 0) then
                    if (sel_last_word = '0') then
                        reg_data  (DSIZE-1   downto (DSIZE MOD G_W )) <=
                            reg_data(DSIZE-G_W-1 downto (DSIZE MOD G_W))
                            & pdata2;
                        reg_vbytes(DSIZE/8-1 downto ((DSIZE/8) MOD WB)) <=
                            reg_vbytes(DSIZE/8-WB-1 downto ((DSIZE/8) MOD WB))
                            & vbytes2;
                        reg_ploc(DSIZE/8-1 downto ((DSIZE/8) MOD WB)) <=
                            reg_ploc(DSIZE/8-WB-1 downto ((DSIZE/8) MOD WB))
                            & ploc2;
                    else
                        reg_data  ((DSIZE mod G_W)-1 downto 0) <=
                            pdata2(G_W  -1 downto  G_W   /2);
                        reg_vbytes(((DSIZE/8) mod WB)-1 downto 0) <=
                            vbytes(WB-1 downto WB/2);
                        reg_ploc(((DSIZE/8) mod WB)-1 downto 0) <=
                            ploc2(WB-1 downto WB/2);
                    end if;
                end if;
            end if;

            if (en_key = '1') then
                if (G_SW < G_KEY_SIZE) then
                    reg_key <= reg_key(G_KEY_SIZE-G_SW-1 downto 0) & sdi_data;
                end if;
            end if;
        end if;
    end process;

    --! =======================================================================
    --! Registers with rst for controller and datapath
    --! =======================================================================
    gSyncRst:
    if (not G_ASYNC_RSTN) generate
        process(clk)
        begin
            if rising_edge(clk) then
                if (rst = '1') then
                    --! Datapath
                    reg_size       <= (others => '0');
                    reg_bdi_valid  <= '0';
                    reg_key_update <= '0';
                    reg_key_valid  <= '0';
                    --! Control
                    req_pad        <= '0';
                    ps             <= S_WAIT_INSTR;
                    ss             <= S_WAIT_INSTR;
                else
                    --! Datapath
                    if (en_data = '1') then
                        reg_size <= std_logic_vector(
                            unsigned(reg_size) + unsigned(size));
                    elsif (bdi_ready = '1') then
                        reg_size <= (others => '0');
                    end if;
                    --! BDI valid register
                    if (en_ps = '1' and nps = S_WAIT_READY) then
                        reg_bdi_valid <= '1';
                    elsif (reg_bdi_valid = '1' and bdi_ready = '1') then
                        reg_bdi_valid <= '0';
                    end if;
                    --! Key update register
                    if (set_key_upd = '1') then
                        reg_key_update <= '1';
                    elsif (key_ready = '1'
                            and ((S_IS_BUFFER and reg_key_valid = '1')
                                or (not S_IS_BUFFER and sdi_valid = '1')))
                    then
                        reg_key_update <= '0';
                    end if;
                    --! Key valid register
                    if (en_ss = '1' and nss = S_WAIT_READY) then
                        reg_key_valid <= '1';
                    elsif (key_ready = '1' and reg_key_valid = '1') then
                        reg_key_valid <= '0';
                    end if;
                    --! Control
                    if (set_req_pad = '1') then
                        req_pad <= '1';
                    elsif (en_len = '1' and sel_pad = '1')
                        or ps = S_WAIT_INSTR
                    then
                        req_pad <= '0';
                    end if;
                    if (en_ps = '1') then
                        ps <= nps;
                    end if;
                    if (en_ss = '1') then
                        ss <= nss;
                    end if;
                end if;
            end if;
        end process;
    end generate;
    gAsyncRstn:
    if (G_ASYNC_RSTN) generate
        process(clk, rst)
        begin
            if (rst = '0') then
                --! Datapath
                reg_size       <= (others => '0');
                reg_bdi_valid  <= '0';
                reg_key_update <= '0';
                reg_key_valid  <= '0';
                --! Control
                req_pad        <= '0';
                ps             <= S_WAIT_INSTR;
                ss             <= S_WAIT_INSTR;
            elsif rising_edge(clk) then
                --! Datapath
                if (en_data = '1') then
                    reg_size <= std_logic_vector(
                        unsigned(reg_size) + unsigned(size));
                elsif (bdi_ready = '1') then
                    reg_size <= (others => '0');
                end if;
                --! BDI valid register
                if (en_ps = '1' and nps = S_WAIT_READY) then
                    reg_bdi_valid <= '1';
                elsif (reg_bdi_valid = '1' and bdi_ready = '1') then
                    reg_bdi_valid <= '0';
                end if;
                --! Key update register
                if (set_key_upd = '1') then
                    reg_key_update <= '1';
                elsif (key_ready = '1'
                        and ((S_IS_BUFFER and reg_key_valid = '1')
                            or (not S_IS_BUFFER and sdi_valid = '1')))
                then
                    reg_key_update <= '0';
                end if;
                --! Key valid register
                if (en_ss = '1' and nss = S_WAIT_READY) then
                    reg_key_valid <= '1';
                elsif (key_ready = '1' and reg_key_valid = '1') then
                    reg_key_valid <= '0';
                end if;
                --! Control
                if (set_req_pad = '1') then
                    req_pad <= '1';
                elsif (en_len = '1' and sel_pad = '1')
                    or ps = S_WAIT_INSTR
                then
                    req_pad <= '0';
                end if;
                if (en_ps = '1') then
                    ps <= nps;
                end if;
                if (en_ss = '1') then
                    ss <= nss;
                end if;
            end if;
        end process;
    end generate;

    --! =======================================================================
    --! Datapath (Output)
    --! =======================================================================
    pdi_ready <= pdi_rdy;
    sdi_ready <= sdi_rdy;
    --!     Public
    decrypt     <= is_decrypt;
    gDsizeEq:
    if (not P_IS_BUFFER) generate
        bdi             <= pdata;
        bdi_type        <= sgmt_type(3 downto 1);
        gNotCiph:
        if (not G_CIPH_EXP) generate
            signal empty : std_logic;
        begin
            empty <= '1' when (unsigned(sgmt_len) = 0)
                       and not (req_pad = '1' and G_ENABLE_PAD
                            and ((sgmt_type(3 downto 2) = ST_A and G_PAD_AD > 2)
                            or (sgmt_type(3 downto 2) = ST_D and G_PAD_D > 2)))
                       else '0';
            bdi_vld <= '1' when (ps = S_DATA  and (pdi_valid = '1' or empty = '1')) else '0';
            bdi_eot <= sgmt_eot
                when (ps = S_DATA and unsigned(sgmt_len) = 0)
                      and not (req_pad = '1' and G_ENABLE_PAD
                        and ((sgmt_type(3 downto 2) = ST_A and G_PAD_AD > 2)
                        or (sgmt_type(3 downto 2) = ST_D and G_PAD_D > 2)))
                else '0';
            bdi_eoi <= sgmt_eoi
                when (ps = S_DATA and unsigned(sgmt_len) = 0)
                      and not (req_pad = '1' and G_ENABLE_PAD
                        and ((sgmt_type(3 downto 2) = ST_A and G_PAD_AD > 2)
                        or (sgmt_type(3 downto 2) = ST_D and G_PAD_D > 2)))
                else '0';
        end generate;
        gCiph:
        if (G_CIPH_EXP) generate
            bdi_vld <= pdi_valid when (ps = S_DATA) else '0';
            bdi_eot <= sgmt_eot or sgmt_eoi
                when (ps = S_DATA and unsigned(sgmt_len) = 0)
                      and (is_decrypt = '1'
                          or not (req_pad = '1' and G_ENABLE_PAD
                            and ((sgmt_type(3 downto 2) = ST_A and G_PAD_AD > 2)
                            or (sgmt_type(3 downto 2) = ST_D and G_PAD_D > 2))))
                else '0';
            bdi_eoi <= sgmt_lst
                when (ps = S_DATA and unsigned(sgmt_len) = 0)
                      and (is_decrypt = '1'
                          or not (req_pad = '1' and G_ENABLE_PAD
                            and ((sgmt_type(3 downto 2) = ST_A and G_PAD_AD > 2)
                            or (sgmt_type(3 downto 2) = ST_D and G_PAD_D > 2))))
                else '0';
            bdi_partial     <= sgmt_pt;
        end generate;
        bdi_size        <= size;
        bdi_valid_bytes <= vbytes;
        bdi_pad_loc     <= ploc;
    end generate;
    gDsizeNeq:
    if (P_IS_BUFFER) generate
        signal en_eoi_last : std_logic;
        signal en_eot_last : std_logic;
    begin
        bdi             <= reg_data;
        bdi_vld         <= reg_bdi_valid;
        bdi_type        <= sgmt_type(3 downto 1);
        pEnd:
        process(clk)
        begin
            if rising_edge(clk) then
                if (ld_end = '1') then
                    if (not G_CIPH_EXP) then
                        bdi_eot <= sgmt_eot and sel_end;
                        bdi_eoi <= sgmt_eoi and sel_end;
                    else
                        bdi_eot <= (sgmt_eot or en_eot_last) and sel_end;
                        bdi_eoi <= (sgmt_eoi or en_eoi_last) and sel_end;
                    end if;
                end if;
            end if;
        end process;
        gCiph:
        if (G_CIPH_EXP) generate
            en_eot_last  <= '1' when
                                ((sgmt_eoi = '1' and sgmt_type = ST_NPUB)
                                or (sgmt_eoi = '1' and G_ENABLE_PAD
                                    and sgmt_type(3 downto 2) = ST_A
                                    and G_PAD_AD /= 2 and G_PAD_AD /= 4)
                                or (sgmt_eoi = '1' and G_ENABLE_PAD
                                    and sgmt_type(3 downto 2) = ST_D
                                    and G_PAD_D /= 2  and G_PAD_D /= 4))
                                else '0';
            en_eoi_last  <= '1' when en_eot_last = '1' and is_decrypt = '0'
                                else '0';
            bdi_partial  <= sgmt_pt;
        end generate;
        bdi_size        <= reg_size;
        bdi_valid_bytes <= reg_vbytes;
        bdi_pad_loc     <= reg_ploc;
    end generate;
    bdi_valid       <= bdi_vld;

    --!     Secret
    gTsizeEq:
    if (S_IS_BUFFER) generate
        key_valid   <= reg_key_valid;
        key         <= reg_key;
    end generate;
    gTsizeNeq:
    if (not S_IS_BUFFER) generate
        key_valid   <= sdi_valid when (ss = S_DATA) else '0';
        key         <= sdi_data;
    end generate;
    key_update  <= reg_key_update;
    --!     CMD FIFO
    cmd       <= pdi_data(G_W-1 downto G_W-5) & '0'
                 & pdi_data(G_W-7 downto G_W-8)
                 & pdi_data(G_W-17 downto G_W-32);
    cmd_valid <= wr_cmd;


    --! =======================================================================
    --! Control
    --! =======================================================================
    process(clk)
    begin
        if rising_edge(clk) then
            --! Operation register
            if (ps = S_WAIT_INSTR) then
                is_decrypt <= p_instr_opcode(0);
            end if;
            --! Length register
            if (ld_sgmt_info = '1') then
                sgmt_type <= p_sgmt_type;
                if (G_CIPH_EXP) then
                    sgmt_pt   <= p_sgmt_pt;
                end if;
                sgmt_eoi  <= p_sgmt_eoi;
                sgmt_eot  <= p_sgmt_eot;
                sgmt_lst  <= p_sgmt_lst;
                sgmt_len  <= p_sgmt_len;
            else
                if (en_len  = '1') then
                    if (sel_pad = '1') then
                        sgmt_len <= (others => '0');
                    else
                        sgmt_len <= std_logic_vector(unsigned(sgmt_len)-WB);
                    end if;
                end if;
            end if;
            --! Padding activation register
            if (en_len = '1') then
                is_pad <= sel_pad;
            end if;
            --! Select zero register
            if (ld_sgmt_info = '1')
                or (P_IS_BUFFER and not A_EQ_D
                    and bdi_ready = '1' and unsigned(sgmt_len) > 0)
            then
                reg_sel_zero <= '0';
            elsif  (unsigned(sgmt_len) = 0 and en_len = '1')
                    or (not A_EQ_D and en_zero = '1')
            then
                reg_sel_zero <= '1';
            end if;
            --! Secret length register
            if (ld_slen = '1') then
                slen <= s_sgmt_len;
            elsif (en_slen = '1') then
                slen <= std_logic_vector(unsigned(slen)-G_KEY_SIZE/8);
            end if;
            --! Extra block register
            if (ld_sgmt_info = '1' or (bdi_ready = '1' and bdi_vld = '1')) then
                is_extra <= '0';
            elsif (set_extra = '1') then
                is_extra <= '1';
            end if;
            --! Public data input counter register
            if (ld_ctr = '1') then
                ctr <= (others => '0');
            elsif (en_ctr = '1') then
                ctr <= std_logic_vector(unsigned(ctr) + 1);
            end if;
            --! Secret data input counter register
            if (ld_ctr2 = '1') then
                ctr2 <= (others => '0');
            elsif (en_ctr2 = '1') then
                ctr2 <= std_logic_vector(unsigned(ctr2) + 1);
            end if;
        end if;
    end process;

    sel_pad <= '1' when (unsigned(sgmt_len) < WB) else '0';

    word_size      <= sgmt_len(LOG2_WB-1 downto 0);
    --! HDR Dissection
    p_instr_opcode <= pdi_data(G_W-1 downto G_W-4);
    p_sgmt_type    <= pdi_data(G_W-1 downto G_W-4);
    p_sgmt_pt      <= pdi_data(G_W-5);
    p_sgmt_eoi     <= pdi_data(G_W-6);
    p_sgmt_eot     <= pdi_data(G_W-7);
    p_sgmt_lst     <= pdi_data(G_W-8);
    p_sgmt_len     <= pdi_data(G_W-17 downto G_W-32);
    s_instr_opcode <= sdi_data(G_SW-1 downto G_SW-4);
    s_sgmt_type    <= sdi_data(G_SW-1 downto G_SW-4);
    s_sgmt_eot     <= sdi_data(G_SW-7);
    s_sgmt_lst     <= sdi_data(G_SW-8);
    s_sgmt_len     <= sdi_data(G_SW-32+LOG2_KEYBYTES downto G_SW-32);

    gPdiComb:
    process(ps, p_instr_opcode, pdi_valid,
        sgmt_len, sgmt_type, sgmt_eot, sgmt_lst,
        p_sgmt_eot, p_sgmt_type,
        bdi_ready, cmd_ready, reg_sel_zero,
        is_extra, ctr)
    begin
        nps          <= ps;
        pdi_rdy      <= '1';
        set_key_upd  <= '0';
        set_req_pad  <= '0';

        ld_sgmt_info <= '0';
        if (P_IS_BUFFER) then
            ld_end       <= '0';
            set_extra    <= '0';
        end if;
        ld_ctr       <= '0';
        en_data      <= '0';
        en_ps        <= '0';
        en_len       <= '0';
        en_ctr       <= '0';
        en_zero      <= '0';
        wr_cmd       <= '0';

        case ps is
            when S_WAIT_INSTR =>
                ld_ctr      <= '1';
                if (p_instr_opcode(3 downto 1) = OP_ENCDEC) then
                    nps      <= S_WAIT_HDR;
                end if;
                if (p_instr_opcode = OP_ACTKEY) then
                    set_key_upd <= '1';
                end if;
                if (cmd_ready = '0') then
                    pdi_rdy <= '0';
                end if;
                if (pdi_valid = '1') then
                    en_ps  <= '1';
                    wr_cmd <= '1';
                end if;

            when S_WAIT_HDR =>
                ld_sgmt_info <= '1';
                nps          <= S_PREP;
                if (cmd_ready = '0') then
                    pdi_rdy <= '0';
                end if;
                if (pdi_valid = '1' and cmd_ready = '1') then
                    en_ps  <= '1';
                    if (p_sgmt_type(3 downto 2) = ST_D
                        or p_sgmt_type(3 downto 1) = ST_NSEC)
                    then
                        wr_cmd <= '1';
                    end if;
                end if;
                if (G_ENABLE_PAD) then
                    if (p_sgmt_eot = '1') then
                        if (p_sgmt_type(3 downto 2) = ST_A and G_PAD_AD > 0)
                            or (p_sgmt_type(3 downto 2) = ST_D and G_PAD_D > 0)
                        then
                            set_req_pad <= '1';
                        end if;
                    end if;
                end if;

            when S_PREP =>
                pdi_rdy <= '0';
                --! state transition
                if (unsigned(sgmt_len) = 0) then
                    if (G_ENABLE_PAD) and
                        --! Add a new block based on padding behavior
                        ((sgmt_type(3 downto 2) = ST_A and NEW_AD)
                        or (sgmt_type(3 downto 2) = ST_D and NEW_D))
                    then
                        nps <= S_DATA;
                    else
                        if (sgmt_lst = '1') then
                            nps <= S_WAIT_INSTR;
                        else
                            nps <= S_WAIT_HDR;
                        end if;
                    end if;
                else
                    nps    <= S_DATA;
                end if;
                en_len <= '1';
                en_ps  <= '1';

            when S_DATA =>
                if (not P_IS_BUFFER) then
                    --! Without buffer
                    if (reg_sel_zero = '1'
                        or (not P_IS_BUFFER
                            and (pdi_valid = '0' or bdi_ready = '0')))
                    then
                        pdi_rdy <= '0';
                    end if;

                    if (unsigned(sgmt_len) = 0)
                        and bdi_ready = '1'
                        and not (req_pad = '1' and G_ENABLE_PAD
                                and ((sgmt_type(3 downto 2) = ST_A and G_PAD_AD > 2)
                                    or (sgmt_type(3 downto 2) = ST_D and G_PAD_D > 2)))
                    then
                        if (sgmt_lst = '1') then
                            nps <= S_WAIT_INSTR;
                        else
                            nps <= S_WAIT_HDR;
                        end if;
                    end if;
                else
                    --! With buffer
                    if (reg_sel_zero = '1') then
                        pdi_rdy <= '0';
                    end if;

                    if (unsigned(ctr) = CNT_DWORDS-1) then
                        nps <= S_WAIT_READY;
                    end if;
                    if (unsigned(ctr) = CNT_DWORDS-2) then
                        ld_end <= '1';
                    end if;
                    if (unsigned(sgmt_len) = WB and G_ENABLE_PAD
                        and sgmt_eot = '1'
                        and ((sgmt_type(3 downto 2) = ST_A and G_PAD_AD > 2)
                            or (sgmt_type(3 downto 2) = ST_D
                                and G_PAD_D > 2
                                and (not G_CIPH_EXP
                                    or (G_CIPH_EXP and is_decrypt = '0')))))
                    then
                        if (A_EQ_D) then
                            if unsigned(ctr) = CNT_DWORDS-2 then
                                set_extra <= '1';
                            end if;
                        else
                            if ((sgmt_type(3 downto 2) = ST_A
                                    and unsigned(ctr) = CNT_AWORDS-2)
                                or (sgmt_type(3 downto 2) = ST_D
                                    and unsigned(ctr) = CNT_DWORDS-2))
                            then
                                set_extra <= '1';
                            end if;
                        end if;
                    end if;

                    --! if ASIZE < DSIZE
                    if (not A_EQ_D) then
                        if (sgmt_type(3 downto 2) = ST_A
                            and unsigned(ctr) >= CNT_AWORDS-1)
                        then
                            en_zero <= '1';
                        end if;
                    end if;
                end if;
                if (pdi_valid = '1' or reg_sel_zero = '1') and
                        (P_IS_BUFFER
                        or (not P_IS_BUFFER and bdi_ready = '1'))
                then
                    if (sgmt_type(3 downto 2) /= ST_A
                        and sgmt_type(3 downto 2) /= ST_D)
                    then
                        --! Not AD or D segment
                        if (P_IS_BUFFER) then
                            if (unsigned(ctr) /= CNT_DWORDS-1) then
                                en_len <= '1';
                            end if;
                        else
                            en_len <= '1';
                        end if;
                    else
                        --! AD or D segment
                        if (P_IS_BUFFER) then
                            if (A_EQ_D) then
                                if (unsigned(ctr) /= CNT_DWORDS-1) then
                                    en_len <= '1';
                                end if;
                            else
                                if ((sgmt_type(3 downto 2) = ST_A
                                        and unsigned(ctr) < CNT_AWORDS-1)
                                    or (sgmt_type(3 downto 2) /= ST_A
                                        and unsigned(ctr) /= CNT_DWORDS-1))
                                then
                                    en_len <= '1';
                                end if;
                            end if;
                        else
                            en_len <= '1';
                        end if;
                    end if;
                    if (P_IS_BUFFER) then
                        en_ctr  <= '1';
                        en_data <= '1';
                    end if;
                    en_ps <= '1';
                end if;

            when S_WAIT_READY =>
                pdi_rdy <= '0';
                ld_ctr  <= '1';
                if (unsigned(sgmt_len) = 0) then
                    if ((G_ENABLE_PAD and (G_PAD_AD > 2 or G_PAD_D > 2))
                        and is_extra = '1')
                    then
                        nps <= S_DATA;
                    else
                        if (sgmt_lst = '1') then
                            nps <= S_WAIT_INSTR;
                        else
                            nps <= S_WAIT_HDR;
                        end if;
                    end if;
                else
                    nps     <= S_DATA;
                end if;
                if (bdi_ready = '1') then
                    en_len  <= '1';
                    en_ps   <= '1';
                end if;
        end case;
    end process;

    sel_end <= '1' when (unsigned(sgmt_len) <= WB
                    and (is_extra = '0' and set_extra = '0'))
                else '0';

    gSdiComb:
    process(ss, s_instr_opcode, sdi_valid, ctr2, key_ready, slen)
    begin
        nss         <= ss;
        sdi_rdy     <= '0';
        en_key      <= '0';
        ld_ctr2     <= '0';
        ld_slen     <= '0';
        en_ctr2     <= '0';
        en_slen     <= '0';
        en_ss       <= '0';

        case ss is
            when S_WAIT_INSTR =>
                ld_ctr2     <= '1';
                sdi_rdy     <= '1';
                if (s_instr_opcode = OP_LDKEY) then
                    nss     <= S_WAIT_HDR;
                end if;
                if (sdi_valid = '1') then
                    en_ss <= '1';
                end if;

            when S_WAIT_HDR =>
                nss <= S_DATA;
                ld_slen     <= '1';
                sdi_rdy     <= '1';
                if (sdi_valid = '1') then
                    en_ss <= '1';
                end if;

            when S_DATA =>
                if (not S_IS_BUFFER) then
                    nss <= S_WAIT_INSTR;
                    if (sdi_valid = '1' and key_ready = '1') then
                        en_slen <= '1';
                        sdi_rdy <= '1';
                        if (unsigned(slen) = G_KEY_SIZE/8) then
                            en_ss   <= '1';
                        end if;
                    end if;
                else
                    sdi_rdy <= '1';
                    nss     <= S_WAIT_READY;
                    if (sdi_valid = '1') then
                        en_ctr2 <= '1';
                        en_key  <= '1';
                        if (unsigned(ctr2) = CNT_KWORDS-1)  then
                            en_ss   <= '1';
                        end if;
                    end if;
                end if;

            when S_WAIT_READY =>
                if (unsigned(slen) = G_KEY_SIZE/8) then
                    nss <= S_WAIT_INSTR;
                else
                    nss <= S_DATA;
                end if;
                ld_ctr2 <= '1';
                if (key_ready = '1') then
                    en_ss   <= '1';
                    en_slen <= '1';
                end if;

        end case;
    end process;
end architecture structure;


-------------------------------------------------------------------------------
--! @file       ASCON_Round.vhd
--! @author     Ekawat (ice) Homsirikamol
--! @brief      Round unit for ASCON
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ASCON_Round is    
    port    ( 
        ii    : in  std_logic_vector(320                  -1 downto 0);
        rc    : in  std_logic_vector(  8                  -1 downto 0);
        oo    : out std_logic_vector(320                  -1 downto 0)
    );
end entity ASCON_Round;

architecture structure of ASCON_Round is   
    type stype is array ( 0 to     4) 
        of std_logic_vector(64    -1 downto 0);
    signal x        : stype;
    signal add      : stype; 
    signal sub      : stype;
    signal ldiff    : stype;
    
    type sboxtype is array (63 downto 0) 
        of std_logic_vector(5         -1 downto 0);
    signal subi     : sboxtype;
    signal subo     : sboxtype;
    
    type sbox_rom_type  is array ( 0 to    31) of integer range 0 to 31;
    constant sbox_rom : sbox_rom_type := 
        (4, 11, 31, 20, 26, 21, 9, 2, 27, 5, 8, 18, 29, 3, 6, 28,
         30, 19, 7, 14, 0, 13, 17, 24, 16, 12, 1, 25, 22, 10, 15, 23);
begin
    gmap:
    for i in 0 to 4 generate
        x(i) <= ii(320-1-64*i downto 320-64-64*i);
        
        oo(320-1-64*i downto 320-64-64*i) <= ldiff(i);
    end generate;
    
    --! Addition of RC
    add(0) <= x(0);
    add(1) <= x(1);
    add(2) <= x(2)(63 downto 8) & (x(2)(7 downto 0) xor rc);
    add(3) <= x(3);
    add(4) <= x(4);
    
    --! Substitution layer 
    gSub0:
    for i in 63 downto 0 generate
        subi(i)     <= add(0)(i) & add(1)(i) & add(2)(i) & add(3)(i) & add(4)(i);
        subo(i)     <= std_logic_vector(to_unsigned(sbox_rom(to_integer(unsigned(subi(i)))), 5));
        
        sub(0)(i)   <= subo(i)(4);
        sub(1)(i)   <= subo(i)(3);
        sub(2)(i)   <= subo(i)(2);
        sub(3)(i)   <= subo(i)(1);
        sub(4)(i)   <= subo(i)(0);
    end generate;
  
    --! Linear diffusion
    ldiff(0) <= sub(0) xor std_logic_vector(ROTATE_RIGHT(unsigned(sub(0)), 19)) xor std_logic_vector(ROTATE_RIGHT(unsigned(sub(0)), 28));
    ldiff(1) <= sub(1) xor std_logic_vector(ROTATE_RIGHT(unsigned(sub(1)), 61)) xor std_logic_vector(ROTATE_RIGHT(unsigned(sub(1)), 39));
    ldiff(2) <= sub(2) xor std_logic_vector(ROTATE_RIGHT(unsigned(sub(2)),  1)) xor std_logic_vector(ROTATE_RIGHT(unsigned(sub(2)),  6));
    ldiff(3) <= sub(3) xor std_logic_vector(ROTATE_RIGHT(unsigned(sub(3)), 10)) xor std_logic_vector(ROTATE_RIGHT(unsigned(sub(3)), 17));
    ldiff(4) <= sub(4) xor std_logic_vector(ROTATE_RIGHT(unsigned(sub(4)),  7)) xor std_logic_vector(ROTATE_RIGHT(unsigned(sub(4)), 41));    
end architecture structure;


-------------------------------------------------------------------------------
--! @file       CipherCore_Datapath.vhd
--! @author     Ekawat (ice) Homsirikamol
--! @brief      Datapath unit for ASCON
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CipherCore_Datapath is
    generic (
        G_DBLK_SIZE     : integer := 64     --! Data size
    );
    port    (
        clk             : in  std_logic;
        rst             : in  std_logic;

        --! Input
        bdi             : in  std_logic_vector(G_DBLK_SIZE      -1 downto 0);
        bdi_valid_bytes : in  std_logic_vector(G_DBLK_SIZE/8    -1 downto 0);
        key             : in  std_logic_vector(32               -1 downto 0);

        --! Datapath
        en_key          : in  std_logic;
        en_npub         : in  std_logic;
        en_state        : in  std_logic;
        en_cmp          : in  std_logic;
        is_first_dat    : in  std_logic;
        clr_rc          : in  std_logic;
        en_rc           : in  std_logic;
        sel_rc_hi       : in  std_logic;
        sel_key_hi      : in  std_logic;
        sel_key_lo      : in  std_logic;
        sel_decrypt     : in  std_logic;
        sel_state       : in  std_logic_vector(2                -1 downto 0);
        sel_tag         : in  std_logic_vector(2                -1 downto 0);

        --! Output
        bdo             : out std_logic_vector(G_DBLK_SIZE      -1 downto 0);
        msg_auth_valid  : out std_logic
    );
end entity CipherCore_Datapath;

architecture structure of CipherCore_Datapath is
    constant DBYTES       : integer := G_DBLK_SIZE/8;
    signal reg_key        : std_logic_vector(128                -1 downto 0);

    signal bdi_xor        : std_logic_vector(G_DBLK_SIZE        -1 downto 0);
    signal bdi_xor_sel    : std_logic_vector(G_DBLK_SIZE        -1 downto 0);
    signal init_state0    : std_logic_vector(320                -1 downto 0);
    signal init_statex    : std_logic_vector(320                -1 downto 0);
    signal istate         : std_logic_vector(320                -1 downto 0);
    signal ostate         : std_logic_vector(320                -1 downto 0);
    signal oround         : std_logic_vector(320                -1 downto 0);
    signal bdo_s          : std_logic_vector(G_DBLK_SIZE        -1 downto 0);

    signal msg_auth_valid_s : std_logic;

    constant ZEROS        : std_logic_vector(128                -1 downto 0)
        := (others => '0');

    signal rc             : std_logic_vector(  8                -1 downto 0);
    signal rc_new         : std_logic_vector(  8                -1 downto 0);    
begin
    p_clk:
    process(clk)
    begin
        if rising_edge(clk) then
            if (en_key = '1') then
                reg_key <= reg_key(95 downto 0) & key;
            end if;

            if (en_state = '1') then
                ostate  <= istate;
            end if;

            if (clr_rc = '1') then
                if (sel_rc_hi = '1') then
                    rc <= x"F0";
                else
                    if (G_DBLK_SIZE = 64) then
                        rc <= x"96";
                    else
                        rc <= x"B4";
                    end if;
                end if;
            elsif (en_rc = '1') then
                rc <= rc_new;
            end if;
        end if;
    end process;
    rc_new(7 downto 4) <= std_logic_vector(unsigned(rc(7 downto 4)) - "0001");
    rc_new(3 downto 0) <= std_logic_vector(unsigned(rc(3 downto 0)) + "0001");

    g64:
    if G_DBLK_SIZE = 64 generate
        signal reg_npub_hi      : std_logic_vector(64           -1 downto 0);
        signal msg_auth_valid_r : std_logic;
    begin
        process(clk)
        begin
            if rising_edge(clk) then
                if (en_npub = '1') then
                    reg_npub_hi <= bdi;
                end if;

                if (en_cmp = '1') then
                    msg_auth_valid_r <= msg_auth_valid_s;
                end if;
            end if;
        end process;
        init_state0  <= x"80" & x"40" & x"0C" & x"06" & ZEROS(31 downto 0)
                        & reg_key & reg_npub_hi & bdi;

        init_statex(319 downto 256) <=  bdi_xor_sel;
        init_statex(255 downto 128) <=  ostate(255 downto 128)                   when sel_key_hi = '0'  else (ostate(255 downto 128) xor reg_key);
        init_statex(127 downto   1) <=  ostate(127 downto   1)                   when sel_key_lo = '0'  else (ostate(127 downto   1) xor reg_key(127 downto   1));
        init_statex(             0) <= (ostate(             0) xor is_first_dat) when sel_key_lo = '0'  else (ostate(             0) xor reg_key(             0)  xor is_first_dat);

        with sel_tag select
        bdo_s <= init_statex(127 downto 64) when "10",
                init_statex(63 downto 0)    when "11",
                bdi_xor                     when others;
        msg_auth_valid <= msg_auth_valid_r and msg_auth_valid_s;
    end generate;
    g128:
    if G_DBLK_SIZE = 128 generate
        signal key_hi : std_logic_vector(G_DBLK_SIZE-1 downto 0);
        signal key_lo : std_logic_vector(G_DBLK_SIZE-1 downto 0);
    begin        
        key_hi <= (others => '0') when sel_key_hi = '0'
                                  else reg_key;
        key_lo <= (others => '0') when sel_key_lo = '0'
                                  else reg_key;
                                  
        init_state0  <= x"80" & x"80" & x"0C" & x"08" & ZEROS(31 downto 0)
                        & reg_key & bdi;

        init_statex(319 downto 192) <= bdi_xor_sel;
        init_statex(191 downto 128) <= ostate(191 downto 128) xor key_hi(127 downto 64);
        init_statex(127 downto  64) <= ostate(127 downto  64) xor key_hi( 63 downto  0) xor key_lo(127 downto 64);
        init_statex( 63 downto   1) <= ostate( 63 downto   1)                           xor key_lo( 63 downto  1);
        init_statex(             0) <= ostate(             0)                           xor key_lo(            0) xor is_first_dat;

        bdo_s <= init_statex(127 downto 0) when sel_tag(1) = '1' else bdi_xor;
        msg_auth_valid <= msg_auth_valid_s;
    end generate;

    gBits:
    for i in (DBYTES-1) downto 0  generate
        bdi_xor_sel(7+i*8 downto i*8) <= bdi(7+i*8 downto i*8)
            when (sel_decrypt = '1' and bdi_valid_bytes(i) = '1')
            else bdi_xor(7+i*8 downto i*8);
    end generate;

    with sel_state(1 downto 0) select
    istate <=   oround      when "00",
                init_statex when "01",
                init_state0 when others;

    u_round:
    entity work.ASCON_Round(structure)
    port map (ii => ostate, oo => oround, rc => rc);

    bdi_xor <= ostate(319 downto 320-G_DBLK_SIZE) xor bdi;
    msg_auth_valid_s <= '1' when bdo_s = bdi else '0';
    bdo <= bdo_s;
end architecture structure;

-------------------------------------------------------------------------------
--! @file       CipherCore_Control.vhd
--! @author     Ekawat (ice) Homsirikamol
--! @brief      Control unit for ASCON
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AEAD_pkg.all;

entity CipherCore_Control is
    generic (
        G_DBLK_SIZE     : integer := 64;     --! Data size
        G_LBS_BYTES     : integer := 4
    );
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;

        --! Input
        key_ready       : out std_logic;
        key_valid       : in  std_logic;
        key_update      : in  std_logic;
        decrypt         : in  std_logic;
        bdi_ready       : out std_logic;
        bdi_valid       : in  std_logic;
        bdi_type        : in  std_logic_vector(3                -1 downto 0);
        bdi_eot         : in  std_logic;
        bdi_eoi         : in  std_logic;
        bdi_size        : in  std_logic_vector(G_LBS_BYTES+1    -1 downto 0);

        --! Datapath
        is_first_dat    : out std_logic;
        en_key          : out std_logic;
        en_state        : out std_logic;
        en_npub         : out std_logic;
        en_cmp          : out std_logic;
        clr_rc          : out std_logic;
        en_rc           : out std_logic;
        sel_rc_hi       : out std_logic;
        sel_key_hi      : out std_logic;
        sel_key_lo      : out std_logic;
        sel_decrypt     : out std_logic;
        sel_state       : out std_logic_vector(2               -1 downto 0);
        sel_tag         : out std_logic_vector(2               -1 downto 0);

        --! Output
        msg_auth_done   : out std_logic;
        bdo_ready       : in  std_logic;
        bdo_valid       : out std_logic
    );
end entity CipherCore_Control;

architecture behavior of CipherCore_Control is
    type state_type is (S_WAIT_KEY, S_LD_KEY,
                        S_LD_NPUB0, S_LD_NPUB1,
                        S_PROCESS, S_WAIT, S_WAIT_OUT_TAG2);
    signal state          : state_type;
    signal nstate         : state_type;

    constant TOT_ROUND_HI : integer := 12;
    constant TOT_ROUND_LO : integer := 6+(G_DBLK_SIZE/128)*2;

    signal set_compute_hi : std_logic;
    signal set_compute_lo : std_logic;
    signal clr_round      : std_logic;
    signal en_round       : std_logic;
    signal clr_tag        : std_logic;
    signal set_tag        : std_logic;
    signal is_tag         : std_logic;
    signal is_decrypt     : std_logic;
    signal is_init_dat    : std_logic;
    signal init_dat       : std_logic;

    signal rndcmp   : std_logic_vector( 4           -1 downto 0);
    signal round    : std_logic_vector( 4           -1 downto 0);
begin
    p_reg:
    process( clk )
    begin
        if rising_edge( clk ) then
            if rst = '1' then
                round      <= (others => '0');
                state      <= S_WAIT_KEY;
                is_tag     <= '0';
                sel_key_lo <= '0';
            else
                state   <= nstate;
                if (clr_round = '1') then
                    round <= (others => '0');
                elsif (en_round = '1') then
                    round <= std_logic_vector(unsigned(round) + 1);
                end if;

                if (set_compute_hi = '1') then
                    rndcmp <= std_logic_vector(to_unsigned((TOT_ROUND_HI-1), 4));
                elsif (set_compute_lo = '1') then
                    rndcmp <= std_logic_vector(to_unsigned((TOT_ROUND_LO-1), 4));
                end if;

                if (clr_tag = '1' or set_tag = '1') then
                    sel_key_lo <= '1';
                elsif (set_compute_lo = '1') then
                    sel_key_lo <= '0';
                end if;

                if (clr_tag = '1') then
                    is_tag <= '0';
                elsif (set_tag = '1') then
                    is_tag <= '1';
                end if;

                if (state = S_LD_NPUB1) then
                    is_decrypt <= decrypt;
                end if;

                if (state = S_LD_NPUB1) then
                    is_init_dat <= '0';
                elsif (init_dat = '1') then
                    is_init_dat <= '1';
                end if;
            end if;
        end if;
    end process;
    is_first_dat <= init_dat;
    clr_rc      <= clr_round;
    en_rc       <= en_round;
    sel_rc_hi   <= set_compute_hi;
    sel_key_hi  <= set_tag;
    sel_tag     <= is_tag & round(0);

    p_state:
    process( state, bdi_valid, bdi_type, is_decrypt,
             bdi_eot, bdo_ready, bdi_size,
             key_valid, key_update, round, rndcmp, is_tag
             )
    begin
        --! External
        key_ready      <= '0';
        bdi_ready      <= '0';
        bdo_valid      <= '0';
        msg_auth_done  <= '0';

        --! Datapath
        en_key         <= '0';
        en_state       <= '0';
        en_npub        <= '0';
        en_cmp         <= '0';
        set_compute_hi <= '0';
        set_compute_lo <= '0';
        sel_decrypt    <= '0';
        sel_state      <= "00";
        set_tag        <= '0';
        init_dat       <= '0';

        --! Internal
        clr_round      <= '0';
        clr_tag        <= '0';
        en_round       <= '0';
        nstate         <= state;

        case state is
            when S_WAIT_KEY =>
                clr_round   <= '1';
                clr_tag     <= '1';
                set_compute_hi  <= '1';
                if (key_update = '1' or bdi_valid = '1') then
                    if (key_update = '1') then
                        nstate <= S_LD_KEY;
                    else
                        if (G_DBLK_SIZE = 64) then
                            nstate <= S_LD_NPUB0;
                        else
                            nstate <= S_LD_NPUB1;
                        end if;
                    end if;
                end if;

            when S_LD_KEY =>
                key_ready <= '1';
                set_compute_hi  <= '1';
                if (key_valid = '1') then
                    en_key   <= '1';
                    en_round <= '1';
                    if (unsigned(round) = 3) then
                        if (G_DBLK_SIZE = 64) then
                            nstate    <= S_LD_NPUB0;
                        else
                            nstate    <= S_LD_NPUB1;
                        end if;                        
                        clr_round <= '1';
                    end if;
                end if;

            when S_LD_NPUB0 =>
                --! Store the first Npub block in the register
                bdi_ready <= '1';
                en_npub   <= '1';
                if (bdi_valid = '1') then
                    nstate <= S_LD_NPUB1;
                end if;

            when S_LD_NPUB1 =>
                --! Get the second Npub and start processing
                bdi_ready <= '1';
                en_state  <= '1';
                sel_state <= "10";
                if (bdi_valid = '1') then
                    nstate    <= S_PROCESS;
                end if;

            when S_PROCESS =>
                --! Process
                en_round <= '1';
                en_state <= '1';
                if (round = rndcmp) then
                    nstate    <= S_WAIT;
                end if;

            when S_WAIT =>
                --! Load/Output data
                if (bdi_type(2 downto 1) = BDI_TYPE_DAT and is_init_dat = '0') then
                    init_dat <= '1';
                end if;

                sel_state       <= "01";                
                if (is_tag = '1') then
                    if (is_decrypt = '0' and bdo_ready = '1') then
                        bdo_valid     <= '1';
                        if (G_DBLK_SIZE = 64) then
                            en_round      <= '1';
                        end if;
                    elsif (is_decrypt = '1' and bdi_valid = '1') then
                        bdi_ready     <= '1';
                        if (G_DBLK_SIZE = 64) then
                            en_round      <= '1';
                            en_cmp        <= '1';
                        else
                            msg_auth_done <= '1';
                        end if;
                    end if;
                    if (G_DBLK_SIZE = 64) then
                        nstate        <= S_WAIT_OUT_TAG2;
                    else
                        nstate        <= S_WAIT_KEY;
                    end if;
                else
                    clr_round <= '1';    
                    if (bdi_valid = '1'
                        and (bdi_type(2 downto 1) = "00"
                            or bdo_ready = '1'
                            or not unsigned(bdi_size) /= 0))
                    then
                        bdi_ready  <= '1';
                        en_state  <= '1';
                        if (bdi_type(2 downto 1) = "00") then
                            set_compute_lo <= '1';
                        else
                            if (unsigned(bdi_size) /= 0) then
                                bdo_valid   <= '1';
                            end if;
                            if (is_decrypt = '1'
                                and unsigned(bdi_size) /= 0)
                            then
                                sel_decrypt <= '1';
                            end if;
                            if (bdi_eot = '1') then
                                set_compute_hi <= '1';
                                set_tag        <= '1';
                            else
                                set_compute_lo <= '1';
                            end if;
                        end if;
                        nstate <= S_PROCESS;
                    end if;
                end if;

            when S_WAIT_OUT_TAG2 =>
                if (is_decrypt = '0') then
                    bdo_valid <= '1';
                    if (bdo_ready = '1') then
                        nstate <= S_WAIT_KEY;
                    end if;
                else
                    bdi_ready <= '1';
                    if (bdi_valid = '1') then
                        msg_auth_done <= '1';
                        nstate <= S_WAIT_KEY;
                    end if;
                end if;

        end case;
    end process;

end behavior;
-------------------------------------------------------------------------------
--! @file       CipherCore_Control.vhd
--! @author     Ekawat (ice) Homsirikamol
--! @brief      Control unit for ASCON
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AEAD_pkg.all;

entity CipherCore_Control is
    generic (
        G_DBLK_SIZE     : integer := 64;     --! Data size
        G_LBS_BYTES     : integer := 4
    );
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;

        --! Input
        key_ready       : out std_logic;
        key_valid       : in  std_logic;
        key_update      : in  std_logic;
        decrypt         : in  std_logic;
        bdi_ready       : out std_logic;
        bdi_valid       : in  std_logic;
        bdi_type        : in  std_logic_vector(3                -1 downto 0);
        bdi_eot         : in  std_logic;
        bdi_eoi         : in  std_logic;
        bdi_size        : in  std_logic_vector(G_LBS_BYTES+1    -1 downto 0);

        --! Datapath
        is_first_dat    : out std_logic;
        en_key          : out std_logic;
        en_state        : out std_logic;
        en_npub         : out std_logic;
        en_cmp          : out std_logic;
        clr_rc          : out std_logic;
        en_rc           : out std_logic;
        sel_rc_hi       : out std_logic;
        sel_key_hi      : out std_logic;
        sel_key_lo      : out std_logic;
        sel_decrypt     : out std_logic;
        sel_state       : out std_logic_vector(2               -1 downto 0);
        sel_tag         : out std_logic_vector(2               -1 downto 0);

        --! Output
        msg_auth_done   : out std_logic;
        bdo_ready       : in  std_logic;
        bdo_valid       : out std_logic
    );
end entity CipherCore_Control;

architecture behavior of CipherCore_Control is
    type state_type is (S_WAIT_KEY, S_LD_KEY,
                        S_LD_NPUB0, S_LD_NPUB1,
                        S_PROCESS, S_WAIT, S_WAIT_OUT_TAG2);
    signal state          : state_type;
    signal nstate         : state_type;

    constant TOT_ROUND_HI : integer := 12;
    constant TOT_ROUND_LO : integer := 6+(G_DBLK_SIZE/128)*2;

    signal set_compute_hi : std_logic;
    signal set_compute_lo : std_logic;
    signal clr_round      : std_logic;
    signal en_round       : std_logic;
    signal clr_tag        : std_logic;
    signal set_tag        : std_logic;
    signal is_tag         : std_logic;
    signal is_decrypt     : std_logic;
    signal is_init_dat    : std_logic;
    signal init_dat       : std_logic;

    signal rndcmp   : std_logic_vector( 4           -1 downto 0);
    signal round    : std_logic_vector( 4           -1 downto 0);
begin
    p_reg:
    process( clk )
    begin
        if rising_edge( clk ) then
            if rst = '1' then
                round      <= (others => '0');
                state      <= S_WAIT_KEY;
                is_tag     <= '0';
                sel_key_lo <= '0';
            else
                state   <= nstate;
                if (clr_round = '1') then
                    round <= (others => '0');
                elsif (en_round = '1') then
                    round <= std_logic_vector(unsigned(round) + 1);
                end if;

                if (set_compute_hi = '1') then
                    rndcmp <= std_logic_vector(to_unsigned((TOT_ROUND_HI-1), 4));
                elsif (set_compute_lo = '1') then
                    rndcmp <= std_logic_vector(to_unsigned((TOT_ROUND_LO-1), 4));
                end if;

                if (clr_tag = '1' or set_tag = '1') then
                    sel_key_lo <= '1';
                elsif (set_compute_lo = '1') then
                    sel_key_lo <= '0';
                end if;

                if (clr_tag = '1') then
                    is_tag <= '0';
                elsif (set_tag = '1') then
                    is_tag <= '1';
                end if;

                if (state = S_LD_NPUB1) then
                    is_decrypt <= decrypt;
                end if;

                if (state = S_LD_NPUB1) then
                    is_init_dat <= '0';
                elsif (init_dat = '1') then
                    is_init_dat <= '1';
                end if;
            end if;
        end if;
    end process;
    is_first_dat <= init_dat;
    clr_rc      <= clr_round;
    en_rc       <= en_round;
    sel_rc_hi   <= set_compute_hi;
    sel_key_hi  <= set_tag;
    sel_tag     <= is_tag & round(0);

    p_state:
    process( state, bdi_valid, bdi_type, is_decrypt,
             bdi_eot, bdo_ready, bdi_size,
             key_valid, key_update, round, rndcmp, is_tag
             )
    begin
        --! External
        key_ready      <= '0';
        bdi_ready      <= '0';
        bdo_valid      <= '0';
        msg_auth_done  <= '0';

        --! Datapath
        en_key         <= '0';
        en_state       <= '0';
        en_npub        <= '0';
        en_cmp         <= '0';
        set_compute_hi <= '0';
        set_compute_lo <= '0';
        sel_decrypt    <= '0';
        sel_state      <= "00";
        set_tag        <= '0';
        init_dat       <= '0';

        --! Internal
        clr_round      <= '0';
        clr_tag        <= '0';
        en_round       <= '0';
        nstate         <= state;

        case state is
            when S_WAIT_KEY =>
                clr_round   <= '1';
                clr_tag     <= '1';
                set_compute_hi  <= '1';
                if (key_update = '1' or bdi_valid = '1') then
                    if (key_update = '1') then
                        nstate <= S_LD_KEY;
                    else
                        if (G_DBLK_SIZE = 64) then
                            nstate <= S_LD_NPUB0;
                        else
                            nstate <= S_LD_NPUB1;
                        end if;
                    end if;
                end if;

            when S_LD_KEY =>
                key_ready <= '1';
                set_compute_hi  <= '1';
                if (key_valid = '1') then
                    en_key   <= '1';
                    en_round <= '1';
                    if (unsigned(round) = 3) then
                        if (G_DBLK_SIZE = 64) then
                            nstate    <= S_LD_NPUB0;
                        else
                            nstate    <= S_LD_NPUB1;
                        end if;                        
                        clr_round <= '1';
                    end if;
                end if;

            when S_LD_NPUB0 =>
                --! Store the first Npub block in the register
                bdi_ready <= '1';
                en_npub   <= '1';
                if (bdi_valid = '1') then
                    nstate <= S_LD_NPUB1;
                end if;

            when S_LD_NPUB1 =>
                --! Get the second Npub and start processing
                bdi_ready <= '1';
                en_state  <= '1';
                sel_state <= "10";
                if (bdi_valid = '1') then
                    nstate    <= S_PROCESS;
                end if;

            when S_PROCESS =>
                --! Process
                en_round <= '1';
                en_state <= '1';
                if (round = rndcmp) then
                    nstate    <= S_WAIT;
                end if;

            when S_WAIT =>
                --! Load/Output data
                if (bdi_type(2 downto 1) = BDI_TYPE_DAT and is_init_dat = '0') then
                    init_dat <= '1';
                end if;

                sel_state       <= "01";                
                if (is_tag = '1') then
                    if (is_decrypt = '0' and bdo_ready = '1') then
                        bdo_valid     <= '1';
                        if (G_DBLK_SIZE = 64) then
                            en_round      <= '1';
                        end if;
                    elsif (is_decrypt = '1' and bdi_valid = '1') then
                        bdi_ready     <= '1';
                        if (G_DBLK_SIZE = 64) then
                            en_round      <= '1';
                            en_cmp        <= '1';
                        else
                            msg_auth_done <= '1';
                        end if;
                    end if;
                    if (G_DBLK_SIZE = 64) then
                        nstate        <= S_WAIT_OUT_TAG2;
                    else
                        nstate        <= S_WAIT_KEY;
                    end if;
                else
                    clr_round <= '1';    
                    if (bdi_valid = '1'
                        and (bdi_type(2 downto 1) = "00"
                            or bdo_ready = '1'
                            or not unsigned(bdi_size) /= 0))
                    then
                        bdi_ready  <= '1';
                        en_state  <= '1';
                        if (bdi_type(2 downto 1) = "00") then
                            set_compute_lo <= '1';
                        else
                            if (unsigned(bdi_size) /= 0) then
                                bdo_valid   <= '1';
                            end if;
                            if (is_decrypt = '1'
                                and unsigned(bdi_size) /= 0)
                            then
                                sel_decrypt <= '1';
                            end if;
                            if (bdi_eot = '1') then
                                set_compute_hi <= '1';
                                set_tag        <= '1';
                            else
                                set_compute_lo <= '1';
                            end if;
                        end if;
                        nstate <= S_PROCESS;
                    end if;
                end if;

            when S_WAIT_OUT_TAG2 =>
                if (is_decrypt = '0') then
                    bdo_valid <= '1';
                    if (bdo_ready = '1') then
                        nstate <= S_WAIT_KEY;
                    end if;
                else
                    bdi_ready <= '1';
                    if (bdi_valid = '1') then
                        msg_auth_done <= '1';
                        nstate <= S_WAIT_KEY;
                    end if;
                end if;

        end case;
    end process;

end behavior;


-------------------------------------------------------------------------------
--! @file       CipherCore_Control.vhd
--! @author     Ekawat (ice) Homsirikamol
--! @brief      ASCON CipherCore
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.ALL;
use work.AEAD_pkg.all;

entity CipherCore is
    generic (
        --! Reset behavior
        G_ASYNC_RSTN    : boolean := False; --! Async active low reset
        --! Block size (bits)
        G_DBLK_SIZE     : integer := 64;    --! Data
        G_KEY_SIZE      : integer := 32;    --! Key
        G_TAG_SIZE      : integer := 128;   --! Tag
        --! The number of bits required to hold block size expressed in
        --! bytes = log2_ceil(G_DBLK_SIZE/8)
        G_LBS_BYTES      : integer := 4;
        --! Maximum supported AD/message/ciphertext length = 2^G_MAX_LEN-1
        G_MAX_LEN       : integer := SINGLE_PASS_MAX
    );
    port (
        --! Global
        clk             : in  std_logic;
        rst             : in  std_logic;
        --! PreProcessor (data)
        key             : in  std_logic_vector(G_KEY_SIZE       -1 downto 0);
        bdi             : in  std_logic_vector(G_DBLK_SIZE      -1 downto 0);
        --! PreProcessor (controls)
        key_ready       : out std_logic;
        key_valid       : in  std_logic;
        key_update      : in  std_logic;
        decrypt         : in  std_logic;
        bdi_ready       : out std_logic;
        bdi_valid       : in  std_logic;
        bdi_type        : in  std_logic_vector(3                -1 downto 0);
        bdi_partial     : in  std_logic;
        bdi_eot         : in  std_logic;
        bdi_eoi         : in  std_logic;
        bdi_size        : in  std_logic_vector(G_LBS_BYTES+1    -1 downto 0);
        bdi_valid_bytes : in  std_logic_vector(G_DBLK_SIZE/8    -1 downto 0);
        bdi_pad_loc     : in  std_logic_vector(G_DBLK_SIZE/8    -1 downto 0);
        --! PostProcessor
        bdo             : out std_logic_vector(G_DBLK_SIZE      -1 downto 0);
        bdo_valid       : out std_logic;
        bdo_ready       : in  std_logic;
        bdo_size        : out std_logic_vector(G_LBS_BYTES+1    -1 downto 0);
        msg_auth_done   : out std_logic;
        msg_auth_valid  : out std_logic
    );
end entity CipherCore;


architecture structure of CipherCore is
    signal is_first_dat : std_logic;
    signal en_key       : std_logic;
    signal en_state     : std_logic;
    signal en_npub      : std_logic;
    signal en_cmp       : std_logic;
    signal clr_rc       : std_logic;
    signal en_rc        : std_logic;
    signal sel_rc_hi    : std_logic;
    signal sel_key_hi   : std_logic;
    signal sel_key_lo   : std_logic;
    signal sel_decrypt  : std_logic;
    signal sel_state    : std_logic_vector(2               -1 downto 0);
    signal sel_tag      : std_logic_vector(2               -1 downto 0);
begin
    u_cc_dp:
    entity work.CipherCore_Datapath(structure)
    generic map (G_DBLK_SIZE => G_DBLK_SIZE)
    port map (
        clk                 => clk              ,
        rst                 => rst              ,

        --! Input Processor
        key                 => key              ,
        bdi                 => bdi              ,
        bdi_valid_bytes     => bdi_valid_bytes  ,

        --! Datapath
        en_key              => en_key           ,
        en_state            => en_state         ,
        en_npub             => en_npub          ,
        en_cmp              => en_cmp           ,
        is_first_dat        => is_first_dat     ,
        clr_rc              => clr_rc           ,
        en_rc               => en_rc            ,
        sel_rc_hi           => sel_rc_hi        ,
        sel_key_hi          => sel_key_hi       ,
        sel_key_lo          => sel_key_lo       ,
        sel_decrypt         => sel_decrypt      ,
        sel_state           => sel_state        ,
        sel_tag             => sel_tag          ,

        --! Output Processor
        bdo                 => bdo              ,
        msg_auth_valid      => msg_auth_valid
    );

    u_cc_ctrl:
    entity work.CipherCore_Control(behavior)
    generic map (
        G_DBLK_SIZE         => G_DBLK_SIZE      ,
        G_LBS_BYTES         => G_LBS_BYTES
    )
    port map (
        clk                 => clk              ,
        rst                 => rst              ,

        --! Input
        key_ready           => key_ready        ,
        key_valid           => key_valid        ,
        key_update          => key_update       ,
        decrypt             => decrypt          ,
        bdi_ready           => bdi_ready        ,
        bdi_valid           => bdi_valid        ,
        bdi_type            => bdi_type         ,
        bdi_eot             => bdi_eot          ,
        bdi_eoi             => bdi_eoi          ,
        bdi_size            => bdi_size         ,

        --! Datapath
        en_key              => en_key           ,
        en_state            => en_state         ,
        en_npub             => en_npub          ,
        en_cmp              => en_cmp           ,
        is_first_dat        => is_first_dat     ,
        clr_rc              => clr_rc           ,
        en_rc               => en_rc            ,
        sel_rc_hi           => sel_rc_hi        ,
        sel_key_hi          => sel_key_hi       ,
        sel_key_lo          => sel_key_lo       ,
        sel_decrypt         => sel_decrypt      ,
        sel_state           => sel_state        ,
        sel_tag             => sel_tag          ,

        --! Output
        msg_auth_done       => msg_auth_done    ,
        bdo_ready           => bdo_ready        ,
        bdo_valid           => bdo_valid
    );
end structure;

-------------------------------------------------------------------------------
--! @file       PostProcessor.vhd
--! @brief      Post-processing unit for an authenticated encryption module.
--! @project    CAESAR Candidate Evaluation
--! @author     Ekawat (ice) Homsirikamol
--! @copyright  Copyright (c) 2016 Cryptographic Engineering Research Group
--!             ECE Department, George Mason University Fairfax, VA, U.S.A.
--!             All rights Reserved.
--! @license    This project is released under the GNU Public License.
--!             The license and distribution terms for this file may be
--!             found in the file LICENSE in this distribution or at
--!             http://www.gnu.org/licenses/gpl-3.0.txt
--! @note       This is publicly available encryption source code that falls
--!             under the License Exception TSU (Technology and software-
--!             —unrestricted)
--! PISO used within this unit follows the following convention:
--! > Order at the PISO input (left to right)      :  A(0) A(1) A(2) … A(N-1)
--! > Order at the PISO output (time 0 to time N-1):  A(0) A(1) A(2) … A(N-1)
--! > Order in the test vector file (left to right):  A(0) A(1) A(2) … A(N-1)
--! where A is a single I/O word.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.AEAD_pkg.all;

entity PostProcessor is
    generic (
        --! I/O size (bits)
        G_W                 : integer := 32;    --! Public data input
        G_SW                : integer := 32;    --! Secret data input
        --! Reset behavior
        G_ASYNC_RSTN        : boolean := False; --! Async active low reset
        --! Special features activation
        G_CIPH_EXP          : boolean := False; --! Ciphertext expansion
        G_REVERSE_CIPH      : boolean := False; --! Reversed ciphertext
        G_MERGE_TAG         : boolean := False; --! Merge tag with data segment
        --! Block size (bits)
        G_DBLK_SIZE         : integer := 128;   --! Data
        G_TAG_SIZE          : integer := 128;   --! Key
        --! The number of bits required to hold block size expressed in
        --! bytes = log2_ceil(G_DBLK_SIZE/8)
        G_LBS_BYTES         : integer := 4
    );
    port (
        --! Global ports
        clk                 : in  std_logic;
        rst                 : in  std_logic;
        --! Data out ports
        do_data             : out std_logic_vector(G_W          -1 downto 0);
        do_ready            : in  std_logic;
        do_valid            : out std_logic;
        --! Header ports
        cmd                 : in  std_logic_vector(24           -1 downto 0);
        cmd_valid           : in  std_logic;
        cmd_ready           : out std_logic;
        --! CipherCore
        bdo                 : in  std_logic_vector(G_DBLK_SIZE  -1 downto 0);
        bdo_valid           : in  std_logic;
        bdo_ready           : out std_logic;
        bdo_size            : in  std_logic_vector(G_LBS_BYTES+1-1 downto 0);
        msg_auth_done       : in  std_logic;
        msg_auth_valid      : in  std_logic
    );
end PostProcessor;

architecture structure of PostProcessor is
    constant IS_BUFFER      : boolean := not (G_W = G_DBLK_SIZE);
    constant WB             : integer := G_W/8; --! Word bytes
    constant LOG2_WB        : integer := log2_ceil(WB);
    constant CNT_DWORDS     : integer := (G_DBLK_SIZE+(G_W-1))/G_W;
    constant ZEROS          : std_logic_vector(G_W      -1 downto 0)
        := (others => '0');
    --! =======================================================================
    type t_lookup is array (0 to (WB-1))
        of std_logic_vector(WB-1 downto 0);
    function getVbytesLookup(size: integer) return t_lookup is
        variable ret : t_lookup;
    begin
        for i in 0 to ((size/8)-1) loop
            if (i = 0) then
                ret(i) := (others => '0');
            else
                ret(i)(size/8-1   downto size/8-i) := (others => '1');
                ret(i)(size/8-i-1 downto 0)        := (others => '0');
            end if;
        end loop;
        return ret;
    end function getVbytesLookup;
    constant VBYTES_LOOKUP  : t_lookup := getVbytesLookup(G_W);
    --! =======================================================================
    --! Control
    signal en_len           : std_logic;
    signal en_s             : std_logic;
    signal en_ctr           : std_logic;
    signal ld_tag           : std_logic;
    signal ld_stat          : std_logic;
    signal ld_ctr           : std_logic;
    signal ld_sgmt_info     : std_logic;
    signal ld_ciph_exp_len  : std_logic;
    signal sel_last         : std_logic;
    signal sel_do           : std_logic;
    signal set_first        : std_logic;
    signal clr_first        : std_logic;
    --! Status
    signal is_decrypt       : std_logic;
    signal is_first         : std_logic;        --! is first block status
    signal is_ciph_exp_len  : std_logic;        --! is ciph_exp len status
    signal cpl_tag          : std_logic;        --! Completed tag header
    signal cpl_stat         : std_logic;        --! Completed status header
    signal sgmt_type        : std_logic_vector(4                -1 downto 0);
    signal sgmt_len         : std_logic_vector(16               -1 downto 0);
    signal sgmt_partial     : std_logic;
    signal sgmt_eot         : std_logic;
    signal sgmt_eoi         : std_logic;
    --! =======================================================================
    --! Datapath'
    --!     Signals
    signal word_size        : std_logic_vector(LOG2_WB          -1 downto 0);
    signal vbytes           : std_logic_vector(WB               -1 downto 0);
    signal out_word         : std_logic_vector(G_W              -1 downto 0);
    signal out_hdr          : std_logic_vector(G_W              -1 downto 0);
    signal is_eoi           : std_logic;
    --!     Registers
    signal msg_auth_done_r  : std_logic;
    signal msg_auth_valid_r : std_logic;
    signal reg_bdo          : std_logic_vector(G_DBLK_SIZE      -1 downto 0);
    signal reg_bdo_ready    : std_logic;
    signal reg_vbits        : std_logic_vector(G_W              -1 downto 0);
    signal reg_vbytes       : std_logic_vector(WB               -1 downto 0);
    signal ctr              : std_logic_vector
        (log2_ceil(CNT_DWORDS)-1 downto 0);
    --! =======================================================================
    --! aliases
    --!     Signal
    signal cmd_instr_opcode : std_logic_vector(4                -1 downto 0);
    signal cmd_sgmt_type    : std_logic_vector(4                -1 downto 0);
    signal cmd_sgmt_partial : std_logic;
    signal cmd_sgmt_eot     : std_logic;
    signal cmd_sgmt_eoi     : std_logic;
    signal cmd_sgmt_len     : std_logic_vector(16               -1 downto 0);
    --!     Global
    signal cmd_rdy          : std_logic;
    signal do_vld           : std_logic;
    signal bdo_rdy          : std_logic;
    --! =======================================================================
    type t_state is (S_WAIT_INSTR, S_WAIT_HDR, S_PREP,
        S_OUT, S_GEN_TAG_HDR, S_GEN_STAT_HDR, S_WAIT_BDO, S_WAIT_BDO_CIPH);
    signal cs   : t_state;  --! Current state
    signal ns   : t_state;  --! Next state
begin
    --! =======================================================================
    --! Datapath registers and control status registers
    --! =======================================================================
    process(clk)
    begin
        if rising_edge(clk) then
            if (cs = S_WAIT_INSTR) then
                is_decrypt <= cmd_instr_opcode(0);
            end if;

            if (cs = S_WAIT_INSTR) then
                cpl_tag <= '0';
            elsif (ld_tag = '1') then
                cpl_tag <= '1';
            end if;

            if (cs = S_WAIT_INSTR) then
                cpl_stat <= '0';
            elsif (ld_stat = '1') then
                cpl_stat <= '1';
            end if;

            if (cs = S_WAIT_INSTR) then
                msg_auth_done_r <= '0';
            elsif (msg_auth_done = '1') then
                msg_auth_done_r <= '1';
                msg_auth_valid_r <= msg_auth_valid;
            end if;

            if (en_len = '1') then
                if (unsigned(sgmt_len) < WB) then
                    reg_vbytes <= vbytes;
                else
                    reg_vbytes <= (others => '1');
                end if;
            end if;

            --! Keeping track of first data block (Only for special mode)
            if (G_CIPH_EXP) then
                if (ld_ciph_exp_len = '1') then
                    is_ciph_exp_len <= '1';
                elsif (en_len = '1' or cs = S_WAIT_INSTR) then
                    is_ciph_exp_len <= '0';
                end if;
                if (G_REVERSE_CIPH) then
                    if (set_first = '1') then
                        is_first <= '1';
                    elsif (clr_first = '1') then
                        clr_first <= '0';
                    end if;
                end if;
            end if;

            if (ld_sgmt_info = '1') then
                sgmt_type(3 downto 2) <= cmd_sgmt_type(3 downto 2);
                if (G_MERGE_TAG) then
                    sgmt_type(1 downto 0) <= not is_decrypt & '0';
                else
                    sgmt_type(1 downto 0) <= '0' & not is_decrypt;
                end if;
                sgmt_partial  <= cmd_sgmt_partial;
                sgmt_len      <= cmd_sgmt_len;
                sgmt_eot      <= cmd_sgmt_eot;
                sgmt_eoi      <= cmd_sgmt_eoi;
            elsif (ld_tag = '1') then
                sgmt_type     <= ST_TAG;
                sgmt_partial  <= '0';
                sgmt_eot      <= '1';
                sgmt_eoi      <= '1';
                sgmt_len      <= std_logic_vector(
                                to_unsigned(G_TAG_SIZE/8, sgmt_len'length));
            elsif (ld_stat = '1') then
                sgmt_type     <= STAT_SUCCESS(3 downto 1)
                                 & (not msg_auth_valid_r and is_decrypt);
                sgmt_partial  <= '0';
                sgmt_eot      <= '0';
                sgmt_eoi      <= '0';
                sgmt_len      <= (others => '0');
            elsif (en_len = '1') then
                if (sel_last = '1') then
                    sgmt_len <= (others => '0');
                else
                    sgmt_len <= std_logic_vector(unsigned(sgmt_len)-WB);
                end if;
            elsif (G_CIPH_EXP and ld_ciph_exp_len = '1') then
                sgmt_len <= ZEROS(15 downto G_LBS_BYTES+1) & bdo_size;
            end if;

            if (ld_ctr = '1') then
                ctr <= (others => '0');
            elsif (en_ctr = '1') then
                ctr <= std_logic_vector(unsigned(ctr)+1);
            end if;

            if (bdo_rdy = '1' and bdo_valid = '1') then
                reg_bdo <= bdo;
            elsif (en_ctr = '1') then
                reg_bdo <= reg_bdo(G_DBLK_SIZE-G_W-1 downto 0)
                    & ZEROS(G_W-1 downto 0);
            end if;
        end if;
    end process;

    --! Combinational logic of datapath
    gVbits:
    for i in WB-1 downto 0 generate
        reg_vbits(i*8+7 downto i*8) <= (others => reg_vbytes(i));
    end generate;
    word_size        <= sgmt_len(LOG2_WB-1 downto 0);
    vbytes <= VBYTES_LOOKUP(to_integer(unsigned(word_size)))
        when sel_last = '1'
        else (others => '1');

    sel_last <= '1' when (unsigned(sgmt_len) < WB) else '0';

    is_eoi <= '1' when (is_decrypt = '1'
                        and sgmt_type(3 downto 1) /= ST_NSEC
                        and sgmt_eot = '1')
                    or (is_decrypt = '0' and sgmt_type = ST_TAG)
                  else '0';
    out_hdr(G_W-1 downto G_W-32) <= sgmt_type
                & sgmt_partial & '0' & sgmt_eot & is_eoi
                & x"00" & sgmt_len;
    g_mt32:
    if (G_W > 32) generate
        out_hdr(G_W-33 downto 0) <= (others => '0');
    end generate;
        
    gBuffer: if (IS_BUFFER) generate
        out_word <= reg_bdo(G_DBLK_SIZE-1 downto G_DBLK_SIZE-G_W) and reg_vbits;
    end generate;
    gNotBuffer: if (not IS_BUFFER) generate
        out_word <= bdo and reg_vbits;
    end generate;
    do_data <= out_hdr when sel_do = '1' else out_word;

    --! Output communication
    cmd_ready <= cmd_rdy;
    gOutBuffer:
    if (IS_BUFFER) generate
        bdo_ready <= reg_bdo_ready;
    end generate;
    gOutNotBuffer:
    if (not IS_BUFFER) generate
        bdo_ready <= bdo_rdy;
    end generate;
    do_valid  <= do_vld;

    --! Command FIFO dissection
    cmd_instr_opcode <= cmd(24-1 downto 24-4);
    cmd_sgmt_type    <= cmd(24-1 downto 24-4);
    gCiphExp:
    if (G_CIPH_EXP) generate
        cmd_sgmt_partial <= cmd(24-5);
    end generate;
    gNotCiphExp:
    if (not G_CIPH_EXP) generate
        is_ciph_exp_len  <= '0';
        ld_ciph_exp_len  <= '0';
        cmd_sgmt_partial <= '0';
    end generate;
    cmd_sgmt_eot <= cmd(24-7);
    cmd_sgmt_eoi <= cmd(24-8);
    cmd_sgmt_len <= cmd(24-9 downto 24-24);


    --! =======================================================================
    --! Control
    --! =======================================================================
    --! State transition
    gNotAsync:
    if (not G_ASYNC_RSTN) generate
        process(clk)
        begin
            if rising_edge(clk) then
                if (rst = '1') then
                    cs <= S_WAIT_INSTR;
                    reg_bdo_ready <= '0';
                else
                    if (en_s = '1') then
                        cs <= ns;
                    end if;

                    --! BDO ready register
                    if (en_s = '1'
                        and (ns = S_WAIT_BDO 
                            or (G_CIPH_EXP and ns = S_WAIT_BDO_CIPH)))
                    then
                        reg_bdo_ready <= '1';
                    elsif (bdo_valid = '1' and reg_bdo_ready = '1') then
                        reg_bdo_ready <= '0';
                    end if;
                end if;
            end if;
        end process;
    end generate;
    gAsync:
    if (G_ASYNC_RSTN) generate
        process(clk, rst)
        begin
            if (rst = '0') then
                cs <= S_WAIT_INSTR;
                reg_bdo_ready <= '0';
            elsif rising_edge(clk) then
                if (en_s = '1') then
                    cs <= ns;
                end if;
                --! BDO ready register
                if (en_s = '1'
                    and (ns = S_WAIT_BDO 
                            or (G_CIPH_EXP and ns = S_WAIT_BDO_CIPH)))
                then
                    reg_bdo_ready <= '1';
                elsif (bdo_valid = '1' and reg_bdo_ready = '1') then
                    reg_bdo_ready <= '0';
                end if;
            end if;
        end process;
    end generate;

    --! Combinational logic
    gPdiComb:
    process(cs, cmd_instr_opcode,
        cmd_sgmt_type, cmd_sgmt_eot, cmd_sgmt_eoi, cmd_sgmt_len,
        is_decrypt, do_ready, bdo_valid,
        cmd_valid, ctr, sgmt_len, sgmt_eoi, sgmt_eot,
        is_first, is_ciph_exp_len,
        cpl_tag, cpl_stat, msg_auth_done_r)
    begin
        ns           <= cs;
        cmd_rdy      <= '0';
        bdo_rdy      <= '0';
        do_vld       <= '0';
        en_ctr       <= '0';
        en_len       <= '0';
        en_s         <= '0';
        ld_ctr       <= '0';
        ld_sgmt_info <= '0';
        ld_stat      <= '0';
        ld_tag       <= '0';
        sel_do       <= '0';
        if (G_CIPH_EXP) then
            ld_ciph_exp_len <= '0';
            if (G_REVERSE_CIPH) then
                clr_first   <=  '1';
            end if;
        end if;

        case cs is
            when S_WAIT_INSTR =>
                ns      <= S_WAIT_HDR;
                cmd_rdy <= '1';
                if (cmd_valid = '1'
                    and cmd_instr_opcode(3 downto 1) = OP_ENCDEC)
                then
                    en_s <= '1';
                end if;
                if (G_CIPH_EXP and G_REVERSE_CIPH) then
                    set_first <= '1';
                end if;

            when S_WAIT_HDR =>
                ld_sgmt_info <= '1';
                cmd_rdy      <= '1';
                if (G_CIPH_EXP) then
                    if (cmd_sgmt_type(3 downto 2) = ST_D
                        and ((G_REVERSE_CIPH and is_first = '1')
                            or (cmd_sgmt_eot = '1')))
                    then
                        ns <= S_WAIT_BDO_CIPH;
                        if (G_REVERSE_CIPH) then
                            clr_first <= '1';
                        end if;
                    else
                        ns <= S_PREP;
                    end if;
                else
                    ns           <= S_PREP;
                end if;
                if (cmd_valid = '1') then
                    en_s   <= '1';
                end if;

            --! Prepare appropriate flags and generate output header/status
            when S_PREP =>
                do_vld <= '1';
                if (do_ready = '1') then
                    if (cpl_stat = '1') then
                        ns <= S_WAIT_INSTR;
                    else
                        if (unsigned(sgmt_len) > 0)
                            or G_MERGE_TAG
                        then
                            if (not IS_BUFFER) then
                                ns <= S_OUT;
                            else
                                if (G_CIPH_EXP and is_ciph_exp_len = '1') then
                                    ns <= S_OUT;
                                else
                                    ns <= S_WAIT_BDO;
                                end if;
                            end if;
                        else
                            if (sgmt_eot = '1'
                                and sgmt_type(3 downto 2) = ST_D)
                            then
                                if (is_decrypt = '0') then
                                    ns <= S_GEN_TAG_HDR;
                                else
                                    ns <= S_GEN_STAT_HDR;
                                end if;
                            end if;
                        end if;
                    end if;
                    en_s   <= '1';
                    en_len <= '1';
                end if;
                sel_do <= '1';

            --! Output data
            when S_OUT =>
                if (not IS_BUFFER) then
                    bdo_rdy <= '1';
                    if (do_ready = '1' and bdo_valid = '1') then
                        do_vld <= '1';
                        en_len <= '1';
                        en_s   <= '1';
                    end if;
                else
                    do_vld <= '1';
                    if (do_ready = '1') then
                        en_len <= '1';
                        en_ctr <= '1';
                        en_s   <= '1';
                    end if;
                end if;

                if (unsigned(sgmt_len) = 0) then
                    if (sgmt_eot = '1') then
                        if (is_decrypt = '0' and cpl_tag = '0') then
                            ns <= S_GEN_TAG_HDR;
                        else
                            ns <= S_GEN_STAT_HDR;
                        end if;
                    else
                        ns <= S_WAIT_HDR;
                    end if;
                elsif (G_W /= G_DBLK_SIZE
                    and unsigned(ctr) = CNT_DWORDS-1)
                then
                    ns <= S_WAIT_BDO;
                end if;

            when S_GEN_TAG_HDR =>
                ld_tag  <= '1';
                ns      <= S_PREP;
                en_s    <= '1';

            when S_GEN_STAT_HDR =>
                ld_stat <= '1';
                ns      <= S_PREP;
                if (is_decrypt = '0' or msg_auth_done_r = '1') then
                    en_s    <= '1';
                end if;

            when S_WAIT_BDO =>
                ns      <= S_OUT;
                bdo_rdy <= '1';
                ld_ctr  <= '1';
                if (bdo_valid = '1') then
                    en_s <= '1';
                end if;

            when S_WAIT_BDO_CIPH =>
                ns              <= S_PREP;
                ld_ciph_exp_len <= '1';
                bdo_rdy         <= '1';
                ld_ctr          <= '1';
                if (bdo_valid = '1') then
                    en_s <= '1';
                end if;


        end case;
    end process;
end structure;


-------------------------------------------------------------------------------
--! @file       fwft_fifo.vhd
--! @brief      First-Word-Fall-Through FIFO
--! @project    CAESAR Candidate Evaluation
--! @author     Ekawat (ice) Homsirikamol
--! @copyright  Copyright (c) 2016 Cryptographic Engineering Research Group
--!             ECE Department, George Mason University Fairfax, VA, U.S.A.
--!             All rights Reserved.
--! @license    This project is released under the GNU Public License.
--!             The license and distribution terms for this file may be
--!             found in the file LICENSE in this distribution or at
--!             http://www.gnu.org/licenses/gpl-3.0.txt
--! @note       This is publicly available encryption source code that falls
--!             under the License Exception TSU (Technology and software-
--!             —unrestricted)
--! @ref        This code is based on the fwft_fifo by
--!             http://www.deathbylogic.com/2015/01/vhdl-first-word-fall-through-fifo/      
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fwft_fifo is
    generic (
        G_W             : integer := 64;    --! Width of I/O (bits)
        G_LOG2DEPTH     : integer := 9;     --! LOG(2) of depth
        G_ASYNC_RSTN    : boolean := False  --! Async reset active low
    );
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        din             : in  std_logic_vector(G_W              -1 downto 0);
        din_valid       : in  std_logic;
        din_ready       : out std_logic;
        dout            : out std_logic_vector(G_W              -1 downto 0);
        dout_valid      : out std_logic;
        dout_ready      : in  std_logic
    );
end fwft_fifo;

architecture structure of fwft_fifo is
    type t_mem is array (2**G_LOG2DEPTH-1 downto 0)
        of std_logic_vector(G_W-1 downto 0);
    signal iready : std_logic;
    signal ovalid : std_logic;
begin
    din_ready  <= iready;
    dout_valid <= ovalid;
    
    gSync:
    if (not G_ASYNC_RSTN) generate
        process(clk)
            variable memory : t_mem;
            variable wrptr  : std_logic_vector(G_LOG2DEPTH      -1 downto 0);
            variable rdptr  : std_logic_vector(G_LOG2DEPTH      -1 downto 0);
            variable looped : boolean;
        begin
            if rising_edge(clk) then
                if (rst = '1') then
                    wrptr  := (others => '0');
                    rdptr  := (others => '0');
                    looped := False;
                    
                    iready <= '1';
                    ovalid <= '0';
                else                                
                    if (dout_ready = '1' and ovalid = '1') then
                        if ((looped = True) or (wrptr /= rdptr)) then
                            if (unsigned(rdptr) = 2**G_LOG2DEPTH-1) then
                                looped := False;
                            end if;                    
                            rdptr := std_logic_vector(unsigned(rdptr) + 1);
                        end if;
                    end if;
                    
                    if (din_valid = '1' and iready = '1') then
                        if ((looped = False) or (wrptr /= rdptr)) then
                            memory(to_integer(unsigned(wrptr))) := din;
                            
                            if (unsigned(wrptr) = 2**G_LOG2DEPTH-1) then
                                looped := True;
                            end if;
                            wrptr := std_logic_vector(unsigned(wrptr) + 1);                        
                        end if;                    
                    end if;
                                                                   
                    dout <= memory(to_integer(unsigned(rdptr)));
                    
                    --! Update flags
                    if (wrptr = rdptr) then
                        if (looped) then
                            iready <= '0';
                        else
                            ovalid <= '0';
                        end if;
                    else
                        iready <= '1';
                        ovalid <= '1';
                    end if;
                end if;
            end if;
        end process;    
    end generate;
    gAsync:
    if (G_ASYNC_RSTN) generate
        process(clk, rst)
            variable memory : t_mem;
            variable wrptr  : std_logic_vector(G_LOG2DEPTH      -1 downto 0);
            variable rdptr  : std_logic_vector(G_LOG2DEPTH      -1 downto 0);
            variable looped : boolean;
        begin
            if (rst = '0') then
                wrptr  := (others => '0');
                rdptr  := (others => '0');
                looped := False;
                
                iready <= '1';
                ovalid <= '0';
            elsif rising_edge(clk) then
                if (dout_ready = '1' and ovalid = '1') then
                    if ((looped = True) or (wrptr /= rdptr)) then
                        if (unsigned(rdptr) = 2**G_LOG2DEPTH-1) then
                            looped := False;
                        end if;                    
                        rdptr := std_logic_vector(unsigned(rdptr) + 1);
                    end if;
                end if;
                
                if (din_valid = '1' and iready = '1') then
                    if ((looped = False) or (wrptr /= rdptr)) then
                        memory(to_integer(unsigned(wrptr))) := din;
                        
                        if (unsigned(wrptr) = 2**G_LOG2DEPTH-1) then
                            looped := True;
                        end if;
                        wrptr := std_logic_vector(unsigned(wrptr) + 1);                        
                    end if;                    
                end if;
                                                               
                dout <= memory(to_integer(unsigned(rdptr)));
                
                --! Update flags
                if (wrptr = rdptr) then
                    if (looped) then
                        iready <= '0';
                    else
                        ovalid <= '0';
                    end if;
                else
                    iready <= '1';
                    ovalid <= '1';
                end if;
            end if;
        end process;    
    end generate;
end architecture structure;


-------------------------------------------------------------------------------
--! @file       AEAD_Arch.vhd
--! @brief      Architecture of authenticated encryption unit.
--!             Note: This file should not be modified by a user.
--! @project    CAESAR Candidate Evaluation
--! @author     Ekawat (ice) Homsirikamol
--! @copyright  Copyright (c) 2016 Cryptographic Engineering Research Group
--!             ECE Department, George Mason University Fairfax, VA, U.S.A.
--!             All rights Reserved.
--! @license    This project is released under the GNU Public License.
--!             The license and distribution terms for this file may be
--!             found in the file LICENSE in this distribution or at
--!             http://www.gnu.org/licenses/gpl-3.0.txt
--! @note       This is publicly available encryption source code that falls
--!             under the License Exception TSU (Technology and software-
--!             —unrestricted)
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use work.AEAD_pkg.all;

-------------------------------------------------------------------------------
--! @brief  Architecture definition of AEAD
-------------------------------------------------------------------------------
architecture structure of AEAD is
    constant LBS_BYTES      : integer   := log2_ceil(G_DBLK_SIZE/8);
    --! Signals from input processor
    signal key              : std_logic_vector(G_KEY_SIZE       -1 downto 0);
    signal bdi              : std_logic_vector(G_DBLK_SIZE      -1 downto 0);

    signal key_valid        : std_logic;
    signal key_ready        : std_logic;    
    signal key_update       : std_logic;
    signal decrypt          : std_logic;
    signal bdi_valid        : std_logic;
    signal bdi_ready        : std_logic;
    signal bdi_partial      : std_logic;
    signal bdi_eot          : std_logic;
    signal bdi_eoi          : std_logic;
    signal bdi_type         : std_logic_vector(3                -1 downto 0);
    signal bdi_size         : std_logic_vector(LBS_BYTES+1      -1 downto 0);
    signal bdi_valid_bytes  : std_logic_vector(G_DBLK_SIZE/8    -1 downto 0);
    signal bdi_pad_loc      : std_logic_vector(G_DBLK_SIZE/8    -1 downto 0);

    --! Signals to output processor
    signal bdo_ready        : std_logic;
    signal bdo_valid        : std_logic;
    signal bdo              : std_logic_vector(G_DBLK_SIZE      -1 downto 0);
    signal bdo_size         : std_logic_vector(LBS_BYTES+1      -1 downto 0);
    signal msg_auth_done    : std_logic;
    signal msg_auth_valid   : std_logic;

    --! FIFO
    signal cmd_din          : std_logic_vector(24               -1 downto 0);
    signal cmd_dout         : std_logic_vector(24               -1 downto 0);
    signal cmd_rd_ready     : std_logic;
    signal cmd_wr_ready     : std_logic;
    signal cmd_wr_valid     : std_logic;
    signal cmd_rd_valid     : std_logic;
begin
    u_input:
    entity work.PreProcessor(structure)
    generic map (
        G_W                 => G_W              ,
        G_SW                => G_SW             ,
        G_ASYNC_RSTN        => G_ASYNC_RSTN     ,
        G_ENABLE_PAD        => G_ENABLE_PAD     ,
        G_CIPH_EXP          => G_CIPH_EXP       ,
        G_REVERSE_CIPH      => G_REVERSE_CIPH   ,
        G_MERGE_TAG         => G_MERGE_TAG      ,
        G_ABLK_SIZE         => G_ABLK_SIZE      ,
        G_DBLK_SIZE         => G_DBLK_SIZE      ,
        G_KEY_SIZE          => G_KEY_SIZE       ,
        G_LBS_BYTES         => LBS_BYTES        ,
        G_PAD_STYLE         => G_PAD_STYLE      ,
        G_PAD_AD            => G_PAD_AD         ,
        G_PAD_D             => G_PAD_D
    )
    port map (
        --! Global
        clk                 => clk              ,
        rst                 => rst              ,
        --! External
        pdi_data            => pdi_data         ,
        pdi_valid           => pdi_valid        ,
        pdi_ready           => pdi_ready        ,
        sdi_data            => sdi_data         ,
        sdi_valid           => sdi_valid        ,
        sdi_ready           => sdi_ready        ,
        --! CipherCore (Data)
        bdi                 => bdi              ,
        key                 => key              ,
        --! CipherCore (Control)
        key_valid           => key_valid        ,
        key_ready           => key_ready        ,
        key_update          => key_update       ,
        decrypt             => decrypt          ,
        bdi_ready           => bdi_ready        ,
        bdi_valid           => bdi_valid        ,
        bdi_type            => bdi_type         ,
        bdi_partial         => bdi_partial      ,
        bdi_eot             => bdi_eot          ,
        bdi_eoi             => bdi_eoi          ,
        bdi_size            => bdi_size         ,
        bdi_valid_bytes     => bdi_valid_bytes  ,
        bdi_pad_loc         => bdi_pad_loc      ,
        --! cmd FIFO
        cmd                 => cmd_din          ,
        cmd_ready           => cmd_wr_ready     ,
        cmd_valid           => cmd_wr_valid
    );

    u_cc:
    entity work.CipherCore(structure)
    generic map (
        G_ASYNC_RSTN        => G_ASYNC_RSTN     ,
        G_DBLK_SIZE         => G_DBLK_SIZE      ,
        G_KEY_SIZE          => G_KEY_SIZE       ,
        G_TAG_SIZE          => G_TAG_SIZE       ,
        G_LBS_BYTES         => LBS_BYTES        ,
        G_MAX_LEN           => G_MAX_LEN
    )
    port map (
        --! Global
        clk                 => clk              ,
        rst                 => rst              ,
        --! PreProcessor (data)
        key                 => key              ,
        bdi                 => bdi              ,
        --! PreProcessor (controls)
        key_valid           => key_valid        ,
        key_ready           => key_ready        ,        
        key_update          => key_update       ,
        decrypt             => decrypt          ,
        bdi_ready           => bdi_ready        ,
        bdi_valid           => bdi_valid        ,
        bdi_type            => bdi_type         ,
        bdi_partial         => bdi_partial      ,
        bdi_eot             => bdi_eot          ,
        bdi_eoi             => bdi_eoi          ,
        bdi_size            => bdi_size         ,
        bdi_valid_bytes     => bdi_valid_bytes  ,
        bdi_pad_loc         => bdi_pad_loc      ,
        --! PostProcessor
        bdo                 => bdo              ,
        bdo_ready           => bdo_ready        ,
        bdo_valid           => bdo_valid        ,
        bdo_size            => bdo_size         ,
        msg_auth_valid      => msg_auth_valid   ,
        msg_auth_done       => msg_auth_done
    );

    u_output:
    entity work.PostProcessor(structure)
    generic map (
        G_W                 => G_W              ,
        G_ASYNC_RSTN        => G_ASYNC_RSTN     ,        
        G_CIPH_EXP          => G_CIPH_EXP       ,
        G_REVERSE_CIPH      => G_REVERSE_CIPH   ,
        G_MERGE_TAG         => G_MERGE_TAG      ,
        G_LBS_BYTES         => LBS_BYTES        ,
        G_DBLK_SIZE         => G_DBLK_SIZE      ,
        G_TAG_SIZE          => G_TAG_SIZE
    )
    port map (
        --! Global
        clk                 => clk              ,
        rst                 => rst              ,
        --! External
        do_data             => do_data          ,
        do_ready            => do_ready         ,
        do_valid            => do_valid         ,
        --! CipherCore
        bdo_ready           => bdo_ready        ,
        bdo_valid           => bdo_valid        ,
        bdo                 => bdo              ,
        bdo_size            => bdo_size         ,
        msg_auth_valid      => msg_auth_valid   ,
        msg_auth_done       => msg_auth_done    ,
        --! cmd FIFOs
        cmd                 => cmd_dout         ,
        cmd_ready           => cmd_rd_ready     ,
        cmd_valid           => cmd_rd_valid
    );

    u_hdr_buffer:
    entity work.fwft_fifo(structure)
    generic map (
        G_W                 => 24               ,
        G_LOG2DEPTH         => 2                ,
        G_ASYNC_RSTN        => G_ASYNC_RSTN
    )
    port map (
        clk                 => clk              ,
        rst                 => rst              ,
        din                 => cmd_din          ,        
        din_valid           => cmd_wr_valid     ,
        din_ready           => cmd_wr_ready     ,
        dout                => cmd_dout         ,
        dout_valid          => cmd_rd_valid     ,
        dout_ready          => cmd_rd_ready
    );
end structure;


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
use work.AEAD_pkg.all;

library std;
use std.textio.all;

entity imp_ASCON IS
    generic (
        G_W             : integer := 32;
        G_SW            : integer := 32;
        size_int        : integer := 64;
        --! Reset behavior
        G_ASYNC_RSTN    : boolean := False  --! Async active low reset
    );
    port (
        --! Global ports
        clk             : in  std_logic;
        rst             : in  std_logic;
		en_c		: in  std_logic;
		
		ld_rec             : in  std_logic;
		MuxSel1		: in  std_logic_vector (1 downto 0);
		MuxSel2		: in  std_logic;
		
		roundsel		: in  std_logic;
		
		rand_in        : in  std_logic_vector(size_int-1 downto 0);
		
		IDt             : in  std_logic_vector(size_int-1  downto 0);
        IDst             : in  std_logic_vector(size_int-1  downto 0);
        key             : in  std_logic_vector((2*size_int)-1 downto 0);
        
         DtSel             : in  std_logic;
		
        --! Publica data ports
        pdi_data        : in  std_logic_vector(G_W             -1 downto 0);
        pdi_valid       : in  std_logic;
        pdi_ready       : out std_logic;
        --! Secret data ports

        sdi_valid       : in  std_logic;
        sdi_ready       : out std_logic;
        --! Data out ports
        do_data         : out std_logic_vector(G_W             -1 downto 0);
        do_ready        : in  std_logic;
        do_valid        : out std_logic;
        
        rand_out        : in  std_logic_vector(size_int             -1 downto 0)
    );
	
end entity imp_ASCON;
	
architecture structural of imp_ASCON is  
signal comxor           : std_logic_vector (size_int-1 downto 0);
signal secxor           : std_logic_vector (size_int-1 downto 0);
signal conc1           : std_logic_vector ((2*size_int)-1 downto 0);
signal conc2           : std_logic_vector ((2*size_int)-1 downto 0);
signal sdi_data           : std_logic_vector (G_SW-1 downto 0);

signal randd           : std_logic_vector (size_int-1 downto 0);
signal IDtReg           : std_logic_vector (size_int-1 downto 0);
signal IDstReg           : std_logic_vector (size_int-1 downto 0);

signal muxo1           : std_logic_vector (G_SW             -1 downto 0);
signal muxo2           : std_logic_vector (G_SW             -1 downto 0);

signal xor_in           : std_logic_vector (size_int-1 downto 0);

signal keytt           : std_logic_vector ((2*size_int)-1 downto 0);

begin  

Inst_AEAD:  entity work.AEAD(structure)
    generic map  (
        G_ASYNC_RSTN => G_ASYNC_RSTN,
        G_W          => G_W,
        G_SW         => G_SW
    )
    port map (
        rst          => rst,
        clk          => clk,
        pdi_data     => pdi_data,
        pdi_ready    => pdi_ready,
        pdi_valid    => pdi_valid,
        sdi_data     => sdi_data,
        sdi_ready    => sdi_ready,
        sdi_valid    => sdi_valid,
        do_data      => do_data,
        do_valid     => do_valid,
        do_ready     => do_ready
    );
	
		Inst_counter:  entity work.UP_COUNTER(Behavioral)--
    generic map  (
        datasize            => 64    
    )
    port map (
        clk          => clk,
        rst          => rst,
        en     => en_c,
        counter    => randd
    );
    
	Inst_RegIDt:  entity work.Regis(behavioral)
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

 with MuxSel1 select
    muxo1 <= conc1(31 downto 0) when "00",
       conc1(63 downto 32) when "01",
       conc1(95 downto 64) when "10",
       conc1(127 downto 96) when others;

       with MuxSel1 select
    muxo2 <= conc2(31 downto 0) when "00",
              conc2(63 downto 32) when "01",
              conc2(95 downto 64) when "10",
              conc2(127 downto 96) when others;
       
sdi_data <= muxo2 when (MuxSel2 = '1') else muxo1;
	
end architecture structural;
		
		
		