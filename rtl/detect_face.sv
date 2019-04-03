`default_nettype none
`include "vj_weights.vh"
`define MAX_CLOCK_COUNT 50
`define IMG_INDEX_DEFAULT 4'd15
`define PYRAMID_START 4'd0
`define INT_IMG_WAIT 10

module detect_face(
  input logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][7:0] laptop_img, // coming from uart module
  input logic clock, laptop_img_rdy, reset,
  output logic [1:0][31:0] face_coords,
  output logic face_coords_ready,
  output logic [3:0] pyramid_number,
  output logic [31:0] accum);

  localparam [`PYRAMID_LEVELS-1:0][31:0] pyramid_widths = `PYRAMID_WIDTHS;
  localparam [`PYRAMID_LEVELS-1:0][31:0] pyramid_heights = `PYRAMID_HEIGHTS;

  // each pyramid image has different size
  logic [pyramid_heights[0]-1:0][pyramid_widths[0]-1:0][7:0] images0;
  logic [pyramid_heights[0]-1:0][pyramid_widths[0]-1:0][31:0] int_images0, int_images_sq0;
  logic [pyramid_heights[1]-1:0][pyramid_widths[1]-1:0][7:0] images1;
  logic [pyramid_heights[1]-1:0][pyramid_widths[1]-1:0][31:0] int_images1, int_images_sq1;
  logic [pyramid_heights[2]-1:0][pyramid_widths[2]-1:0][7:0] images2;
  logic [pyramid_heights[2]-1:0][pyramid_widths[2]-1:0][31:0] int_images2, int_images_sq2;
  logic [pyramid_heights[3]-1:0][pyramid_widths[3]-1:0][7:0] images3;
  logic [pyramid_heights[3]-1:0][pyramid_widths[3]-1:0][31:0] int_images3, int_images_sq3;
  logic [pyramid_heights[4]-1:0][pyramid_widths[4]-1:0][7:0] images4;
  logic [pyramid_heights[4]-1:0][pyramid_widths[4]-1:0][31:0] int_images4, int_images_sq4;
  logic [pyramid_heights[5]-1:0][pyramid_widths[5]-1:0][7:0] images5;
  logic [pyramid_heights[5]-1:0][pyramid_widths[5]-1:0][31:0] int_images5, int_images_sq5;
  logic [pyramid_heights[6]-1:0][pyramid_widths[6]-1:0][7:0] images6;
  logic [pyramid_heights[6]-1:0][pyramid_widths[6]-1:0][31:0] int_images6, int_images_sq6;
  logic [pyramid_heights[7]-1:0][pyramid_widths[7]-1:0][7:0] images7;
  logic [pyramid_heights[7]-1:0][pyramid_widths[7]-1:0][31:0] int_images7, int_images_sq7;
  logic [pyramid_heights[8]-1:0][pyramid_widths[8]-1:0][7:0] images8;
  logic [pyramid_heights[8]-1:0][pyramid_widths[8]-1:0][31:0] int_images8, int_images_sq8;

  // temporary array to hold the image for the current pyramid level
  logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][31:0] curr_int_image, curr_int_image_sq;
  logic [3:0] img_index;
  logic [31:0] row_index, col_index;
  logic [`WINDOW_SIZE:0][`WINDOW_SIZE:0][31:0] scan_win, scan_win_sq;
  logic [1:0][31:0] scan_win_index;
  logic [31:0] scan_win_std_dev;

  assign scan_win_index[0] = row_index;
  assign scan_win_index[1] = col_index;

  /* write laptop image into the first image pyramid */
  always_ff @(posedge clock, posedge reset) begin: set_first_img
    if (reset) begin
      images0 <= 'd0;
    end else if (laptop_img_rdy) begin
      images0 <= laptop_img;
    end
  end

  /* downscalers to downscale the original image into all pyramid levels */
  downscaler #(.PYRAMID_INDEX(0),
               .WIDTH_LIMIT(pyramid_widths[1]),
               .HEIGHT_LIMIT(pyramid_heights[1]))
             down1(.input_img(images0), .output_img(images1));
  downscaler #(.PYRAMID_INDEX(1),
               .WIDTH_LIMIT(pyramid_widths[2]),
               .HEIGHT_LIMIT(pyramid_heights[2]))
             down2(.input_img(images0), .output_img(images2));
  downscaler #(.PYRAMID_INDEX(2),
               .WIDTH_LIMIT(pyramid_widths[3]),
               .HEIGHT_LIMIT(pyramid_heights[3]))
             down3(.input_img(images0), .output_img(images3));
  downscaler #(.PYRAMID_INDEX(3),
               .WIDTH_LIMIT(pyramid_widths[4]),
               .HEIGHT_LIMIT(pyramid_heights[4]))
             down4(.input_img(images0), .output_img(images4));
  downscaler #(.PYRAMID_INDEX(4),
               .WIDTH_LIMIT(pyramid_widths[5]),
               .HEIGHT_LIMIT(pyramid_heights[5]))
             down5(.input_img(images0),  .output_img(images5));
  downscaler #(.PYRAMID_INDEX(5),
               .WIDTH_LIMIT(pyramid_widths[6]),
               .HEIGHT_LIMIT(pyramid_heights[6]))
             down6(.input_img(images0), .output_img(images6));
  downscaler #(.PYRAMID_INDEX(6),
               .WIDTH_LIMIT(pyramid_widths[7]),
               .HEIGHT_LIMIT(pyramid_heights[7]))
             down7(.input_img(images0), .output_img(images7));
  downscaler #(.PYRAMID_INDEX(7),
               .WIDTH_LIMIT(pyramid_widths[8]),
               .HEIGHT_LIMIT(pyramid_heights[8]))
             down8(.input_img(images0), .output_img(images8));

  /* integral image calculator for all pyramid levels */
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

  /* calculate standard deviation of the current scanning window */
  window_std_dev stddev(.scan_win, .scan_win_sq, .scan_win_std_dev);
  
  logic clock_count_max;
  logic [31:0] clock_count;
  assign clock_count_max = (clock_count == `MAX_CLOCK_COUNT);

  always_ff @(posedge clock, posedge reset) begin: count_clock
    if (reset) begin
      clock_count <= 'd0;
    end else begin
      clock_count <= clock_count_max ? 'd0 : clock_count + 'd1;
    end
  end
  
  //logic [1:0][31:0] top_left;
  //logic top_left_ready;
  /* viola-jones pipeline to send scanning window through each feature */
  vj_pipeline vjp(.clock(clock_count_max), .reset, .scan_win, .input_std_dev(scan_win_std_dev), .img_index,
                  .scan_win_index, .top_left(face_coords), .top_left_ready(face_coords_ready), 
                  .pyramid_number, .accum);

  /* choose the current integral image because each pyramid level has
   * different sizes */
  always_comb begin
    case (img_index)
      4'd0: begin
            for (int row = 0; row < pyramid_heights[0]; row++) begin: image0_row
              for (int col = 0; col < pyramid_widths[0]; col++) begin: image0_col
                curr_int_image[row][col] = int_images0[row][col];
                curr_int_image_sq[row][col] = int_images_sq0[row][col];
              end
            end
            end
      4'd1: begin
            for (int row = 0; row < pyramid_heights[1]; row++) begin: image1_row
              for (int col = 0; col < pyramid_widths[1]; col++) begin: image1_col
                curr_int_image[row][col] = int_images1[row][col];
                curr_int_image_sq[row][col] = int_images_sq1[row][col];
              end
            end
            end
      4'd2: begin
            for (int row = 0; row < pyramid_heights[2]; row++) begin: image2_row
              for (int col = 0; col < pyramid_widths[2]; col++) begin: image2_col
                curr_int_image[row][col] = int_images2[row][col];
                curr_int_image_sq[row][col] = int_images_sq2[row][col];
              end
            end
            end
      4'd3: begin
            for (int row = 0; row < pyramid_heights[3]; row++) begin: image3_row
              for (int col = 0; col < pyramid_widths[3]; col++) begin: image3_col
                curr_int_image[row][col] = int_images3[row][col];
                curr_int_image_sq[row][col] = int_images_sq3[row][col];
              end
            end
            end
      4'd4: begin
            for (int row = 0; row < pyramid_heights[4]; row++) begin: image4_row
              for (int col = 0; col < pyramid_widths[4]; col++) begin: image4_col
                curr_int_image[row][col] = int_images4[row][col];
                curr_int_image_sq[row][col] = int_images_sq4[row][col];
              end
            end
            end
      4'd5: begin
            for (int row = 0; row < pyramid_heights[5]; row++) begin: image5_row
              for (int col = 0; col < pyramid_widths[5]; col++) begin: image5_col
                curr_int_image[row][col] = int_images5[row][col];
                curr_int_image_sq[row][col] = int_images_sq5[row][col];
              end
            end
            end
      4'd6: begin
            for (int row = 0; row < pyramid_heights[6]; row++) begin: image6_row
              for (int col = 0; col < pyramid_widths[6]; col++) begin: image6_col
                curr_int_image[row][col] = int_images6[row][col];
                curr_int_image_sq[row][col] = int_images_sq6[row][col];
              end
            end
            end
      4'd7: begin
            for (int row = 0; row < pyramid_heights[7]; row++) begin: image7_row
              for (int col = 0; col < pyramid_widths[7]; col++) begin: image7_col
                curr_int_image[row][col] = int_images7[row][col];
                curr_int_image_sq[row][col] = int_images_sq7[row][col];
              end
            end
            end
      4'd8: begin
            for (int row = 0; row < pyramid_heights[8]; row++) begin: image8_row
              for (int col = 0; col < pyramid_widths[8]; col++) begin: image8_col
                curr_int_image[row][col] = int_images8[row][col];
                curr_int_image_sq[row][col] = int_images_sq8[row][col];
              end
            end
            end
      default: begin
               curr_int_image = 'd0;
               curr_int_image_sq = 'd0;
               end
    endcase
  end

  /* choose the current scanning window */
  genvar k, l;
  generate
    for (k=0; k<`WINDOW_SIZE+1; k=k+1) begin: scan_win_row
      for (l=0; l<`WINDOW_SIZE+1; l=l+1) begin: scan_win_column
        assign scan_win[k][l] = (img_index == `IMG_INDEX_DEFAULT) ? 32'd0 : curr_int_image[row_index+k][col_index+l];
        assign scan_win_sq[k][l] = (img_index == `IMG_INDEX_DEFAULT) ? 32'd0 : curr_int_image_sq[row_index+k][col_index+l];
      end
    end
  endgenerate

  

  /* ---------------------------------------------------------------------------
   * FSM -----------------------------------------------------------------------
   */

  logic [31:0] wait_integral_image_count;
  logic vj_pipeline_on, finished_sending_windows;

  always_ff @(posedge clock_count_max, posedge reset) begin
    if (reset) begin
      img_index <= `IMG_INDEX_DEFAULT;
      row_index <= 32'd0;
      col_index <= 32'd0;
    end else begin
      if (vj_pipeline_on) begin
        if (img_index == `IMG_INDEX_DEFAULT) begin
          img_index <= `PYRAMID_START;
          row_index <= 32'd0;
          col_index <= 32'd0;
        end
        if ((img_index == `PYRAMID_LEVELS-1) && (row_index == pyramid_heights[img_index] - `WINDOW_SIZE - 1) &&
            (col_index == pyramid_widths[img_index] - `WINDOW_SIZE - 1)) begin: vj_pipeline_finished
          img_index <= `IMG_INDEX_DEFAULT;
          row_index <= 32'd0;
          col_index <= 32'd0;
          finished_sending_windows <= 1'b1;
        end else begin
          if (col_index == pyramid_widths[img_index] - `WINDOW_SIZE - 1) begin: row_done
            if (row_index == pyramid_heights[img_index] - `WINDOW_SIZE - 1) begin: col_done
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
      end else begin
        finished_sending_windows <= 1'b0;
      end
    end
  end

  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      wait_integral_image_count <= 32'd0;
      vj_pipeline_on <= 1'd0;
    end else begin
      if (laptop_img_rdy) begin
        wait_integral_image_count <= 32'd1;
      end
      if ((wait_integral_image_count > 32'd0) && (wait_integral_image_count < `INT_IMG_WAIT)) begin: waiting_for_first_int_img
        wait_integral_image_count <= wait_integral_image_count + 32'd1;
      end
      if (wait_integral_image_count == `INT_IMG_WAIT) begin: turn_on_vj_pipeline
        wait_integral_image_count <= 32'd0;
        vj_pipeline_on <= 1'b1;
      end
      if (finished_sending_windows) begin
        vj_pipeline_on <= 1'd0;
      end
    end
  end
endmodule
