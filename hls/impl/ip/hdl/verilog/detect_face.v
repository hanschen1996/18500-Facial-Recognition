// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2016.4
// Copyright (C) 1986-2017 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

(* CORE_GENERATION_INFO="detect_face,hls_ip_2016_4,{HLS_INPUT_TYPE=c,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xc7k325tffg900-2,HLS_INPUT_CLOCK=10.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=8.430000,HLS_SYN_LAT=-1,HLS_SYN_TPT=none,HLS_SYN_MEM=182,HLS_SYN_DSP=28,HLS_SYN_FF=5766,HLS_SYN_LUT=9693}" *)

module detect_face (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        orig_image_address0,
        orig_image_ce0,
        orig_image_q0,
        success,
        success_ap_vld
);

parameter    ap_ST_fsm_state1 = 22'b1;
parameter    ap_ST_fsm_state2 = 22'b10;
parameter    ap_ST_fsm_state3 = 22'b100;
parameter    ap_ST_fsm_state4 = 22'b1000;
parameter    ap_ST_fsm_state5 = 22'b10000;
parameter    ap_ST_fsm_state6 = 22'b100000;
parameter    ap_ST_fsm_state7 = 22'b1000000;
parameter    ap_ST_fsm_state8 = 22'b10000000;
parameter    ap_ST_fsm_state9 = 22'b100000000;
parameter    ap_ST_fsm_state10 = 22'b1000000000;
parameter    ap_ST_fsm_state11 = 22'b10000000000;
parameter    ap_ST_fsm_state12 = 22'b100000000000;
parameter    ap_ST_fsm_state13 = 22'b1000000000000;
parameter    ap_ST_fsm_state14 = 22'b10000000000000;
parameter    ap_ST_fsm_state15 = 22'b100000000000000;
parameter    ap_ST_fsm_state16 = 22'b1000000000000000;
parameter    ap_ST_fsm_state17 = 22'b10000000000000000;
parameter    ap_ST_fsm_state18 = 22'b100000000000000000;
parameter    ap_ST_fsm_state19 = 22'b1000000000000000000;
parameter    ap_ST_fsm_state20 = 22'b10000000000000000000;
parameter    ap_ST_fsm_state21 = 22'b100000000000000000000;
parameter    ap_ST_fsm_state22 = 22'b1000000000000000000000;
parameter    ap_const_lv32_0 = 32'b00000000000000000000000000000000;
parameter    ap_const_lv32_3 = 32'b11;
parameter    ap_const_lv32_4 = 32'b100;
parameter    ap_const_lv32_5 = 32'b101;
parameter    ap_const_lv32_B = 32'b1011;
parameter    ap_const_lv32_C = 32'b1100;
parameter    ap_const_lv32_14 = 32'b10100;
parameter    ap_const_lv32_15 = 32'b10101;
parameter    ap_const_lv32_3F800000 = 32'b111111100000000000000000000000;
parameter    ap_const_lv32_A0 = 32'b10100000;
parameter    ap_const_lv32_78 = 32'b1111000;
parameter    ap_const_lv32_2 = 32'b10;
parameter    ap_const_lv32_6 = 32'b110;
parameter    ap_const_lv15_0 = 15'b000000000000000;
parameter    ap_const_lv32_7 = 32'b111;
parameter    ap_const_lv32_1 = 32'b1;
parameter    ap_const_lv32_42F00000 = 32'b1000010111100000000000000000000;
parameter    ap_const_lv32_D = 32'b1101;
parameter    ap_const_lv32_43200000 = 32'b1000011001000000000000000000000;
parameter    ap_const_lv64_3FF3333333333333 = 64'b11111111110011001100110011001100110011001100110011001100110011;
parameter    ap_const_lv32_17 = 32'b10111;
parameter    ap_const_lv7_0 = 7'b0000000;
parameter    ap_const_lv5_0 = 5'b00000;
parameter    ap_const_lv8_FF = 8'b11111111;
parameter    ap_const_lv15_1 = 15'b1;
parameter    ap_const_lv32_1E = 32'b11110;
parameter    ap_const_lv9_181 = 9'b110000001;
parameter    ap_const_lv32_8 = 32'b1000;
parameter    ap_const_lv8_7F = 8'b1111111;
parameter    ap_const_lv32_36 = 32'b110110;
parameter    ap_const_lv32_9 = 32'b1001;
parameter    ap_const_lv32_A = 32'b1010;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
output  [14:0] orig_image_address0;
output   orig_image_ce0;
input  [7:0] orig_image_q0;
output  [31:0] success;
output   success_ap_vld;

reg ap_done;
reg ap_idle;
reg ap_ready;
reg success_ap_vld;

