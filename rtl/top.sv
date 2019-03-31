//`default_nettype none
`include "vj_weights.vh"

module top(
  input logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][7:0] laptop_img, // coming from uart module
  input logic clock, laptop_img_rdy, reset,
  output logic [1:0][31:0] face_coords,
  output logic face_coords_ready,
  output logic [3:0] pyramid_number);

  localparam [`PYRAMID_LEVELS-1:0][31:0] pyramid_widths = `PYRAMID_WIDTHS;
  localparam [`PYRAMID_LEVELS-1:0][31:0] pyramid_heights = `PYRAMID_HEIGHTS;
  logic [pyramid_widths[1]-1:0][31:0] pyramid1_x_ratios = `PYRAMID1_X_RATIOS;
  logic [pyramid_heights[1]-1:0][31:0] pyramid1_y_ratios = `PYRAMID1_Y_RATIOS;
  logic [pyramid_widths[2]-1:0][31:0] pyramid2_x_ratios = `PYRAMID2_X_RATIOS;
  logic [pyramid_heights[2]-1:0][31:0] pyramid2_y_ratios = `PYRAMID2_Y_RATIOS;
  logic [pyramid_widths[3]-1:0][31:0] pyramid3_x_ratios = `PYRAMID3_X_RATIOS;
  logic [pyramid_heights[3]-1:0][31:0] pyramid3_y_ratios = `PYRAMID3_Y_RATIOS;
  logic [pyramid_widths[4]-1:0][31:0] pyramid4_x_ratios = `PYRAMID4_X_RATIOS;
  logic [pyramid_heights[4]-1:0][31:0] pyramid4_y_ratios = `PYRAMID4_Y_RATIOS;
  logic [pyramid_widths[5]-1:0][31:0] pyramid5_x_ratios = `PYRAMID5_X_RATIOS;
  logic [pyramid_heights[5]-1:0][31:0] pyramid5_y_ratios = `PYRAMID5_Y_RATIOS;
  logic [pyramid_widths[6]-1:0][31:0] pyramid6_x_ratios = `PYRAMID6_X_RATIOS;
  logic [pyramid_heights[6]-1:0][31:0] pyramid6_y_ratios = `PYRAMID6_Y_RATIOS;
  logic [pyramid_widths[7]-1:0][31:0] pyramid7_x_ratios = `PYRAMID7_X_RATIOS;
  logic [pyramid_heights[7]-1:0][31:0] pyramid7_y_ratios = `PYRAMID7_Y_RATIOS;
  logic [pyramid_widths[8]-1:0][31:0] pyramid8_x_ratios = `PYRAMID8_X_RATIOS;
  logic [pyramid_heights[8]-1:0][31:0] pyramid8_y_ratios = `PYRAMID8_Y_RATIOS;
  logic [pyramid_widths[9]-1:0][31:0] pyramid9_x_ratios = `PYRAMID9_X_RATIOS;
  logic [pyramid_heights[9]-1:0][31:0] pyramid9_y_ratios = `PYRAMID9_Y_RATIOS;

  // each pyramid image has different size
  logic [pyramid_heights[0]-1:0][pyramid_widths[0]-1:0][31:0] images0, int_images0, int_images_sq0;
  logic [pyramid_heights[1]-1:0][pyramid_widths[1]-1:0][31:0] images1, int_images1, int_images_sq1;
  logic [pyramid_heights[2]-1:0][pyramid_widths[2]-1:0][31:0] images2, int_images2, int_images_sq2;
  logic [pyramid_heights[3]-1:0][pyramid_widths[3]-1:0][31:0] images3, int_images3, int_images_sq3;
  logic [pyramid_heights[4]-1:0][pyramid_widths[4]-1:0][31:0] images4, int_images4, int_images_sq4;
  logic [pyramid_heights[5]-1:0][pyramid_widths[5]-1:0][31:0] images5, int_images5, int_images_sq5;
  logic [pyramid_heights[6]-1:0][pyramid_widths[6]-1:0][31:0] images6, int_images6, int_images_sq6;
  logic [pyramid_heights[7]-1:0][pyramid_widths[7]-1:0][31:0] images7, int_images7, int_images_sq7;
  logic [pyramid_heights[8]-1:0][pyramid_widths[8]-1:0][31:0] images8, int_images8, int_images_sq8;
  logic [pyramid_heights[9]-1:0][pyramid_widths[9]-1:0][31:0] images9, int_images9, int_images_sq9;

  // temporary array to hold the image for the current pyramid level
  logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][31:0] curr_int_image, curr_int_image_sq;

  always_ff @(posedge clock, posedge reset) begin: set_first_img
    if (reset) begin
      images0 <= 'd0;
    end else if (laptop_img_rdy) begin
      for (int y = 0; y < `LAPTOP_HEIGHT; y++) begin: traverse_rows
        for (int z = 0; z < `LAPTOP_WIDTH; z++) begin: traverse_cols
          images0[y][z] <= {24'd0, laptop_img[y][z]};
        end
      end
    end
  end

  downscaler #(.WIDTH_LIMIT(pyramid_widths[1]),
               .HEIGHT_LIMIT(pyramid_heights[1]))
             down1(.input_img(images0), .x_ratio(pyramid1_x_ratios),
                   .y_ratio(pyramid1_y_ratios), .output_img(images1));
  downscaler #(.WIDTH_LIMIT(pyramid_widths[2]),
               .HEIGHT_LIMIT(pyramid_heights[2]))
             down2(.input_img(images0), .x_ratio(pyramid2_x_ratios),
                   .y_ratio(pyramid2_y_ratios), .output_img(images2));
  downscaler #(.WIDTH_LIMIT(pyramid_widths[3]),
               .HEIGHT_LIMIT(pyramid_heights[3]))
             down3(.input_img(images0), .x_ratio(pyramid3_x_ratios),
                   .y_ratio(pyramid3_y_ratios), .output_img(images3));
  downscaler #(.WIDTH_LIMIT(pyramid_widths[4]),
               .HEIGHT_LIMIT(pyramid_heights[4]))
             down4(.input_img(images0), .x_ratio(pyramid4_x_ratios),
                   .y_ratio(pyramid4_y_ratios), .output_img(images4));
  downscaler #(.WIDTH_LIMIT(pyramid_widths[5]),
               .HEIGHT_LIMIT(pyramid_heights[5]))
             down5(.input_img(images0), .x_ratio(pyramid5_x_ratios),
                   .y_ratio(pyramid5_y_ratios), .output_img(images5));
  downscaler #(.WIDTH_LIMIT(pyramid_widths[6]),
               .HEIGHT_LIMIT(pyramid_heights[6]))
             down6(.input_img(images0), .x_ratio(pyramid6_x_ratios),
                   .y_ratio(pyramid6_y_ratios), .output_img(images6));
  downscaler #(.WIDTH_LIMIT(pyramid_widths[7]),
               .HEIGHT_LIMIT(pyramid_heights[7]))
             down7(.input_img(images0), .x_ratio(pyramid7_x_ratios),
                   .y_ratio(pyramid7_y_ratios), .output_img(images7));
  downscaler #(.WIDTH_LIMIT(pyramid_widths[8]),
               .HEIGHT_LIMIT(pyramid_heights[8]))
             down8(.input_img(images0), .x_ratio(pyramid8_x_ratios),
                   .y_ratio(pyramid8_y_ratios), .output_img(images8));
  downscaler #(.WIDTH_LIMIT(pyramid_widths[9]),
               .HEIGHT_LIMIT(pyramid_heights[9]))
             down9(.input_img(images0), .x_ratio(pyramid9_x_ratios),
                   .y_ratio(pyramid9_y_ratios), .output_img(images9));

  int_img_calc #(.WIDTH_LIMIT(pyramid_widths[0]),
                 .HEIGHT_LIMIT(pyramid_heights[0]))
               int_calc0(.input_img(images0), .output_img(int_images0),
                         .output_img_sq(int_images_sq0));
  int_img_calc #(.WIDTH_LIMIT(pyramid_widths[1]),
                 .HEIGHT_LIMIT(pyramid_heights[1]))
               int_calc1(.input_img(images1), .output_img(int_images1),
                         .output_img_sq(int_images_sq1));
  int_img_calc #(.WIDTH_LIMIT(pyramid_widths[2]),
                 .HEIGHT_LIMIT(pyramid_heights[2]))
               int_calc2(.input_img(images2), .output_img(int_images2),
                         .output_img_sq(int_images_sq2));
  int_img_calc #(.WIDTH_LIMIT(pyramid_widths[3]),
                 .HEIGHT_LIMIT(pyramid_heights[3]))
               int_calc3(.input_img(images3), .output_img(int_images3),
                         .output_img_sq(int_images_sq3));
  int_img_calc #(.WIDTH_LIMIT(pyramid_widths[4]),
                 .HEIGHT_LIMIT(pyramid_heights[4]))
               int_calc4(.input_img(images4), .output_img(int_images4),
                         .output_img_sq(int_images_sq4));
  int_img_calc #(.WIDTH_LIMIT(pyramid_widths[5]),
                 .HEIGHT_LIMIT(pyramid_heights[5]))
               int_calc5(.input_img(images5), .output_img(int_images5),
                         .output_img_sq(int_images_sq5));
  int_img_calc #(.WIDTH_LIMIT(pyramid_widths[6]),
                 .HEIGHT_LIMIT(pyramid_heights[6]))
               int_calc6(.input_img(images6), .output_img(int_images6),
                         .output_img_sq(int_images_sq6));
  int_img_calc #(.WIDTH_LIMIT(pyramid_widths[7]),
                 .HEIGHT_LIMIT(pyramid_heights[7]))
               int_calc7(.input_img(images7), .output_img(int_images7),
                         .output_img_sq(int_images_sq7));
  int_img_calc #(.WIDTH_LIMIT(pyramid_widths[8]),
                 .HEIGHT_LIMIT(pyramid_heights[8]))
               int_calc8(.input_img(images8), .output_img(int_images8),
                         .output_img_sq(int_images_sq8));
  int_img_calc #(.WIDTH_LIMIT(pyramid_widths[9]),
                 .HEIGHT_LIMIT(pyramid_heights[9]))
               int_calc9(.input_img(images9), .output_img(int_images9),
                         .output_img_sq(int_images_sq9));

  logic [3:0] img_index;
  logic [31:0] row_index, col_index;
  logic [`WINDOW_SIZE-1:0][`WINDOW_SIZE-1:0][31:0] scan_win;
  logic [1:0][31:0] scan_win_index;

  logic [31:0] scan_win_top_left, scan_win_top_right, scan_win_bottom_left, scan_win_bottom_right;
  logic [31:0] scan_win_top_left_sq, scan_win_top_right_sq, scan_win_bottom_left_sq, scan_win_bottom_right_sq;
  logic [31:0] scan_win_sum, scan_win_sq_sum;
  logic [31:0] scan_win_std_dev, scan_win_std_dev1, scan_win_std_dev2;

  always_comb begin
    case (img_index)
      4'd0: begin
            for (int row = 0; row < pyramid_heights[0]; row++) begin: image0_row
              for (int col = 0; col < pyramid_widths[0]; col++) begin: image0_col
                curr_int_image[row][col] = images0[row][col];
                curr_int_image_sq[row][col] = images0[row][col];
              end
            end
            end
      4'd1: begin
            for (int row = 0; row < pyramid_heights[1]; row++) begin: image1_row
              for (int col = 0; col < pyramid_widths[1]; col++) begin: image1_col
                curr_int_image[row][col] = images1[row][col];
                curr_int_image_sq[row][col] = images1[row][col];
              end
            end
            end
      4'd2: begin
            for (int row = 0; row < pyramid_heights[2]; row++) begin: image2_row
              for (int col = 0; col < pyramid_widths[2]; col++) begin: image2_col
                curr_int_image[row][col] = images2[row][col];
                curr_int_image_sq[row][col] = images2[row][col];
              end
            end
            end
      4'd3: begin
            for (int row = 0; row < pyramid_heights[3]; row++) begin: image3_row
              for (int col = 0; col < pyramid_widths[3]; col++) begin: image3_col
                curr_int_image[row][col] = images3[row][col];
                curr_int_image_sq[row][col] = images3[row][col];
              end
            end
            end
      4'd4: begin
            for (int row = 0; row < pyramid_heights[4]; row++) begin: image4_row
              for (int col = 0; col < pyramid_widths[4]; col++) begin: image4_col
                curr_int_image[row][col] = images4[row][col];
                curr_int_image_sq[row][col] = images4[row][col];
              end
            end
            end
      4'd5: begin
            for (int row = 0; row < pyramid_heights[5]; row++) begin: image5_row
              for (int col = 0; col < pyramid_widths[5]; col++) begin: image5_col
                curr_int_image[row][col] = images5[row][col];
                curr_int_image_sq[row][col] = images5[row][col];
              end
            end
            end
      4'd6: begin
            for (int row = 0; row < pyramid_heights[6]; row++) begin: image6_row
              for (int col = 0; col < pyramid_widths[6]; col++) begin: image6_col
                curr_int_image[row][col] = images6[row][col];
                curr_int_image_sq[row][col] = images6[row][col];
              end
            end
            end
      4'd7: begin
            for (int row = 0; row < pyramid_heights[7]; row++) begin: image7_row
              for (int col = 0; col < pyramid_widths[7]; col++) begin: image7_col
                curr_int_image[row][col] = images7[row][col];
                curr_int_image_sq[row][col] = images7[row][col];
              end
            end
            end
      4'd8: begin
            for (int row = 0; row < pyramid_heights[8]; row++) begin: image8_row
              for (int col = 0; col < pyramid_widths[8]; col++) begin: image8_col
                curr_int_image[row][col] = images8[row][col];
                curr_int_image_sq[row][col] = images8[row][col];
              end
            end
            end
      4'd9: begin
            for (int row = 0; row < pyramid_heights[9]; row++) begin: image9_row
              for (int col = 0; col < pyramid_widths[9]; col++) begin: image9_col
                curr_int_image[row][col] = images9[row][col];
                curr_int_image_sq[row][col] = images9[row][col];
              end
            end
            end
      default: curr_int_image = 'd0;
    endcase
  end

  assign scan_win_index[0] = row_index;
  assign scan_win_index[1] = col_index;
  assign scan_win_top_left = curr_int_image[row_index][col_index];
  assign scan_win_top_right = curr_int_image[row_index][col_index + `WINDOW_SIZE];
  assign scan_win_bottom_left = curr_int_image[row_index + `WINDOW_SIZE][col_index];
  assign scan_win_bottom_right = curr_int_image[row_index + `WINDOW_SIZE][col_index + `WINDOW_SIZE];
  assign scan_win_top_left_sq = curr_int_image_sq[row_index][col_index];
  assign scan_win_top_right_sq = curr_int_image_sq[row_index][col_index + `WINDOW_SIZE];
  assign scan_win_bottom_left_sq = curr_int_image_sq[row_index + `WINDOW_SIZE][col_index];
  assign scan_win_bottom_right_sq = curr_int_image_sq[row_index + `WINDOW_SIZE][col_index + `WINDOW_SIZE];
  assign scan_win_sq_sum = scan_win_bottom_right_sq - scan_win_bottom_left_sq + scan_win_top_left_sq - scan_win_top_right_sq;
  assign scan_win_sum = scan_win_bottom_right - scan_win_bottom_left + scan_win_top_left - scan_win_top_right;

  multiplier scan_win_mult1(.out(scan_win_std_dev1), .a(scan_win_sq_sum), .b(32'd576));
  multiplier scan_win_mult2(.out(scan_win_std_dev2), .a(scan_win_sum), .b(scan_win_sum));

  sqrt stddev(.val(scan_win_std_dev1 - scan_win_std_dev2), .res(scan_win_std_dev));

  // copy current scanning window into a buffer
  genvar k, l;
  generate
    for (k=0; k<`WINDOW_SIZE; k=k+1) begin: scan_win_row
      for (l=0; l<`WINDOW_SIZE; l=l+1) begin: scan_win_column
        assign scan_win[k][l] = (img_index == 4'd15) ? 31'd0 : curr_int_image[row_index+k][col_index+l];
      end
    end
  endgenerate

  //logic [1:0][31:0] top_left;
  //logic top_left_ready;

  vj_pipeline vjp(.clock, .reset, .scan_win, .scan_win_std_dev,
                  .scan_win_index, .top_left(face_coords), .top_left_ready(face_coords_ready));

  assign pyramid_number = img_index;

  /* ---------------------------------------------------------------------------
   * FSM -----------------------------------------------------------------------
   */

  logic [31:0] wait_integral_image_count;
  logic vj_pipeline_on;

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
        if ((img_index == `PYRAMID_LEVELS-1) && (row_index == pyramid_heights[img_index] - `WINDOW_SIZE) &&
            (col_index == pyramid_widths[img_index] - `WINDOW_SIZE)) begin: vj_pipeline_finished
          img_index <= 4'd15;
          row_index <= 32'd0;
          col_index <= 32'd0;
          vj_pipeline_on <= 1'd0;
        end else begin
          if (col_index == pyramid_widths[img_index] - `WINDOW_SIZE) begin: row_done
            if (row_index == pyramid_heights[img_index] - `WINDOW_SIZE) begin: col_done
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
  #(parameter WIDTH_LIMIT = `LAPTOP_WIDTH, HEIGHT_LIMIT = `LAPTOP_HEIGHT)(
  input  logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][31:0] input_img,
  input  logic [WIDTH_LIMIT-1:0][31:0] x_ratio,
  input  logic [HEIGHT_LIMIT-1:0][31:0] y_ratio,
  output logic [HEIGHT_LIMIT-1:0][WIDTH_LIMIT-1:0][31:0] output_img);

  localparam [HEIGHT_LIMIT-1:0][31:0] local_y_ratio = y_ratio;
  localparam [WIDTH_LIMIT-1:0][31:0] local_x_ratio = x_ratio;
  genvar i, j, k, l, m;
  generate
    for (i = 0; i < HEIGHT_LIMIT; i=i+1) begin: downscaled_row
      for (j = 0; j < WIDTH_LIMIT; j=j+1) begin: downscaled_pixels_in_row
        assign output_img[i][j] = input_img[local_y_ratio[i]][local_x_ratio[j]];
      end

