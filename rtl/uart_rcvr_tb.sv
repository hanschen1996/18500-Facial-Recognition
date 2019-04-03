`default_nettype none
`define bauds_per_clock 54

module uart_rcvr_tb();

  logic clock, reset, uart_rx;
  logic uart_data_rdy;
  logic [7:0] uart_data;

  uart_rcvr dut(.*);

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
    uart_rx = 1'd1;
    reset = 1'd0;
    #1
    reset = 1'd1;
    #1
    reset = 1'd0;
    ##10;
    writeUart(8'hab);
    ##10;
    writeUart(8'hde);
    ##10;
    $finish;
  end

  initial begin
    int z;
    #1;
    z = 0;
    while (z == 0) begin
      @(posedge uart_data_rdy);
      $display("%0h", uart_data);
    end
    ##10;
    $finish;
  end

endmodule