(* fsm_encoding = "none" *) reg   [21:0] ap_CS_fsm;
wire   [0:0] ap_CS_fsm_state1;
reg   [31:0] alr_found;
wire   [15:0] tmp_17_fu_426_p2;
reg   [15:0] tmp_17_reg_807;
wire   [0:0] ap_CS_fsm_state4;
wire   [31:0] row_2_fu_442_p2;
reg   [31:0] row_2_reg_815;
wire   [0:0] tmp_3_fu_448_p2;
reg   [0:0] tmp_3_reg_820;
wire   [0:0] exitcond1_fu_436_p2;
wire   [15:0] tmp_27_fu_484_p2;
reg   [15:0] tmp_27_reg_824;
wire   [63:0] tmp_1_fu_370_p1;
reg   [63:0] tmp_1_reg_829;
reg   [14:0] integral_image_sq_ad_reg_834;
wire   [0:0] ap_CS_fsm_state5;
reg   [14:0] integral_image_sq_ad_1_reg_839;
reg   [14:0] integral_image_sq_ad_2_reg_844;
reg   [14:0] integral_image_addr_reg_854;
reg   [14:0] integral_image_addr_1_reg_859;
reg   [14:0] integral_image_addr_2_reg_864;
wire   [14:0] col_2_fu_529_p2;
reg   [14:0] col_2_reg_872;
wire   [31:0] accum_1_fu_543_p2;
reg   [31:0] accum_1_reg_877;
wire   [0:0] ap_CS_fsm_state6;
wire   [31:0] grp_fu_796_p3;
reg   [31:0] accum_sq_1_reg_883;
wire   [63:0] grp_fu_374_p2;
reg   [63:0] tmp_2_reg_890;
wire   [0:0] ap_CS_fsm_state12;
wire   [31:0] factor_1_fu_367_p1;
reg   [31:0] factor_1_reg_895;
wire   [0:0] ap_CS_fsm_state13;
reg   [7:0] loc_V_reg_902;
wire   [0:0] ap_CS_fsm_state21;
wire   [22:0] loc_V_1_fu_576_p1;
reg   [22:0] loc_V_1_reg_908;
reg   [7:0] loc_V_2_reg_913;
wire   [22:0] loc_V_3_fu_594_p1;
reg   [22:0] loc_V_3_reg_919;
wire   [31:0] result_V_fu_689_p3;
wire   [0:0] ap_CS_fsm_state22;
wire   [31:0] result_V_1_fu_788_p3;
reg   [14:0] image_address0;
reg    image_ce0;
reg    image_we0;
wire   [7:0] image_q0;
reg   [14:0] integral_image_address0;
reg    integral_image_ce0;
reg    integral_image_we0;
reg   [31:0] integral_image_d0;
wire   [31:0] integral_image_q0;
reg    integral_image_ce1;
wire   [31:0] integral_image_q1;
reg   [14:0] integral_image_sq_address0;
reg    integral_image_sq_ce0;
reg    integral_image_sq_we0;
reg   [31:0] integral_image_sq_d0;
wire   [31:0] integral_image_sq_q0;
reg    integral_image_sq_ce1;
wire   [31:0] integral_image_sq_q1;
wire    grp_cascade_classifier_fu_282_ap_start;
wire    grp_cascade_classifier_fu_282_ap_done;
wire    grp_cascade_classifier_fu_282_ap_idle;
wire    grp_cascade_classifier_fu_282_ap_ready;
wire   [14:0] grp_cascade_classifier_fu_282_integral_image_address0;
wire    grp_cascade_classifier_fu_282_integral_image_ce0;
wire   [14:0] grp_cascade_classifier_fu_282_integral_image_address1;
wire    grp_cascade_classifier_fu_282_integral_image_ce1;
wire   [14:0] grp_cascade_classifier_fu_282_integral_image_sq_address0;
wire    grp_cascade_classifier_fu_282_integral_image_sq_ce0;
wire   [14:0] grp_cascade_classifier_fu_282_integral_image_sq_address1;
wire    grp_cascade_classifier_fu_282_integral_image_sq_ce1;
wire   [31:0] grp_cascade_classifier_fu_282_alr_found_o;
wire    grp_cascade_classifier_fu_282_alr_found_o_ap_vld;
wire    grp_downscale_fu_346_ap_start;
wire    grp_downscale_fu_346_ap_done;
wire    grp_downscale_fu_346_ap_idle;
wire    grp_downscale_fu_346_ap_ready;
wire   [14:0] grp_downscale_fu_346_src_address0;
wire    grp_downscale_fu_346_src_ce0;
wire   [14:0] grp_downscale_fu_346_dest_address0;
wire    grp_downscale_fu_346_dest_ce0;
wire    grp_downscale_fu_346_dest_we0;
wire   [7:0] grp_downscale_fu_346_dest_d0;
reg   [31:0] factor_reg_200;
reg   [31:0] curr_width_reg_212;
reg   [31:0] curr_height_reg_224;
reg   [31:0] row_reg_236;
wire   [0:0] ap_CS_fsm_state3;
wire   [0:0] exitcond_fu_523_p2;
reg   [14:0] col_reg_247;
wire   [0:0] ap_CS_fsm_state7;
reg   [31:0] accum_reg_258;
reg   [31:0] accum_sq_reg_270;
reg    ap_reg_grp_cascade_classifier_fu_282_ap_start;
wire   [0:0] ap_CS_fsm_state8;
reg    ap_reg_grp_downscale_fu_346_ap_start;
wire   [0:0] ap_CS_fsm_state2;
wire   [0:0] tmp_9_fu_391_p2;
wire   [31:0] col_cast_fu_490_p1;
wire   [31:0] tmp_31_cast_fu_505_p1;
wire   [31:0] tmp_32_cast_fu_516_p1;
wire   [31:0] tmp_7_fu_550_p2;
(* use_dsp48 = "no" *) wire   [31:0] tmp_8_fu_556_p2;
wire   [0:0] ap_CS_fsm_state14;
wire   [0:0] tmp_fu_379_p2;
wire   [0:0] tmp_s_fu_385_p2;
wire   [8:0] tmp_18_fu_402_p1;
wire   [10:0] tmp_20_fu_414_p1;
wire   [15:0] p_shl1_cast_fu_418_p3;
wire   [15:0] p_shl_cast_fu_406_p3;
wire   [7:0] tmp_23_fu_432_p1;
wire   [7:0] tmp_4_fu_454_p2;
wire   [14:0] tmp_25_fu_460_p3;
wire   [12:0] tmp_26_fu_472_p3;
wire   [15:0] p_shl3_cast_fu_480_p1;
wire   [15:0] p_shl2_cast_fu_468_p1;
wire   [15:0] col_cast_cast_fu_496_p1;
wire   [15:0] tmp_28_fu_500_p2;
wire   [15:0] tmp_29_fu_511_p2;
wire   [31:0] tmp_5_fu_535_p1;
wire   [31:0] grp_fu_357_p2;
wire   [31:0] p_Val2_s_fu_562_p1;
wire   [31:0] grp_fu_362_p2;
wire   [31:0] p_Val2_4_fu_580_p1;
wire   [23:0] p_Result_s_fu_598_p3;
wire   [8:0] tmp_i_i_i_cast2_fu_609_p1;
wire   [8:0] sh_assign_fu_612_p2;
wire   [7:0] tmp_4_i_i_fu_626_p2;
wire   [0:0] isNeg_fu_618_p3;
wire  signed [8:0] tmp_4_i_i_cast_fu_631_p1;
wire   [8:0] sh_assign_1_fu_635_p3;
wire  signed [31:0] sh_assign_1_cast_fu_643_p1;
wire  signed [23:0] sh_assign_1_cast_cas_fu_647_p1;
wire   [77:0] tmp_2_i_i_fu_605_p1;
wire   [77:0] tmp_6_i_i_fu_651_p1;
wire   [23:0] tmp_7_i_i_fu_655_p2;
wire   [0:0] tmp_33_fu_667_p3;
wire   [77:0] tmp_9_i_i_fu_661_p2;
wire   [31:0] tmp_19_fu_675_p1;
wire   [31:0] tmp_21_fu_679_p4;
wire   [23:0] p_Result_4_fu_697_p3;
wire   [8:0] tmp_i_i_i6_cast1_fu_708_p1;
wire   [8:0] sh_assign_2_fu_711_p2;
wire   [7:0] tmp_4_i_i9_fu_725_p2;
wire   [0:0] isNeg_1_fu_717_p3;
wire  signed [8:0] tmp_4_i_i9_cast_fu_730_p1;
wire   [8:0] sh_assign_3_fu_734_p3;
wire  signed [31:0] sh_assign_3_cast_fu_742_p1;
wire  signed [23:0] sh_assign_3_cast_cas_fu_746_p1;
wire   [77:0] tmp_2_i_i5_fu_704_p1;
wire   [77:0] tmp_6_i_i1_fu_750_p1;
wire   [23:0] tmp_7_i_i1_fu_754_p2;
wire   [0:0] tmp_36_fu_766_p3;
wire   [77:0] tmp_9_i_i1_fu_760_p2;
wire   [31:0] tmp_22_fu_774_p1;
wire   [31:0] tmp_24_fu_778_p4;
wire   [7:0] grp_fu_796_p0;
wire   [15:0] tmp_16_cast_fu_539_p1;
wire   [7:0] grp_fu_796_p1;
reg    grp_fu_374_ce;
wire   [0:0] ap_CS_fsm_state9;
wire   [0:0] ap_CS_fsm_state10;
wire   [0:0] ap_CS_fsm_state11;
reg   [21:0] ap_NS_fsm;

