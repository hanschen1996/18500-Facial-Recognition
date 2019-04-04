`include "vj_weights.vh"
`define PIPELINE_PARTS 4

module vj_pipeline(
  input  logic clock, reset,
  input  logic [`WINDOW_SIZE:0][`WINDOW_SIZE:0][31:0] scan_win,
  input  logic [31:0] input_std_dev,
  input  logic [1:0][31:0] scan_win_index,
  input  logic [3:0] img_index,
  output logic [1:0][31:0] top_left,
  output logic [3:0] pyramid_number,
  output logic top_left_ready,
  output logic [31:0] accum);

  localparam [`NUM_STAGE:0][31:0] stage_num_feature = `STAGE_NUM_FEATURE;
  localparam [`NUM_STAGE-1:0][31:0] stage_threshold = `STAGE_THRESHOLD;
  localparam [`NUM_FEATURE-1:0][4:0] rectangle1_x1 = `RECTANGLE1_X1;
  localparam [`NUM_FEATURE-1:0][4:0] rectangle1_y1 = `RECTANGLE1_Y1;
  localparam [`NUM_FEATURE-1:0][4:0] rectangle1_x2 = `RECTANGLE1_X2;
  localparam [`NUM_FEATURE-1:0][4:0] rectangle1_y2 = `RECTANGLE1_Y2;
  localparam [`NUM_FEATURE-1:0][31:0] rectangle1_weights = `RECTANGLE1_WEIGHTS;
  localparam [`NUM_FEATURE-1:0][4:0] rectangle2_x1 = `RECTANGLE2_X1;
  localparam [`NUM_FEATURE-1:0][4:0] rectangle2_y1 = `RECTANGLE2_Y1;
  localparam [`NUM_FEATURE-1:0][4:0] rectangle2_x2 = `RECTANGLE2_X2;
  localparam [`NUM_FEATURE-1:0][4:0] rectangle2_y2 = `RECTANGLE2_Y2;
  localparam [`NUM_FEATURE-1:0][31:0] rectangle2_weights = `RECTANGLE2_WEIGHTS;
  localparam [`NUM_FEATURE-1:0][4:0] rectangle3_x1 = `RECTANGLE3_X1;
  localparam [`NUM_FEATURE-1:0][4:0] rectangle3_y1 = `RECTANGLE3_Y1;
  localparam [`NUM_FEATURE-1:0][4:0] rectangle3_x2 = `RECTANGLE3_X2;
  localparam [`NUM_FEATURE-1:0][4:0] rectangle3_y2 = `RECTANGLE3_Y2;
  localparam [`NUM_FEATURE-1:0][31:0] rectangle3_weights = `RECTANGLE3_WEIGHTS;
  localparam [`NUM_FEATURE-1:0][31:0] feature_thresholds = `FEATURE_THRESHOLD;
  localparam [`NUM_FEATURE-1:0][31:0] feature_aboves = `FEATURE_ABOVE;
  localparam [`NUM_FEATURE-1:0][31:0] feature_belows = `FEATURE_BELOW;

  logic [`NUM_STAGE-1:0] is_feature;
  
  //all pipeline parts
  logic [`PIPELINE_PARTS-1:0][1:0][31:0] top_lefts;
  logic [`PIPELINE_PARTS-1:0][3:0] pyr_nums;

  //pipeline part 1 to 2
  logic [`NUM_FEATURE-1:0][31:0] feature_sums, feature_products;
  logic [`NUM_FEATURE-1:0][31:0] feature_sums_prev, feature_products_prev;

  //pipeline part 2 to 3
  logic [`NUM_FEATURE-1:0][31:0] feature_accums;
  logic [`NUM_FEATURE-1:0][31:0] feature_accums_prev;

  //pipeline part 3 to 4
  logic [`NUM_FEATURE-1:0][31:0] feature_accums_prev_sum;
  logic [`NUM_STAGE-1:0][31:0] stage_accums;
  logic [`NUM_STAGE-1:0][31:0] stage_accums_prev;

  genvar i, j;
  generate
    for (i = 0; i < `NUM_STAGE; i=i+1) begin
      for (j = stage_num_feature[i]; j < stage_num_feature[i+1]; j++) begin
        pipeline1 #(.RECT1_X1(rectangle1_x1[j]), .RECT1_Y1(rectangle1_y1[j]),
                    .RECT1_X2(rectangle1_x2[j]), .RECT1_Y2(rectangle1_y2[j]),
                    .RECT2_X1(rectangle2_x1[j]), .RECT2_Y1(rectangle2_y1[j]),
                    .RECT2_X2(rectangle2_x2[j]), .RECT2_Y2(rectangle2_y2[j]),
                    .RECT3_X1(rectangle3_x1[j]), .RECT3_Y1(rectangle3_y1[j]),
                    .RECT3_X2(rectangle3_x2[j]), .RECT3_Y2(rectangle3_y2[j]),
                    .RECT1_WEIGHT(rectangle1_weights[j]), 
                    .RECT2_WEIGHT(rectangle2_weights[j]),
                    .RECT3_WEIGHT(rectangle3_weights[j]), 
                    .FEAT_THRES(feature_thresholds[j]))
                  p1(.scan_win, .scan_win_std_dev(input_std_dev), 
                     .feature_sum(feature_sums[j]), 
                     .feature_product(feature_products[j]));
        pipeline2 #(.FEAT_ABOVE(feature_aboves[j]),
                    .FEAT_BELOW(feature_belows[j]))
                  p2(.feature_sum(feature_sums_prev[j]), 
                     .feature_product(feature_products_prev[j]), 
                     .feature_accum(feature_accums[j]));
      end
    end
  endgenerate

  genvar k, l;
  generate
    for (k = 0; k < `NUM_STAGE; k=k+1) begin: pipeline3
      for (l = stage_num_feature[k] + 1; l < stage_num_feature[k+1]; l++) begin
        assign feature_accums_prev_sum[l] = feature_accums_prev_sum[l - 1] + feature_accums_prev[l];
      end
      assign feature_accums_prev_sum[stage_num_feature[k]] = feature_accums_prev[stage_num_feature[k]];
      assign stage_accums[k] = feature_accums_prev_sum[stage_num_feature[k+1] - 1];
    end
  endgenerate

  genvar m;
  generate
    for (m = 0; m < `NUM_STAGE; m=m+1) begin: pipeline4
      signed_comparator stage_c(.gt(is_feature[m]), .A(stage_accums_prev[m]), .B(stage_threshold[m]));
    end
  endgenerate

  logic [11:0] is_feature_L1;
  logic [5:0]  is_feature_L2;
  logic [2:0]  is_feature_L3;
  assign is_feature_L1[0] = is_feature[1] & is_feature[0];
  assign is_feature_L1[1] = is_feature[3] & is_feature[2];
  assign is_feature_L1[2] = is_feature[5] & is_feature[4];
  assign is_feature_L1[3] = is_feature[7] & is_feature[6];
  assign is_feature_L1[4] = is_feature[9] & is_feature[8];
  assign is_feature_L1[5] = is_feature[11] & is_feature[10];
  assign is_feature_L1[6] = is_feature[13] & is_feature[12];
  assign is_feature_L1[7] = is_feature[15] & is_feature[14];
  assign is_feature_L1[8] = is_feature[17] & is_feature[16];
  assign is_feature_L1[9] = is_feature[19] & is_feature[18];
  assign is_feature_L1[10] = is_feature[21] & is_feature[20];
  assign is_feature_L1[11] = is_feature[24] & is_feature[23] & is_feature[22];
  assign is_feature_L2[0] = is_feature_L1[1] & is_feature_L1[0];
  assign is_feature_L2[1] = is_feature_L1[3] & is_feature_L1[2];
  assign is_feature_L2[2] = is_feature_L1[5] & is_feature_L1[4];
  assign is_feature_L2[3] = is_feature_L1[7] & is_feature_L1[6];
  assign is_feature_L2[4] = is_feature_L1[9] & is_feature_L1[8];
  assign is_feature_L2[5] = is_feature_L1[11] & is_feature_L1[10];
  assign is_feature_L3[0] = is_feature_L2[1] & is_feature_L2[0];
  assign is_feature_L3[1] = is_feature_L2[3] & is_feature_L2[2];
  assign is_feature_L3[2] = is_feature_L2[5] & is_feature_L2[4];
  assign top_left_ready = is_feature_L3[2] & is_feature_L3[1] & is_feature_L3[0];

  logic [11:0][31:0] stage_accums_prev_L1;
  logic [5:0][31:0]  stage_accums_prev_L2;
  logic [2:0][31:0]  stage_accums_prev_L3;
  assign stage_accums_prev_L1[0] = stage_accums_prev[1] + stage_accums_prev[0];
  assign stage_accums_prev_L1[1] = stage_accums_prev[3] + stage_accums_prev[2];
  assign stage_accums_prev_L1[2] = stage_accums_prev[5] + stage_accums_prev[4];
  assign stage_accums_prev_L1[3] = stage_accums_prev[7] + stage_accums_prev[6];
  assign stage_accums_prev_L1[4] = stage_accums_prev[9] + stage_accums_prev[8];
  assign stage_accums_prev_L1[5] = stage_accums_prev[11] + stage_accums_prev[10];
  assign stage_accums_prev_L1[6] = stage_accums_prev[13] + stage_accums_prev[12];
  assign stage_accums_prev_L1[7] = stage_accums_prev[15] + stage_accums_prev[14];
  assign stage_accums_prev_L1[8] = stage_accums_prev[17] + stage_accums_prev[16];
  assign stage_accums_prev_L1[9] = stage_accums_prev[19] + stage_accums_prev[18];
  assign stage_accums_prev_L1[10] = stage_accums_prev[21] + stage_accums_prev[20];
  assign stage_accums_prev_L1[11] = stage_accums_prev[24] + stage_accums_prev[23] + accum[22];
  assign stage_accums_prev_L2[0] = stage_accums_prev_L1[1] + stage_accums_prev_L1[0];
  assign stage_accums_prev_L2[1] = stage_accums_prev_L1[3] + stage_accums_prev_L1[2];
  assign stage_accums_prev_L2[2] = stage_accums_prev_L1[5] + stage_accums_prev_L1[4];
  assign stage_accums_prev_L2[3] = stage_accums_prev_L1[7] + stage_accums_prev_L1[6];
  assign stage_accums_prev_L2[4] = stage_accums_prev_L1[9] + stage_accums_prev_L1[8];
  assign stage_accums_prev_L2[5] = stage_accums_prev_L1[11] + stage_accums_prev_L1[10];
  assign stage_accums_prev_L3[0] = stage_accums_prev_L2[1] + stage_accums_prev_L2[0];
  assign stage_accums_prev_L3[1] = stage_accums_prev_L2[3] + stage_accums_prev_L2[2];
  assign stage_accums_prev_L3[2] = stage_accums_prev_L2[5] + stage_accums_prev_L2[4];
  assign accum = stage_accums_prev_L3[2] + stage_accums_prev_L3[1] + stage_accums_prev_L3[0];

  always_ff @(posedge clock, posedge reset) begin: pipeline_propagate
    if (reset) begin
      feature_products_prev <= 'd0;
      feature_sums_prev <= 'd0;
      feature_accums_prev <= 'd0;
      stage_accums_prev <= 'd0;
      top_lefts <= 'd0;
      pyr_nums <= 'd0;
    end else begin
      feature_products_prev <= feature_products;
      feature_sums_prev <= feature_sums;
      feature_accums_prev <= feature_accums;
      stage_accums_prev <= stage_accums;
      top_lefts[0] <= scan_win_index;
      pyr_nums[0] <= img_index;
      for (int n = 0; n < `PIPELINE_PARTS-1; n++) begin
        top_lefts[n+1] <= top_lefts[n];
        pyr_nums[n+1] <= pyr_nums[n];
      end
    end
  end

  assign top_left = top_lefts[`PIPELINE_PARTS - 1];
  assign pyramid_number = pyr_nums[`PIPELINE_PARTS-1];

endmodule

module pipeline1
  #(parameter RECT1_X1 = 0, RECT1_Y1 = 0, RECT1_X2 = 0, RECT1_Y2 = 0,
              RECT2_X1 = 0, RECT2_Y1 = 0, RECT2_X2 = 0, RECT2_Y2 = 0,
              RECT3_X1 = 0, RECT3_Y1 = 0, RECT3_X2 = 0, RECT3_Y2 = 0,
              RECT1_WEIGHT = 0, RECT2_WEIGHT = 0, RECT3_WEIGHT = 0,
              FEAT_THRES = 0) (
  input  logic [`WINDOW_SIZE:0][`WINDOW_SIZE:0][31:0] scan_win,
  input  logic [31:0] scan_win_std_dev,
  output logic [31:0] feature_sum, feature_product);

  logic [31:0] rect1_val, rect1_val1, rect1_val2, 
               rect2_val, rect2_val1, rect2_val2, 
               rect3_val, rect3_val1, rect3_val2,
               rect1_product, rect2_product, rect3_product;;

  assign rect1_val1 = scan_win[RECT1_Y2][RECT1_X2] + scan_win[RECT1_Y1][RECT1_X1];
  assign rect1_val2 = scan_win[RECT1_Y1][RECT1_X2] + scan_win[RECT1_Y2][RECT1_X1];
  assign rect1_val  = rect1_val1 - rect1_val2;
  assign rect2_val1 = scan_win[RECT2_Y2][RECT2_X2] + scan_win[RECT2_Y1][RECT2_X1];
  assign rect2_val2 = scan_win[RECT2_Y1][RECT2_X2] + scan_win[RECT2_Y2][RECT2_X1];
  assign rect2_val  = rect2_val1 - rect2_val2;
  assign rect3_val1 = scan_win[RECT3_Y2][RECT3_X2] + scan_win[RECT3_Y1][RECT3_X1];
  assign rect3_val2 = scan_win[RECT3_Y1][RECT3_X2] + scan_win[RECT3_Y2][RECT3_X1];
  assign rect3_val  = rect3_val1 - rect3_val2;

  multiplier m1(.out(rect1_product), .a(rect1_val), .b(RECT1_WEIGHT));
  multiplier m2(.out(rect2_product), .a(rect2_val), .b(RECT2_WEIGHT));
  multiplier m3(.out(rect3_product), .a(rect3_val), .b(RECT3_WEIGHT));
  multiplier m4(.out(feature_product), .a(FEAT_THRES), .b(scan_win_std_dev));
  assign feature_sum = rect1_product + rect2_product + rect3_product;

endmodule

module pipeline2
  #(parameter FEAT_ABOVE = 0, FEAT_BELOW = 0) (
  input  logic [31:0] feature_sum, feature_product,
  output logic [31:0] feature_accum);

  logic feature_comparison;

  signed_comparator feature_c(.gt(feature_comparison), .A(feature_sum), .B(feature_product));
  assign feature_accum = (feature_comparison) ? FEAT_ABOVE : FEAT_BELOW;

endmodule