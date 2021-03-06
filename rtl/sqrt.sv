`default_nettype none

module sqrt(
  input logic [31:0] val,
  output logic [15:0] res);

  logic [16:0][31:0] left_shifts;
  logic [16:1][17:0] lefts, rights;
  logic [16:0][17:0] remainders;
  logic [16:0][15:0] qs;

  assign left_shifts[0] = val;
  assign qs[0] = 16'd0;
  assign remainders[0] = 18'd0;

  genvar i;
  generate
    for (i=0; i<16; i=i+1) begin 
      assign left_shifts[i+1] = {left_shifts[i][29:0], 2'd0};
      assign lefts[i+1] = {remainders[i][15:0], left_shifts[i][31:30]};
      assign rights[i+1] = {qs[i], remainders[i][17], 1'b1};
      assign remainders[i+1] = (remainders[i][17]) ? lefts[i+1] + rights[i+1] : lefts[i+1] - rights[i+1];
      assign qs[i+1] = {qs[i][14:0], ~remainders[i+1][17]};
    end
  endgenerate

  assign res = qs[16];

endmodule 
/*
module sqrt_tb();

  logic [31:0] val;
  logic [15:0] res;

  sqrt dut(.*);

  localparam length = 5;

  logic [length-1:0][31:0] vals = {32'd784638647, 32'd9, 32'd225, 32'd2983, 32'd3300}; //28011

  initial begin
    for (int i = 0; i < 5; i++) begin 
      val = vals[i];
      #1 $display("sqrt of %0d is %0d", val, res);
      #1;
    end
    #10;
    $finish;
  end

endmodule
*/