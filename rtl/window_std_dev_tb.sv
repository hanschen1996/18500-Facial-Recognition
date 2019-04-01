`include "vj_weights.vh"

module window_std_dev_tb();

  logic [`WINDOW_SIZE-1:0][`WINDOW_SIZE-1:0][31:0] input_img;
  logic [`WINDOW_SIZE-1:0][`WINDOW_SIZE-1:0][31:0] scan_win, scan_win_sq;
  logic [31:0] scan_win_std_dev;

  int_img_calc #(.WIDTH_LIMIT(`WINDOW_SIZE),.HEIGHT_LIMIT(`WINDOW_SIZE))
               down1(.input_img, .output_img(scan_win), .output_img_sq(scan_win_sq));
  window_std_dev std(.scan_win, .scan_win_sq, .scan_win_std_dev);

  initial begin
    for (int i = 0; i < `WINDOW_SIZE; i=i+1) begin
      for (int j = 0; j < `WINDOW_SIZE; j=j+1) begin
        input_img[i][j] = 2;
      end
    end
    #10
    for (int i = 0; i < `WINDOW_SIZE; i=i+1) begin
      for (int j = 0; j < `WINDOW_SIZE; j=j+1) begin
        $write("%0d ", scan_win[i][j]);
      end
      $write("\n");
    end
    $display("----------------------------------------------------------");
    for (int i = 0; i < `WINDOW_SIZE; i=i+1) begin
      for (int j = 0; j < `WINDOW_SIZE; j=j+1) begin
        $write("%0d ", scan_win_sq[i][j]);
      end
      $write("\n");
    end
    #10

    $display("topleft: %d, topright: %d, bottomleft: %d, bottomright: %d", std.scan_win_top_left, std.scan_win_top_right, std.scan_win_bottom_left, std.scan_win_bottom_right);
    $display("stddev1: %d, stddev2: %d", std.scan_win_std_dev1, std.scan_win_std_dev2);
    $display("window standard deviation: %d", scan_win_std_dev);
    #10
    $finish;
  end

endmodule