`default_nettype none

module signed_comparator(
  input  logic [31:0] A, B,
  output logic gt);

  always_comb begin
    if (A[31] & ~B[31]) begin // A is negative, B is positive
      gt = 1'b0;
    end else if (~A[31] & B[31]) begin // A is positive, B is negative
      gt = 1'b1;
    end else if (A[31]) begin // both are same sign
      gt = A > B;
    end
  end

endmodule