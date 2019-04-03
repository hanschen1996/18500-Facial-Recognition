`default_nettype none
`include "vj_weights.vh"

module downscaler
  #(parameter WIDTH_LIMIT = `LAPTOP_WIDTH, HEIGHT_LIMIT = `LAPTOP_HEIGHT,
    PYRAMID_INDEX = 1)(
  input  logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][31:0] input_img,
  output logic [HEIGHT_LIMIT-1:0][WIDTH_LIMIT-1:0][31:0] output_img);

  localparam [`PYRAMID_LEVELS-1:0][`LAPTOP_HEIGHT-1:0][7:0] all_y_mappings = `PYRAMID_Y_MAPPINGS;
  localparam [`PYRAMID_LEVELS-1:0][`LAPTOP_WIDTH-1:0][7:0] all_x_mappings = `PYRAMID_X_MAPPINGS;

  genvar i, j, k, l, m;
  generate
    for (i = 0; i < HEIGHT_LIMIT; i=i+1) begin: downscaled_row
      for (j = 0; j < WIDTH_LIMIT; j=j+1) begin: downscaled_pixels_in_row
        assign output_img[i][j][7:0] = input_img[all_y_mappings[PYRAMID_INDEX][i]][all_x_mappings[PYRAMID_INDEX][j]][7:0];
      end
    end
  endgenerate

endmodule
/*
module downscaler_call();

  localparam [`PYRAMID_LEVELS-1:0][31:0] pyramid_widths= `PYRAMID_WIDTHS;
  localparam [`PYRAMID_LEVELS-1:0][31:0] pyramid_heights = `PYRAMID_HEIGHTS;
  logic [pyramid_heights[0]-1:0][pyramid_widths[0]-1:0][31:0] images0;
  logic [pyramid_heights[8]-1:0][pyramid_widths[8]-1:0][31:0] images8;

  downscaler #(.PYRAMID_INDEX(7),
               .WIDTH_LIMIT(pyramid_widths[8]),
               .HEIGHT_LIMIT(pyramid_heights[8]))
             down1(.input_img(images0), .output_img(images8));

endmodule
*/
