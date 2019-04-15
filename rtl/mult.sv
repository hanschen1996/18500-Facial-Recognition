`default_nettype none

module mult_8(
  input  logic [7:0] a, b,
  output logic [31:0] out);

  // two 8-bit numbers multiply to at most 16 bits
  logic [7:0][15:0] partial_products;

  assign partial_products[0][7:0] = b[0] ? a : 'b0;
  assign partial_products[0][15:8] = 8'b0;

  assign partial_products[1][8:1] = b[1] ? a : 'b0;
  assign partial_products[1][15:9] = 7'b0;
  assign partial_products[1][0] = 1'b0;

  assign partial_products[2][9:2] = b[2] ? a : 'b0;
  assign partial_products[2][15:10] = 6'b0;
  assign partial_products[2][1:0] = 2'b0;

  assign partial_products[3][10:3] = b[3] ? a : 'b0;
  assign partial_products[3][15:11] = 5'b0;
  assign partial_products[3][2:0] = 3'b0;

  assign partial_products[4][11:4] = b[4] ? a : 'b0;
  assign partial_products[4][15:12] = 4'b0;
  assign partial_products[4][3:0] = 4'b0;

  assign partial_products[5][12:5] = b[5] ? a : 'b0;
  assign partial_products[5][15:13] = 3'b0;
  assign partial_products[5][4:0] = 5'b0;

  assign partial_products[6][13:6] = b[6] ? a : 'b0;
  assign partial_products[6][15:14] = 2'b0;
  assign partial_products[6][5:0] = 6'b0;

  assign partial_products[7][14:7] = b[7] ? a : 'b0;
  assign partial_products[7][15] = 1'b0;
  assign partial_products[7][6:0] = 7'b0;

  assign out[31:16] = 16'b0;
  assign out[15:0] = partial_products[0] + partial_products[1] + partial_products[2] +
                     partial_products[3] + partial_products[4] + partial_products[5] +
                     partial_products[6] + partial_products[7];

endmodule

module multiplier(
  input  logic [31:0]  a, b,
  output logic [31:0]  out);

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
