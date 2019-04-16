// ==============================================================
// RTL generated by Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC
// Version: 2016.4
// Copyright (C) 1986-2017 Xilinx, Inc. All Rights Reserved.
// 
// ===========================================================

`timescale 1 ns / 1 ps 

module downscale (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        src_address0,
        src_ce0,
        src_q0,
        dest_address0,
        dest_ce0,
        dest_we0,
        dest_d0,
        height,
        width
);

parameter    ap_ST_fsm_state1 = 32'b1;
parameter    ap_ST_fsm_state2 = 32'b10;
parameter    ap_ST_fsm_state3 = 32'b100;
parameter    ap_ST_fsm_state4 = 32'b1000;
parameter    ap_ST_fsm_state5 = 32'b10000;
parameter    ap_ST_fsm_state6 = 32'b100000;
parameter    ap_ST_fsm_state7 = 32'b1000000;
parameter    ap_ST_fsm_state8 = 32'b10000000;
parameter    ap_ST_fsm_state9 = 32'b100000000;
parameter    ap_ST_fsm_state10 = 32'b1000000000;
parameter    ap_ST_fsm_state11 = 32'b10000000000;
parameter    ap_ST_fsm_state12 = 32'b100000000000;
parameter    ap_ST_fsm_state13 = 32'b1000000000000;
parameter    ap_ST_fsm_state14 = 32'b10000000000000;
parameter    ap_ST_fsm_state15 = 32'b100000000000000;
parameter    ap_ST_fsm_state16 = 32'b1000000000000000;
parameter    ap_ST_fsm_state17 = 32'b10000000000000000;
parameter    ap_ST_fsm_state18 = 32'b100000000000000000;
parameter    ap_ST_fsm_state19 = 32'b1000000000000000000;
parameter    ap_ST_fsm_state20 = 32'b10000000000000000000;
parameter    ap_ST_fsm_state21 = 32'b100000000000000000000;
parameter    ap_ST_fsm_state22 = 32'b1000000000000000000000;
parameter    ap_ST_fsm_state23 = 32'b10000000000000000000000;
parameter    ap_ST_fsm_state24 = 32'b100000000000000000000000;
parameter    ap_ST_fsm_state25 = 32'b1000000000000000000000000;
parameter    ap_ST_fsm_state26 = 32'b10000000000000000000000000;
parameter    ap_ST_fsm_state27 = 32'b100000000000000000000000000;
parameter    ap_ST_fsm_state28 = 32'b1000000000000000000000000000;
parameter    ap_ST_fsm_state29 = 32'b10000000000000000000000000000;
parameter    ap_ST_fsm_state30 = 32'b100000000000000000000000000000;
parameter    ap_ST_fsm_state31 = 32'b1000000000000000000000000000000;
parameter    ap_ST_fsm_state32 = 32'b10000000000000000000000000000000;
parameter    ap_const_lv32_0 = 32'b00000000000000000000000000000000;
parameter    ap_const_lv32_1 = 32'b1;
parameter    ap_const_lv32_1C = 32'b11100;
parameter    ap_const_lv32_1D = 32'b11101;
parameter    ap_const_lv32_1E = 32'b11110;
parameter    ap_const_lv7_0 = 7'b0000000;
parameter    ap_const_lv32_1F = 32'b11111;
parameter    ap_const_lv8_0 = 8'b00000000;
parameter    ap_const_lv25_0 = 25'b0000000000000000000000000;
parameter    ap_const_lv32_A00000 = 32'b101000000000000000000000;
parameter    ap_const_lv32_780000 = 32'b11110000000000000000000;
parameter    ap_const_lv25_1 = 25'b1;
parameter    ap_const_lv24_1 = 24'b1;
parameter    ap_const_lv5_0 = 5'b00000;
parameter    ap_const_lv7_78 = 7'b1111000;
parameter    ap_const_lv7_1 = 7'b1;
parameter    ap_const_lv32_10 = 32'b10000;
parameter    ap_const_lv32_17 = 32'b10111;
parameter    ap_const_lv8_A0 = 8'b10100000;
parameter    ap_const_lv8_1 = 8'b1;
parameter    ap_const_lv32_18 = 32'b11000;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
output  [14:0] src_address0;
output   src_ce0;
input  [7:0] src_q0;
output  [14:0] dest_address0;
output   dest_ce0;
output   dest_we0;
output  [7:0] dest_d0;
input  [31:0] height;
input  [31:0] width;

reg ap_done;
reg ap_idle;
reg ap_ready;
reg src_ce0;
reg dest_ce0;
reg dest_we0;

(* fsm_encoding = "none" *) reg   [31:0] ap_CS_fsm;
wire   [0:0] ap_CS_fsm_state1;
wire   [0:0] ap_CS_fsm_state2;
wire   [24:0] x_ratio_fu_145_p2;
reg   [24:0] x_ratio_reg_342;
wire   [0:0] ap_CS_fsm_state29;
(* use_dsp48 = "no" *) wire  signed [23:0] y_ratio_fu_155_p2;
reg  signed [23:0] y_ratio_reg_347;
wire   [14:0] tmp_11_fu_193_p2;
reg   [14:0] tmp_11_reg_352;
wire   [0:0] ap_CS_fsm_state30;
wire   [6:0] row_1_fu_205_p2;
reg   [6:0] row_1_reg_360;
wire   [0:0] tmp_2_fu_211_p2;
reg   [0:0] tmp_2_reg_365;
wire   [0:0] tmp_1_fu_199_p2;
wire   [15:0] tmp_14_fu_249_p2;
reg   [15:0] tmp_14_reg_370;
reg   [14:0] dest_addr_reg_375;
wire   [0:0] ap_CS_fsm_state31;
wire   [7:0] col_1_fu_279_p2;
reg   [7:0] col_1_reg_383;
wire   [0:0] or_cond_fu_290_p2;
reg   [0:0] or_cond_reg_388;
wire   [0:0] tmp_5_fu_273_p2;
wire   [24:0] next_mul_fu_295_p2;
reg   [24:0] next_mul_reg_392;
reg   [6:0] row_reg_96;
reg   [7:0] col_reg_107;
wire   [0:0] ap_CS_fsm_state32;
reg   [24:0] phi_mul_reg_118;
wire   [31:0] tmp_15_cast_fu_268_p1;
wire   [31:0] tmp_16_cast_fu_319_p1;
wire   [24:0] grp_fu_129_p0;
wire   [23:0] grp_fu_135_p0;
wire   [24:0] grp_fu_129_p2;
wire   [24:0] tmp_7_fu_141_p1;
wire   [23:0] grp_fu_135_p2;
wire   [23:0] tmp_8_fu_151_p1;
wire   [13:0] tmp_9_fu_169_p3;
wire   [11:0] tmp_10_fu_181_p3;
wire   [14:0] p_shl1_cast_fu_189_p1;
wire   [14:0] p_shl_cast_fu_177_p1;
wire   [31:0] row_cast3_fu_165_p1;
wire  signed [23:0] tmp_3_fu_324_p2;
wire   [7:0] tmp_4_fu_216_p4;
wire   [14:0] tmp_12_fu_225_p3;
wire   [12:0] tmp_13_fu_237_p3;
wire   [15:0] p_shl3_cast_fu_245_p1;
wire   [15:0] p_shl2_cast_fu_233_p1;
wire   [14:0] col_cast1_cast_fu_259_p1;
wire   [14:0] tmp_15_fu_263_p2;
wire   [31:0] col_cast1_fu_255_p1;
wire   [0:0] tmp_6_fu_285_p2;
wire   [8:0] tmp_17_fu_300_p4;
wire   [15:0] tmp_8_cast_cast_fu_310_p1;
wire   [15:0] tmp_16_fu_314_p2;
wire   [6:0] tmp_3_fu_324_p1;
reg    grp_fu_129_ap_start;
wire    grp_fu_129_ap_done;
reg    grp_fu_135_ap_start;
wire    grp_fu_135_ap_done;
reg   [31:0] ap_NS_fsm;
wire   [23:0] tmp_3_fu_324_p10;

// power-on initialization
initial begin
#0 ap_CS_fsm = 32'b1;
end

detect_face_udiv_bkb #(
    .ID( 1 ),
    .NUM_STAGE( 29 ),
    .din0_WIDTH( 25 ),
    .din1_WIDTH( 32 ),
    .dout_WIDTH( 25 ))
detect_face_udiv_bkb_U0(
    .clk(ap_clk),
    .reset(ap_rst),
    .start(grp_fu_129_ap_start),
    .done(grp_fu_129_ap_done),
    .din0(grp_fu_129_p0),
    .din1(width),
    .ce(1'b1),
    .dout(grp_fu_129_p2)
);

detect_face_udiv_cud #(
    .ID( 1 ),
    .NUM_STAGE( 28 ),
    .din0_WIDTH( 24 ),
    .din1_WIDTH( 32 ),
    .dout_WIDTH( 24 ))
detect_face_udiv_cud_U1(
    .clk(ap_clk),
    .reset(ap_rst),
    .start(grp_fu_135_ap_start),
    .done(grp_fu_135_ap_done),
    .din0(grp_fu_135_p0),
    .din1(height),
    .ce(1'b1),
    .dout(grp_fu_135_p2)
);

detect_face_mul_mdEe #(
    .ID( 1 ),
    .NUM_STAGE( 1 ),
    .din0_WIDTH( 24 ),
    .din1_WIDTH( 7 ),
    .dout_WIDTH( 24 ))
detect_face_mul_mdEe_U2(
    .din0(y_ratio_reg_347),
    .din1(tmp_3_fu_324_p1),
    .dout(tmp_3_fu_324_p2)
);

always @ (posedge ap_clk) begin
    if (ap_rst == 1'b1) begin
        ap_CS_fsm <= ap_ST_fsm_state1;
    end else begin
        ap_CS_fsm <= ap_NS_fsm;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state30) & (tmp_1_fu_199_p2 == 1'b0))) begin
        col_reg_107 <= ap_const_lv8_0;
    end else if ((1'b1 == ap_CS_fsm_state32)) begin
        col_reg_107 <= col_1_reg_383;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state30) & (tmp_1_fu_199_p2 == 1'b0))) begin
        phi_mul_reg_118 <= ap_const_lv25_0;
    end else if ((1'b1 == ap_CS_fsm_state32)) begin
        phi_mul_reg_118 <= next_mul_reg_392;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state31) & ~(1'b0 == tmp_5_fu_273_p2))) begin
        row_reg_96 <= row_1_reg_360;
    end else if ((1'b1 == ap_CS_fsm_state29)) begin
        row_reg_96 <= ap_const_lv7_0;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state31)) begin
        col_1_reg_383 <= col_1_fu_279_p2;
        dest_addr_reg_375 <= tmp_15_cast_fu_268_p1;
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state31) & (1'b0 == tmp_5_fu_273_p2))) begin
        next_mul_reg_392 <= next_mul_fu_295_p2;
        or_cond_reg_388 <= or_cond_fu_290_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state30)) begin
        row_1_reg_360 <= row_1_fu_205_p2;
        tmp_11_reg_352[14 : 5] <= tmp_11_fu_193_p2[14 : 5];
    end
end

always @ (posedge ap_clk) begin
    if (((1'b1 == ap_CS_fsm_state30) & (tmp_1_fu_199_p2 == 1'b0))) begin
        tmp_14_reg_370[15 : 5] <= tmp_14_fu_249_p2[15 : 5];
        tmp_2_reg_365 <= tmp_2_fu_211_p2;
    end
end

always @ (posedge ap_clk) begin
    if ((1'b1 == ap_CS_fsm_state29)) begin
        x_ratio_reg_342 <= x_ratio_fu_145_p2;
        y_ratio_reg_347 <= y_ratio_fu_155_p2;
    end
end

always @ (*) begin
    if ((((1'b0 == ap_start) & (ap_CS_fsm_state1 == 1'b1)) | ((1'b1 == ap_CS_fsm_state30) & ~(tmp_1_fu_199_p2 == 1'b0)))) begin
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
    if (((1'b1 == ap_CS_fsm_state30) & ~(tmp_1_fu_199_p2 == 1'b0))) begin
        ap_ready = 1'b1;
    end else begin
        ap_ready = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state32)) begin
        dest_ce0 = 1'b1;
    end else begin
        dest_ce0 = 1'b0;
    end
end

always @ (*) begin
    if (((1'b1 == ap_CS_fsm_state32) & ~(1'b0 == or_cond_reg_388))) begin
        dest_we0 = 1'b1;
    end else begin
        dest_we0 = 1'b0;
    end
end

always @ (*) begin
    if (((ap_CS_fsm_state1 == 1'b1) & ~(ap_start == 1'b0))) begin
        grp_fu_129_ap_start = 1'b1;
    end else begin
        grp_fu_129_ap_start = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state2)) begin
        grp_fu_135_ap_start = 1'b1;
    end else begin
        grp_fu_135_ap_start = 1'b0;
    end
end

always @ (*) begin
    if ((1'b1 == ap_CS_fsm_state31)) begin
        src_ce0 = 1'b1;
    end else begin
        src_ce0 = 1'b0;
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
            ap_NS_fsm = ap_ST_fsm_state3;
        end
        ap_ST_fsm_state3 : begin
            ap_NS_fsm = ap_ST_fsm_state4;
        end
        ap_ST_fsm_state4 : begin
            ap_NS_fsm = ap_ST_fsm_state5;
        end
        ap_ST_fsm_state5 : begin
            ap_NS_fsm = ap_ST_fsm_state6;
        end
        ap_ST_fsm_state6 : begin
            ap_NS_fsm = ap_ST_fsm_state7;
        end
        ap_ST_fsm_state7 : begin
            ap_NS_fsm = ap_ST_fsm_state8;
        end
        ap_ST_fsm_state8 : begin
            ap_NS_fsm = ap_ST_fsm_state9;
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
            ap_NS_fsm = ap_ST_fsm_state23;
        end
        ap_ST_fsm_state23 : begin
            ap_NS_fsm = ap_ST_fsm_state24;
        end
        ap_ST_fsm_state24 : begin
            ap_NS_fsm = ap_ST_fsm_state25;
        end
        ap_ST_fsm_state25 : begin
            ap_NS_fsm = ap_ST_fsm_state26;
        end
        ap_ST_fsm_state26 : begin
            ap_NS_fsm = ap_ST_fsm_state27;
        end
        ap_ST_fsm_state27 : begin
            ap_NS_fsm = ap_ST_fsm_state28;
        end
        ap_ST_fsm_state28 : begin
            ap_NS_fsm = ap_ST_fsm_state29;
        end
        ap_ST_fsm_state29 : begin
            ap_NS_fsm = ap_ST_fsm_state30;
        end
        ap_ST_fsm_state30 : begin
            if (~(tmp_1_fu_199_p2 == 1'b0)) begin
                ap_NS_fsm = ap_ST_fsm_state1;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state31;
            end
        end
        ap_ST_fsm_state31 : begin
            if (~(1'b0 == tmp_5_fu_273_p2)) begin
                ap_NS_fsm = ap_ST_fsm_state30;
            end else begin
                ap_NS_fsm = ap_ST_fsm_state32;
            end
        end
        ap_ST_fsm_state32 : begin
            ap_NS_fsm = ap_ST_fsm_state31;
        end
        default : begin
            ap_NS_fsm = 'bx;
        end
    endcase
end

assign ap_CS_fsm_state1 = ap_CS_fsm[ap_const_lv32_0];

assign ap_CS_fsm_state2 = ap_CS_fsm[ap_const_lv32_1];

assign ap_CS_fsm_state29 = ap_CS_fsm[ap_const_lv32_1C];

assign ap_CS_fsm_state30 = ap_CS_fsm[ap_const_lv32_1D];

assign ap_CS_fsm_state31 = ap_CS_fsm[ap_const_lv32_1E];

assign ap_CS_fsm_state32 = ap_CS_fsm[ap_const_lv32_1F];

assign col_1_fu_279_p2 = (col_reg_107 + ap_const_lv8_1);

assign col_cast1_cast_fu_259_p1 = col_reg_107;

assign col_cast1_fu_255_p1 = col_reg_107;

assign dest_address0 = dest_addr_reg_375;

assign dest_d0 = src_q0;

assign grp_fu_129_p0 = ap_const_lv32_A00000;

assign grp_fu_135_p0 = ap_const_lv32_780000;

assign next_mul_fu_295_p2 = (phi_mul_reg_118 + x_ratio_reg_342);

assign or_cond_fu_290_p2 = (tmp_2_reg_365 & tmp_6_fu_285_p2);

assign p_shl1_cast_fu_189_p1 = tmp_10_fu_181_p3;

assign p_shl2_cast_fu_233_p1 = tmp_12_fu_225_p3;

assign p_shl3_cast_fu_245_p1 = tmp_13_fu_237_p3;

assign p_shl_cast_fu_177_p1 = tmp_9_fu_169_p3;

assign row_1_fu_205_p2 = (row_reg_96 + ap_const_lv7_1);

assign row_cast3_fu_165_p1 = row_reg_96;

assign src_address0 = tmp_16_cast_fu_319_p1;

assign tmp_10_fu_181_p3 = {{row_reg_96}, {ap_const_lv5_0}};

assign tmp_11_fu_193_p2 = (p_shl1_cast_fu_189_p1 + p_shl_cast_fu_177_p1);

assign tmp_12_fu_225_p3 = {{tmp_4_fu_216_p4}, {ap_const_lv7_0}};

assign tmp_13_fu_237_p3 = {{tmp_4_fu_216_p4}, {ap_const_lv5_0}};

assign tmp_14_fu_249_p2 = (p_shl3_cast_fu_245_p1 + p_shl2_cast_fu_233_p1);

assign tmp_15_cast_fu_268_p1 = tmp_15_fu_263_p2;

assign tmp_15_fu_263_p2 = (tmp_11_reg_352 + col_cast1_cast_fu_259_p1);

assign tmp_16_cast_fu_319_p1 = tmp_16_fu_314_p2;

assign tmp_16_fu_314_p2 = (tmp_8_cast_cast_fu_310_p1 + tmp_14_reg_370);

assign tmp_17_fu_300_p4 = {{phi_mul_reg_118[ap_const_lv32_18 : ap_const_lv32_10]}};

assign tmp_1_fu_199_p2 = ((row_reg_96 == ap_const_lv7_78) ? 1'b1 : 1'b0);

assign tmp_2_fu_211_p2 = ((row_cast3_fu_165_p1 < height) ? 1'b1 : 1'b0);

assign tmp_3_fu_324_p1 = tmp_3_fu_324_p10;

assign tmp_3_fu_324_p10 = row_reg_96;

assign tmp_4_fu_216_p4 = {{tmp_3_fu_324_p2[ap_const_lv32_17 : ap_const_lv32_10]}};

assign tmp_5_fu_273_p2 = ((col_reg_107 == ap_const_lv8_A0) ? 1'b1 : 1'b0);

assign tmp_6_fu_285_p2 = ((col_cast1_fu_255_p1 < width) ? 1'b1 : 1'b0);

assign tmp_7_fu_141_p1 = grp_fu_129_p2[24:0];

assign tmp_8_cast_cast_fu_310_p1 = tmp_17_fu_300_p4;

assign tmp_8_fu_151_p1 = grp_fu_135_p2[23:0];

assign tmp_9_fu_169_p3 = {{row_reg_96}, {ap_const_lv7_0}};

assign x_ratio_fu_145_p2 = (ap_const_lv25_1 + tmp_7_fu_141_p1);

assign y_ratio_fu_155_p2 = (ap_const_lv24_1 + tmp_8_fu_151_p1);

always @ (posedge ap_clk) begin
    tmp_11_reg_352[4:0] <= 5'b00000;
    tmp_14_reg_370[4:0] <= 5'b00000;
end

endmodule //downscale
