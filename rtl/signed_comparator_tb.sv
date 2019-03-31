`default_nettype none

module signed_comparator_tb();

  logic [31:0] A, B;
  logic gt;
  
  signed_comparator s(.*);
  
  initial begin
    A = -32'sd1;
    B = 32'd1;
    #10
    $display("-1 gt than 1 gives %0d", gt);
    A = -32'sd9348;
    B = 32'd754;
    #10
    $display("-9348 gt than 754 gives %0d", gt);
    A = 32'd1;
    B = -32'sd1;
    #10
    $display("1 gt than -1 gives %0d", gt);
    A = 32'd349;
    B = -32'sd2309;
    #10
    $display("349 gt than -2309 gives %0d", gt);
    A = 32'd984;
    B = 32'd34;
    #10
    $display("984 gt than 34 gives %0d", gt);
    A = 32'd24;
    B = 32'd2398;
    #10
    $display("24 gt than 2398 gives %0d", gt);
    A = 32'd232;
    B = 32'd232;
    #10
    $display("232 gt than 232 gives %0d", gt);
    A = -32'sd345;
    B = -32'sd345;
    #10
    $display("-345 gt than -345 gives %0d", gt);
    A = -32'sd234;
    B = -32'sd9348;
    #10
    $display("-234 gt than -9348 gives %0d", gt);
    A = -32'sd345345;
    B = -32'sd9348;
    #10
    $display("-345345 gt than -9348 gives %0d", gt);
    #10;
    $finish;
  end

endmodule