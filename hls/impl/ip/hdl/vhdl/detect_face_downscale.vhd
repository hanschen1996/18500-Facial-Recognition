-- ==============================================================
-- RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
-- Version: 2016.2
-- Copyright (C) 1986-2016 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity detect_face_downscale is
port (
    ap_clk : IN STD_LOGIC;
    ap_rst : IN STD_LOGIC;
    ap_start : IN STD_LOGIC;
    ap_done : OUT STD_LOGIC;
    ap_idle : OUT STD_LOGIC;
    ap_ready : OUT STD_LOGIC;
    src_address0 : OUT STD_LOGIC_VECTOR (14 downto 0);
    src_ce0 : OUT STD_LOGIC;
    src_q0 : IN STD_LOGIC_VECTOR (7 downto 0);
    dest_address0 : OUT STD_LOGIC_VECTOR (14 downto 0);
    dest_ce0 : OUT STD_LOGIC;
    dest_we0 : OUT STD_LOGIC;
    dest_d0 : OUT STD_LOGIC_VECTOR (7 downto 0);
    dest_height : IN STD_LOGIC_VECTOR (31 downto 0);
    dest_width : IN STD_LOGIC_VECTOR (31 downto 0) );
end;


architecture behav of detect_face_downscale is 
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_st1_fsm_0 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000000000000000000001";
    constant ap_ST_st2_fsm_1 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000000000000000000010";
    constant ap_ST_st3_fsm_2 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000000000000000000100";
    constant ap_ST_st4_fsm_3 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000000000000000001000";
    constant ap_ST_st5_fsm_4 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000000000000000010000";
    constant ap_ST_st6_fsm_5 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000000000000000100000";
    constant ap_ST_st7_fsm_6 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000000000000001000000";
    constant ap_ST_st8_fsm_7 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000000000000010000000";
    constant ap_ST_st9_fsm_8 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000000000000100000000";
    constant ap_ST_st10_fsm_9 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000000000001000000000";
    constant ap_ST_st11_fsm_10 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000000000010000000000";
    constant ap_ST_st12_fsm_11 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000000000100000000000";
    constant ap_ST_st13_fsm_12 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000000001000000000000";
    constant ap_ST_st14_fsm_13 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000000010000000000000";
    constant ap_ST_st15_fsm_14 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000000100000000000000";
    constant ap_ST_st16_fsm_15 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000001000000000000000";
    constant ap_ST_st17_fsm_16 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000010000000000000000";
    constant ap_ST_st18_fsm_17 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000100000000000000000";
    constant ap_ST_st19_fsm_18 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000001000000000000000000";
    constant ap_ST_st20_fsm_19 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000010000000000000000000";
    constant ap_ST_st21_fsm_20 : STD_LOGIC_VECTOR (30 downto 0) := "0000000000100000000000000000000";
    constant ap_ST_st22_fsm_21 : STD_LOGIC_VECTOR (30 downto 0) := "0000000001000000000000000000000";
    constant ap_ST_st23_fsm_22 : STD_LOGIC_VECTOR (30 downto 0) := "0000000010000000000000000000000";
    constant ap_ST_st24_fsm_23 : STD_LOGIC_VECTOR (30 downto 0) := "0000000100000000000000000000000";
    constant ap_ST_st25_fsm_24 : STD_LOGIC_VECTOR (30 downto 0) := "0000001000000000000000000000000";
    constant ap_ST_st26_fsm_25 : STD_LOGIC_VECTOR (30 downto 0) := "0000010000000000000000000000000";
    constant ap_ST_st27_fsm_26 : STD_LOGIC_VECTOR (30 downto 0) := "0000100000000000000000000000000";
    constant ap_ST_st28_fsm_27 : STD_LOGIC_VECTOR (30 downto 0) := "0001000000000000000000000000000";
    constant ap_ST_st29_fsm_28 : STD_LOGIC_VECTOR (30 downto 0) := "0010000000000000000000000000000";
    constant ap_ST_pp0_stg0_fsm_29 : STD_LOGIC_VECTOR (30 downto 0) := "0100000000000000000000000000000";
    constant ap_ST_st32_fsm_30 : STD_LOGIC_VECTOR (30 downto 0) := "1000000000000000000000000000000";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant ap_const_lv1_1 : STD_LOGIC_VECTOR (0 downto 0) := "1";
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
    constant ap_const_lv32_1C : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000011100";
    constant ap_const_lv32_1D : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000011101";
    constant ap_const_lv1_0 : STD_LOGIC_VECTOR (0 downto 0) := "0";
    constant ap_const_lv15_0 : STD_LOGIC_VECTOR (14 downto 0) := "000000000000000";
    constant ap_const_lv7_0 : STD_LOGIC_VECTOR (6 downto 0) := "0000000";
    constant ap_const_lv8_0 : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    constant ap_const_lv32_A00000 : STD_LOGIC_VECTOR (31 downto 0) := "00000000101000000000000000000000";
    constant ap_const_lv32_780000 : STD_LOGIC_VECTOR (31 downto 0) := "00000000011110000000000000000000";
    constant ap_const_lv15_4B00 : STD_LOGIC_VECTOR (14 downto 0) := "100101100000000";
    constant ap_const_lv15_1 : STD_LOGIC_VECTOR (14 downto 0) := "000000000000001";
    constant ap_const_lv7_1 : STD_LOGIC_VECTOR (6 downto 0) := "0000001";
    constant ap_const_lv8_A0 : STD_LOGIC_VECTOR (7 downto 0) := "10100000";
    constant ap_const_lv32_10 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000010000";
    constant ap_const_lv32_18 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000011000";
    constant ap_const_lv32_1A : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000011010";
    constant ap_const_lv5_0 : STD_LOGIC_VECTOR (4 downto 0) := "00000";
    constant ap_const_lv32_1F : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000011111";
    constant ap_const_lv8_1 : STD_LOGIC_VECTOR (7 downto 0) := "00000001";
    constant ap_const_lv32_1E : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000011110";

    signal ap_CS_fsm : STD_LOGIC_VECTOR (30 downto 0) := "0000000000000000000000000000001";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_sig_cseq_ST_st1_fsm_0 : STD_LOGIC;
    signal ap_sig_48 : BOOLEAN;
    signal indvar_flatten_reg_113 : STD_LOGIC_VECTOR (14 downto 0);
    signal row_reg_124 : STD_LOGIC_VECTOR (6 downto 0);
    signal col_reg_135 : STD_LOGIC_VECTOR (7 downto 0);
    signal ap_sig_cseq_ST_st2_fsm_1 : STD_LOGIC;
    signal ap_sig_86 : BOOLEAN;
    signal x_ratio_fu_158_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal x_ratio_reg_389 : STD_LOGIC_VECTOR (31 downto 0);
    signal ap_sig_cseq_ST_st29_fsm_28 : STD_LOGIC;
    signal ap_sig_95 : BOOLEAN;
    signal y_ratio_fu_164_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal y_ratio_reg_394 : STD_LOGIC_VECTOR (31 downto 0);
    signal exitcond_flatten_fu_179_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal exitcond_flatten_reg_399 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_sig_cseq_ST_pp0_stg0_fsm_29 : STD_LOGIC;
    signal ap_sig_106 : BOOLEAN;
    signal ap_reg_ppiten_pp0_it0 : STD_LOGIC := '0';
    signal ap_reg_ppiten_pp0_it1 : STD_LOGIC := '0';
    signal indvar_flatten_next_fu_185_p2 : STD_LOGIC_VECTOR (14 downto 0);
    signal col_mid2_fu_203_p3 : STD_LOGIC_VECTOR (7 downto 0);
    signal col_mid2_reg_408 : STD_LOGIC_VECTOR (7 downto 0);
    signal tmp_17_mid2_v_v_v_fu_228_p3 : STD_LOGIC_VECTOR (6 downto 0);
    signal tmp_17_mid2_v_v_v_reg_413 : STD_LOGIC_VECTOR (6 downto 0);
    signal or_cond_fu_296_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal or_cond_reg_420 : STD_LOGIC_VECTOR (0 downto 0);
    signal col_1_fu_328_p2 : STD_LOGIC_VECTOR (7 downto 0);
    signal row_phi_fu_128_p4 : STD_LOGIC_VECTOR (6 downto 0);
    signal tmp_64_cast_fu_323_p1 : STD_LOGIC_VECTOR (63 downto 0);
    signal tmp_65_cast_fu_371_p1 : STD_LOGIC_VECTOR (63 downto 0);
    signal grp_fu_146_p0 : STD_LOGIC_VECTOR (24 downto 0);
    signal grp_fu_152_p0 : STD_LOGIC_VECTOR (23 downto 0);
    signal grp_fu_146_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal grp_fu_152_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal row_cast2_fu_170_p1 : STD_LOGIC_VECTOR (31 downto 0);
    signal exitcond7_fu_197_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal row_1_fu_191_p2 : STD_LOGIC_VECTOR (6 downto 0);
    signal row_cast2_mid1_fu_211_p1 : STD_LOGIC_VECTOR (31 downto 0);
    signal tmp_14_mid1_fu_215_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_1_fu_174_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_17_mid2_v_v_fu_240_p0 : STD_LOGIC_VECTOR (6 downto 0);
    signal tmp_17_mid2_v_v_fu_240_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal tmp_98_fu_245_p4 : STD_LOGIC_VECTOR (8 downto 0);
    signal tmp_99_fu_263_p4 : STD_LOGIC_VECTOR (10 downto 0);
    signal p_shl2_cast_fu_255_p3 : STD_LOGIC_VECTOR (15 downto 0);
    signal p_shl3_cast_fu_273_p3 : STD_LOGIC_VECTOR (15 downto 0);
    signal col_cast1_fu_287_p1 : STD_LOGIC_VECTOR (31 downto 0);
    signal tmp_14_mid2_fu_220_p3 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_3_fu_291_p2 : STD_LOGIC_VECTOR (0 downto 0);
    signal tmp_4_fu_302_p0 : STD_LOGIC_VECTOR (7 downto 0);
    signal tmp_4_fu_302_p2 : STD_LOGIC_VECTOR (31 downto 0);
    signal tmp_5_fu_307_p4 : STD_LOGIC_VECTOR (15 downto 0);
    signal tmp_56_fu_281_p2 : STD_LOGIC_VECTOR (15 downto 0);
    signal tmp_60_fu_317_p2 : STD_LOGIC_VECTOR (15 downto 0);
    signal tmp_57_fu_334_p3 : STD_LOGIC_VECTOR (13 downto 0);
    signal tmp_58_fu_345_p3 : STD_LOGIC_VECTOR (11 downto 0);
    signal p_shl_cast_fu_341_p1 : STD_LOGIC_VECTOR (14 downto 0);
    signal p_shl1_cast_fu_352_p1 : STD_LOGIC_VECTOR (14 downto 0);
    signal tmp_7_cast_fu_362_p1 : STD_LOGIC_VECTOR (14 downto 0);
    signal tmp_59_fu_356_p2 : STD_LOGIC_VECTOR (14 downto 0);
    signal tmp_61_fu_365_p2 : STD_LOGIC_VECTOR (14 downto 0);
    signal grp_fu_146_ap_start : STD_LOGIC;
    signal grp_fu_146_ap_done : STD_LOGIC;
    signal grp_fu_152_ap_start : STD_LOGIC;
    signal grp_fu_152_ap_done : STD_LOGIC;
    signal ap_sig_cseq_ST_st32_fsm_30 : STD_LOGIC;
    signal ap_sig_317 : BOOLEAN;
    signal ap_NS_fsm : STD_LOGIC_VECTOR (30 downto 0);
    signal tmp_17_mid2_v_v_fu_240_p00 : STD_LOGIC_VECTOR (31 downto 0);

    component detect_face_udiv_25ns_32ns_32_29_seq IS
    generic (
        ID : INTEGER;
        NUM_STAGE : INTEGER;
        din0_WIDTH : INTEGER;
        din1_WIDTH : INTEGER;
        dout_WIDTH : INTEGER );
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        start : IN STD_LOGIC;
        done : OUT STD_LOGIC;
        din0 : IN STD_LOGIC_VECTOR (24 downto 0);
        din1 : IN STD_LOGIC_VECTOR (31 downto 0);
        ce : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR (31 downto 0) );
    end component;


    component detect_face_udiv_24ns_32ns_32_28_seq IS
    generic (
        ID : INTEGER;
        NUM_STAGE : INTEGER;
        din0_WIDTH : INTEGER;
        din1_WIDTH : INTEGER;
        dout_WIDTH : INTEGER );
    port (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        start : IN STD_LOGIC;
        done : OUT STD_LOGIC;
        din0 : IN STD_LOGIC_VECTOR (23 downto 0);
        din1 : IN STD_LOGIC_VECTOR (31 downto 0);
        ce : IN STD_LOGIC;
        dout : OUT STD_LOGIC_VECTOR (31 downto 0) );
    end component;



