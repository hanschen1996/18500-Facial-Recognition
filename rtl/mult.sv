//`default_nettype none

module multiplier(
  input  wire logic [31:0]  a, b,
  output wire logic [31:0]  out);

  logic [31:0][31:0] partial_products;
  logic [3:0][31:0] intermed_sums;
  logic [31:0] sum;


  /*
     10110
      1001
     -----
     10110
    00000
   00000
  10110
  --------
  11000110
  */
  genvar i, j, k;
  generate
    for (i = 0; i < 32; i=i+1) begin: find_partial_products
      for (j = 0; j < i; j=j+1) begin: right_zeros
        assign partial_products[i][j] = 1'b0;
      end
      for (k = i; k < 32; k=k+1) begin: remaining
        assign partial_products[i][k] = a[k-i] & b[i];
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

  assign out = sum;
  
endmodule