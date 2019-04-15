`default_nettype none
`include "vj_weights.vh"

module block_mem_gen_0(
  input logic [`NUM_FEATURE-1:0][4:0] memory,
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [4:0] dina,
  output logic [4:0] douta);

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module block_mem_gen_1(
  input logic [`NUM_FEATURE-1:0][31:0] memory,
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [31:0] dina,
  output logic [31:0] douta);

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module block_mem_gen_2(
  input logic [`NUM_FEATURE-1:0] memory,
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic dina,
  output logic douta);

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module mult_gen_0(
  input  logic [7:0] A, B,
  input  logic CLK,
  output logic [15:0] P);

  always_ff @(posedge CLK) begin
    P <= A * B;
  end

endmodule

module mult_gen_1(
  input  logic [31:0] A, B,
  input  logic CLK,
  output logic [31:0] P);

  always_ff @(posedge CLK) begin
    P <= A * B;
  end

endmodule

module clk_wiz_0 (
  output logic clk_out1, 
  input  logic reset, clk_in1_p, clk_in1_n);

  assign clk_out1 = clk_in1_p;

endmodule