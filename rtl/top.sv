`default_nettype none

module top(
  input logic [239:0][319:0][7:0] laptop_img, // coming from uart module
  input logic clock, laptop_img_rdy, reset,
  output logic [3:0][31:0] face_coords);

  logic [12:0][239:0][319:0][7:0] images, int_images;

  always_ff @(posedge clock, posedge reset) begin: set_first_img
    if (reset) begin
      for (int i = 0; i < 240; i++) begin
        for (int j = 0; j < 320; j++) begin
          images[0][i][j] <= 8'b0;
        end
      end
    end else if (laptop_img_rdy) begin
      for (int i = 0; i < 240; i++) begin
        for (int j = 0; j < 320; j++) begin
          images[0][i][j] <= laptop_img[i][j];
        end
      end
    end
  end

  genvar i;
  generate
    for (i=0; i<12; i=i+1) begin: downscalers
      downscaler #(WIDTH = 320, HEIGHT = 240) 
                 d(.input_img(images[i]), .ratio(), .output_img(images[i+1]));
    end
  endgenerate

  genvar j;
  generate
    for (j=0; j<13; j=j+1) begin: integral_img_calculators
      int_img_calc #(WIDTH = 320, HEIGHT = 240)
                   i(.input_img(images[i]), .output_img(int_images[i]));
    end
  endgenerate

  logic [3:0] img_index;
  logic [7:0] row_index;
  logic [8:0] col_index;
  logic [23:0][23:0][7:0] scanning_window;

  genvar k, l;
  generate
    for (k=0; k<24; k=k+1) begin
      for (l=0; l<24; l=l+1) begin
        assign scanning_window[k][l] = int_images[img_index][row_index][col_index];
      end
    end
  endgenerate
 
  vj_pipeline vjp(.clock, .reset, .scanning_window, .face_coords());

  face_coords_q fcq(.clock);

endmodule

module downscaler
  #(parameter WIDTH = 320, HEIGHT = 320)(
  input  logic [HEIGHT-1:0][WIDTH-1:0] input_img,
  input  logic [31:0] ratio,
  output logic [HEIGHT-1:0][WIDTH-1:0] output_img);

  logic [HEIGHT-1:0][WIDTH-1:0][31:0] row_nums;
  logic [HEIGHT-1:0][WIDTH-1:0][31:0] col_nums;

  genvar i, j;
  generate
    for (i = 0; i < HEIGHT; i=i+1) begin
      multiplier m_r(.Y(row_nums[i]), .A(i), .B(ratio));

      for (j = 0; j < WIDTH; j=j+1) begin
        // TODO: make a 32 bit output multiplier
        multiplier m_c(.Y(col_nums[j]), .A(j), .B(ratio));
        assign output_img[i][j] = input_img[row_nums[i]>>16][col_nums[j]>>16];
      end
    end
  endgenerate

endmodule

module int_img_calc
  #(parameter WIDTH = 320, HEIGHT = 320)(
  input  logic [HEIGHT-1:0][WIDTH-1:0] input_img,
  output logic [HEIGHT-1:0][WIDTH-1:0] output_img);

  logic hi;

endmodule

module vj_pipeline(
  input  logic clock, reset, enable,
  input  logic [23:0][23:0][7:0] scanning_window,
  output logic [3:0][31:0] face_coords);

  logic [2912:0][23:0][23:0][7:0] scan_wins;

  always_ff @(posedge clock, posedge reset) begin: set_scanning_windows
    if(reset) begin: reset_scanning_windows
       //something
    end else if (enable) begin: move_scanning_windows
      scan_wins[0] <= scanning_window;
      for (int i = 0; i < 2912; i++) begin
        scan_wins[i+1] <= scan_wins[i];
      end
    end
  end

endmodule