`default_nettype none
`include "vj_weights.vh"

module int_img_calc
  #(parameter WIDTH_LIMIT = `LAPTOP_WIDTH, HEIGHT_LIMIT = `LAPTOP_HEIGHT)(
  input  logic [HEIGHT_LIMIT-1:0][WIDTH_LIMIT-1:0][7:0] input_img,
  output logic [HEIGHT_LIMIT-1:0][WIDTH_LIMIT-1:0][31:0] output_img, output_img_sq);

  logic [HEIGHT_LIMIT-1:0][WIDTH_LIMIT-1:0][31:0] input_img_sq;
  assign output_img[0][0] = {24'd0, input_img[0][0]};
  assign output_img_sq[0][0] = input_img_sq[0][0];

  genvar i, j, k, l;
  generate
    for (i = 1; i < WIDTH_LIMIT; i=i+1) begin: top_row
      assign output_img[0][i] = {24'd0, input_img[0][i]} + output_img[0][i-1];
      assign output_img_sq[0][i] = input_img_sq[0][i] + output_img_sq[0][i-1];
    end
    for (j = 1; j < HEIGHT_LIMIT; j=j+1) begin: left_column
      assign output_img[j][0] = {24'd0, input_img[j][0]} + output_img[j-1][0];
      assign output_img_sq[j][0] = input_img_sq[j][0] + output_img_sq[j-1][0];
    end
    for (k = 1; k < HEIGHT_LIMIT; k=k+1) begin: rest_of_rows
      for (l = 1; l < WIDTH_LIMIT; l=l+1) begin: rest_of_columns
        assign output_img[k][l] = {24'd0, input_img[k][l]} + output_img[k][l-1] + output_img[k-1][l] - output_img[k-1][l-1];
        assign output_img_sq[k][l] = input_img_sq[k][l] + output_img_sq[k][l-1] + output_img_sq[k-1][l] - output_img_sq[k-1][l-1];
      end
    end
  endgenerate

  genvar m, n;
  generate
    for (m = 0; m < HEIGHT_LIMIT; m=m+1) begin: multiplier_row
      for (n = 0; n < WIDTH_LIMIT; n=n+1) begin: multiplier_column
        mult_8 m(.out(input_img_sq[m][n]), .a(input_img[m][n]), .b(input_img[m][n]));
      end
    end
  endgenerate

endmodule
