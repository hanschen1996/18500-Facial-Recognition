`default_nettype none
`include "vj_weights.vh"

module blk_mem_gen_r1x1(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [4:0] dina,
  output logic [4:0] douta);

  logic [`NUM_FEATURE-1:0][4:0] memory;
  assign memory = `RECTANGLE1_X1;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_r1y1(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [4:0] dina,
  output logic [4:0] douta);

  logic [`NUM_FEATURE-1:0][4:0] memory;
  assign memory = `RECTANGLE1_Y1;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_r1x2(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [4:0] dina,
  output logic [4:0] douta);

  logic [`NUM_FEATURE-1:0][4:0] memory;
  assign memory = `RECTANGLE1_X2;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_r1y2(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [4:0] dina,
  output logic [4:0] douta);

  logic [`NUM_FEATURE-1:0][4:0] memory;
  assign memory = `RECTANGLE1_Y2;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_r2x1(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [4:0] dina,
  output logic [4:0] douta);

  logic [`NUM_FEATURE-1:0][4:0] memory;
  assign memory = `RECTANGLE2_X1;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_r2y1(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [4:0] dina,
  output logic [4:0] douta);

  logic [`NUM_FEATURE-1:0][4:0] memory;
  assign memory = `RECTANGLE2_Y1;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_r2x2(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [4:0] dina,
  output logic [4:0] douta);

  logic [`NUM_FEATURE-1:0][4:0] memory;
  assign memory = `RECTANGLE2_X2;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_r2y2(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [4:0] dina,
  output logic [4:0] douta);

  logic [`NUM_FEATURE-1:0][4:0] memory;
  assign memory = `RECTANGLE2_Y2;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_r3x1(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [4:0] dina,
  output logic [4:0] douta);

  logic [`NUM_FEATURE-1:0][4:0] memory;
  assign memory = `RECTANGLE3_X1;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_r3y1(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [4:0] dina,
  output logic [4:0] douta);

  logic [`NUM_FEATURE-1:0][4:0] memory;
  assign memory = `RECTANGLE3_Y1;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_r3x2(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [4:0] dina,
  output logic [4:0] douta);

  logic [`NUM_FEATURE-1:0][4:0] memory;
  assign memory = `RECTANGLE3_X2;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_r3y2(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [4:0] dina,
  output logic [4:0] douta);

  logic [`NUM_FEATURE-1:0][4:0] memory;
  assign memory = `RECTANGLE3_Y2;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_r1w(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [31:0] dina,
  output logic [31:0] douta);

  logic [`NUM_FEATURE-1:0][31:0] memory;
  assign memory = `RECTANGLE1_WEIGHTS;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_r2w(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [31:0] dina,
  output logic [31:0] douta);

  logic [`NUM_FEATURE-1:0][31:0] memory;
  assign memory = `RECTANGLE2_WEIGHTS;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_r3w(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [31:0] dina,
  output logic [31:0] douta);

  logic [`NUM_FEATURE-1:0][31:0] memory;
  assign memory = `RECTANGLE3_WEIGHTS;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_fa(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [31:0] dina,
  output logic [31:0] douta);

  logic [`NUM_FEATURE-1:0][31:0] memory;
  assign memory = `FEATURE_ABOVE;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_fb(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [31:0] dina,
  output logic [31:0] douta);

  logic [`NUM_FEATURE-1:0][31:0] memory;
  assign memory = `FEATURE_BELOW;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_ft(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [31:0] dina,
  output logic [31:0] douta);

  logic [`NUM_FEATURE-1:0][31:0] memory;
  assign memory = `FEATURE_THRESHOLD;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_st(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic [31:0] dina,
  output logic [31:0] douta);

  logic [`NUM_FEATURE-1:0][31:0] memory;
  assign memory = `STAGE_THRESHOLD;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module blk_mem_gen_ise(
  input logic clka, wea,
  input logic [11:0] addra, 
  input logic dina,
  output logic douta);

  logic [`NUM_FEATURE-1:0] memory;
  assign memory = `IS_STAGE_END;

  always_ff @(posedge clka) begin
    douta <= memory[addra];
  end

endmodule

module mult_gen_0(
  input  logic [7:0] A, B,
  output logic [15:0] P);

  always_comb begin
    P = A * B;
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

module mult_gen_2(
  input  logic [31:0] A, B,
  output logic [31:0] P);

  always_comb begin
    P = A * B;
  end

endmodule

module clk_wiz_0 (
  output logic clk_out1, 
  input  logic reset, clk_in1_p, clk_in1_n);

  assign clk_out1 = clk_in1_p;

endmodule