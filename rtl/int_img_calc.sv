`default_nettype none
`include "vj_weights.vh"

module int_img_calc
  #(parameter WIDTH_LIMIT = `LAPTOP_WIDTH, HEIGHT_LIMIT = `LAPTOP_HEIGHT)(
  input  logic [HEIGHT_LIMIT-1:0][WIDTH_LIMIT-1:0][7:0] input_img,
  input  logic clock, reset, enable,
  output logic [HEIGHT_LIMIT-1:0][WIDTH_LIMIT-1:0][17:0] output_img,
  output logic [HEIGHT_LIMIT-1:0][WIDTH_LIMIT-1:0][31:0] output_img_sq);

  logic [HEIGHT_LIMIT-1:0][WIDTH_LIMIT-1:0][15:0] input_img_sq;
  logic [HEIGHT_LIMIT-1:0][WIDTH_LIMIT-1:0][17:0] saved_input_img, input_img_sum;
  logic [HEIGHT_LIMIT-1:0][WIDTH_LIMIT-1:0][31:0] saved_input_img_sq, input_img_sq_sum;
  logic [1:0] clock_count;

  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      saved_input_img <= 'd0;
      saved_input_img_sq <= 'd0;      
    end else if (enable) begin
      for (int i = 0; i < HEIGHT_LIMIT; i=i+1) begin: add_rows
        for (int j = 0; j < WIDTH_LIMIT; j=j+1) begin: iter_cols
          saved_input_img[i][j] <= input_img_sum[i][j];
          saved_input_img_sq[i][j] <= input_img_sq_sum[i][j];
        end
      end
    end
  end

  genvar m, n;
  generate
    for (m = 0; m < HEIGHT_LIMIT; m=m+1) begin
      assign input_img_sum[m][0] = input_img[m][0];
      assign input_img_sq_sum[m][0] = input_img_sq[m][0];
      for (n = 1; n < WIDTH_LIMIT; n=n+1) begin
        assign input_img_sum[m][n] = input_img[m][n] + input_img_sum[m][n-1];
        assign input_img_sq_sum[m][n] = input_img_sq[m][n] + input_img_sq_sum[m][n-1];
      end
    end
  endgenerate

  genvar o, p;
  generate
    for (o = 0; o < WIDTH_LIMIT; o=o+1) begin
      assign output_img[0][o] = saved_input_img[0][o];
      assign output_img_sq[0][o] = saved_input_img_sq[0][o];
      for (p = 1; p < HEIGHT_LIMIT; p=p+1) begin
        assign output_img[p][o] = saved_input_img[p][o] + output_img[p-1][o];
        assign output_img_sq[p][o] = saved_input_img_sq[p][o] + output_img_sq[p-1][o];
      end
    end
  endgenerate

  genvar q, r;
  generate
    for (q = 0; q < HEIGHT_LIMIT; q=q+1) begin: multiplier_row
      for (r = 0; r < WIDTH_LIMIT; r=r+1) begin: multiplier_column
        mult_gen_0 m(.P(input_img_sq[q][r]), .A(input_img[q][r]), .B(input_img[q][r]));
        //assign input_img_sq[q][r] = input_img[q][r] * input_img[q][r];
      end
    end
  endgenerate

endmodule
