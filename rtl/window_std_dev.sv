`include "vj_weights.vh"

module window_std_dev(
  input  logic [`WINDOW_SIZE:0][`WINDOW_SIZE:0][17:0] scan_win,
  input  logic [`WINDOW_SIZE:0][`WINDOW_SIZE:0][31:0] scan_win_sq,
  output logic [31:0] scan_win_std_dev);

  logic [31:0] scan_win_top_left, scan_win_top_right, scan_win_bottom_left, scan_win_bottom_right;
  logic [31:0] scan_win_top_left_sq, scan_win_top_right_sq, scan_win_bottom_left_sq, scan_win_bottom_right_sq;
  logic [31:0] scan_win_sum, scan_win_sq_sum;
  logic [31:0] scan_win_std_dev1, scan_win_std_dev2;

  assign scan_win_top_left = scan_win[0][0];
  assign scan_win_top_right = scan_win[0][`WINDOW_SIZE];
  assign scan_win_bottom_left = scan_win[`WINDOW_SIZE][0];
  assign scan_win_bottom_right = scan_win[`WINDOW_SIZE][`WINDOW_SIZE];
  assign scan_win_top_left_sq = scan_win_sq[0][0];
  assign scan_win_top_right_sq = scan_win_sq[0][`WINDOW_SIZE];
  assign scan_win_bottom_left_sq = scan_win_sq[`WINDOW_SIZE][0];
  assign scan_win_bottom_right_sq = scan_win_sq[`WINDOW_SIZE][`WINDOW_SIZE];
  assign scan_win_sq_sum = scan_win_bottom_right_sq - scan_win_bottom_left_sq + scan_win_top_left_sq - scan_win_top_right_sq;
  assign scan_win_sum = scan_win_bottom_right - scan_win_bottom_left + scan_win_top_left - scan_win_top_right;

  assign scan_win_std_dev1 = {scan_win_sq_sum[22:0], 9'd0} + {scan_win_sq_sum[25:0], 6'd0};
  mult_gen_2 scan_win_mult2(.P(scan_win_std_dev2), .A(scan_win_sum), .B(scan_win_sum));

  assign scan_win_std_dev[31:16] = 16'd0;
  sqrt stddev(.val(scan_win_std_dev1 - scan_win_std_dev2), .res(scan_win_std_dev[15:0]));
endmodule
