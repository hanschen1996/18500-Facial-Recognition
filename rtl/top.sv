`default_nettype none
`include "vj_weights.vh"

/*
With hardware flow control (also called RTS/CTS flow control), two extra wires are needed in addition to the data lines. They are called
RTS (Request to Send) and CTS (Clear to Send). These wires are cross-coupled between the two devices, so RTS on one device is
connected to CTS on the remote device and vice versa. Each device will use its RTS to output if it is ready to accept new data and read
CTS to see if it is allowed to send data to the other device.

As long as a device is ready to accept more data, it will keep the RTS line asserted. It will deassert RTS some time before its receive
buffer is full. There might still be data on the line and in the other device transmit registers which has to be received even after RTS has
been deasserted. The other device is required to respect the flow control signal and pause the transmission until RTS is again asserted.

The flow control is bidirectional, meaning both devices can request a halt in transmission. If one of the devices never has to request a
stop in transmission (i.e. it is fast enough to always receive data), the CTS signal on the other device can be tied to the asserted logic
level. The RTS pin on the fast device can thus be freed up to other functions.
*/

/*
Idle: fpga_can_receive = 1, laptop_can_receive = 0
Image starts sending: fpga_can_receive = 1, laptop_can_receive = 1 (listener is forked)
Image received on fpga: fpga_can_receive = 0, laptop_can_receive = 1
Fpga sending coords back: fpga_can_receive = 0, laptop_can_receive = 1
Image received on laptop: fpga_can_receive = 1, laptop_can_receive = 0 (forked listener disappears)
*/

module top(
  input  logic sys_clk_p, sys_clk_n, uart_rx, uart_cts, GPIO_SW_C,
  output logic uart_tx, uart_rts);
  
  logic clock, reset, laptop_img_rdy, face_coords_ready, uart_data_rdy;
  logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][7:0] laptop_img;
  logic [1:0][31:0] face_coords;
  logic [3:0] pyramid_number;
  logic [7:0] uart_data;

  logic laptop_can_receive;
  assign laptop_can_receive = uart_cts;
  logic fpga_can_receive;
  assign fpga_can_receive = uart_rts;

  assign reset = GPIO_SW_C;
  clk_wiz_0 cw(.clk_out1(clock), .reset(1'b0), .clk_in1_p(sys_clk_p), .clk_in1_n(sys_clk_n));

  detect_face t(.laptop_img, .clock, .laptop_img_rdy, .reset, .face_coords, .face_coords_ready, .pyramid_number);
  
  uart_rcvr u_r(.clock, .uart_rx, .uart_data_rdy, .uart_data);

  always_ff @(posedge uart_data_rdy, posedge reset) begin: get_laptop_img
    if (reset) begin
      laptop_img <= 'd0;
      row_index <= 32'd0;
      col_index <= 32'd0;
      laptop_img_rdy <= 1'b0;
    end else if (~laptop_img_rdy) begin
      laptop_img[row_index][col_index] <= uart_data;
      row_index <= (row_index < `LAPTOP_HEIGHT - 1) ? row_index + 32'd1 : 32'd0;
      col_index <= (col_index < `LAPTOP_WIDTH - 1) ? col_index + 32'd1 : 32'd0;
      laptop_img_rdy <= (row_index == `LAPTOP_HEIGHT-1 && col_index == `LAPTOP_WIDTH - 1);
    end
  end
  
endmodule