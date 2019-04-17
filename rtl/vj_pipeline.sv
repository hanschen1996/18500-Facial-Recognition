`default_nettype none
`include "vj_weights.vh"

module vj_pipeline(
  input  logic clock, reset, vj_pipeline_on,
  input  logic [`WINDOW_SIZE:0][`WINDOW_SIZE:0][17:0] scan_win,
  input  logic [31:0] input_std_dev,
  input  logic [1:0][31:0] scan_win_index,
  input  logic [3:0] img_index,
  output logic next_scan_win,
  output logic [1:0][31:0] top_left,
  output logic [3:0] pyramid_number,
  output logic top_left_ready,
  output logic [31:0] accum);

  logic [11:0] curr_feature, next_curr_feature;
  logic [`WINDOW_SIZE:0][`WINDOW_SIZE:0][17:0] curr_scan_win;
  logic is_stage_end_prev_x4, stage_comp, vjp_on_prev;
  logic [1:0][31:0] win_idx_prev;
  logic [3:0] img_idx_prev;

  logic [4:0] rect1_x1, rect1_x2, rect1_y1, rect1_y2, rect2_x1, rect2_x2, 
              rect2_y1, rect2_y2, rect3_x1, rect3_x2, rect3_y1, rect3_y2;
  logic [31:0] rect1_wt, rect2_wt, rect3_wt, feat_above, feat_below, feat_thres,
               stage_thres, std_dev_prev;
  logic is_stage_end;

  blk_mem_gen_r1x1  r0(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(5'd0), .douta(rect1_x1));
  blk_mem_gen_r1y1  r1(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(5'd0), .douta(rect1_y1));
  blk_mem_gen_r1x2  r2(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(5'd0), .douta(rect1_x2));
  blk_mem_gen_r1y2  r3(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(5'd0), .douta(rect1_y2));
  blk_mem_gen_r2x1  r4(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(5'd0), .douta(rect2_x1));
  blk_mem_gen_r2y1  r5(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(5'd0), .douta(rect2_y1));
  blk_mem_gen_r2x2  r6(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(5'd0), .douta(rect2_x2));
  blk_mem_gen_r2y2  r7(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(5'd0), .douta(rect2_y2));
  blk_mem_gen_r3x1  r8(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(5'd0), .douta(rect3_x1));
  blk_mem_gen_r3y1  r9(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(5'd0), .douta(rect3_y1));
  blk_mem_gen_r3x2 r10(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(5'd0), .douta(rect3_x2));
  blk_mem_gen_r3y2 r11(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(5'd0), .douta(rect3_y2));
  blk_mem_gen_r1w  r12(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(32'd0), .douta(rect1_wt));
  blk_mem_gen_r2w  r13(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(32'd0), .douta(rect2_wt));
  blk_mem_gen_r3w  r14(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(32'd0), .douta(rect3_wt));
  blk_mem_gen_fa   r15(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(32'd0), .douta(feat_above));
  blk_mem_gen_fb   r16(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(32'd0), .douta(feat_below));
  blk_mem_gen_ft   r17(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(32'd0), .douta(feat_thres));
  blk_mem_gen_st   r18(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(32'd0), .douta(stage_thres));
  blk_mem_gen_ise  r19(.clka(clock), .wea(1'b0), .addra(next_curr_feature), .dina(1'b0),  .douta(is_stage_end));

  always_comb begin
    next_scan_win = 1'd0;
    next_curr_feature = 12'd0;
    if ((curr_feature == 12'd`NUM_FEATURE - 12'd1) | (is_stage_end_prev_x4 & ~stage_comp) | (~vjp_on_prev & vj_pipeline_on))
      next_scan_win = 1'd1;
    if (~reset && ~next_scan_win) next_curr_feature = curr_feature + 12'd1;
  end

  always_ff @(posedge clock, posedge reset) begin
    vjp_on_prev <= vj_pipeline_on;
    if (reset) begin
      win_idx_prev <= 'd0;
      img_idx_prev <= 4'd0;
      curr_scan_win <= 'd0;
      curr_feature <= 12'd0;
      std_dev_prev <= 32'd0;
    end else begin
      curr_feature <= next_curr_feature;
      if (next_scan_win && vj_pipeline_on) begin
        win_idx_prev <= scan_win_index;
        img_idx_prev <= img_index;
        curr_scan_win <= scan_win;
        std_dev_prev <= input_std_dev;
      end else if (next_scan_win && ~vj_pipeline_on) begin
        win_idx_prev <= 'd0;
        img_idx_prev <= 'd0;
        curr_scan_win <= 'd0;
        std_dev_prev <= 32'd0;
      end
    end
  end



  logic [31:0] rect1_val, rect2_val, rect3_val, rect1_val_prev, rect2_val_prev, rect3_val_prev;
  logic [31:0] rect1_wt_prev, rect2_wt_prev, rect3_wt_prev, feat_above_prev, 
               feat_below_prev, feat_thres_prev, std_dev_prev_x2, stage_thres_prev;
  logic [11:0] curr_feature_prev;
  logic is_stage_end_prev;

  calc_rect_vals stage1_r(.scan_win(curr_scan_win), .rect1_x1, .rect1_x2, 
                          .rect1_y1, .rect1_y2, .rect2_x1, .rect2_x2, .rect2_y1, 
                          .rect2_y2, .rect3_x1, .rect3_x2, .rect3_y1, .rect3_y2,
                          .rect1_val, .rect2_val, .rect3_val);

  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      rect1_val_prev <= 5'd0;
      rect2_val_prev <= 5'd0;
      rect3_val_prev <= 5'd0;
      rect1_wt_prev <= 32'd0;
      rect2_wt_prev <= 32'd0;
      rect3_wt_prev <= 32'd0;
      feat_above_prev <= 32'd0;
      feat_below_prev <= 32'd0;
      feat_thres_prev <= 32'd0;
      std_dev_prev_x2 <= 32'd0;
      is_stage_end_prev <= 1'd0;
      stage_thres_prev <= 32'd0;
      curr_feature_prev <= 12'd0;
    end else begin
      rect1_val_prev <= rect1_val;
      rect2_val_prev <= rect2_val;
      rect3_val_prev <= rect3_val;
      rect1_wt_prev <= rect1_wt;
      rect2_wt_prev <= rect2_wt;
      rect3_wt_prev <= rect3_wt;
      feat_above_prev <= feat_above;
      feat_below_prev <= feat_below;
      feat_thres_prev <= feat_thres;
      std_dev_prev_x2 <= std_dev_prev;
      is_stage_end_prev <= is_stage_end;
      stage_thres_prev <= stage_thres;
      curr_feature_prev <= curr_feature;
    end
  end

  logic [31:0] rect1_prod_prev, rect2_prod_prev, rect3_prod_prev, feat_prod_prev,
               feat_above_prev_x2, feat_below_prev_x2, stage_thres_prev_x2;
  logic [11:0] curr_feature_prev_x2;
  logic is_stage_end_prev_x2;

  mult_gen_1 stage2_m1(.P(rect1_prod_prev), .A(rect1_wt_prev), .B(rect1_val_prev), .CLK(clock));
  mult_gen_1 stage2_m2(.P(rect2_prod_prev), .A(rect2_wt_prev), .B(rect2_val_prev), .CLK(clock));
  mult_gen_1 stage2_m3(.P(rect3_prod_prev), .A(rect3_wt_prev), .B(rect3_val_prev), .CLK(clock));
  mult_gen_1 stage2_m4(.P(feat_prod_prev), .A(std_dev_prev_x2), .B(feat_thres_prev), .CLK(clock));

  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      feat_above_prev_x2 <= 32'd0;
      feat_below_prev_x2 <= 32'd0;
      stage_thres_prev_x2 <= 32'd0;
      is_stage_end_prev_x2 <= 1'd0;
      curr_feature_prev_x2 <= 12'd0;
    end else begin
      feat_above_prev_x2 <= feat_above_prev;
      feat_below_prev_x2 <= feat_below_prev;
      stage_thres_prev_x2 <= stage_thres_prev;
      is_stage_end_prev_x2 <= is_stage_end_prev;
      curr_feature_prev_x2 <= curr_feature_prev;
    end
  end

  logic [31:0] feat_sum, feat_accum, feat_accum_prev, stage_thres_prev_x3;
  logic [11:0] curr_feature_prev_x3;
  logic feat_comp, is_stage_end_prev_x3;

  assign feat_sum = rect1_prod_prev + rect2_prod_prev + rect3_prod_prev;
  signed_comparator stage3_c(.gt(feat_comp), .A(feat_sum), .B(feat_prod_prev));
  assign feat_accum = (curr_feature < 12'd2) ? 32'd0 : (feat_comp) ? feat_above_prev_x2 : feat_below_prev_x2;

  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      feat_accum_prev <= 32'd0;
      stage_thres_prev_x3 <= 32'd0;
      is_stage_end_prev_x3 <= 1'd0;
      curr_feature_prev_x3 <= 32'd0;
    end else begin
      feat_accum_prev <= feat_accum;
      stage_thres_prev_x3 <= stage_thres_prev_x2;
      is_stage_end_prev_x3 <= is_stage_end_prev_x2;
      curr_feature_prev_x3 <= curr_feature_prev_x2;
    end
  end

  logic [31:0] stage_accum_prev, stage_thres_prev_x4, final_stage_accum;
  logic [11:0] curr_feature_prev_x4;

  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      stage_accum_prev <= 32'd0;
      final_stage_accum <= 32'd0;
      stage_thres_prev_x4 <= 32'd0;
      curr_feature_prev_x4 <= 12'd0;
      is_stage_end_prev_x4 <= 1'd0;
    end else begin
      stage_accum_prev <= (is_stage_end_prev_x3) ? 32'd0 : stage_accum_prev + feat_accum_prev;
      final_stage_accum <= (is_stage_end_prev_x3) ? stage_accum_prev + feat_accum_prev : 32'd0;
      stage_thres_prev_x4 <= stage_thres_prev_x3;
      curr_feature_prev_x4 <= curr_feature_prev_x3;
      is_stage_end_prev_x4 <= is_stage_end_prev_x3;
    end
  end

  logic is_face;

  assign is_face = (curr_feature_prev_x4 == 12'd`NUM_FEATURE - 12'd1) & stage_comp;
  signed_comparator stage5_c(.gt(stage_comp), .A(final_stage_accum), .B(stage_thres_prev_x4));

  logic [1:0][31:0] win_idx_prev_x2, win_idx_prev_x3, win_idx_prev_x4, win_idx_prev_x5;
  logic [3:0] img_idx_prev_x2, img_idx_prev_x3, img_idx_prev_x4, img_idx_prev_x5; 

  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      win_idx_prev_x2 <= 'd0;
      win_idx_prev_x3 <= 'd0;
      win_idx_prev_x4 <= 'd0;
      win_idx_prev_x5 <= 'd0;
      img_idx_prev_x2 <= 4'd0;
      img_idx_prev_x3 <= 4'd0;
      img_idx_prev_x4 <= 4'd0;
      img_idx_prev_x5 <= 4'd0;
    end else begin
      win_idx_prev_x2 <= win_idx_prev;
      win_idx_prev_x3 <= win_idx_prev_x2;
      win_idx_prev_x4 <= win_idx_prev_x3;
      win_idx_prev_x5 <= win_idx_prev_x4;
      img_idx_prev_x2 <= img_idx_prev;
      img_idx_prev_x3 <= img_idx_prev_x2;
      img_idx_prev_x4 <= img_idx_prev_x3;
      img_idx_prev_x5 <= img_idx_prev_x4;
    end
  end

  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      accum <= 32'd0;
    end else begin
      accum <= (is_stage_end_prev_x3) ? accum + stage_accum_prev + feat_accum_prev : accum;
    end
  end

  assign top_left = win_idx_prev_x5;
  assign pyramid_number = img_idx_prev_x5;
  assign top_left_ready = is_face;

endmodule

module calc_rect_vals (
  input  logic [4:0] rect1_x1, rect1_x2, rect1_y1, rect1_y2, 
                     rect2_x1, rect2_x2, rect2_y1, rect2_y2,
                     rect3_x1, rect3_x2, rect3_y1, rect3_y2,
  input  logic [`WINDOW_SIZE:0][`WINDOW_SIZE:0][17:0] scan_win,
  output logic [31:0] rect1_val, rect2_val, rect3_val);

  logic [31:0] rect1_val1, rect1_val2, rect2_val1, rect2_val2, rect3_val1, rect3_val2;

  assign rect1_val1 = scan_win[rect1_y2][rect1_x2] + scan_win[rect1_y1][rect1_x1];
  assign rect1_val2 = scan_win[rect1_y1][rect1_x2] + scan_win[rect1_y2][rect1_x1];
  assign rect1_val  = rect1_val1 - rect1_val2;
  assign rect2_val1 = scan_win[rect2_y2][rect2_x2] + scan_win[rect2_y1][rect2_x1];
  assign rect2_val2 = scan_win[rect2_y1][rect2_x2] + scan_win[rect2_y2][rect2_x1];
  assign rect2_val  = rect2_val1 - rect2_val2;
  assign rect3_val1 = scan_win[rect3_y2][rect3_x2] + scan_win[rect3_y1][rect3_x1];
  assign rect3_val2 = scan_win[rect3_y1][rect3_x2] + scan_win[rect3_y2][rect3_x1];
  assign rect3_val  = rect3_val1 - rect3_val2;

endmodule