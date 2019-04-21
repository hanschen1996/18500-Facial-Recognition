`default_nettype none
`define bauds_per_clock 54

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

module uart_rcvr(
  input logic clock, reset, uart_rx,
  output logic uart_data_rdy,
  output logic [7:0] uart_data);

  logic [31:0] clk_cnt;
  logic clk_cnt_en, clk_cnt_rst;
  logic [2:0] uart_data_cnt;
  logic uart_data_cnt_en, uart_data_cnt_rst;

  always_ff @(posedge clock) begin: clock_counter
    if (clk_cnt_rst) begin
      clk_cnt <= 32'd0;
    end else begin
      if (clk_cnt_en) begin 
        clk_cnt <= clk_cnt + 32'd1;
      end
    end
  end

  always_ff @(posedge clock) begin: uart_data_counter
    if (uart_data_cnt_rst) begin
      uart_data_cnt <= 3'd0;
    end else begin
      if (uart_data_cnt_en) begin 
        uart_data_cnt <= uart_data_cnt + 32'd1;
      end
    end
  end

  /* ---------------------------------------------------------------------------
   * ---------------FSM
   */

  logic [2:0] state;
  localparam WAIT = 3'd0;
  localparam START = 3'd1;
  localparam DATA = 3'd2;
  localparam STOP = 3'd3;
  localparam BUFFER = 3'd4;

  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      state <= 3'd0;
      uart_data <= 'd0;
    end else begin
      if (state == WAIT) state <= (uart_rx == 1'b0) ? START : WAIT;
      else if (state == START) state <= (clk_cnt == 32'd26) ? DATA : START;
      else if (state == DATA) begin
        state <= (uart_data_cnt == 4'd7 && clk_cnt == `bauds_per_clock) ? STOP : DATA;
        if (clk_cnt == `bauds_per_clock) begin
          uart_data[uart_data_cnt] <= uart_rx;
        end
      end else if (state == STOP) state <= (clk_cnt == 32'd26) ? BUFFER : STOP;
      else if (state == BUFFER) state <= WAIT;
    end
  end

  always_comb begin
    uart_data_rdy = (state == BUFFER);
    case (state)
      WAIT,
      BUFFER: begin
              clk_cnt_rst = uart_rx;
              clk_cnt_en = ~uart_rx;
              uart_data_cnt_rst = 1'b1;
              uart_data_cnt_en = 1'b0;
              end
      START,
      STOP: begin 
            clk_cnt_rst = (clk_cnt == 32'd26);
            clk_cnt_en = 1'b1;
            uart_data_cnt_rst = 1'b1;
            uart_data_cnt_en = 1'b0;
            end
      DATA: begin 
            clk_cnt_rst = (clk_cnt == `bauds_per_clock);
            clk_cnt_en = 1'b1;
            uart_data_cnt_rst = 1'b0;
            uart_data_cnt_en = (clk_cnt == `bauds_per_clock);
            end
      default: begin
               clk_cnt_rst = uart_rx;
               clk_cnt_en = ~uart_rx;
               uart_data_cnt_rst = 1'b1;
               uart_data_cnt_en = 1'b0;
               end
    endcase
  end

endmodule