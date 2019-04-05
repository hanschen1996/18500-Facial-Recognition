`include "vj_weights.vh"

module int_img_calc_tb();

  logic [9:0][9:0][7:0] input_img;
  logic [9:0][9:0][31:0] output_img, output_img_sq;
  logic clock, reset;
  logic enable;
  int_img_calc #(.WIDTH_LIMIT(10),
               .HEIGHT_LIMIT(10))
             dut(.input_img, .output_img, .output_img_sq, .reset, .clock, .enable);
  
  initial begin
    clock = 1'b0;
    forever #5 clock = ~clock;
  end                 
  
  initial begin
    reset = 1'b0;
    #1;
    reset = 1'b1;
    #1;
    reset = 1'b0;
    $display("-----------------original image--------------------------");
    for (int i = 0; i < 10; i=i+1) begin
      for (int j = 0; j < 10; j=j+1) begin
        input_img[i][j] = 8'hff;
        $write("%0d ", input_img[i][j]);
      end
      $write("\n");
    end

    #1;
    
    $display("-----------------original image sq-----------------------");
    for (int i = 0; i < 10; i ++) begin
      for (int j = 0; j < 10; j ++) begin
        $write("%0d ", dut.input_img_sq[i][j]);
      end
      $write("\n");
    end
    
    enable = 1'b1;
    @(posedge clock);
    #1;

    $display("-----------------integral image rows summed--------------------------");
    for (int i = 0; i < 10; i=i+1) begin
      for (int j = 0; j < 10; j=j+1) begin
        $write("%0d ", dut.saved_input_img[i][j]);
      end
      $write("\n");
    end

    $display("-----------------integral image sq rows summed-----------------------");
    for (int i = 0; i < 10; i=i+1) begin
      for (int j = 0; j < 10; j=j+1) begin
        $write("%0d ", dut.saved_input_img_sq[i][j]);
      end
      $write("\n");
    end
    
    @(posedge clock);
    #1;

    $display("-----------------integral image cols summed--------------------------");
    for (int i = 0; i < 10; i=i+1) begin
      for (int j = 0; j < 10; j=j+1) begin
        $write("%0h ", output_img[i][j][7:0]);
      end
      $write("\n");
    end

    $display("-----------------integral image sq cols summed-----------------------");
    for (int i = 0; i < 10; i=i+1) begin
      for (int j = 0; j < 10; j=j+1) begin
        $write("%0h ", output_img_sq[i][j][7:0]);
      end
      $write("\n");
    end

    #1;

    $finish;
  end

endmodule
