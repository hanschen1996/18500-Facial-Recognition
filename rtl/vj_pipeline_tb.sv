`include "vj_weights.vh"

module accum_calculator_tb();

  logic [`WINDOW_SIZE:0][`WINDOW_SIZE:0][31:0] input_img, scan_win, scan_win_sq;
  logic [31:0] scan_win_std_dev;
  logic [31:0] feature_accum;

  accum_calculator #(.RECT1_X(0), .RECT1_Y(0), .RECT1_WIDTH(6), .RECT1_HEIGHT(6), .RECT1_WEIGHT(1),
                     .RECT2_X(6), .RECT2_Y(6), .RECT2_WIDTH(6), .RECT2_HEIGHT(6), .RECT2_WEIGHT(1),
                     .RECT3_X(4), .RECT3_Y(4), .RECT3_WIDTH(4), .RECT3_HEIGHT(4), .RECT3_WEIGHT(-1),
                     .FEAT_THRES(128), .FEAT_ABOVE(6), .FEAT_BELOW(-6))
                   calc(.scan_win(scan_win_int), .scan_win_std_dev, .feature_accum);

  logic [`WINDOW_SIZE:0][`WINDOW_SIZE:0][31:0] input_img, output_img, output_img_sq;
  int_img_calc #(.WIDTH_LIMIT(`WINDOW_SIZE+1),
                 .HEIGHT_LIMIT(`WINDOW_SIZE+1))
               down1(.input_img, .output_img(scan_win), .output_img_sq(scan_win_sq));
                   
  initial begin
    for (int i = 0; i < 10; i=i+1) begin
      for (int j = 0; j < 10; j=j+1) begin
        input_img[i][j] = 2;
      end
    end
    #10

    for (int i = 0; i < 10; i=i+1) begin
              for (int j = 0; j < 10; j=j+1) begin
                $write("%0d ", output_img[i][j]);
              end
              $write("\n");
    end
    $display("----------------------------------------------------------");
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

module accum_calculator_tb;

  accum_calculator calc
