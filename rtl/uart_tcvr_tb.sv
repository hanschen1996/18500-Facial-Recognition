`default_nettype none
`define bauds_per_clock 54

module uart_rcvr_tb();

  logic clock, reset, uart_tx;
  logic uart_data_sent, send_uart_data;
  logic [7:0] uart_data;

  uart_tcvr dut(.*);

  default clocking cb_main 
    @(posedge clock); 
  endclocking
  
  initial begin
    clock = 1'b0;
    forever #5 clock = ~clock;
  end

  task writeUart(input [7:0] data);
    begin
      uart_data = data;
      send_uart_data = 1'b1;
      ##1;
      send_uart_data = 1'b0;
    end
  endtask

  initial begin
    reset = 1'd0;
    send_uart_data = 1'b0;
    uart_data = 8'd0;
    #1
    reset = 1'd1;
    #1
    reset = 1'd0;
    ##10;
    writeUart(8'hab);
    @(posedge uart_data_sent);
    $display("ab sent!");
    ##10;
    writeUart(8'hde);
    @(posedge uart_data_sent);
    $display("de sent!");
    ##10;
    $finish;
  end

  initial begin
    ##3000;
    $finish;
  end

endmodule