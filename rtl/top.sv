`default_nettype none


module top(
  input logic [LAPTOP_HEIGHT-1:0][LAPTOP_WIDTH-1:0][7:0] laptop_img, // coming from uart module
  input logic clock, laptop_img_rdy, reset,
  output logic [3:0][31:0] face_coords,
  output logic face_coords_ready);

  logic [PYRAMID_LEVELS-1:0][LAPTOP_HEIGHT-1:0][LAPTOP_WIDTH-1:0][7:0] images, int_images, int_images_sq;

  always_ff @(posedge clock, posedge reset) begin: set_first_img
    if (reset) begin
      images[0] <= 'd0;
    end else if (laptop_img_rdy) begin
      images[0] <= laptop_img;
    end
  end

  genvar i;
  generate
    for (i=0; i<PYRAMID_LEVELS-1; i=i+1) begin: downscalers
      downscaler #(WIDTH_LIMIT = pyramid_widths[i+1],
                   HEIGHT_LIMIT = pyramid_heights[i+1]) 
                 down(.input_img(images[i]),
                      .x_ratio(x_ratios[i+1]),
                      .y_ratio(y_ratios[i+1]),
                      .output_img(images[i+1]));
    end
  endgenerate

  genvar j;
  generate
    for (j=0; j<PYRAMID_LEVELS; j=j+1) begin: integral_img_calculators
      int_img_calc int_calc(.input_img(images[j]),
                            .output_img(int_images[j]),
                            .output_img_sq(int_images_sq[j]));
    end
  endgenerate

  logic [3:0] img_index;
  logic [31:0] row_index, col_index;
  logic [WINDOW_SIZE-1:0][WINDOW_SIZE-1:0][7:0] scan_win;
  logic [1:0][31:0] scan_win_index;

  logic [31:0] scan_win_top_left, scan_win_top_right, scan_win_bottom_left, scan_win_bottom_right;
  logic [31:0] scan_win_top_left_sq, scan_win_top_right_sq, scan_win_bottom_left_sq, scan_win_bottom_right_sq;
  logic [31:0] scan_win_sum, scan_win_sq_sum;
  logic [31:0] scan_win_std, scan_win_std_dev1, scan_win_std_dev2;


  assign scan_win_index[0] = row_index;
  assign scan_win_index[1] = col_index;
  assign scan_win_top_left = int_images[img_index][row_index][col_index];
  assign scan_win_top_right = int_images[img_index][row_index][col_index + WINDOW_SIZE];
  assign scan_win_bottom_left = int_images[img_index][row_index + WINDOW_SIZE][col_index];
  assign scan_win_bottom_right = int_images[img_index][row_index + WINDOW_SIZE][col_index + WINDOW_SIZE];
  assign scan_win_top_left_sq = int_images_sq[img_index][row_index][col_index];
  assign scan_win_top_right_sq = int_images_sq[img_index][row_index][col_index + WINDOW_SIZE];
  assign scan_win_bottom_left_sq = int_images_sq[img_index][row_index + WINDOW_SIZE][col_index];
  assign scan_win_bottom_right_sq = int_images_sq[img_index][row_index + WINDOW_SIZE][col_index + WINDOW_SIZE];
  assign scan_win_sq_sum = scan_win_bottom_right_sq - scan_win_bottom_left_sq + scan_win_top_left_sq - scan_win_top_right_sq;

  multiplier scan_win_mult1(.Y(scan_win_std_dev1), .A(scan_win_sq_sum), .B(32'd576));
  multiplier scan_win_mult2(.Y(scan_win_std_dev2), .A(scan_win_sum), .B(scan_win_sum));
  
  // TODO: define sqrt
  assign scan_win_std_dev = sqrt(scan_win_std_dev1 - scan_win_std_dev2);

  // copy current scanning window into a buffer
  genvar k, l;
  generate
    for (k=0; k<WINDOW_SIZE; k=k+1) begin
      for (l=0; l<WINDOW_SIZE; l=l+1) begin
        assign scanning_window[k][l] = (img_index == 4'd15) ? 8'd0 : int_images[img_index][row_index+k][col_index+l];
      end
    end
  endgenerate

  logic [1:0][31:0] top_left;

  // TODO: react to top_left_ready signal
  vj_pipeline vjp(.clock, .reset, .scan_win, .scan_win_std_dev,
                  .scan_win_index, .top_left, .top_left_ready);


  /* ---------------------------------------------------------------------------
   * FSM -----------------------------------------------------------------------
   */

  logic [31:0] wait_integral_image_count;
  logic vj_pipeline_on;

  always_comb begin
  end

  always_ff @(posedge clock, reset) begin
    if (reset) begin
      wait_integral_image_count <= 32'd0;
      img_index <= 4'd15;
      row_index <= 32'd0;
      col_index <= 32'd0;
    end else begin
      if (laptop_img_rdy) begin 
        wait_integral_image_count <= 32'd1;
      end
      if ((wait_integral_image_count > 32'd0) && (wait_integral_image_count < 32'd76800)) begin: waiting_for_first_int_img
        wait_integral_image_count <= wait_integral_image_count + 32'd1;
      end
      if (wait_integral_image_count == 32'd76800) begin: turn_on_vj_pipeline
        wait_integral_image_count <= 32'd0;
        vj_pipeline_on <= 1'b1;
        img_index <= 4'd0;
        row_index <= 32'd0;
        col_index <= 32'd0;
      end
      if (vj_pipeline_on) begin 
        if ((img_index == PYRAMID_LEVELS-1) && (row_index == pyramid_heights[img_index] - WINDOW_SIZE) &&
            (col_index == pyramid_widths[img_index] - WINDOW_SIZE)) begin: vj_pipeline_finished
          img_index <= 4'd15;
          row_index <= 32'd0;
          col_index <= 32'd0;
          vj_pipeline_on <= 1'd0;
        end else begin
          if (col_index == pyramid_widths[img_index] - WINDOW_SIZE) begin: row_done
            if (row_index == pyramid_heights[img_index] - WINDOW_SIZE) begin: col_done
              img_index <= img_index + 4'd1;
              row_index <= 32'd0;
              col_index <= 32'd0;
            end else begin: col_not_done
              col_index <= 32'd0;
              row_index <= row_index + 32'd1;
            end
          end else begin: row_not_done
            col_index <= col_index + 32'd1;
          end
        end
      end
    end
  end
endmodule

module downscaler
  #(parameter WIDTH_LIMIT = 320, HEIGHT_LIMIT = 240)(
  input  logic [LAPTOP_HEIGHT-1:0][LAPTOP_WIDTH-1:0][7:0] input_img,
  input  logic [31:0] x_ratio, y_ratio,
  output logic [LAPTOP_HEIGHT-1:0][LAPTOP_WIDTH-1:0][7:0] output_img);

  logic [LAPTOP_HEIGHT-1:0][31:0] row_nums;
  logic [LAPTOP_WIDTH-1:0][31:0] col_nums;

  genvar i, j;
  generate
    for (i = 0; i < HEIGHT_LIMIT; i=i+1) begin: downscaled_row
      multiplier m_r(.Y(row_nums[i]), .A(i), .B(x_ratio));

      for (j = 0; j < WIDTH_LIMIT; j=j+1) begin: downscaled_pixels_in_row
        multiplier m_c(.Y(col_nums[j]), .A(j), .B(y_ratio));
        assign output_img[i][j] = input_img[row_nums[i]>>16][col_nums[j]>>16];
      end

      for (k = WIDTH_LIMIT; k < LAPTOP_WIDTH; k=k+1) begin: black_pixels1
        assign output_img[i][k] = 8'd0;
      end
    end

    for (l = HEIGHT_LIMIT; l < LAPTOP_HEIGHT; l=l+1) begin: black_pixel2
      for (m = 0; m < LAPTOP_WIDTH; m=m+1) begin
        assign output_img[l][m] = 8'd0;
      end
    end
  endgenerate

endmodule

module int_img_calc(
  input  logic [LAPTOP_HEIGHT-1:0][LAPTOP_WIDTH-1:0][7:0] input_img,
  output logic [LAPTOP_HEIGHT-1:0][LAPTOP_WIDTH-1:0][7:0] output_img, output_img_sq);

  logic [LAPTOP_HEIGHT-1:0][LAPTOP_WIDTH-1:0][7:0] input_img_sq;
  assign output_img[0][0] = input_img[0][0];
  assign output_img_sq[0][0] = input_img_sq[0][0];

  genvar i, j, k, l;
  generate
    for (i = 1; i < LAPTOP_WIDTH; i=i+1) begin: top_row
      output_img[0][i] = input_img[0][i] + output_img[0][i-1];
      output_img_sq[0][i] = input_img_sq[0][i] + output_img_sq[0][i-1];
    end
    for (j = 1; j < LAPTOP_HEIGHT; j=j+1) begin: left_column
      output_img[j][0] = input_img[j][0] + output_img[j-1][0];
      output_img_sq[j][0] = input_img_sq[j][0] + output_img_sq[j-1][0];
    end
    for (k = 1; k < LAPTOP_HEIGHT; k=k+1) begin: rest 
      for (l = 1; l < LAPTOP_WIDTH; l=l+1) begin
        output_img[k][l] = input_img[k][l] + output_img[k][l-1] + output_img[k-1][l] - output_img[k-1][l-1];
        output_img_sq[k][l] = input_img_sq[k][l] + output_img_sq[k][l-1] + output_img_sq[k-1][l] - output_img_sq[k-1][l-1];
      end
    end
  endgenerate

  genvar m, n;
  generate
    for (m = 0; m < LAPTOP_HEIGHT; m=m+1) begin
      for (n = 0; n < LAPTOP_WIDTH; n=n+1) begin
        multiplier m(.Y(input_img_sq[m][n]), .A(input_img[m][n]), .B(input_img[m][n]));
      end
    end
  endgenerate

endmodule

module vj_pipeline(
  input  logic clock, reset,
  input  logic [WINDOW_SIZE-1:0][WINDOW_SIZE-1:0][7:0] scan_win,
  input  logic [31:0] scan_win_std_dev,
  input  logic [1:0][31:0] scan_win_index,
  output logic [1:0][31:0] top_left,
  output logic top_left_ready);

  logic [NUM_FEATURE-1:0][WINDOW_SIZE-1:0][WINDOW_SIZE-1:0][7:0] scan_wins;
  logic [NUM_FEATURE-1:0][1:0][31:0] scan_coords;
  logic [NUM_FEATURE-1:0][31:0] scan_win_std_devs;

  always_ff @(posedge clock, posedge reset) begin: set_scanning_windows
    if (reset) begin: reset_scanning_windows
       scan_wins <= 'd0;
       scan_coords <= 'd0;
       scan_win_std_devs <= 'd0;
       top_left <= 'd0;
    end else begin: move_scanning_windows
      scan_wins[0] <= scan_win;
      scan_coords[0] <= scan_win_index;
      scan_win_std_devs[0] <= scan_win_std_dev;
      for (int i = 0; i < NUM_FEATURE-1; i++) begin
        scan_wins[i+1] <= scan_wins[i];
        scan_coords[i+1] <= scan_coords[i];
        scan_win_std_devs[i+1] <= scan_win_std_devs[i]
      end
      top_left <= scan_coords[NUM_FEATURE-1];
    end
  end

  logic [NUM_FEATURE-1:0][31:0] rectangle1_vals, rectangle2_vals, rectangle3_vals,
                                rectangle1_products, rectangle2_products, rectangle3_products,
                                feature_sums, feature_thresholds, feature_products, 
                                feature_accums;
  logic [NUM_FEATURE-1:0] feature_comparisons;

  genvar j;
  generate
    for (j = 0; j < NUM_FEATURE; j = j+1) begin: 
      assign rectangle1_vals[j] = scan_wins[j][rectangle1_ys[j] + rectangle1_heights[j]][rectangle1_xs[j] + rectangle1_widths[j]] +
                                  scan_wins[j][rectangle1_ys[j]][rectangle1_xs[j]]-
                                  scan_wins[j][rectangle1_ys[j]][rectangle1_xs[j] + rectangle1_widths[j]] -
                                  scan_wins[j][rectangle1_ys[j] + rectangle1_heights[j]][rectangle1_xs[j]];
      assign rectangle2_vals[j] = scan_wins[j][rectangle2_ys[j] + rectangle2_heights[j]][rectangle2_xs[j] + rectangle2_widths[j]] +
                                  scan_wins[j][rectangle2_ys[j]][rectangle2_xs[j]]-
                                  scan_wins[j][rectangle2_ys[j]][rectangle2_xs[j] + rectangle2_widths[j]] -
                                  scan_wins[j][rectangle2_ys[j] + rectangle2_heights[j]][rectangle2_xs[j]];
      assign rectangle3_vals[j] = scan_wins[j][rectangle3_ys[j] + rectangle3_heights[j]][rectangle3_xs[j] + rectangle3_widths[j]] +
                                  scan_wins[j][rectangle3_ys[j]][rectangle3_xs[j]]-
                                  scan_wins[j][rectangle3_ys[j]][rectangle3_xs[j] + rectangle3_widths[j]] -
                                  scan_wins[j][rectangle3_ys[j] + rectangle3_heights[j]][rectangle3_xs[j]];
      multiplier m1(.Y(rectangle1_products[j]), .A(rectangle1_vals[j]), .B(rectangle1_weights[j]));
      multiplier m2(.Y(rectangle2_products[j]), .A(rectangle2_vals[j]), .B(rectangle2_weights[j]));
      multiplier m3(.Y(rectangle3_products[j]), .A(rectangle3_vals[j]), .B(rectangle3_weights[j]));
      multiplier m4(.Y(feature_products[j]), .A(feature_thresholds[j]), .B(scan_win_std_devs[j]));
      assign feature_sums[j] = rectangle1_products[j] + rectangle2_products[j] + rectangle3_products[j];
      signed_comparator feature_c(.gt(feature_comparisons[j]), .A(feature_sums[j]), .B(feature_products[j]));
      assign feature_accums[j] = (feature_comparisons[j]) ? feature_aboves[j] : feature_belows[j];
    end
  endgenerate

  logic [NUM_FEATURE:0][31:0] stage_accums; // stage_accums[0] is wire to zero and stage_accums[2913] is reg to zero
  logic [NUM_FEATURE:0] is_feature; // is_feature[0] is wire to one and is_feature[2913] is reg to face_coords_ready
  logic [NUM_STAGE:1] stage_comparisons;
  assign stage_accums[0] = 32'd0;
  assign is_feature[0] = 1'd1;
  assign top_left_ready = is_feature[NUM_FEATURE];

  always_ff @(posedge clock, posedge reset) begin: set_accums_and_is_feature
    if (reset) begin
      stage_accums <= 'd0;
      is_feature <= 'd0;
    end else begin
      for (int k = 1; k < 26; k++) begin
        for (int l = stage_num_feature[k-1]; l < stage_num_feature[k] - 1; l++) 
          stage_accums[l+1] <= stage_accums[l] + feature_accums[l];
          is_feature[l+1] <= is_feature[l];
        end
        is_feature[stage_num_feature[k]] <= stage_comparisons[k] & is_feature[stage_num_feature[k] - 1];
        stage_accums[stage_num_feature[k]] <= 32'd0;
      end
    end
  end

  genvar m;
  generate
    for (m = 1; m < NUM_STAGE+1; m=m+1) begin
      signed_comparator stage_c(.gt(stage_comparisons[m]), .A(stage_accums[stage_num_feature[m] - 1] + feature_accums[stage_num_feature[m] - 1]), .B(stage_threshold[m]));
    end
  endgenerate

endmodule

