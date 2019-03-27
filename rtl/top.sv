`default_nettype none
localparam logic [12:0][31:0] x_ratios = 
{32'd78841, 32'd78526, 32'd78644, 32'd78729, 32'd78849, 32'd78399, 32'd78791, 
 32'd78821, 32'd78221, 32'd79672, 32'd77729, 32'd80516};
localparam logic [12:0][31:0] y_ratios = 
{32'd79039, 32'd78565, 32'd78834, 32'd78644, 32'd78507, 32'd78644, 32'd79438, 
 32'd78644, 32'd78359, 32'd79334, 32'd77825, 32'd80660};

module top(
  input logic [239:0][319:0][7:0] laptop_img, // coming from uart module
  input logic clock, laptop_img_rdy, reset,
  output logic [3:0][31:0] face_coords,
  output logic [31:0]
  output logic face_coords_ready);

  logic [12:0][239:0][319:0][7:0] images, int_images;

  always_ff @(posedge clock, posedge reset) begin: set_first_img
    if (reset) begin
      images[0] <= 'd0;
    end else if (laptop_img_rdy) begin
      images[0] <= laptop_img;
    end
  end

  genvar i;
  generate
    for (i=0; i<12; i=i+1) begin: downscalers
      downscaler #(WIDTH = 320, HEIGHT = 240, 
                   WIDTH_LIMIT = pyramid_widths[i+1],
                   HEIGHT_LIMIT = pyramid_heights[i+1]) 
                 d(.input_img(images[i]), .x_ratio(x_ratios[i+1]), .y_ratio(y_ratios[i+1]), .output_img(images[i+1]));
    end
  endgenerate

  genvar j;
  generate
    for (j=0; j<13; j=j+1) begin: integral_img_calculators
      int_img_calc #(WIDTH = 320, HEIGHT = 240)
                   i(.input_img(images[i]), .output_img(int_images[i]));
    end
  endgenerate

  logic [3:0] img_index;
  logic [31:0] row_index, col_index;
  logic [23:0][23:0][7:0] scanning_window;
  logic [3:0][31:0] scanning_window_coords;

  genvar k, l;
  generate
    for (k=0; k<24; k=k+1) begin
      for (l=0; l<24; l=l+1) begin
        assign scanning_window[k][l] = int_images[img_index][row_index][col_index];
      end
    end
  endgenerate

  assign scanning_window_coords[0] = row_index;
  assign scanning_window_coords[1] = row_index + 'd23;
  assign scanning_window_coords[2] = col_index;
  assign scanning_window_coords[3] = col_index + 'd23;
 
  logic vj_enable, vj_reset;

  // todo: figure out standard deviation calculation
  vj_pipeline vjp(.clock, .reset(vj_reset), .enable(vj_enable), .scanning_window, 
                  .scanning_window_std_dev(), .scanning_window_coords, 
                  .face_coords, .face_coords_ready);

  // todo: fsm controlling img_index, row_index, col_index, vj_enable, vj_reset

endmodule

module downscaler
  #(parameter WIDTH = 320, HEIGHT = 240, 
              WIDTH_LIMIT = 320, HEIGHT_LIMIT = 240)(
  input  logic [HEIGHT-1:0][WIDTH-1:0][7:0] input_img,
  input  logic [31:0] x_ratio, y_ratio,
  input  logic [3:0] img_number,
  output logic [HEIGHT-1:0][WIDTH-1:0][7:0] output_img);

  logic [HEIGHT-1:0][31:0] row_nums;
  logic [WIDTH-1:0][31:0] col_nums;

  genvar i, j;
  generate
    for (i = 0; i < HEIGHT_LIMIT; i=i+1) begin: downscaled_row
      multiplier m_r(.Y(row_nums[i]), .A(i), .B(x_ratio));

      for (j = 0; j < WIDTH_LIMIT; j=j+1) begin: downscaled_pixels_in_row
        multiplier m_c(.Y(col_nums[j]), .A(j), .B(y_ratio));
        assign output_img[i][j] = input_img[row_nums[i]>>16][col_nums[j]>>16];
      end

      for (k = WIDTH_LIMIT; k < WIDTH; k=k+1) begin: black_pixels1
        assign output_img[i][k] = 8'd0;
      end
    end

    for (l = HEIGHT_LIMIT; l < HEIGHT; l=l+1) begin: black_pixel2
      for (m = 0; m < WIDTH; m=m+1) begin
        assign output_img[l][m] = 8'd0;
      end
    end
  endgenerate

endmodule

module int_img_calc
  #(parameter WIDTH = 320, HEIGHT = 240)(
  input  logic [HEIGHT-1:0][WIDTH-1:0][7:0] input_img,
  output logic [HEIGHT-1:0][WIDTH-1:0][7:0] output_img);

  assign output_img[0][0] = input_img[0][0];

  genvar i, j, k, l;
  generate
    for (i = 1; i < WIDTH; i=i+1) begin: top_row
      output_img[0][i] = input_img[0][i] + output_img[0][i-1];
    end
    for (j = 1; j < HEIGHT; j=j+1) begin: left_column
      output_img[j][0] = input_img[j][0] + output_img[j-1][0];
    end
    for (k = 1; k < HEIGHT; k=k+1) begin: rest 
      for (l = 1; l < WIDTH; l=l+1) begin
        output_img[k][l] = input_img[k][l] + output_img[k][l-1] + output_img[k-1][l];
      end
    end
  endgenerate

endmodule

module vj_pipeline(
  input  logic clock, reset, enable,
  input  logic [23:0][23:0][7:0] scanning_window,
  input  logic [31:0] scanning_window_std_dev,
  input  logic [3:0][31:0] scanning_window_coords,
  output logic [3:0][31:0] face_coords,
  output logic face_coords_ready);

  logic [2912:0][23:0][23:0][7:0] scan_wins;
  logic [2913:0][3:0][31:0] scan_coords;

  always_ff @(posedge clock, posedge reset) begin: set_scanning_windows
    if(reset) begin: reset_scanning_windows
       // something
    end else if (enable) begin: move_scanning_windows
      scan_wins[0] <= scanning_window;
      scan_coords[0] <= scanning_window_coords;
      std_devs[0] <= scanning_window_std_dev;
      for (int i = 0; i < 2912; i++) begin
        scan_wins[i+1] <= scan_wins[i];
        scan_coords[i+1] <= scan_coords[i];
        std_devs[i+1] <= std_devs[i]
      end
      scan_coords[2913] <= scan_coords[2912];
    end
  end

  assign face_coords = scan_coords[2913];

  logic [2912:0] rectangle1_vals, rectangle2_vals, rectangle3_vals, 
                 rectangle1_products, rectangle2_products, rectangle3_products, 
                 feature_sums, feature_thresholds, feature_products, 
                 feature_accums, feature_comparisons;

  genvar j;
  generate
    for (j = 0; j < 2913; j = j+1) begin: 
      assign rectangle1_vals[j] = scan_wins[j][rectangle1_ys[j] + rectangle1_heights[j]][rectangle1_xs[j] + rectangle1_widths[j]];
      assign rectangle2_vals[j] = scan_wins[j][rectangle2_ys[j] + rectangle2_heights[j]][rectangle2_xs[j] + rectangle2_widths[j]];
      assing rectangle3_vals[j] = scan_wins[j][rectangle3_ys[j] + rectangle3_heights[j]][rectangle3_xs[j] + rectangle3_widths[j]];
      multiplier m1(.Y(rectangle1_products[j]), .A(rectangle1_vals[j]), .B(rectangle1_weights[j]));
      multiplier m2(.Y(rectangle2_products[j]), .A(rectangle1_vals[j]), .B(rectangle1_weights[j]));
      multiplier m3(.Y(rectangle3_products[j]), .A(rectangle1_vals[j]), .B(rectangle1_weights[j]));
      multiplier m4(.Y(feature_products[j]), .A(feature_thresholds[j]), .B(std_devs[j]));
      assign feature_sums[j] = rectangle1_products[j] + rectangle2_products[j] + rectangle3_products[j];
      signed_comparator feature_c(.gt(feature_comparisons[j]), .A(feature_sums[j]), .B(feature_products[j]));
      assign feature_accums = (feature_comparisons[j]) ? feature_aboves[j] : feature_belows[j];
    end
  endgenerate

  logic [2913:0][31:0] accums; // accums[0] is wire to zero and accums[2913] is reg to zero
  logic [2913:0] is_feature; // is_feature[0] is wire to one and is_feature[2913] is reg to face_coords_ready
  logic [25:1] stage_comparisons;
  assign accums[0] = 32'd0;
  assign is_feature[0] = 1'd1;
  assign face_coords_ready = is_feature[2913];

  always_ff @(posedge clock, posedge reset) begin: set_accums_and_is_feature
    if (reset) begin
      accums <= 'd0;
      is_feature <= 2914'd0;
    end else begin
      for (int k = 1; k < 26; k++) begin
        for (int l = num_stages[k-1]; l < num_stages[k] - 1; l++) 
          accums[l+1] <= accums[l] + feature_accums[l];
          is_feature[l+1] <= is_feature[l];
        end
        is_feature[num_stages[k]] <= stage_comparisons[k] & is_feature[num_stages[k] - 1];
        accums[num_stages[k]] <= 32'd0;
      end
    end
  end

  genvar m;
  generate
    for (m = 1; m < 26; m=m+1) begin
      signed_comparator stage_c(.gt(stage_comparisons[m]), .A(accums[num_stages[m] - 1] + feature_accums[num_stages[m] - 1]), .B(stage_threshold[m]));
    end
  endgenerate

endmodule

