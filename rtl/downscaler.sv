`default_nettype none
`include "vj_weights.vh"

module downscaler(
  input  logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][7:0] input_img,
  output logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][7:0] output_img);

  genvar i, j;
  generate
    for (i = 0; i < 96; i=i+1) begin: downscaled_row
      for (j = 0; j < 128; j=j+1) begin: downscaled_pixels_in_row
        assign output_img[i][j] = input_img[i + i[31:2]][j + j[31:2]];
      end
    end
  endgenerate

endmodule