// power-on initialization
initial begin
#0 ap_CS_fsm = 22'b1;
#0 alr_found = 32'b00000000000000000000000000000000;
#0 ap_reg_grp_cascade_classifier_fu_282_ap_start = 1'b0;
#0 ap_reg_grp_downscale_fu_346_ap_start = 1'b0;
end

detect_face_image #(
    .DataWidth( 8 ),
    .AddressRange( 19200 ),
    .AddressWidth( 15 ))
image_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .address0(image_address0),
    .ce0(image_ce0),
    .we0(image_we0),
    .d0(grp_downscale_fu_346_dest_d0),
    .q0(image_q0)
);

detect_face_integEe0 #(
    .DataWidth( 32 ),
    .AddressRange( 19200 ),
    .AddressWidth( 15 ))
integral_image_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .address0(integral_image_address0),
    .ce0(integral_image_ce0),
    .we0(integral_image_we0),
    .d0(integral_image_d0),
    .q0(integral_image_q0),
    .address1(grp_cascade_classifier_fu_282_integral_image_address1),
    .ce1(integral_image_ce1),
    .q1(integral_image_q1)
);

detect_face_integEe0 #(
    .DataWidth( 32 ),
    .AddressRange( 19200 ),
    .AddressWidth( 15 ))
integral_image_sq_U(
    .clk(ap_clk),
    .reset(ap_rst),
    .address0(integral_image_sq_address0),
    .ce0(integral_image_sq_ce0),
    .we0(integral_image_sq_we0),
    .d0(integral_image_sq_d0),
    .q0(integral_image_sq_q0),
    .address1(grp_cascade_classifier_fu_282_integral_image_sq_address1),
    .ce1(integral_image_sq_ce1),
    .q1(integral_image_sq_q1)
);

cascade_classifier grp_cascade_classifier_fu_282(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(grp_cascade_classifier_fu_282_ap_start),
    .ap_done(grp_cascade_classifier_fu_282_ap_done),
    .ap_idle(grp_cascade_classifier_fu_282_ap_idle),
    .ap_ready(grp_cascade_classifier_fu_282_ap_ready),
    .integral_image_address0(grp_cascade_classifier_fu_282_integral_image_address0),
    .integral_image_ce0(grp_cascade_classifier_fu_282_integral_image_ce0),
    .integral_image_q0(integral_image_q0),
    .integral_image_address1(grp_cascade_classifier_fu_282_integral_image_address1),
    .integral_image_ce1(grp_cascade_classifier_fu_282_integral_image_ce1),
    .integral_image_q1(integral_image_q1),
    .integral_image_sq_address0(grp_cascade_classifier_fu_282_integral_image_sq_address0),
    .integral_image_sq_ce0(grp_cascade_classifier_fu_282_integral_image_sq_ce0),
    .integral_image_sq_q0(integral_image_sq_q0),
    .integral_image_sq_address1(grp_cascade_classifier_fu_282_integral_image_sq_address1),
    .integral_image_sq_ce1(grp_cascade_classifier_fu_282_integral_image_sq_ce1),
    .integral_image_sq_q1(integral_image_sq_q1),
    .height(curr_height_reg_224),
    .width(curr_width_reg_212),
    .factor(factor_reg_200),
    .alr_found_i(alr_found),
    .alr_found_o(grp_cascade_classifier_fu_282_alr_found_o),
    .alr_found_o_ap_vld(grp_cascade_classifier_fu_282_alr_found_o_ap_vld)
);

