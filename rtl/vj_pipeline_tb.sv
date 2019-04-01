`include "vj_weights.vh"

module accum_calculator_tb();

  logic [`WINDOW_SIZE:0][`WINDOW_SIZE:0][31:0] input_img, scan_win, scan_win_sq;
  logic [31:0] scan_win_std_dev;
  logic [31:0] feature_accum;

  accum_calculator #(.RECT1_X(0), .RECT1_Y(0), .RECT1_WIDTH(6), .RECT1_HEIGHT(6), .RECT1_WEIGHT(1),
                     .RECT2_X(6), .RECT2_Y(6), .RECT2_WIDTH(6), .RECT2_HEIGHT(6), .RECT2_WEIGHT(1),
                     .RECT3_X(4), .RECT3_Y(4), .RECT3_WIDTH(4), .RECT3_HEIGHT(4), .RECT3_WEIGHT(-1),
                     .FEAT_THRES(2), .FEAT_ABOVE(6), .FEAT_BELOW(-6))
                   calc(.scan_win, .scan_win_std_dev, .feature_accum);

  int_img_calc #(.WIDTH_LIMIT(`WINDOW_SIZE+1),
                 .HEIGHT_LIMIT(`WINDOW_SIZE+1))
               down1(.input_img, .output_img(scan_win), .output_img_sq(scan_win_sq));

  window_std_dev stddev(.scan_win, .scan_win_sq, .scan_win_std_dev);
                   
  initial begin
    for (int i = 0; i < `WINDOW_SIZE+1; i=i+1) begin
      for (int j = 0; j < `WINDOW_SIZE+1; j=j+1) begin
        input_img[i][j] = 2;
      end
    end
    #10
    $display("----------------------------------------------------------");
    for (int i = 0; i < `WINDOW_SIZE+1; i=i+1) begin
      for (int j = 0; j < `WINDOW_SIZE+1; j=j+1) begin
        $write("%0d,", scan_win[i][j]);
      end
      $write("\n");
    end
    #10

    $display("standard deviation: %d", scan_win_std_dev);
    $display("rectangle1 val: %d, rectangle2 val: %d, rectangle3 val: %d",
             calc.rectangle1_val,
             calc.rectangle2_val,
             calc.rectangle3_val);
    $display("feature sum: %d", calc.feature_sum);
    $display("threshold*stddev: %d", calc.feature_product);
    $display("greater? %d", calc.feature_comparison);
    $display("feature_accum: %d", feature_accum);
    $finish;
  end

endmodule