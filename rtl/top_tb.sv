`default_nettype none
`include "vj_weights.vh"
`define bauds_per_clock 54 // 50 MHz clock for now

module detect_face_tb();

  logic clock, reset;
  logic uart_rx, uart_cts;
  logic uart_tx, uart_rts;
  logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][7:0] in_img;

  logic [7:0] laptop_uart_data;
  logic uart_data_rdy;

  top dut(.sys_clk_p(clock), .sys_clk_n(), .GPIO_SW_C(reset), .uart_rx, .uart_cts, .uart_tx, .uart_rts);
  uart_rcvr u_r(.clock, .reset, .uart_data(laptop_uart_data), .uart_data_rdy, .uart_rx(uart_tx));

  integer file;
  logic [31:0] c;
  logic [31:0] row, col;

  default clocking cb_main 
    @(posedge clock); 
  endclocking
  
  initial begin
    clock = 1'b0;
    forever #5 clock = ~clock;
  end

  task writeUart(input [7:0] data);
    begin
      uart_rx = 1'd0;
      ##`bauds_per_clock;
      for (int i = 0; i < 8; i++) begin
        uart_rx = data[i];
        ##`bauds_per_clock;
      end
      uart_rx = 1'd1;
      ##`bauds_per_clock;
    end
  endtask

  initial begin
    int i, j;
    reset = 1'b1;
    row = 0;
    col = 0;
    uart_rx = 1'd1;
    uart_cts = 1'b1;
    ##1;

    file = $fopen("input.txt", "r");

    if (file == 0) begin
      $display("ERROR: file not opened");
      $finish;
    end

    while ((c = $fgetc(file)) != -1) begin
      in_img[row][col] = c[7:0];
      if (col == `LAPTOP_WIDTH - 1) begin
        row = row + 1;
        col = 0;
      end
      else col = col + 1;
    end

    reset = 1'b0;

    ##10;
    for (i = 0; i < `LAPTOP_HEIGHT; i++) begin
      for (j = 0; j < `LAPTOP_WIDTH; j++) begin
        writeUart(in_img[i][j]);
      end
    end
    writeUart(8'd0);
    writeUart(8'd0);
    $display("nice! %d", $time);
    @(posedge dut.vj_pipeline_done);
    ##1000000;
    $finish;
  end

  initial begin
    #103690905;
    ##1000000;
    $finish;
  end

  initial begin
    int z;
    logic [31:0] read;
    #1 z = 0;
    while (z >= 0) begin 
      @(posedge uart_data_rdy);
      if (z == 0) #1 read[7:0] = laptop_uart_data;
      else if (z == 8) #1 read[15:8] = laptop_uart_data;
      else if (z == 16) #1 read[23:16] = laptop_uart_data;
      else #1 read[31:24] = laptop_uart_data;
      
      z = z + 8;
      if (z == 32) begin
        z = 0;
        $display("saw %0d", read);
      end
    end
    ##10
    $finish;
  end

  /*initial begin
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
      while (face_coords_ready) begin
        $display("nice!!!!!");
        $display("pyramid_number is %0d", pyramid_number);
        $display("face_coords are (r%0d, c%0d)", face_coords[0], face_coords[1]);
        $display("------------------------------------------------------");
        ##1;
      end
    end
    ##10
    $finish;
  end*/

endmodule
