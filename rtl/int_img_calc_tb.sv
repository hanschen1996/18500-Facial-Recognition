`include "vj_weights.vh"

module int_img_calc_tb();

  logic [9:0][9:0][7:0] input_img;
  logic [9:0][9:0][31:0] output_img, output_img_sq;
  int_img_calc #(.WIDTH_LIMIT(10),
               .HEIGHT_LIMIT(10))
             down1(.input_img, .output_img, .output_img_sq);
                   
  initial begin
    $display("-----------------original image--------------------------");
    for (int i = 0; i < 10; i=i+1) begin
      for (int j = 0; j < 10; j=j+1) begin
        input_img[i][j] = i + j;
        $write("%0d ", input_img[i][j]);
      end
      $write("\n");
    end
    #10 
    $display("-----------------original image sq-----------------------");
    for (int i = 0; i < 10; i ++) begin
      for (int j = 0; j < 10; j ++) begin
        $write("%0d ", down1.input_img_sq[i][j]);
      end
      $write("\n");
    end
    #10
    $display("-----------------integral image--------------------------");
    for (int i = 0; i < 10; i=i+1) begin
      for (int j = 0; j < 10; j=j+1) begin
        $write("%0d ", output_img[i][j]);
      end
      $write("\n");
    end
    $display("-----------------integral image sq-----------------------");
    for (int i = 0; i < 10; i=i+1) begin
      for (int j = 0; j < 10; j=j+1) begin
        $write("%0d ", output_img_sq[i][j]);
      end
      $write("\n");
    end
    #10
    $finish;
  end

endmodule
