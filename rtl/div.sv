`default_nettype none

// unsigned divider
// takes 32-bit input dividend a, 16-bit divisor b
// returns 16-bit quotient out 
module div
( input   logic [31:0]  a,
  input   logic [15:0]  b,
  output  logic [15:0]  out);

  // implements non-restoring division

  // outputs of each subtractor
  logic [16:0] diff17;
  logic [17:0] diff18;
  logic [18:0] diff19;
  logic [19:0] diff20;
  logic [20:0] diff21;
  logic [21:0] diff22;
  logic [22:0] diff23;
  logic [23:0] diff24;
  logic [24:0] diff25;
  logic [25:0] diff26;
  logic [26:0] diff27;
  logic [27:0] diff28;
  logic [28:0] diff29;
  logic [29:0] diff30;
  logic [30:0] diff31;
  logic [31:0] diff32;

  // adder subtractors for each level of dividing
  add_sub_2c #(17)   as17(.A(a[31:15]),         .B({ 1'd0, b}), 
                          .sub(1'b1),        .S(diff17));
  add_sub_2c #(18)   as18(.A({diff17,  a[14]}), .B({ 2'd0, b}), 
                          .sub(~diff17[16]), .S(diff18));
  add_sub_2c #(19)   as19(.A({diff18,  a[13]}), .B({ 3'd0, b}), 
                          .sub(~diff18[17]), .S(diff19));
  add_sub_2c #(20)   as20(.A({diff19,  a[12]}), .B({ 4'd0, b}), 
                          .sub(~diff19[18]), .S(diff20));
  add_sub_2c #(21)   as21(.A({diff20,  a[11]}), .B({ 5'd0, b}), 
                          .sub(~diff20[19]), .S(diff21));
  add_sub_2c #(22)   as22(.A({diff21,  a[10]}), .B({ 6'd0, b}), 
                          .sub(~diff21[20]), .S(diff22));
  add_sub_2c #(23)   as23(.A({diff22,  a[ 9]}), .B({ 7'd0, b}), 
                          .sub(~diff22[21]), .S(diff23));
  add_sub_2c #(24)   as24(.A({diff23,  a[ 8]}), .B({ 8'd0, b}), 
                          .sub(~diff23[22]), .S(diff24));
  add_sub_2c #(25)   as25(.A({diff24,  a[ 7]}), .B({ 9'd0, b}), 
                          .sub(~diff24[23]), .S(diff25));
  add_sub_2c #(26)   as26(.A({diff25,  a[ 6]}), .B({10'd0, b}), 
                          .sub(~diff25[24]), .S(diff26));
  add_sub_2c #(27)   as27(.A({diff26,  a[ 5]}), .B({11'd0, b}), 
                          .sub(~diff26[25]), .S(diff27));
  add_sub_2c #(28)   as28(.A({diff27,  a[ 4]}), .B({12'd0, b}), 
                          .sub(~diff27[26]), .S(diff28));
  add_sub_2c #(29)   as29(.A({diff28,  a[ 3]}), .B({13'd0, b}), 
                          .sub(~diff28[27]), .S(diff29));
  add_sub_2c #(30)   as30(.A({diff29,  a[ 2]}), .B({14'd0, b}), 
                          .sub(~diff29[28]), .S(diff30));
  add_sub_2c #(31)   as31(.A({diff30,  a[ 1]}), .B({15'd0, b}), 
                          .sub(~diff30[29]), .S(diff31));
  add_sub_2c #(32)   as32(.A({diff31,  a[ 0]}), .B({16'd0, b}), 
                          .sub(~diff31[30]), .S(diff32));
  
  assign out = {~diff17[16], ~diff18[17], ~diff19[18], ~diff20[19], ~diff21[20],
                ~diff22[21], ~diff23[22], ~diff24[23], ~diff25[24], ~diff26[25], 
                ~diff27[26], ~diff28[27], ~diff29[28], ~diff30[29], ~diff31[30]};

endmodule: div

module add_sub_2c
  #(parameter N = 16) (
  input  logic [N-1:0] A, B,
  input  logic         sub,
  output logic [N-1:0] S,
  output logic         overflow);

  logic [N-1:0] xor_outs, carry_outs, carry_ins;
  genvar i;

  assign carry_ins[0] = sub;

  generate
    for (i = 0; i < N; i=i+1) begin: fa_and_xors
      assign xor_outs[i] = sub ^ B[i];
      assign {carry_outs[i], S[i]} = xor_outs[i] + A[i] + carry_ins[i];
    end
    for (i = 1; i < N; i=i+1) begin: connect_Cin_Cout
      assign carry_ins[i] = carry_outs[i-1];
    end
  endgenerate

endmodule: add_sub_2c