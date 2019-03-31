`default_nettype none
`include "vj_weights.vh"

module downscaler
  #(parameter WIDTH_LIMIT = `LAPTOP_WIDTH, HEIGHT_LIMIT = `LAPTOP_HEIGHT)(
  input  logic [3:0] pyramid_index,
  input  logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][31:0] input_img,
  output logic [HEIGHT_LIMIT-1:0][WIDTH_LIMIT-1:0][31:0] output_img);

  localparam [`LAPTOP_HEIGHT-1:0][31:0] y_mappings;
  localparam [`LAPTOP_WIDTH-1:0][31:0] x_mappings;

  always_comb begin: choose_mappings
    case (pyramid_index)
      4'd1: begin
            y_mappings = `PYRAMID1_Y_MAPPINGS;
            x_mappings = `PYRAMID1_X_MAPPINGS;
            end
      4'd2: begin
            y_mappings = `PYRAMID2_Y_MAPPINGS;
            x_mappings = `PYRAMID2_X_MAPPINGS;
            end
      4'd3: begin
            y_mappings = `PYRAMID3_Y_MAPPINGS;
            x_mappings = `PYRAMID3_X_MAPPINGS;
            end
      4'd4: begin
            y_mappings = `PYRAMID4_Y_MAPPINGS;
            x_mappings = `PYRAMID4_X_MAPPINGS;
            end
      4'd5: begin
            y_mappings = `PYRAMID5_Y_MAPPINGS;
            x_mappings = `PYRAMID5_X_MAPPINGS;
            end
      4'd6: begin
            y_mappings = `PYRAMID6_Y_MAPPINGS;
            x_mappings = `PYRAMID6_X_MAPPINGS;
            end
      4'd7: begin
            y_mappings = `PYRAMID7_Y_MAPPINGS;
            x_mappings = `PYRAMID7_X_MAPPINGS;
            end
      4'd8: begin
            y_mappings = `PYRAMID8_Y_MAPPINGS;
            x_mappings = `PYRAMID8_X_MAPPINGS;
            end
      4'd9: begin
            y_mappings = `PYRAMID9_Y_MAPPINGS;
            x_mappings = `PYRAMID9_X_MAPPINGS;
            end
      default: begin
            y_mappings = 'd0;
            x_mappings = 'd0;
            end
    endcase // pyramid_index
  end

  genvar i, j, k, l, m;
  generate
    for (i = 0; i < HEIGHT_LIMIT; i=i+1) begin: downscaled_row
      for (j = 0; j < WIDTH_LIMIT; j=j+1) begin: downscaled_pixels_in_row
        assign output_img[i][j] = input_img[y_mappings[i]][x_mappings[j]];
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

module downscaler_call();

  localparam [`PYRAMID_LEVELS-1:0][31:0] pyramid_widths= `PYRAMID_WIDTHS;
  localparam [`PYRAMID_LEVELS-1:0][31:0] pyramid_heights = `PYRAMID_HEIGHTS;
  logic [pyramid_heights[9]-1:0][pyramid_widths[9]-1:0][31:0] images0;
  logic [pyramid_heights[0]-1:0][pyramid_widths[0]-1:0][31:0] images9;
  logic [pyramid_widths[0]-1:0][31:0] pyramid1_x_ratios = `PYRAMID9_X_RATIOS;
  logic [pyramid_heights[0]-1:0][31:0] pyramid1_y_ratios = `PYRAMID9_Y_RATIOS;

  downscaler #(.WIDTH_LIMIT(pyramid_widths[0]),
               .HEIGHT_LIMIT(pyramid_heights[0]))
             down1(.input_img(images0), .x_ratio(pyramid1_x_ratios),
                   .y_ratio(pyramid1_y_ratios), .output_img(images9));

endmodule