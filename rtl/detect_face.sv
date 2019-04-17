`default_nettype none
`include "vj_weights.vh"
`define IMG_INDEX_DEFAULT 4'd15
`define PYRAMID_START 4'd0
`define INT_IMG_WAIT 3

module detect_face(
  input logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][7:0] laptop_img, // coming from uart module
  input logic clock, laptop_img_rdy, reset,
  output logic [1:0][31:0] face_coords,
  output logic face_coords_ready, vj_pipeline_done,
  output logic [3:0] pyramid_number,
  output logic [31:0] accum);

  localparam [`PYRAMID_LEVELS-1:0][31:0] pyramid_widths = `PYRAMID_WIDTHS;
  localparam [`PYRAMID_LEVELS-1:0][31:0] pyramid_heights = `PYRAMID_HEIGHTS;

  // temporary array to hold the image for the current pyramid level
  logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][7:0] curr_image, curr_image_down;
  logic [3:0] img_index;
  logic [31:0] row_index, col_index;
  logic [`WINDOW_SIZE:0][`WINDOW_SIZE:0][7:0] scan_win;
  logic [`WINDOW_SIZE:0][`WINDOW_SIZE:0][17:0] scan_win_int;
  logic [`WINDOW_SIZE:0][`WINDOW_SIZE:0][31:0] scan_win_int_sq;
  logic [1:0][31:0] scan_win_index;
  logic [31:0] scan_win_std_dev;

  assign scan_win_index[0] = row_index;
  assign scan_win_index[1] = col_index;

  /* downscalers to downscale the original image into all pyramid levels */
  downscaler down(.input_img(curr_image), .output_img(curr_image_down));

  /* calculate standard deviation of the current scanning window */
  window_std_dev stddev(.scan_win(scan_win_int), .scan_win_sq(scan_win_int_sq), .scan_win_std_dev);
  
  /* viola-jones pipeline to send scanning window through each feature */
  logic next_scan_win;
  vj_pipeline vjp(.clock, .reset, .scan_win(scan_win_int), .input_std_dev(scan_win_std_dev), .img_index, .vj_pipeline_on,
                  .scan_win_index, .next_scan_win, .top_left(face_coords), .top_left_ready(face_coords_ready), 
                  .pyramid_number, .accum);
  assign vj_pipeline_done = (pyramid_number == `PYRAMID_LEVELS-1) & 
                            (face_coords[0] == pyramid_heights[`PYRAMID_LEVELS - 1] -`WINDOW_SIZE - 1) &
                            (face_coords[1] == pyramid_widths[`PYRAMID_LEVELS - 1] - `WINDOW_SIZE - 1) &
                            next_scan_win;

  int_img_calc #(.WIDTH_LIMIT(`WINDOW_SIZE + 1), .HEIGHT_LIMIT(`WINDOW_SIZE + 1))
               iic(.input_img(scan_win), .output_img(scan_win_int), .output_img_sq(scan_win_int_sq),
                   .clock, .reset, .enable(1'b1));

  /* choose the current scanning window */
  genvar k, l;
  generate
    for (k=0; k<`WINDOW_SIZE+1; k=k+1) begin: scan_win_row
      for (l=0; l<`WINDOW_SIZE+1; l=l+1) begin: scan_win_column
        assign scan_win[k][l] = (img_index == `IMG_INDEX_DEFAULT) ? 8'd0 : curr_image[row_index+k][col_index+l];
      end
    end
  endgenerate

  

  /* ---------------------------------------------------------------------------
   * FSM -----------------------------------------------------------------------
   */

  logic [31:0] wait_integral_image_count;
  logic vj_pipeline_on;

  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      img_index <= `IMG_INDEX_DEFAULT;
      row_index <= 32'd0;
      col_index <= 32'd0;
      curr_image <= 'd0;
      vj_pipeline_on <= 1'd0;
      wait_integral_image_count <= 32'd0;
    end else begin
      if (laptop_img_rdy) begin
        wait_integral_image_count <= 32'd1;
        curr_image <= laptop_img;
      end
      if ((wait_integral_image_count > 32'd0) && (wait_integral_image_count < `INT_IMG_WAIT)) begin: waiting_for_first_int_img
        wait_integral_image_count <= wait_integral_image_count + 32'd1;
      end
      if (wait_integral_image_count == `INT_IMG_WAIT) begin: turn_on_vj_pipeline
        wait_integral_image_count <= 32'd0;
        vj_pipeline_on <= 1'b1;
        img_index <= `PYRAMID_START;
        row_index <= 32'd0;
        col_index <= 32'd0;
      end
      if (vj_pipeline_on) begin
        if ((img_index == `PYRAMID_LEVELS-1) && (row_index == pyramid_heights[img_index] - `WINDOW_SIZE - 1) &&
            (col_index == pyramid_widths[img_index] - `WINDOW_SIZE - 1) && next_scan_win) begin: vj_pipeline_finished
          img_index <= `IMG_INDEX_DEFAULT;
          row_index <= 32'd0;
          col_index <= 32'd0;
          vj_pipeline_on <= 1'b0;
        end else begin
          if (col_index == pyramid_widths[img_index] - `WINDOW_SIZE - 1 && next_scan_win) begin: row_done
            if (row_index == pyramid_heights[img_index] - `WINDOW_SIZE - 1 && next_scan_win) begin: col_done
              img_index <= img_index + 4'd1;
              row_index <= 32'd0;
              col_index <= 32'd0;
              curr_image <= curr_image_down;
            end else if (next_scan_win) begin: col_not_done
              col_index <= 32'd0;
              row_index <= row_index + 32'd1;
            end
          end else if (next_scan_win) begin: row_not_done
            col_index <= col_index + 32'd1;
          end
        end
      end
    end
  end

endmodule
