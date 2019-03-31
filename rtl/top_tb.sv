`default_nettype none
`include "vj_weights.vh"

module top_tb();

  logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][7:0] laptop_img;
  logic clock, laptop_img_rdy, reset;
  logic [1:0][31:0] face_coords;
  logic face_coords_ready;
  logic [3:0] pyramid_number;
  localparam [`NUM_STAGE:0][31:0] stage_num_feature = `STAGE_NUM_FEATURE;

  top dut(.*);

  default clocking cb_main 
    @(posedge clock); 
  endclocking
  
  initial begin
    clock = 1'b0;
    forever #5 clock = ~clock;
  end

  initial begin
    for (int i = 0; i < `LAPTOP_HEIGHT; i++) begin 
      for (int j = 0; j < `LAPTOP_WIDTH; j++) begin 
        laptop_img = 32'd5;
      end
    end
    reset = 1'b1;
    laptop_img_rdy = 1'b0;
    
    ##1;

    reset = 1'b0;

    ##1;

    laptop_img_rdy = 1'b1;

    ##1;

    laptop_img_rdy = 1'b0;

    ##76800;

    for (int z = 0; z < 3200; z++) begin 
      $display("pyramid_number is %0d", pyramid_number);
      $display("indexing into row %0d, column %0d", dut.row_index, dut.col_index);
      for (int k = 1; k < 26; k++) begin
        $display("stage %0d comparison result is %b", k, dut.vjp.stage_comparisons[k]);
      end
      $display("face_coords are (r%0d, c%0d)", face_coords[0], face_coords[1]);
      $display("------------------------------------------------------");
    end

    ##5;

    $finish;
  end

endmodule