begin
    detect_face_udiv_25ns_32ns_32_29_seq_U1 : component detect_face_udiv_25ns_32ns_32_29_seq
    generic map (
        ID => 1,
        NUM_STAGE => 29,
        din0_WIDTH => 25,
        din1_WIDTH => 32,
        dout_WIDTH => 32)
    port map (
        clk => ap_clk,
        reset => ap_rst,
        start => grp_fu_146_ap_start,
        done => grp_fu_146_ap_done,
        din0 => grp_fu_146_p0,
        din1 => dest_width,
        ce => ap_const_logic_1,
        dout => grp_fu_146_p2);

    detect_face_udiv_24ns_32ns_32_28_seq_U2 : component detect_face_udiv_24ns_32ns_32_28_seq
    generic map (
        ID => 1,
        NUM_STAGE => 28,
        din0_WIDTH => 24,
        din1_WIDTH => 32,
        dout_WIDTH => 32)
    port map (
        clk => ap_clk,
        reset => ap_rst,
        start => grp_fu_152_ap_start,
        done => grp_fu_152_ap_done,
        din0 => grp_fu_152_p0,
        din1 => dest_height,
        ce => ap_const_logic_1,
        dout => grp_fu_152_p2);





    ap_CS_fsm_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_CS_fsm <= ap_ST_st1_fsm_0;
            else
                ap_CS_fsm <= ap_NS_fsm;
            end if;
        end if;
    end process;


    ap_reg_ppiten_pp0_it0_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_reg_ppiten_pp0_it0 <= ap_const_logic_0;
            else
                if (((ap_const_logic_1 = ap_sig_cseq_ST_pp0_stg0_fsm_29) and not((exitcond_flatten_fu_179_p2 = ap_const_lv1_0)))) then 
                    ap_reg_ppiten_pp0_it0 <= ap_const_logic_0;
                elsif ((ap_const_logic_1 = ap_sig_cseq_ST_st29_fsm_28)) then 
                    ap_reg_ppiten_pp0_it0 <= ap_const_logic_1;
                end if; 
            end if;
        end if;
    end process;


    ap_reg_ppiten_pp0_it1_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst = '1') then
                ap_reg_ppiten_pp0_it1 <= ap_const_logic_0;
            else
                if (((ap_const_logic_1 = ap_sig_cseq_ST_pp0_stg0_fsm_29) and (exitcond_flatten_fu_179_p2 = ap_const_lv1_0))) then 
                    ap_reg_ppiten_pp0_it1 <= ap_const_logic_1;
                elsif (((ap_const_logic_1 = ap_sig_cseq_ST_st29_fsm_28) or ((ap_const_logic_1 = ap_sig_cseq_ST_pp0_stg0_fsm_29) and not((exitcond_flatten_fu_179_p2 = ap_const_lv1_0))))) then 
                    ap_reg_ppiten_pp0_it1 <= ap_const_logic_0;
                end if; 
            end if;
        end if;
    end process;


    col_reg_135_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_logic_1 = ap_sig_cseq_ST_pp0_stg0_fsm_29) and (ap_const_logic_1 = ap_reg_ppiten_pp0_it0) and (exitcond_flatten_fu_179_p2 = ap_const_lv1_0))) then 
                col_reg_135 <= col_1_fu_328_p2;
            elsif ((ap_const_logic_1 = ap_sig_cseq_ST_st29_fsm_28)) then 
                col_reg_135 <= ap_const_lv8_0;
            end if; 
        end if;
    end process;

    indvar_flatten_reg_113_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_logic_1 = ap_sig_cseq_ST_pp0_stg0_fsm_29) and (ap_const_logic_1 = ap_reg_ppiten_pp0_it0) and (exitcond_flatten_fu_179_p2 = ap_const_lv1_0))) then 
                indvar_flatten_reg_113 <= indvar_flatten_next_fu_185_p2;
            elsif ((ap_const_logic_1 = ap_sig_cseq_ST_st29_fsm_28)) then 
                indvar_flatten_reg_113 <= ap_const_lv15_0;
            end if; 
        end if;
    end process;

    row_reg_124_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_logic_1 = ap_sig_cseq_ST_pp0_stg0_fsm_29) and (ap_const_logic_1 = ap_reg_ppiten_pp0_it1) and (exitcond_flatten_reg_399 = ap_const_lv1_0))) then 
                row_reg_124 <= tmp_17_mid2_v_v_v_reg_413;
            elsif ((ap_const_logic_1 = ap_sig_cseq_ST_st29_fsm_28)) then 
                row_reg_124 <= ap_const_lv7_0;
            end if; 
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_logic_1 = ap_sig_cseq_ST_pp0_stg0_fsm_29) and (exitcond_flatten_fu_179_p2 = ap_const_lv1_0))) then
                col_mid2_reg_408 <= col_mid2_fu_203_p3;
                or_cond_reg_420 <= or_cond_fu_296_p2;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_sig_cseq_ST_pp0_stg0_fsm_29)) then
                exitcond_flatten_reg_399 <= exitcond_flatten_fu_179_p2;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((ap_const_logic_1 = ap_sig_cseq_ST_pp0_stg0_fsm_29) and (ap_const_logic_1 = ap_reg_ppiten_pp0_it0) and (exitcond_flatten_fu_179_p2 = ap_const_lv1_0))) then
                tmp_17_mid2_v_v_v_reg_413 <= tmp_17_mid2_v_v_v_fu_228_p3;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if ((ap_const_logic_1 = ap_sig_cseq_ST_st29_fsm_28)) then
                x_ratio_reg_389 <= x_ratio_fu_158_p2;
                y_ratio_reg_394 <= y_ratio_fu_164_p2;
            end if;
        end if;
    end process;

    ap_NS_fsm_assign_proc : process (ap_start, ap_CS_fsm, exitcond_flatten_fu_179_p2, ap_reg_ppiten_pp0_it0)
    begin
        case ap_CS_fsm is
            when ap_ST_st1_fsm_0 => 
                if (not((ap_start = ap_const_logic_0))) then
                    ap_NS_fsm <= ap_ST_st2_fsm_1;
                else
                    ap_NS_fsm <= ap_ST_st1_fsm_0;
                end if;
            when ap_ST_st2_fsm_1 => 
                ap_NS_fsm <= ap_ST_st3_fsm_2;
            when ap_ST_st3_fsm_2 => 
                ap_NS_fsm <= ap_ST_st4_fsm_3;
            when ap_ST_st4_fsm_3 => 
                ap_NS_fsm <= ap_ST_st5_fsm_4;
            when ap_ST_st5_fsm_4 => 
                ap_NS_fsm <= ap_ST_st6_fsm_5;
            when ap_ST_st6_fsm_5 => 
                ap_NS_fsm <= ap_ST_st7_fsm_6;
            when ap_ST_st7_fsm_6 => 
                ap_NS_fsm <= ap_ST_st8_fsm_7;
            when ap_ST_st8_fsm_7 => 
                ap_NS_fsm <= ap_ST_st9_fsm_8;
            when ap_ST_st9_fsm_8 => 
                ap_NS_fsm <= ap_ST_st10_fsm_9;
            when ap_ST_st10_fsm_9 => 
                ap_NS_fsm <= ap_ST_st11_fsm_10;
            when ap_ST_st11_fsm_10 => 
                ap_NS_fsm <= ap_ST_st12_fsm_11;
            when ap_ST_st12_fsm_11 => 
                ap_NS_fsm <= ap_ST_st13_fsm_12;
            when ap_ST_st13_fsm_12 => 
                ap_NS_fsm <= ap_ST_st14_fsm_13;
            when ap_ST_st14_fsm_13 => 
                ap_NS_fsm <= ap_ST_st15_fsm_14;
            when ap_ST_st15_fsm_14 => 
                ap_NS_fsm <= ap_ST_st16_fsm_15;
            when ap_ST_st16_fsm_15 => 
                ap_NS_fsm <= ap_ST_st17_fsm_16;
            when ap_ST_st17_fsm_16 => 
                ap_NS_fsm <= ap_ST_st18_fsm_17;
            when ap_ST_st18_fsm_17 => 
                ap_NS_fsm <= ap_ST_st19_fsm_18;
            when ap_ST_st19_fsm_18 => 
                ap_NS_fsm <= ap_ST_st20_fsm_19;
            when ap_ST_st20_fsm_19 => 
                ap_NS_fsm <= ap_ST_st21_fsm_20;
            when ap_ST_st21_fsm_20 => 
                ap_NS_fsm <= ap_ST_st22_fsm_21;
            when ap_ST_st22_fsm_21 => 
                ap_NS_fsm <= ap_ST_st23_fsm_22;
            when ap_ST_st23_fsm_22 => 
                ap_NS_fsm <= ap_ST_st24_fsm_23;
            when ap_ST_st24_fsm_23 => 
                ap_NS_fsm <= ap_ST_st25_fsm_24;
            when ap_ST_st25_fsm_24 => 
                ap_NS_fsm <= ap_ST_st26_fsm_25;
            when ap_ST_st26_fsm_25 => 
                ap_NS_fsm <= ap_ST_st27_fsm_26;
            when ap_ST_st27_fsm_26 => 
                ap_NS_fsm <= ap_ST_st28_fsm_27;
            when ap_ST_st28_fsm_27 => 
                ap_NS_fsm <= ap_ST_st29_fsm_28;
            when ap_ST_st29_fsm_28 => 
                ap_NS_fsm <= ap_ST_pp0_stg0_fsm_29;
            when ap_ST_pp0_stg0_fsm_29 => 
                if (not(((ap_const_logic_1 = ap_reg_ppiten_pp0_it0) and not((exitcond_flatten_fu_179_p2 = ap_const_lv1_0))))) then
                    ap_NS_fsm <= ap_ST_pp0_stg0_fsm_29;
                else
                    ap_NS_fsm <= ap_ST_st32_fsm_30;
                end if;
            when ap_ST_st32_fsm_30 => 
                ap_NS_fsm <= ap_ST_st1_fsm_0;
            when others =>  
                ap_NS_fsm <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
        end case;
    end process;

    ap_done_assign_proc : process(ap_start, ap_sig_cseq_ST_st1_fsm_0, ap_sig_cseq_ST_st32_fsm_30)
    begin
        if ((((ap_const_logic_0 = ap_start) and (ap_const_logic_1 = ap_sig_cseq_ST_st1_fsm_0)) or (ap_const_logic_1 = ap_sig_cseq_ST_st32_fsm_30))) then 
            ap_done <= ap_const_logic_1;
        else 
            ap_done <= ap_const_logic_0;
        end if; 
    end process;


    ap_idle_assign_proc : process(ap_start, ap_sig_cseq_ST_st1_fsm_0)
    begin
        if (((ap_const_logic_0 = ap_start) and (ap_const_logic_1 = ap_sig_cseq_ST_st1_fsm_0))) then 
            ap_idle <= ap_const_logic_1;
        else 
            ap_idle <= ap_const_logic_0;
        end if; 
    end process;


    ap_ready_assign_proc : process(ap_sig_cseq_ST_st32_fsm_30)
    begin
        if ((ap_const_logic_1 = ap_sig_cseq_ST_st32_fsm_30)) then 
            ap_ready <= ap_const_logic_1;
        else 
            ap_ready <= ap_const_logic_0;
        end if; 
    end process;


    ap_sig_106_assign_proc : process(ap_CS_fsm)
    begin
                ap_sig_106 <= (ap_const_lv1_1 = ap_CS_fsm(29 downto 29));
    end process;


    ap_sig_317_assign_proc : process(ap_CS_fsm)
    begin
                ap_sig_317 <= (ap_const_lv1_1 = ap_CS_fsm(30 downto 30));
    end process;


    ap_sig_48_assign_proc : process(ap_CS_fsm)
    begin
                ap_sig_48 <= (ap_CS_fsm(0 downto 0) = ap_const_lv1_1);
    end process;


    ap_sig_86_assign_proc : process(ap_CS_fsm)
    begin
                ap_sig_86 <= (ap_const_lv1_1 = ap_CS_fsm(1 downto 1));
    end process;


    ap_sig_95_assign_proc : process(ap_CS_fsm)
    begin
                ap_sig_95 <= (ap_const_lv1_1 = ap_CS_fsm(28 downto 28));
    end process;


    ap_sig_cseq_ST_pp0_stg0_fsm_29_assign_proc : process(ap_sig_106)
    begin
        if (ap_sig_106) then 
            ap_sig_cseq_ST_pp0_stg0_fsm_29 <= ap_const_logic_1;
        else 
            ap_sig_cseq_ST_pp0_stg0_fsm_29 <= ap_const_logic_0;
        end if; 
    end process;


    ap_sig_cseq_ST_st1_fsm_0_assign_proc : process(ap_sig_48)
    begin
        if (ap_sig_48) then 
            ap_sig_cseq_ST_st1_fsm_0 <= ap_const_logic_1;
        else 
            ap_sig_cseq_ST_st1_fsm_0 <= ap_const_logic_0;
        end if; 
    end process;


    ap_sig_cseq_ST_st29_fsm_28_assign_proc : process(ap_sig_95)
    begin
        if (ap_sig_95) then 
            ap_sig_cseq_ST_st29_fsm_28 <= ap_const_logic_1;
        else 
            ap_sig_cseq_ST_st29_fsm_28 <= ap_const_logic_0;
        end if; 
    end process;


    ap_sig_cseq_ST_st2_fsm_1_assign_proc : process(ap_sig_86)
    begin
        if (ap_sig_86) then 
            ap_sig_cseq_ST_st2_fsm_1 <= ap_const_logic_1;
        else 
            ap_sig_cseq_ST_st2_fsm_1 <= ap_const_logic_0;
        end if; 
    end process;


    ap_sig_cseq_ST_st32_fsm_30_assign_proc : process(ap_sig_317)
    begin
        if (ap_sig_317) then 
            ap_sig_cseq_ST_st32_fsm_30 <= ap_const_logic_1;
        else 
            ap_sig_cseq_ST_st32_fsm_30 <= ap_const_logic_0;
        end if; 
    end process;

    col_1_fu_328_p2 <= std_logic_vector(unsigned(col_mid2_fu_203_p3) + unsigned(ap_const_lv8_1));
    col_cast1_fu_287_p1 <= std_logic_vector(resize(unsigned(col_mid2_fu_203_p3),32));
    col_mid2_fu_203_p3 <= 
        ap_const_lv8_0 when (exitcond7_fu_197_p2(0) = '1') else 
        col_reg_135;
    dest_address0 <= tmp_65_cast_fu_371_p1(15 - 1 downto 0);

    dest_ce0_assign_proc : process(ap_sig_cseq_ST_pp0_stg0_fsm_29, ap_reg_ppiten_pp0_it1)
    begin
        if (((ap_const_logic_1 = ap_sig_cseq_ST_pp0_stg0_fsm_29) and (ap_const_logic_1 = ap_reg_ppiten_pp0_it1))) then 
            dest_ce0 <= ap_const_logic_1;
        else 
            dest_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    dest_d0 <= src_q0;

    dest_we0_assign_proc : process(ap_sig_cseq_ST_pp0_stg0_fsm_29, ap_reg_ppiten_pp0_it1, or_cond_reg_420)
    begin
        if ((((ap_const_logic_1 = ap_sig_cseq_ST_pp0_stg0_fsm_29) and (ap_const_logic_1 = ap_reg_ppiten_pp0_it1) and not((ap_const_lv1_0 = or_cond_reg_420))))) then 
            dest_we0 <= ap_const_logic_1;
        else 
            dest_we0 <= ap_const_logic_0;
        end if; 
    end process;

    exitcond7_fu_197_p2 <= "1" when (col_reg_135 = ap_const_lv8_A0) else "0";
    exitcond_flatten_fu_179_p2 <= "1" when (indvar_flatten_reg_113 = ap_const_lv15_4B00) else "0";

    grp_fu_146_ap_start_assign_proc : process(ap_start, ap_sig_cseq_ST_st1_fsm_0)
    begin
        if (((ap_const_logic_1 = ap_sig_cseq_ST_st1_fsm_0) and not((ap_start = ap_const_logic_0)))) then 
            grp_fu_146_ap_start <= ap_const_logic_1;
        else 
            grp_fu_146_ap_start <= ap_const_logic_0;
        end if; 
    end process;

    grp_fu_146_p0 <= ap_const_lv32_A00000(25 - 1 downto 0);

    grp_fu_152_ap_start_assign_proc : process(ap_sig_cseq_ST_st2_fsm_1)
    begin
        if ((ap_const_logic_1 = ap_sig_cseq_ST_st2_fsm_1)) then 
            grp_fu_152_ap_start <= ap_const_logic_1;
        else 
            grp_fu_152_ap_start <= ap_const_logic_0;
        end if; 
    end process;

    grp_fu_152_p0 <= ap_const_lv32_780000(24 - 1 downto 0);
    indvar_flatten_next_fu_185_p2 <= std_logic_vector(unsigned(indvar_flatten_reg_113) + unsigned(ap_const_lv15_1));
    or_cond_fu_296_p2 <= (tmp_14_mid2_fu_220_p3 and tmp_3_fu_291_p2);
    p_shl1_cast_fu_352_p1 <= std_logic_vector(resize(unsigned(tmp_58_fu_345_p3),15));
    p_shl2_cast_fu_255_p3 <= (tmp_98_fu_245_p4 & ap_const_lv7_0);
    p_shl3_cast_fu_273_p3 <= (tmp_99_fu_263_p4 & ap_const_lv5_0);
    p_shl_cast_fu_341_p1 <= std_logic_vector(resize(unsigned(tmp_57_fu_334_p3),15));
    row_1_fu_191_p2 <= std_logic_vector(unsigned(row_phi_fu_128_p4) + unsigned(ap_const_lv7_1));
    row_cast2_fu_170_p1 <= std_logic_vector(resize(unsigned(row_phi_fu_128_p4),32));
    row_cast2_mid1_fu_211_p1 <= std_logic_vector(resize(unsigned(row_1_fu_191_p2),32));

    row_phi_fu_128_p4_assign_proc : process(row_reg_124, exitcond_flatten_reg_399, ap_sig_cseq_ST_pp0_stg0_fsm_29, ap_reg_ppiten_pp0_it1, tmp_17_mid2_v_v_v_reg_413)
    begin
        if (((ap_const_logic_1 = ap_sig_cseq_ST_pp0_stg0_fsm_29) and (ap_const_logic_1 = ap_reg_ppiten_pp0_it1) and (exitcond_flatten_reg_399 = ap_const_lv1_0))) then 
            row_phi_fu_128_p4 <= tmp_17_mid2_v_v_v_reg_413;
        else 
            row_phi_fu_128_p4 <= row_reg_124;
        end if; 
    end process;

    src_address0 <= tmp_64_cast_fu_323_p1(15 - 1 downto 0);

    src_ce0_assign_proc : process(ap_sig_cseq_ST_pp0_stg0_fsm_29, ap_reg_ppiten_pp0_it0)
    begin
        if (((ap_const_logic_1 = ap_sig_cseq_ST_pp0_stg0_fsm_29) and (ap_const_logic_1 = ap_reg_ppiten_pp0_it0))) then 
            src_ce0 <= ap_const_logic_1;
        else 
            src_ce0 <= ap_const_logic_0;
        end if; 
    end process;

    tmp_14_mid1_fu_215_p2 <= "1" when (unsigned(row_cast2_mid1_fu_211_p1) < unsigned(dest_height)) else "0";
    tmp_14_mid2_fu_220_p3 <= 
        tmp_14_mid1_fu_215_p2 when (exitcond7_fu_197_p2(0) = '1') else 
        tmp_1_fu_174_p2;
    tmp_17_mid2_v_v_fu_240_p0 <= tmp_17_mid2_v_v_fu_240_p00(7 - 1 downto 0);
    tmp_17_mid2_v_v_fu_240_p00 <= std_logic_vector(resize(unsigned(tmp_17_mid2_v_v_v_fu_228_p3),32));
    tmp_17_mid2_v_v_fu_240_p2 <= std_logic_vector(resize(unsigned(std_logic_vector(signed('0' &tmp_17_mid2_v_v_fu_240_p0) * signed(y_ratio_reg_394))), 32));
    tmp_17_mid2_v_v_v_fu_228_p3 <= 
        row_1_fu_191_p2 when (exitcond7_fu_197_p2(0) = '1') else 
        row_phi_fu_128_p4;
    tmp_1_fu_174_p2 <= "1" when (unsigned(row_cast2_fu_170_p1) < unsigned(dest_height)) else "0";
    tmp_3_fu_291_p2 <= "1" when (unsigned(col_cast1_fu_287_p1) < unsigned(dest_width)) else "0";
    tmp_4_fu_302_p0 <= col_cast1_fu_287_p1(8 - 1 downto 0);
    tmp_4_fu_302_p2 <= std_logic_vector(resize(unsigned(std_logic_vector(signed('0' &tmp_4_fu_302_p0) * signed(x_ratio_reg_389))), 32));
    tmp_56_fu_281_p2 <= std_logic_vector(unsigned(p_shl2_cast_fu_255_p3) + unsigned(p_shl3_cast_fu_273_p3));
    tmp_57_fu_334_p3 <= (tmp_17_mid2_v_v_v_reg_413 & ap_const_lv7_0);
    tmp_58_fu_345_p3 <= (tmp_17_mid2_v_v_v_reg_413 & ap_const_lv5_0);
    tmp_59_fu_356_p2 <= std_logic_vector(unsigned(p_shl_cast_fu_341_p1) + unsigned(p_shl1_cast_fu_352_p1));
    tmp_5_fu_307_p4 <= tmp_4_fu_302_p2(31 downto 16);
    tmp_60_fu_317_p2 <= std_logic_vector(unsigned(tmp_5_fu_307_p4) + unsigned(tmp_56_fu_281_p2));
    tmp_61_fu_365_p2 <= std_logic_vector(unsigned(tmp_7_cast_fu_362_p1) + unsigned(tmp_59_fu_356_p2));
    tmp_64_cast_fu_323_p1 <= std_logic_vector(resize(unsigned(tmp_60_fu_317_p2),64));
    tmp_65_cast_fu_371_p1 <= std_logic_vector(resize(unsigned(tmp_61_fu_365_p2),64));
    tmp_7_cast_fu_362_p1 <= std_logic_vector(resize(unsigned(col_mid2_reg_408),15));
    tmp_98_fu_245_p4 <= tmp_17_mid2_v_v_fu_240_p2(24 downto 16);
    tmp_99_fu_263_p4 <= tmp_17_mid2_v_v_fu_240_p2(26 downto 16);
    x_ratio_fu_158_p2 <= std_logic_vector(unsigned(grp_fu_146_p2) + unsigned(ap_const_lv32_1));
    y_ratio_fu_164_p2 <= std_logic_vector(unsigned(grp_fu_152_p2) + unsigned(ap_const_lv32_1));
end behav;