downscale grp_downscale_fu_346(
    .ap_clk(ap_clk),
    .ap_rst(ap_rst),
    .ap_start(grp_downscale_fu_346_ap_start),
    .ap_done(grp_downscale_fu_346_ap_done),
    .ap_idle(grp_downscale_fu_346_ap_idle),
    .ap_ready(grp_downscale_fu_346_ap_ready),
    .src_address0(grp_downscale_fu_346_src_address0),
    .src_ce0(grp_downscale_fu_346_src_ce0),
    .src_q0(orig_image_q0),
    .dest_address0(grp_downscale_fu_346_dest_address0),
    .dest_ce0(grp_downscale_fu_346_dest_ce0),
    .dest_we0(grp_downscale_fu_346_dest_we0),
    .dest_d0(grp_downscale_fu_346_dest_d0),
    .height(curr_height_reg_224),
    .width(curr_width_reg_212)
);

detect_face_fdiv_Gfk #(
    .ID( 1 ),
    .NUM_STAGE( 8 ),
    .din0_WIDTH( 32 ),
    .din1_WIDTH( 32 ),
    .dout_WIDTH( 32 ))
detect_face_fdiv_Gfk_U41(
    .clk(ap_clk),
    .reset(ap_rst),
    .din0(ap_const_lv32_42F00000),
    .din1(factor_1_reg_895),
    .ce(1'b1),
    .dout(grp_fu_357_p2)
);

detect_face_fdiv_Gfk #(
    .ID( 1 ),
    .NUM_STAGE( 8 ),
    .din0_WIDTH( 32 ),
    .din1_WIDTH( 32 ),
    .dout_WIDTH( 32 ))
detect_face_fdiv_Gfk_U42(
    .clk(ap_clk),
    .reset(ap_rst),
    .din0(ap_const_lv32_43200000),
    .din1(factor_1_reg_895),
    .ce(1'b1),
    .dout(grp_fu_362_p2)
);

detect_face_fptruHfu #(
    .ID( 1 ),
    .NUM_STAGE( 1 ),
    .din0_WIDTH( 64 ),
    .dout_WIDTH( 32 ))
detect_face_fptruHfu_U43(
    .din0(tmp_2_reg_890),
    .dout(factor_1_fu_367_p1)
);

detect_face_fpextIfE #(
    .ID( 1 ),
    .NUM_STAGE( 1 ),
    .din0_WIDTH( 32 ),
    .dout_WIDTH( 64 ))
detect_face_fpextIfE_U44(
    .din0(factor_reg_200),
    .dout(tmp_1_fu_370_p1)
);

detect_face_dmul_JfO #(
    .ID( 1 ),
    .NUM_STAGE( 5 ),
    .din0_WIDTH( 64 ),
    .din1_WIDTH( 64 ),
    .dout_WIDTH( 64 ))
detect_face_dmul_JfO_U45(
    .clk(ap_clk),
    .reset(ap_rst),
    .din0(tmp_1_reg_829),
    .din1(ap_const_lv64_3FF3333333333333),
    .ce(grp_fu_374_ce),
    .dout(grp_fu_374_p2)
);

detect_face_mac_mKfY #(
    .ID( 1 ),
    .NUM_STAGE( 1 ),
    .din0_WIDTH( 8 ),
    .din1_WIDTH( 8 ),
    .din2_WIDTH( 32 ),
    .dout_WIDTH( 32 ))
