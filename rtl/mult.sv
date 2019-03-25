`default_nettype none

module multiplier(
  input  logic [31:0]  a, b,
  output logic [31:0]  out);

  logic [31:0][63:0] partial_products;
  logic [3:0][63:0] intermed_sums;
  logic [31:0][31:0] b_bits;
  logic [63:0] sum;

  genvar i, j, k;
  generate
    for (i = 0; i < 32; i=i+1) begin: find_partial_products
      for (j = 0; j < i; j=j+1) begin: right_zeros
        assign partial_products[i][j] = 1'b0;
      end
      assign partial_products[i][i+32:i] = a & b_bits[i];
      for (k = i+32; k < 64; k=k+1) begin: left_zeros
        assign partial_products[i][k] = 1'b0;
      end
    end
  endgenerate

  genvar l, m;
  generate
    for (l = 0; l < 32; l=l+1) begin: loop_through_b_bits
      for (m = 0; m < 32; m=m+1) begin: extend_32
        b_bits[l][m] = b[l]
      end
    end
  endgenerate

  assign intermed_sums[0] = partial_products[0] + partial_products[1] +
                            partial_products[2] + partial_products[3] + 
                            partial_products[4] + partial_products[5] +
                            partial_products[6] + partial_products[7];
  assign intermed_sums[1] = partial_products[8] + partial_products[9] +
                            partial_products[10] + partial_products[11] + 
                            partial_products[12] + partial_products[13] +
                            partial_products[14] + partial_products[15];
  assign intermed_sums[2] = partial_products[16] + partial_products[17] +
                            partial_products[18] + partial_products[19] + 
                            partial_products[20] + partial_products[21] +
                            partial_products[22] + partial_products[23];
  assign intermed_sums[3] = partial_products[24] + partial_products[25] +
                            partial_products[26] + partial_products[27] + 
                            partial_products[28] + partial_products[29] +
                            partial_products[30] + partial_products[31];
  assign sum = intermed_sums[0] + intermed_sums[1] + intermed_sums[2] + 
               intermed_sums[3];

  assign out = sum[31:0]
  
endmodule