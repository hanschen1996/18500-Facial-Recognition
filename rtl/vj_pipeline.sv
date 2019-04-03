`include "vj_weights.vh"

module vj_pipeline(
  input  logic clock, reset,
  input  logic [`WINDOW_SIZE:0][`WINDOW_SIZE:0][31:0] scan_win,
  input  logic [31:0] input_std_dev,
  input  logic [1:0][31:0] scan_win_index,
  input  logic [3:0] img_index,
  output logic [1:0][31:0] top_left,
  output logic top_left_ready,
  output logic [3:0] pyramid_number,
  output logic [31:0] accum);

  logic [`NUM_FEATURE-1:0][1:0][31:0] scan_coords;
  
  logic [`NUM_FEATURE-1:0][3:0] pyr_nums;

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

  logic [`NUM_STAGE-1:0][`WINDOW_SIZE:0][`WINDOW_SIZE:0][31:0] scan_wins;
  logic [`NUM_STAGE-1:0][31:0] scan_win_std_devs;
  logic [`NUM_FEATURE-1:0][31:0] feature_accums, feature_accums_prev;
  logic [`NUM_FEATURE-1:0][31:0] feature_accums_prev_sum;
  logic [`NUM_STAGE:0][31:0] stage_accums_prev, stage_accums;
  logic [`NUM_STAGE:0] is_feature, is_feature_prev;

  assign top_left_ready = is_feature[`NUM_STAGE] & is_feature_prev[`NUM_STAGE-1];
  assign accum = stage_accums[`NUM_STAGE];

  genvar i, j;
  generate
    for (i = 0; i < `NUM_STAGE; i ++) begin
      for (j = stage_num_feature[i]; j < stage_num_feature[i+1]; j++) begin
        accum_calculator #(.RECT1_X1(rectangle1_x1[j]),
                           .RECT1_Y1(rectangle1_y1[j]),
                           .RECT1_X2(rectangle1_x2[j]),
                           .RECT1_Y2(rectangle1_y2[j]),
                           .RECT1_WEIGHT(rectangle1_weights[j]),
                           .RECT2_X1(rectangle2_x1[j]),
                           .RECT2_Y1(rectangle2_y1[j]),
                           .RECT2_X2(rectangle2_x2[j]),
                           .RECT2_Y2(rectangle2_y2[j]),
                           .RECT2_WEIGHT(rectangle2_weights[j]),
                           .RECT3_X1(rectangle3_x1[j]),
                           .RECT3_Y1(rectangle3_y1[j]),
                           .RECT3_X2(rectangle3_x2[j]),
                           .RECT3_Y2(rectangle3_y2[j]),
                           .RECT3_WEIGHT(rectangle3_weights[j]),
                           .FEAT_THRES(feature_thresholds[j]),
                           .FEAT_ABOVE(feature_aboves[j]),
                           .FEAT_BELOW(feature_belows[j]))
                         calc(.scan_win(scan_wins[i]),
                              .scan_win_std_dev(scan_win_std_devs[i]),
                              .feature_accum(feature_accums[j]));
      end
    end
  endgenerate

  genvar k, l;
  generate
    for (k = 0; k < `NUM_STAGE; k ++) begin
      for (l = stage_num_feature[k] + 1; l < stage_num_feature[k+1]; l++) begin
        assign feature_accums_prev_sum[l] = feature_accums_prev_sum[l - 1] + feature_accums_prev[l];
      end
      assign feature_accums_prev_sum[stage_num_feature[k]] = feature_accums_prev[stage_num_feature[k]];
    end
  endgenerate

  genvar m;
  generate
    for (m = 1; m < `NUM_STAGE + 1; m++) begin
      assign stage_accums[m] = feature_accums_prev_sum[stage_num_feature[m] - 1] + stage_accums_prev[m - 1];
      signed_comparator stage_c(.gt(is_feature[m]), .A(feature_accums_prev_sum[stage_num_feature[m] - 1]), .B(stage_threshold[m-1]));
    end
  endgenerate

  assign stage_accums[0] = 32'd0;
  assign is_feature[0] = 1'b1;

  // propagate current feature accums so we calculate the sum
  // in the next cycle
  always_ff @(posedge clock, posedge reset) begin: set_feature_accums_prev
    if (reset) begin
      feature_accums_prev <= 'd0;
      stage_accums_prev <= 'd0;
      is_feature_prev <= 'd1;
    end else
      feature_accums_prev <= feature_accums;
      stage_accums_prev <= stage_accums;
      is_feature_prev[`NUM_STAGE:1] <= is_feature[`NUM_STAGE:1] & is_feature_prev[`NUM_STAGE-1:0];
    end
  end

  always_ff @(posedge clock, posedge reset) begin: set_scan_coords_and_scan_win_std_devs
    if (reset) begin: reset_scanning_windows
       scan_coords <= 'd0;
       scan_win_std_devs <= 'd0;
       top_left <= 'd0;
       pyr_nums <= 'd0;
    end else begin: move_scan_coords_and_scan_win_std_devs
      scan_coords[0] <= scan_win_index;
      pyr_nums[0] <= img_index;
      scan_win_std_devs[0] <= input_std_dev;
      for (int i = 0; i < `NUM_FEATURE-1; i++) begin
        scan_coords[i+1] <= scan_coords[i];
        pyr_nums[i+1] <= pyr_nums[i];
        scan_win_std_dev[i+1] <= scan_win_std_dev[i];
      end
      top_left <= scan_coords[`NUM_FEATURE-1];
      pyramid_number <= pyr_nums[`NUM_FEATURE-1];
    end
  end

endmodule

module accum_calculator
  #(parameter RECT1_X1 = 0, RECT1_Y1 = 0, RECT1_X2 = 0, RECT1_Y2 = 0, RECT1_WEIGHT = 0,
              RECT2_X1 = 0, RECT2_Y1 = 0, RECT2_X2 = 0, RECT2_Y2 = 0, RECT2_WEIGHT = 0,
              RECT3_X1 = 0, RECT3_Y1 = 0, RECT3_X2 = 0, RECT3_Y2 = 0, RECT3_WEIGHT = 0,
              FEAT_THRES = 0, FEAT_ABOVE = 0, FEAT_BELOW = 0) (
  input  logic [`WINDOW_SIZE:0][`WINDOW_SIZE:0][31:0] scan_win,
  input  logic [31:0] scan_win_std_dev,
  output logic [31:0] feature_accum);

  logic [31:0] rectangle1_val, rectangle2_val, rectangle3_val, 
               rectangle1_product, rectangle2_product, rectangle3_product,
               feature_product, feature_sum;
  logic feature_comparison;

  assign rectangle1_val = scan_win[RECT1_Y2][RECT1_X2] +
                          scan_win[RECT1_Y1][RECT1_X1] -
                          scan_win[RECT1_Y1][RECT1_X2] -
                          scan_win[RECT1_Y2][RECT1_X1];
  assign rectangle2_val = scan_win[RECT2_Y2][RECT2_X2] +
                          scan_win[RECT2_Y1][RECT2_X1] -
                          scan_win[RECT2_Y1][RECT2_X2] -
                          scan_win[RECT2_Y2][RECT2_X1];
  assign rectangle3_val = scan_win[RECT3_Y2][RECT3_X2] +
                          scan_win[RECT3_Y1][RECT3_X1] -
                          scan_win[RECT3_Y1][RECT3_X2] -
                          scan_win[RECT3_Y2][RECT3_X1];
  multiplier m1(.out(rectangle1_product), .a(rectangle1_val), .b(RECT1_WEIGHT));
  multiplier m2(.out(rectangle2_product), .a(rectangle2_val), .b(RECT2_WEIGHT));
  multiplier m3(.out(rectangle3_product), .a(rectangle3_val), .b(RECT3_WEIGHT));
  multiplier m4(.out(feature_product), .a(FEAT_THRES), .b(scan_win_std_dev));
  assign feature_sum = rectangle1_product + rectangle2_product + rectangle3_product;
  signed_comparator feature_c(.gt(feature_comparison), .A(feature_sum), .B(feature_product));
  assign feature_accum = (feature_comparison) ? FEAT_ABOVE : FEAT_BELOW;

endmodule