detect_face_mac_mKfY_U46(
    .din0(grp_fu_796_p0),
    .din1(grp_fu_796_p1),
    .din2(accum_sq_reg_270),
    .dout(grp_fu_796_p3)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_reg_grp_cascade_classifier_fu_282_ap_start <= 1'b0;
    end else begin
        if (((1'b1 == ap_CS_fsm_state4) & ~(exitcond1_fu_436_p2 == 1'b0))) begin
            ap_reg_grp_cascade_classifier_fu_282_ap_start <= 1'b1;
        end else if ((1'b1 == grp_cascade_classifier_fu_282_ap_ready)) begin
            ap_reg_grp_cascade_classifier_fu_282_ap_start <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_reg_grp_downscale_fu_346_ap_start <= 1'b0;
    end else begin
        if (((1'b1 == ap_CS_fsm_state2) & ~(1'b0 == tmp_9_fu_391_p2))) begin
            ap_reg_grp_downscale_fu_346_ap_start <= 1'b1;
        end else if ((1'b1 == grp_downscale_fu_346_ap_ready)) begin
            ap_reg_grp_downscale_fu_346_ap_start <= 1'b0;
        end
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state4) & (exitcond1_fu_436_p2 == 1'b0))) begin
        accum_reg_258 <= ap_const_lv32_0;
    end else if ((1'b1 == ap_CS_fsm_state7)) begin
        accum_reg_258 <= accum_1_reg_877;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state4) & (exitcond1_fu_436_p2 == 1'b0))) begin
        accum_sq_reg_270 <= ap_const_lv32_0;
    end else if ((1'b1 == ap_CS_fsm_state7)) begin
        accum_sq_reg_270 <= accum_sq_1_reg_883;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state4) & (exitcond1_fu_436_p2 == 1'b0))) begin
        col_reg_247 <= ap_const_lv15_0;
    end else if ((1'b1 == ap_CS_fsm_state7)) begin
        col_reg_247 <= col_2_reg_872;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state22)) begin
        curr_height_reg_224 <= result_V_fu_689_p3;
    end else if (((ap_CS_fsm_state1 == 1'b1) & ~(ap_start == 1'b0))) begin
        curr_height_reg_224 <= ap_const_lv32_78;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state22)) begin
        curr_width_reg_212 <= result_V_1_fu_788_p3;
    end else if (((ap_CS_fsm_state1 == 1'b1) & ~(ap_start == 1'b0))) begin
        curr_width_reg_212 <= ap_const_lv32_A0;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state22)) begin
        factor_reg_200 <= factor_1_reg_895;
    end else if (((ap_CS_fsm_state1 == 1'b1) & ~(ap_start == 1'b0))) begin
        factor_reg_200 <= ap_const_lv32_3F800000;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state5) & ~(1'b0 == exitcond_fu_523_p2))) begin
        row_reg_236 <= row_2_reg_815;
    end else if (((1'b1 == ap_CS_fsm_state3) & ~(1'b0 == grp_downscale_fu_346_ap_done))) begin
        row_reg_236 <= ap_const_lv32_0;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state6)) begin
        accum_1_reg_877 <= accum_1_fu_543_p2;
        accum_sq_1_reg_883 <= grp_fu_796_p3;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state8) & (1'b1 == grp_cascade_classifier_fu_282_alr_found_o_ap_vld))) begin
        alr_found <= grp_cascade_classifier_fu_282_alr_found_o;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        col_2_reg_872 <= col_2_fu_529_p2;
        integral_image_addr_1_reg_859 <= tmp_31_cast_fu_505_p1;
        integral_image_addr_2_reg_864 <= tmp_32_cast_fu_516_p1;
        integral_image_addr_reg_854 <= col_cast_fu_490_p1;
        integral_image_sq_ad_1_reg_839 <= tmp_31_cast_fu_505_p1;
        integral_image_sq_ad_2_reg_844 <= tmp_32_cast_fu_516_p1;
        integral_image_sq_ad_reg_834 <= col_cast_fu_490_p1;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state13)) begin
        factor_1_reg_895 <= factor_1_fu_367_p1;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state21)) begin
        loc_V_1_reg_908 <= loc_V_1_fu_576_p1;
        loc_V_2_reg_913 <= {{p_Val2_4_fu_580_p1[ap_const_lv32_1E : ap_const_lv32_17]}};
        loc_V_3_reg_919 <= loc_V_3_fu_594_p1;
        loc_V_reg_902 <= {{p_Val2_s_fu_562_p1[ap_const_lv32_1E : ap_const_lv32_17]}};
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state4)) begin
        row_2_reg_815 <= row_2_fu_442_p2;
        tmp_17_reg_807[15 : 5] <= tmp_17_fu_426_p2[15 : 5];
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state4) & ~(exitcond1_fu_436_p2 == 1'b0))) begin
        tmp_1_reg_829 <= tmp_1_fu_370_p1;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state4) & (exitcond1_fu_436_p2 == 1'b0))) begin
        tmp_27_reg_824[15 : 5] <= tmp_27_fu_484_p2[15 : 5];
        tmp_3_reg_820 <= tmp_3_fu_448_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state12)) begin
        tmp_2_reg_890 <= grp_fu_374_p2;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state2) & (1'b0 == tmp_9_fu_391_p2))) begin
        ap_done = 1'b1;
    end else begin
        ap_done = 1'b0;
    end
end

always @ (*) begin
    if (((1'b0 == ap_start) & (ap_CS_fsm_state1 == 1'b1))) begin
        ap_idle = 1'b1;
    end else begin
        ap_idle = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state2) & (1'b0 == tmp_9_fu_391_p2))) begin
        ap_ready = 1'b1;
    end else begin
        ap_ready = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state12) | ((1'b1 == ap_CS_fsm_state8) & ~(1'b0 == grp_cascade_classifier_fu_282_ap_done)) | (1'b1 == ap_CS_fsm_state9) | (1'b1 == ap_CS_fsm_state10) | (1'b1 == ap_CS_fsm_state11))) begin
        grp_fu_374_ce = 1'b1;
    end else begin
        grp_fu_374_ce = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        image_address0 = tmp_32_cast_fu_516_p1;
    end else if ((1'b1 == ap_CS_fsm_state3)) begin
        image_address0 = grp_downscale_fu_346_dest_address0;
    end else begin
        image_address0 = 'bx;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state5)) begin
        image_ce0 = 1'b1;
    end else if ((1'b1 == ap_CS_fsm_state3)) begin
        image_ce0 = grp_downscale_fu_346_dest_ce0;
    end else begin
        image_ce0 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state3)) begin
        image_we0 = grp_downscale_fu_346_dest_we0;
    end else begin
        image_we0 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state7)) begin
        integral_image_address0 = integral_image_addr_2_reg_864;
    end else if (((1'b1 == ap_CS_fsm_state6) & ~(tmp_3_reg_820 == 1'b0))) begin
        integral_image_address0 = integral_image_addr_reg_854;
    end else if (((1'b1 == ap_CS_fsm_state6) & (tmp_3_reg_820 == 1'b0))) begin
        integral_image_address0 = integral_image_addr_1_reg_859;
    end else if ((1'b1 == ap_CS_fsm_state8)) begin
        integral_image_address0 = grp_cascade_classifier_fu_282_integral_image_address0;
    end else begin
        integral_image_address0 = 'bx;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state7) | ((1'b1 == ap_CS_fsm_state6) & (tmp_3_reg_820 == 1'b0)) | ((1'b1 == ap_CS_fsm_state6) & ~(tmp_3_reg_820 == 1'b0)))) begin
        integral_image_ce0 = 1'b1;
    end else if ((1'b1 == ap_CS_fsm_state8)) begin
        integral_image_ce0 = grp_cascade_classifier_fu_282_integral_image_ce0;
    end else begin
        integral_image_ce0 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state8)) begin
        integral_image_ce1 = grp_cascade_classifier_fu_282_integral_image_ce1;
    end else begin
        integral_image_ce1 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state7)) begin
        integral_image_d0 = tmp_7_fu_550_p2;
    end else if (((1'b1 == ap_CS_fsm_state6) & ~(tmp_3_reg_820 == 1'b0))) begin
        integral_image_d0 = accum_1_fu_543_p2;
    end else begin
        integral_image_d0 = 'bx;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state7) & ~(tmp_3_reg_820 == 1'b0))) begin
        integral_image_sq_address0 = integral_image_sq_ad_reg_834;
    end else if (((1'b1 == ap_CS_fsm_state7) & (tmp_3_reg_820 == 1'b0))) begin
        integral_image_sq_address0 = integral_image_sq_ad_2_reg_844;
    end else if ((1'b1 == ap_CS_fsm_state6)) begin
        integral_image_sq_address0 = integral_image_sq_ad_1_reg_839;
    end else if ((1'b1 == ap_CS_fsm_state8)) begin
        integral_image_sq_address0 = grp_cascade_classifier_fu_282_integral_image_sq_address0;
    end else begin
        integral_image_sq_address0 = 'bx;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state6) | ((1'b1 == ap_CS_fsm_state7) & (tmp_3_reg_820 == 1'b0)) | ((1'b1 == ap_CS_fsm_state7) & ~(tmp_3_reg_820 == 1'b0)))) begin
        integral_image_sq_ce0 = 1'b1;
    end else if ((1'b1 == ap_CS_fsm_state8)) begin
        integral_image_sq_ce0 = grp_cascade_classifier_fu_282_integral_image_sq_ce0;
    end else begin
        integral_image_sq_ce0 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state8)) begin
        integral_image_sq_ce1 = grp_cascade_classifier_fu_282_integral_image_sq_ce1;
    end else begin
        integral_image_sq_ce1 = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state7)) begin
        if (~(tmp_3_reg_820 == 1'b0)) begin
            integral_image_sq_d0 = accum_sq_1_reg_883;
        end else if ((tmp_3_reg_820 == 1'b0)) begin
            integral_image_sq_d0 = tmp_8_fu_556_p2;
        end else begin
            integral_image_sq_d0 = 'bx;
        end
    end else begin
        integral_image_sq_d0 = 'bx;
    end
end

always @ (*) begin
    if ((((1'b1 == ap_CS_fsm_state7) & (tmp_3_reg_820 == 1'b0)) | ((1'b1 == ap_CS_fsm_state7) & ~(tmp_3_reg_820 == 1'b0)))) begin
        integral_image_sq_we0 = 1'b1;
    end else begin
        integral_image_sq_we0 = 1'b0;
    end
end

always @ (*) begin
    if ((((1'b1 == ap_CS_fsm_state6) & ~(tmp_3_reg_820 == 1'b0)) | ((1'b1 == ap_CS_fsm_state7) & (tmp_3_reg_820 == 1'b0)))) begin
        integral_image_we0 = 1'b1;
    end else begin
        integral_image_we0 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state2) & (1'b0 == tmp_9_fu_391_p2))) begin
        success_ap_vld = 1'b1;
    end else begin
        success_ap_vld = 1'b0;
    end
end

always @ (*) begin
    case (ap_CS_fsm)
        ap_ST_fsm_state1 : begin
            if (~(ap_start == 1'b0)) begin
                ap_NS_fsm = ap_ST_fsm_state2;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end
        end
        ap_ST_fsm_state2 : begin
            if ((1'b0 == tmp_9_fu_391_p2)) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end
        end
        ap_ST_fsm_state3 : begin
            if (~(1'b0 == grp_downscale_fu_346_ap_done)) begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state3;
            end
        end
        ap_ST_fsm_state4 : begin
            if ((exitcond1_fu_436_p2 == 1'b0)) begin
                ap_NS_fsm = ap_ST_fsm_state5;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state8;
            end
        end
        ap_ST_fsm_state5 : begin
            if (~(1'b0 == exitcond_fu_523_p2)) begin
                ap_NS_fsm = ap_ST_fsm_state4;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state6;
            end
        end
        ap_ST_fsm_state6 : begin
            ap_NS_fsm = ap_ST_fsm_state7;
        end
        ap_ST_fsm_state7 : begin
            ap_NS_fsm = ap_ST_fsm_state5;
        end
        ap_ST_fsm_state8 : begin
            if (~(1'b0 == grp_cascade_classifier_fu_282_ap_done)) begin
                ap_NS_fsm = ap_ST_fsm_state9;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state8;
            end
        end
        ap_ST_fsm_state9 : begin
            ap_NS_fsm = ap_ST_fsm_state10;
        end
        ap_ST_fsm_state10 : begin
            ap_NS_fsm = ap_ST_fsm_state11;
        end
        ap_ST_fsm_state11 : begin
            ap_NS_fsm = ap_ST_fsm_state12;
        end
        ap_ST_fsm_state12 : begin
            ap_NS_fsm = ap_ST_fsm_state13;
        end
        ap_ST_fsm_state13 : begin
            ap_NS_fsm = ap_ST_fsm_state14;
        end
        ap_ST_fsm_state14 : begin
            ap_NS_fsm = ap_ST_fsm_state15;
        end
        ap_ST_fsm_state15 : begin
            ap_NS_fsm = ap_ST_fsm_state16;
        end
        ap_ST_fsm_state16 : begin
            ap_NS_fsm = ap_ST_fsm_state17;
        end
        ap_ST_fsm_state17 : begin
            ap_NS_fsm = ap_ST_fsm_state18;
        end
        ap_ST_fsm_state18 : begin
            ap_NS_fsm = ap_ST_fsm_state19;
        end
        ap_ST_fsm_state19 : begin
            ap_NS_fsm = ap_ST_fsm_state20;
        end
        ap_ST_fsm_state20 : begin
            ap_NS_fsm = ap_ST_fsm_state21;
        end
        ap_ST_fsm_state21 : begin
            ap_NS_fsm = ap_ST_fsm_state22;
        end
        ap_ST_fsm_state22 : begin
            ap_NS_fsm = ap_ST_fsm_state2;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign accum_1_fu_543_p2 = (tmp_5_fu_535_p1 + accum_reg_258);

assign ap_CS_fsm_state1 = ap_CS_fsm[ap_const_lv32_0];

assign ap_CS_fsm_state10 = ap_CS_fsm[ap_const_lv32_9];

assign ap_CS_fsm_state11 = ap_CS_fsm[ap_const_lv32_A];

assign ap_CS_fsm_state12 = ap_CS_fsm[ap_const_lv32_B];

assign ap_CS_fsm_state13 = ap_CS_fsm[ap_const_lv32_C];

assign ap_CS_fsm_state14 = ap_CS_fsm[ap_const_lv32_D];

assign ap_CS_fsm_state2 = ap_CS_fsm[ap_const_lv32_1];

assign ap_CS_fsm_state21 = ap_CS_fsm[ap_const_lv32_14];

assign ap_CS_fsm_state22 = ap_CS_fsm[ap_const_lv32_15];

assign ap_CS_fsm_state3 = ap_CS_fsm[ap_const_lv32_2];

assign ap_CS_fsm_state4 = ap_CS_fsm[ap_const_lv32_3];

assign ap_CS_fsm_state5 = ap_CS_fsm[ap_const_lv32_4];

assign ap_CS_fsm_state6 = ap_CS_fsm[ap_const_lv32_5];

assign ap_CS_fsm_state7 = ap_CS_fsm[ap_const_lv32_6];

assign ap_CS_fsm_state8 = ap_CS_fsm[ap_const_lv32_7];

assign ap_CS_fsm_state9 = ap_CS_fsm[ap_const_lv32_8];

assign col_2_fu_529_p2 = (col_reg_247 + ap_const_lv15_1);

assign col_cast_cast_fu_496_p1 = col_reg_247;

assign col_cast_fu_490_p1 = col_reg_247;

assign exitcond1_fu_436_p2 = ((row_reg_236 == curr_height_reg_224) ? 1'b1 : 1'b0);

assign exitcond_fu_523_p2 = ((col_cast_fu_490_p1 == curr_width_reg_212) ? 1'b1 : 1'b0);

assign grp_cascade_classifier_fu_282_ap_start = ap_reg_grp_cascade_classifier_fu_282_ap_start;

assign grp_downscale_fu_346_ap_start = ap_reg_grp_downscale_fu_346_ap_start;

assign grp_fu_796_p0 = tmp_16_cast_fu_539_p1;

assign grp_fu_796_p1 = tmp_16_cast_fu_539_p1;

assign isNeg_1_fu_717_p3 = sh_assign_2_fu_711_p2[ap_const_lv32_8];

assign isNeg_fu_618_p3 = sh_assign_fu_612_p2[ap_const_lv32_8];

assign loc_V_1_fu_576_p1 = p_Val2_s_fu_562_p1[22:0];

assign loc_V_3_fu_594_p1 = p_Val2_4_fu_580_p1[22:0];

assign orig_image_address0 = grp_downscale_fu_346_src_address0;

assign orig_image_ce0 = grp_downscale_fu_346_src_ce0;

assign p_Result_4_fu_697_p3 = {{1'b1}, {loc_V_3_reg_919}};

assign p_Result_s_fu_598_p3 = {{1'b1}, {loc_V_1_reg_908}};

assign p_Val2_4_fu_580_p1 = grp_fu_362_p2;

assign p_Val2_s_fu_562_p1 = grp_fu_357_p2;

assign p_shl1_cast_fu_418_p3 = {{tmp_20_fu_414_p1}, {ap_const_lv5_0}};

assign p_shl2_cast_fu_468_p1 = tmp_25_fu_460_p3;

assign p_shl3_cast_fu_480_p1 = tmp_26_fu_472_p3;

assign p_shl_cast_fu_406_p3 = {{tmp_18_fu_402_p1}, {ap_const_lv7_0}};

assign result_V_1_fu_788_p3 = ((isNeg_1_fu_717_p3[0:0] === 1'b1) ? tmp_22_fu_774_p1 : tmp_24_fu_778_p4);

assign result_V_fu_689_p3 = ((isNeg_fu_618_p3[0:0] === 1'b1) ? tmp_19_fu_675_p1 : tmp_21_fu_679_p4);

assign row_2_fu_442_p2 = (ap_const_lv32_1 + row_reg_236);

assign sh_assign_1_cast_cas_fu_647_p1 = $signed(sh_assign_1_fu_635_p3);

assign sh_assign_1_cast_fu_643_p1 = $signed(sh_assign_1_fu_635_p3);

assign sh_assign_1_fu_635_p3 = ((isNeg_fu_618_p3[0:0] === 1'b1) ? tmp_4_i_i_cast_fu_631_p1 : sh_assign_fu_612_p2);

assign sh_assign_2_fu_711_p2 = ($signed(ap_const_lv9_181) + $signed(tmp_i_i_i6_cast1_fu_708_p1));

assign sh_assign_3_cast_cas_fu_746_p1 = $signed(sh_assign_3_fu_734_p3);

assign sh_assign_3_cast_fu_742_p1 = $signed(sh_assign_3_fu_734_p3);

assign sh_assign_3_fu_734_p3 = ((isNeg_1_fu_717_p3[0:0] === 1'b1) ? tmp_4_i_i9_cast_fu_730_p1 : sh_assign_2_fu_711_p2);

assign sh_assign_fu_612_p2 = ($signed(ap_const_lv9_181) + $signed(tmp_i_i_i_cast2_fu_609_p1));

assign success = alr_found;

assign tmp_16_cast_fu_539_p1 = image_q0;

assign tmp_17_fu_426_p2 = (p_shl1_cast_fu_418_p3 + p_shl_cast_fu_406_p3);

assign tmp_18_fu_402_p1 = row_reg_236[8:0];

assign tmp_19_fu_675_p1 = tmp_33_fu_667_p3;

assign tmp_20_fu_414_p1 = row_reg_236[10:0];

assign tmp_21_fu_679_p4 = {{tmp_9_i_i_fu_661_p2[ap_const_lv32_36 : ap_const_lv32_17]}};

assign tmp_22_fu_774_p1 = tmp_36_fu_766_p3;

assign tmp_23_fu_432_p1 = row_reg_236[7:0];

assign tmp_24_fu_778_p4 = {{tmp_9_i_i1_fu_760_p2[ap_const_lv32_36 : ap_const_lv32_17]}};

assign tmp_25_fu_460_p3 = {{tmp_4_fu_454_p2}, {ap_const_lv7_0}};

assign tmp_26_fu_472_p3 = {{tmp_4_fu_454_p2}, {ap_const_lv5_0}};

assign tmp_27_fu_484_p2 = (p_shl3_cast_fu_480_p1 + p_shl2_cast_fu_468_p1);

assign tmp_28_fu_500_p2 = (tmp_27_reg_824 + col_cast_cast_fu_496_p1);

assign tmp_29_fu_511_p2 = (tmp_17_reg_807 + col_cast_cast_fu_496_p1);

assign tmp_2_i_i5_fu_704_p1 = p_Result_4_fu_697_p3;

assign tmp_2_i_i_fu_605_p1 = p_Result_s_fu_598_p3;

assign tmp_31_cast_fu_505_p1 = tmp_28_fu_500_p2;

assign tmp_32_cast_fu_516_p1 = tmp_29_fu_511_p2;

assign tmp_33_fu_667_p3 = tmp_7_i_i_fu_655_p2[ap_const_lv32_17];

assign tmp_36_fu_766_p3 = tmp_7_i_i1_fu_754_p2[ap_const_lv32_17];

assign tmp_3_fu_448_p2 = ((row_reg_236 == ap_const_lv32_0) ? 1'b1 : 1'b0);

assign tmp_4_fu_454_p2 = ($signed(tmp_23_fu_432_p1) + $signed(ap_const_lv8_FF));

assign tmp_4_i_i9_cast_fu_730_p1 = $signed(tmp_4_i_i9_fu_725_p2);

assign tmp_4_i_i9_fu_725_p2 = (ap_const_lv8_7F - loc_V_2_reg_913);

assign tmp_4_i_i_cast_fu_631_p1 = $signed(tmp_4_i_i_fu_626_p2);

assign tmp_4_i_i_fu_626_p2 = (ap_const_lv8_7F - loc_V_reg_902);

assign tmp_5_fu_535_p1 = image_q0;

assign tmp_6_i_i1_fu_750_p1 = $unsigned(sh_assign_3_cast_fu_742_p1);

assign tmp_6_i_i_fu_651_p1 = $unsigned(sh_assign_1_cast_fu_643_p1);

assign tmp_7_fu_550_p2 = (integral_image_q0 + accum_1_reg_877);

assign tmp_7_i_i1_fu_754_p2 = p_Result_4_fu_697_p3 >> sh_assign_3_cast_cas_fu_746_p1;

assign tmp_7_i_i_fu_655_p2 = p_Result_s_fu_598_p3 >> sh_assign_1_cast_cas_fu_647_p1;

assign tmp_8_fu_556_p2 = (integral_image_sq_q0 + accum_sq_1_reg_883);

assign tmp_9_fu_391_p2 = (tmp_fu_379_p2 & tmp_s_fu_385_p2);

assign tmp_9_i_i1_fu_760_p2 = tmp_2_i_i5_fu_704_p1 << tmp_6_i_i1_fu_750_p1;

assign tmp_9_i_i_fu_661_p2 = tmp_2_i_i_fu_605_p1 << tmp_6_i_i_fu_651_p1;

assign tmp_fu_379_p2 = ((curr_height_reg_224 > ap_const_lv32_17) ? 1'b1 : 1'b0);

assign tmp_i_i_i6_cast1_fu_708_p1 = loc_V_2_reg_913;

assign tmp_i_i_i_cast2_fu_609_p1 = loc_V_reg_902;

assign tmp_s_fu_385_p2 = ((curr_width_reg_212 > ap_const_lv32_17) ? 1'b1 : 1'b0);

always @ (posedge ap_clk) begin
    tmp_17_reg_807[4:0] <= 5'b00000;
    tmp_27_reg_824[4:0] <= 5'b00000;
end

endmodule //detect_face
