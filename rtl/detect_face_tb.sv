`default_nettype none
`include "vj_weights.vh"

module detect_face_tb();

  logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][7:0] laptop_img;
  logic clock, laptop_img_rdy, reset;
  logic [1:0][31:0] face_coords;
  logic face_coords_ready, vj_pipeline_done;
  logic [3:0] pyramid_number;
  integer file;
  logic [31:0] c;
  logic [31:0] row, col, accum;

  detect_face dut(.*);

  default clocking cb_main 
    @(posedge clock); 
  endclocking
  
  initial begin
    clock = 1'b0;
    forever #5 clock = ~clock;
  end

  initial begin
    reset = 1'b1;
    laptop_img_rdy = 1'b0;
    row = 0;
    col = 0;
    ##1;

    file = $fopen("input.txt", "r");

    if (file == 0) begin
      $display("ERROR: file not opened");
      $finish;
    end

    while ((c = $fgetc(file)) != -1) begin
      laptop_img[row][col] = c[7:0];
      if (col == `LAPTOP_WIDTH - 1) begin
        row = row + 1;
        col = 0;
      end
      else col = col + 1;
    end
    /*
    for (int y = 0; y < `LAPTOP_HEIGHT; y ++) begin
      for (int x = 0; x < `LAPTOP_WIDTH; x ++) begin
        $write("%0d,", laptop_img[y][x]);
      end
      $write("\n");
    end
    */

    reset = 1'b0;

    ##1;
    $display("nice!! %d", $time);

    laptop_img_rdy = 1'b1;

    ##1;

    laptop_img_rdy = 1'b0;

    @(posedge dut.vj_pipeline_done);
    ##10;
    $finish;
  end
  
  initial begin
    /*int z= 0;
    while (z == 0) begin
      $display("pyramid_number is %0d", pyramid_number);
      $display("indexing into row %0d, column %0d", dut.row_index, dut.col_index);
      for (int k = 1; k < 26; k++) begin
       $display("stage %0d comparison result is %b", k, dut.vjp.stage_comparisons[k]);
      end
      $display("face_coords are (r%0d, c%0d)", face_coords[0], face_coords[1]);
      $display("------------------------------------------------------");
      ##1;
    end*/
    int z;
    #1 z = 0;
    while (z == 0) begin 
      @(posedge face_coords_ready);
      $display("nice!!!!!");
      $display("pyramid_number is %0d", pyramid_number);
      // $display("indexing into row %0d, column %0d", dut.row_index, dut.col_index);
      // for (int k = 1; k < 26; k++) begin
      //  $display("stage %0d comparison result is %b", k, dut.vjp.stage_comparisons[k]);
      // end
      $display("face_coords are (r%0d, c%0d)", face_coords[0], face_coords[1]);
      $display("------------------------------------------------------");
      ##1;
      #1;
      while (face_coords_ready) begin
        $display("nice!!!!!");
        $display("pyramid_number is %0d", pyramid_number);
        $display("face_coords are (r%0d, c%0d)", face_coords[0], face_coords[1]);
        $display("------------------------------------------------------");
        ##1;
        #1;
      end
    end
    ##10
    $finish;
  end
  
  /*
  initial begin
    int g = 0;
    @(posedge dut.vj_pipeline_on);
    while (g == 0) begin
      if (!dut.vj_pipeline_on) g = 1;
      ##1;
    end
    ##3000;
    $finish;
  end
  */

endmodule
