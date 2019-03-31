`default_nettype none
`include "vj_weights.vh"

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

