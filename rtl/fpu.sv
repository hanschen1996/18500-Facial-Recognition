`default_nettype none
`define FP_ADD  2'b00
`define FP_MULT 2'b10

`define NAN (32'hFFFFFFFF)

module FPU (Y, A, B, SEL);
`include "fpu_tasks.sv"

  output bit [31:0] Y;
  input  bit [31:0] A,B;
  input  bit        SEL;

  bit        s1, s2, sf;
  bit [7:0]  e1, e2, e1_parse, e2_parse;
  bit [22:0] m1, m2, mf;
  bit        adding, multiplying;
  // mantissas with implied leading 1 and guard bits
  bit [26:0] b1, b2;
  // for addition align step
  bit [7:0]  e_align;
  bit [26:0] b1_align, b2_align;
  bit [27:0] bf_align;
  bit        sticky_bit;
  // for addition normalize step
  bit [26:0] bf_norm;
  bit [9:0]  e_norm;
  bit [4:0]  zeros;
  // for addition round step
  bit [24:0] bf_round;
  bit [9:0]  ef;
  // for multiplication
  bit [47:0] b_mult, b_mult_shift;
  bit [9:0]  e_mult;
  // flags
  bit        A_infty, B_infty, A_nan, B_nan, A_zero, B_zero, A_denorm, B_denorm, 
             overflow, underflow;

  // operation
  assign adding = (SEL == 1'b0);
  assign multiplying = (SEL == 1'b1);
  // parse A and B for IEEE sections
  assign {s1, e1_parse, m1} = A;
  assign {s2, e2_parse, m2} = B;
  // flags for A and B
  assign A_denorm = (e1_parse == 8'd0);
  assign B_denorm = (e2_parse == 8'd0);
  assign A_infty = (e1 == 8'd255) & (m1 == 23'd0);
  assign B_infty = (e2 == 8'd255) & (m2 == 23'd0);
  assign A_nan = (e1 == 8'd255) & (m1 != 23'd0);
  assign B_nan = (e2 == 8'd255) & (m2 != 23'd0);
  assign A_zero = (e1 == 8'd0) & (m1 == 23'd0);
  assign B_zero = (e2 == 8'd0) & (m2 == 23'd0);
  // calculate base and real e1/e2
  assign b1 = {~A_denorm, m1, 3'd0};
  assign b2 = {~B_denorm, m2, 3'd0};
  assign e1 = (A_denorm) ? 8'd1 : e1_parse;
  assign e2 = (B_denorm) ? 8'd1 : e2_parse;
  // flags for Y
  assign overflow = ~underflow & (ef > 10'd254);
  assign underflow = (e_norm[9] == 1'b1);

  always_comb begin: fpu_ops
    if (adding) begin: adding
      // calculate aligned b1 and b2, along with e
      if (e1 > e2) begin
        e_align = e1;
        getSticky_27(b2, e1-e2, sticky_bit);
        b1_align = b1;
        b2_align = (b2 >> (e1-e2)) | sticky_bit;
      end else begin
        e_align = e2;
        getSticky_27(b1, e2-e1, sticky_bit);
        b1_align = (b1 >> (e2-e1)) | sticky_bit;
        b2_align = b2;
      end
      // calculate bf and ef after normalization
      if (s1 != s2) begin
         sf = (b1_align > b2_align) ? s1 : s2;
         bf_align = (b1_align > b2_align) ? b1_align - b2_align : b2_align - b1_align;
         LeadingZeros_27(bf_align[26:0], zeros);
         bf_norm = bf_align[26:0] << zeros;
         e_norm = (e_align < zeros) ? 10'h200 : e_align - zeros;
      end else begin
         sf = s1;
         bf_align = b1_align + b2_align;
         if (bf_align[27] == 1'b1) begin
           bf_norm = bf_align[27:1] | bf_align[0];
           e_norm = e_align + 8'd1;
         end else begin
           LeadingZeros_27(bf_align[26:0], zeros);
           bf_norm = bf_align[26:0] << zeros;
           e_norm = (e_align > zeros) ? e_align - zeros : 10'h200;
         end
      end
      // calculate bf after rounding
      casex (bf_norm[2:0])
        3'b0??: begin
                bf_round = bf_norm[26:3];
                end
        3'b1?1, 
        3'b11?: begin
                bf_round = bf_norm[26:3] + 24'd1;
                end
        3'b100: begin
                bf_round = (bf_norm[3]) ? bf_norm[26:3] + 24'd1 : bf_norm[26:3];
                end
      endcase
      // calculate bf and ef
      if (bf_round[24] == 1'b1) begin
        mf = bf_round[23:1];
        ef = e_norm + 9'd1;
      end else begin
        mf = bf_round[22:0];
        ef = e_norm;
      end
    end else begin: multiplying
      b_mult = b1[26:3] * b2[26:3];
      e_mult = e1 + e2;
      sf = s1 ^ s2;
      // truncate and get sticky bits
      if (b_mult[47] == 1'b1) begin
        e_norm = (e_mult > 10'd126) ? e_mult + 10'd1 : 10'h200;
        sticky_bit = | b_mult[21:0];
        bf_norm = {b_mult[47:22], sticky_bit};
      end else begin
        LeadingZeros_47(b_mult[46:0], zeros);
        e_norm = (e_mult > 10'd127 + zeros) ? e_mult - zeros : 10'h200;
        b_mult_shift = b_mult << zeros;
        sticky_bit = | b_mult_shift[20:0];
        bf_norm = {b_mult_shift[46:21], sticky_bit};
      end
      casex (bf_norm[2:0])
        3'b0??: begin
                bf_round = bf_norm[26:3];
                end
        3'b1?1, 
        3'b11?: begin
                bf_round = bf_norm[26:3] + 24'd1;
                end
        3'b100: begin
                bf_round = (bf_norm[3]) ? bf_norm[26:3] + 24'd1 : bf_norm[26:3];
                end
      endcase
      mf = bf_round[22:0];
      ef = e_norm - 10'd127;
    end
  end

  always_comb begin
    if (A_nan | B_nan) Y = {1'b0, 8'd255, 23'h7FFFFF};
    // treat denorm result as underflow
    else if (adding) begin
      if (A_infty & B_infty & (s1^s2)) Y = {1'b1, 8'd255, 23'h7FFFFF};
      else if (A_infty) Y = A;
      else if (B_infty) Y = B;
      else if (A_zero) Y = B;
      else if (B_zero) Y = A;
      else if ((b1 == b2) & (s1^s2)) Y = {1'b1, 8'd0, 23'd0};
      else if (overflow) Y = {1'b0, 8'd255, 23'd0};
      else if (underflow) Y = {1'b0, 8'd0, 23'd0};
      else Y = {sf, ef[7:0], mf};
    end else begin
      if (A_infty | B_infty) Y = {s1^s2, 8'd255, 23'd0};
      else if (A_zero) Y = A;
      else if (B_zero) Y = B;
      else if (overflow) Y = {1'b0, 8'd255, 23'd0};
      else if (underflow) Y = {1'b0, 8'd0, 23'd0};
      else Y = {sf, ef[7:0], mf};
    end
  end

endmodule : FPU