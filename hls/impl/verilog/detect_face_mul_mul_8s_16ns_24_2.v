
`timescale 1 ns / 1 ps

  module detect_face_mul_mul_8s_16ns_24_2_DSP48_0(clk, rst, ce, a, b, p);
input clk;
input rst;
input ce;
input signed [8 - 1 : 0] a; 
input [16 - 1 : 0] b; 
output signed [24 - 1 : 0] p; 

reg signed [24 - 1 : 0] p_reg; 


always @ (posedge clk) begin
    if (rst) begin
        p_reg <= 0;
    end else
    if (ce) begin
        p_reg <= $signed (a) * $signed ({1'b0, b});
    end
end

assign p = p_reg;

endmodule

`timescale 1 ns / 1 ps
module detect_face_mul_mul_8s_16ns_24_2(
    clk,
    reset,
    ce,
    din0,
    din1,
    dout);

parameter ID = 32'd1;
parameter NUM_STAGE = 32'd1;
parameter din0_WIDTH = 32'd1;
parameter din1_WIDTH = 32'd1;
parameter dout_WIDTH = 32'd1;
input clk;
input reset;
input ce;
input[din0_WIDTH - 1:0] din0;
input[din1_WIDTH - 1:0] din1;
output[dout_WIDTH - 1:0] dout;



detect_face_mul_mul_8s_16ns_24_2_DSP48_0 detect_face_mul_mul_8s_16ns_24_2_DSP48_0_U(
    .clk( clk ),
    .rst( reset ),
    .ce( ce ),
    .a( din0 ),
    .b( din1 ),
    .p( dout ));

endmodule