/*
      for (k = WIDTH_LIMIT; k < `LAPTOP_WIDTH; k=k+1) begin: black_pixels1
        assign output_img[i][k] = 31'd0;
      end*/
    end
/*
    for (l = HEIGHT_LIMIT; l < `LAPTOP_HEIGHT; l=l+1) begin: black_pixel2_row
      for (m = 0; m < `LAPTOP_WIDTH; m=m+1) begin: black_pixel2_column
        assign output_img[l][m] = 31'd0;      end
    end*/
  endgenerate

endmodule

module int_img_calc
  #(parameter WIDTH_LIMIT = `LAPTOP_WIDTH, HEIGHT_LIMIT = `LAPTOP_HEIGHT)(
  input  logic [HEIGHT_LIMIT-1:0][WIDTH_LIMIT-1:0][31:0] input_img,
  output logic [HEIGHT_LIMIT-1:0][WIDTH_LIMIT-1:0][31:0] output_img, output_img_sq);

  logic [HEIGHT_LIMIT-1:0][WIDTH_LIMIT-1:0][31:0] input_img_sq;
  assign output_img[0][0] = input_img[0][0];
  assign output_img_sq[0][0] = input_img_sq[0][0];

  genvar i, j, k, l;
  generate
    for (i = 1; i < WIDTH_LIMIT; i=i+1) begin: top_row
      assign output_img[0][i] = input_img[0][i] + output_img[0][i-1];
      assign output_img_sq[0][i] = input_img_sq[0][i] + output_img_sq[0][i-1];
    end
    for (j = 1; j < HEIGHT_LIMIT; j=j+1) begin: left_column
      assign output_img[j][0] = input_img[j][0] + output_img[j-1][0];
      assign output_img_sq[j][0] = input_img_sq[j][0] + output_img_sq[j-1][0];
    end
    for (k = 1; k < HEIGHT_LIMIT; k=k+1) begin: rest_of_rows
      for (l = 1; l < WIDTH_LIMIT; l=l+1) begin: rest_of_columns
        assign output_img[k][l] = input_img[k][l] + output_img[k][l-1] + output_img[k-1][l] - output_img[k-1][l-1];
        assign output_img_sq[k][l] = input_img_sq[k][l] + output_img_sq[k][l-1] + output_img_sq[k-1][l] - output_img_sq[k-1][l-1];
      end
    end
  endgenerate

  genvar m, n;
  generate
    for (m = 0; m < HEIGHT_LIMIT; m=m+1) begin: multiplier_row
      for (n = 0; n < WIDTH_LIMIT; n=n+1) begin: multiplier_column
        multiplier m(.out(input_img_sq[m][n]), .a(input_img[m][n]), .b(input_img[m][n]));
      end
    end
  endgenerate

