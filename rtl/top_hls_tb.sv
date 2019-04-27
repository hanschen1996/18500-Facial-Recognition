//`default_nettype none
`include "vj_weights.vh"
`define bauds_per_clock 217

module detect_face_tb();

  logic clock, reset;
  logic uart_rx, uart_cts;
  logic uart_tx, uart_rts;
  logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][7:0] in_img;
  logic [7:0] in_data;

  logic [7:0] laptop_uart_data;
  logic uart_data_rdy;
  logic [3:0] sw;
  logic [7:0] led;

  top dut(.sys_clk_p(clock), .sys_clk_n(~clock), .reset, .uart_rx, .uart_cts, .uart_tx, .uart_rts, .sw, .led);
  uart_rcvr u_r(.clock, .reset, .uart_data(laptop_uart_data), .uart_data_rdy, .uart_rx(uart_tx));

  integer file;
  logic [31:0] c;
  logic [31:0] row, col;
  
  initial begin
    int clock_lock;
    clock_lock = 0;
    clock = 1'b1;
    while (clock_lock == 0) begin
      #2 clock = 1'b0;
      #3 clock = 1'b1;
    end
    //    clock = 1'b0;
    //    forever #5 clock = ~clock;
  end

  task writeUart(input [7:0] data);
    begin
      uart_rx = 1'd0;
      for (int a = 0; a < `bauds_per_clock; a++) begin @(posedge clock); end
      for (int i = 0; i < 8; i++) begin
        uart_rx = data[i];
        for (int b = 0; b < `bauds_per_clock; b++) begin @(posedge clock); end
      end
      uart_rx = 1'd1;
      for (int c = 0; c < `bauds_per_clock; c++) begin @(posedge clock); end
    end
  endtask

  logic uart_sent_successfully;

  initial begin
    int i, j, d, e;
    uart_sent_successfully = 1'b0;
    reset = 1'b1;
    row = 0;
    col = 0;
    uart_rx = 1'd1;
    uart_cts = 1'b1;
    @(posedge clock);

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

    for (d = 0; d < 10; d++) begin @(posedge clock); end
    for (i = 0; i < `LAPTOP_HEIGHT; i++) begin
      for (j = 0; j < `LAPTOP_WIDTH; j++) begin
        in_data = in_img[i][j];
        #5;
        writeUart(in_img[i][j]);
      end
    end

    uart_sent_successfully = 1'b1;
    // force dut.laptop_img_rdy = 1'b1;
    // ##1;
    // force dut.laptop_img_rdy = 1'b0;
    // force dut.enq = 1'b0;
    // release dut.laptop_img;
    @(posedge dut.vj_pipeline_done);
    for (e = 0; e < 10000; e++) begin @(posedge clock); end
    $finish;
  end

  initial begin
    int z,g;
    logic [103:0] read;
    #1 z = 0;
    while (z >= 0) begin 
      @(posedge uart_data_rdy);
      #1 read[8*z +: 8] = laptop_uart_data;
      
      z = z + 1;
      if (z == 5) begin
        z = 0;
        $display("face_found = %0d, from (r%0d,c%0d) to (r%0d,c%0d)", read[7:0], read[23:16], read[15:8], read[39:32], read[31:24]);
      end
    end
    for (g = 0; g < 10; g++) begin @(posedge clock); end
    $finish;
  end

  /*initial begin
    int z;
    #1 z = 0;
    while (z == 0) begin 
      @(posedge dut.face_coords_ready);
      $display("nice!!!!!");
      $display("pyramid_number is %0d", dut.pyramid_number);
      $display("face_coords are (r%0d, c%0d)", dut.face_coords[0], dut.face_coords[1]);
      $display("------------------------------------------------------");
      #11;
      while (dut.face_coords_ready) begin
        $display("nice!!!!!");
        $display("pyramid_number is %0d", dut.pyramid_number);
        $display("face_coords are (r%0d, c%0d)", dut.face_coords[0], dut.face_coords[1]);
        $display("------------------------------------------------------");
        #11;
      end
    end
    ##10
    $finish;
  end*/

endmodule