endmodule

module vj_pipeline(
  input  logic clock, reset,
  input  logic [`WINDOW_SIZE-1:0][`WINDOW_SIZE-1:0][31:0] scan_win,
  input  logic [31:0] scan_win_std_dev,
  input  logic [1:0][31:0] scan_win_index,
  output logic [1:0][31:0] top_left,
  output logic top_left_ready);

  logic [`NUM_FEATURE-1:0][`WINDOW_SIZE-1:0][`WINDOW_SIZE-1:0][31:0] scan_wins;
  logic [`NUM_FEATURE-1:0][1:0][31:0] scan_coords;
  logic [`NUM_FEATURE-1:0][31:0] scan_win_std_devs;

  logic [`NUM_STAGE:0][31:0] stage_num_feature = `STAGE_NUM_FEATURE;
  logic [`NUM_STAGE-1:0][31:0] stage_threshold = `STAGE_THRESHOLD;
  logic [`NUM_FEATURE-1:0][31:0] rectangle1_xs = `RECTANGLE1_XS;
  logic [`NUM_FEATURE-1:0][31:0] rectangle1_ys = `RECTANGLE1_YS;
  logic [`NUM_FEATURE-1:0][31:0] rectangle1_widths = `RECTANGLE1_WIDTHS;
  logic [`NUM_FEATURE-1:0][31:0] rectangle1_heights = `RECTANGLE1_HEIGHTS;
  logic [`NUM_FEATURE-1:0][31:0] rectangle1_weights = `RECTANGLE1_WEIGHTS;
  logic [`NUM_FEATURE-1:0][31:0] rectangle2_xs = `RECTANGLE2_XS;
  logic [`NUM_FEATURE-1:0][31:0] rectangle2_ys = `RECTANGLE2_YS;
  logic [`NUM_FEATURE-1:0][31:0] rectangle2_widths = `RECTANGLE2_WIDTHS;
  logic [`NUM_FEATURE-1:0][31:0] rectangle2_heights = `RECTANGLE2_HEIGHTS;
  logic [`NUM_FEATURE-1:0][31:0] rectangle2_weights = `RECTANGLE2_WEIGHTS;
  logic [`NUM_FEATURE-1:0][31:0] rectangle3_xs = `RECTANGLE3_XS;
  logic [`NUM_FEATURE-1:0][31:0] rectangle3_ys = `RECTANGLE3_YS;
  logic [`NUM_FEATURE-1:0][31:0] rectangle3_widths = `RECTANGLE3_WIDTHS;
  logic [`NUM_FEATURE-1:0][31:0] rectangle3_heights = `RECTANGLE3_HEIGHTS;
  logic [`NUM_FEATURE-1:0][31:0] rectangle3_weights = `RECTANGLE3_WEIGHTS;
  logic [`NUM_FEATURE-1:0][31:0] feature_threshold = `FEATURE_THRESHOLD;
  logic [`NUM_FEATURE-1:0][31:0] feature_aboves = `FEATURE_ABOVE;
  logic [`NUM_FEATURE-1:0][31:0] feature_belows = `FEATURE_BELOW;

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
      for (int i = 0; i < `NUM_FEATURE-1; i++) begin
        scan_wins[i+1] <= scan_wins[i];
        scan_coords[i+1] <= scan_coords[i];
        scan_win_std_devs[i+1] <= scan_win_std_devs[i];
      end
      top_left <= scan_coords[`NUM_FEATURE-1];
    end
  end

  logic [`NUM_FEATURE-1:0][31:0] rectangle1_vals, rectangle2_vals, rectangle3_vals,
                                rectangle1_products, rectangle2_products, rectangle3_products,
                                feature_sums, feature_thresholds, feature_products,
                                feature_accums;
  logic [`NUM_FEATURE-1:0] feature_comparisons;

  genvar j;
  generate
    for (j = 0; j < `NUM_FEATURE; j = j+1) begin: feature_calculations
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
      multiplier m1(.out(rectangle1_products[j]), .a(rectangle1_vals[j]), .b(rectangle1_weights[j]));
      multiplier m2(.out(rectangle2_products[j]), .a(rectangle2_vals[j]), .b(rectangle2_weights[j]));
      multiplier m3(.out(rectangle3_products[j]), .a(rectangle3_vals[j]), .b(rectangle3_weights[j]));
      multiplier m4(.out(feature_products[j]), .a(feature_thresholds[j]), .b(scan_win_std_devs[j]));
      assign feature_sums[j] = rectangle1_products[j] + rectangle2_products[j] + rectangle3_products[j];
      signed_comparator feature_c(.gt(feature_comparisons[j]), .A(feature_sums[j]), .B(feature_products[j]));
      assign feature_accums[j] = (feature_comparisons[j]) ? feature_aboves[j] : feature_belows[j];
    end
  endgenerate

  logic [`NUM_FEATURE:0][31:0] stage_accums; // stage_accums[0] is wire to zero and stage_accums[2913] is reg to zero
  logic [`NUM_FEATURE:0] is_feature; // is_feature[0] is wire to one and is_feature[2913] is reg to face_coords_ready
  logic [`NUM_STAGE:1] stage_comparisons;
  assign stage_accums[0] = 32'd0;
  assign is_feature[0] = 1'd1;
  assign top_left_ready = is_feature[`NUM_FEATURE];

  always_ff @(posedge clock, posedge reset) begin: set_accums_and_is_feature
    if (reset) begin
      stage_accums <= 'd0;
      is_feature <= 'd0;
    end else begin
      for (int k = 1; k < 26; k++) begin
        for (int l = stage_num_feature[k-1]; l < stage_num_feature[k] - 1; l++) begin
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
    for (m = 1; m < `NUM_STAGE+1; m=m+1) begin: stage_threshold_check
      signed_comparator stage_c(.gt(stage_comparisons[m]), .A(stage_accums[stage_num_feature[m] - 1] + feature_accums[stage_num_feature[m] - 1]), .B(stage_threshold[m]));
    end
  endgenerate

endmodule

