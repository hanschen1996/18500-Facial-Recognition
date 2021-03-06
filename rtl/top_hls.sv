`default_nettype none
`include "vj_weights.vh"
`define NUM_SAVED_FACES_TIMES_5 150

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
  input  logic sys_clk_p, sys_clk_n,
  input  logic uart_rx_async, uart_cts, reset,
  input  logic GPIO_SW_C, GPIO_SW_N, GPIO_SW_E, GPIO_SW_S, GPIO_SW_W,
  input  logic [3:0] sw,
  output logic uart_tx_async, uart_rts,
  output logic [7:0] led);
  
  logic laptop_can_receive;
  assign laptop_can_receive = uart_cts;
  logic fpga_can_receive;
  assign uart_rts = fpga_can_receive;
  assign fpga_can_receive = 1'b1;

  logic clock;
  clk_wiz_0 cw(.clk_out1(clock), .clk_in1_p(sys_clk_p), 
               .clk_in1_n(sys_clk_n));
               
  logic uart_tx, uart_rx;
  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      uart_rx <= 1'b1;
      uart_tx_async <= 1'b1;
    end else begin
      uart_rx <= uart_rx_async;
      uart_tx_async <= uart_tx;
    end
  end

  logic [7:0] uart_data_rx;
  logic uart_data_rdy;

  uart_rcvr u_r(.clock, .reset, .uart_data(uart_data_rx), .uart_data_rdy, 
                .uart_rx);

  logic [7:0] result_x1_0, result_y1_0, result_x2_0, result_y2_0,
              faces_found;
  logic result_x1_0_ap_vld, result_x2_0_ap_vld, result_y1_0_ap_vld, result_y2_0_ap_vld;
  logic ap_done, vj_pipeline_done;
 
  detect_face_wrapper df(.ap_clk(clock), .ap_rst(reset), .ap_start(uart_data_rdy), .pixel(uart_data_rx),
                         .ap_done, .ap_idle(), .ap_ready(), .ap_return(faces_found),
                         .result_x1_0, .result_x1_0_ap_vld,
                         .result_x2_0, .result_x2_0_ap_vld,
                         .result_y1_0, .result_y1_0_ap_vld,
                         .result_y2_0, .result_y2_0_ap_vld);
  
  assign vj_pipeline_done = ap_done & ((faces_found == 8'd1) | (faces_found == 8'hff));

  logic [7:0] queue_out;
  logic [`NUM_SAVED_FACES_TIMES_5:0][7:0] saved_faces;
  logic [31:0] enq_idx, deq_idx;
  logic enq, deq;

  assign enq = result_x1_0_ap_vld & result_y1_0_ap_vld & result_x2_0_ap_vld & result_y2_0_ap_vld;

  always_ff @(posedge clock, posedge reset) begin: queue_data
    if (reset) begin
      saved_faces <= 'd0;
      deq_idx <= 32'd0;
      enq_idx <= 32'd0;
    end else begin
      if (enq && (enq_idx < `NUM_SAVED_FACES_TIMES_5)) begin
        saved_faces[enq_idx] <= 8'd1; // when valid signal asserted there is always a face
        saved_faces[enq_idx+32'd1] <= result_x1_0;
        saved_faces[enq_idx+32'd2] <= result_y1_0;
        saved_faces[enq_idx+32'd3] <= result_x2_0;
        saved_faces[enq_idx+32'd4] <= result_y2_0;
        enq_idx <= enq_idx + 32'd5;
      end else if (deq && (deq_idx < enq_idx)) begin
        queue_out <= saved_faces[deq_idx];
        deq_idx <= deq_idx + 32'd1;
      end else if (deq_idx == enq_idx) begin
        enq_idx <= 32'd0;
        deq_idx <= 32'd0;
      end
    end
  end

  logic send_uart_data, uart_data_sent;
  logic [7:0] uart_data_tx;
  
  uart_tcvr u_t(.clock, .reset, .uart_data(uart_data_tx), .send_uart_data, 
                .uart_tx, .uart_data_sent);

  results_to_uart r_u(.enq_idx, .deq_idx, .vj_pipeline_done, .uart_data_sent, 
                      .clock, .reset, .queue_out, .send_uart_data, .deq,
                      .uart_data_tx);
  
  // timing logic
  logic uart_data_rdy_max;
  logic [31:0] uart_data_rdy_count;
  assign uart_data_rdy_max = (uart_data_rdy_count == `LAPTOP_HEIGHT * `LAPTOP_WIDTH);
  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      uart_data_rdy_count <= 32'd0;
    end else if (uart_data_rdy) begin
      uart_data_rdy_count <= uart_data_rdy_count + 32'd1;
    end
  end
   
  logic [31:0] clock_count, saved_clock_count;
  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      clock_count <= 32'd0;
      saved_clock_count <= 32'd0;
    end else begin
      if (uart_data_rdy_max) begin
        clock_count <= clock_count + 32'd1;
      end
      if (vj_pipeline_done) begin
        saved_clock_count <= clock_count;
      end
    end
  end
   
  always_ff @(posedge clock, posedge reset) begin
    if (reset) begin
      led <= 8'd0;
    end else begin
      case (sw)
        4'b0001: led <= saved_clock_count[7:0];
        4'b0010: led <= saved_clock_count[15:8];
        4'b0100: led <= saved_clock_count[23:16];
        4'b1000: led <= saved_clock_count[31:24];
        default: led <= 8'd0;
      endcase
    end
  end
  
  //logic [31:0] data_count, result_x1_count, result_y1_count, result_x2_count, result_y2_count;
  //always_ff @(posedge clock, posedge reset) begin
  //  if (reset) begin
  //    data_count <= 32'd0;
  //    result_x1_count <= 32'd0;
  //    result_y1_count <= 32'd0;
  //    result_x2_count <= 32'd0;
  //    result_y2_count <= 32'd0;
  //  end else begin
  //    if (uart_data_rdy) begin
  //      data_count <= 32'd1 + data_count;
  //    end
  //    if (result_x1_0_ap_vld) begin
  //      result_x1_count <= result_x1_count + 32'd1;
  //    end 
  //    if (result_y1_0_ap_vld) begin
  //      result_y1_count <= result_y1_count + 32'd1;
  //    end 
  //    if (result_x2_0_ap_vld) begin
  //      result_x2_count <= result_x2_count + 32'd1;
  //    end
  //    if (result_y2_0_ap_vld) begin
  //      result_y2_count <= result_y2_count + 32'd1;
  //    end
  //  end
  //end
  
  //ila_0 i(.clk(clock), .probe0(vj_pipeline_done), .probe1(uart_tx), .probe2(enq), .probe3(deq), .probe4(uart_rx), .probe5(reset));
  
  //ila_0 i1(.clk(clock), .probe0(data_count), .probe1(result_x1_count), .probe2(result_y1_count), .probe3(result_x2_count), .probe4(result_y2_count));
  
endmodule

module results_to_uart(
  input logic [31:0] enq_idx, deq_idx, 
  input logic vj_pipeline_done, uart_data_sent, clock, reset,
  input logic [7:0] queue_out,
  output logic send_uart_data, deq,
  output logic [7:0] uart_data_tx);

  enum logic [2:0] {WAIT, DEQ, PREP_Y, SEND_Y, PREP_N, SEND_N} state, next_state;

  always_ff @(posedge clock, posedge reset) begin: send_data_fsm_states
    if (reset) begin
      state <= WAIT;
    end else begin
      state <= next_state;
    end
  end

  always_comb begin : send_data_fsm_signals
    case (state)
         WAIT: begin
               send_uart_data = 1'b0;
               deq = 1'b0;
               uart_data_tx = 8'd0;
               if (vj_pipeline_done)
                 next_state = (enq_idx > 7'd0) ? DEQ : SEND_N;
               else 
                 next_state = WAIT;
               end
          DEQ: begin
               send_uart_data = 1'b0;
               deq = 1'b1;
               uart_data_tx = 8'd0;
               next_state = PREP_Y;
               end
       PREP_Y: begin
               send_uart_data = 1'b0;
               deq = 1'b0;
               uart_data_tx = queue_out;
               next_state = SEND_Y;
               end
       SEND_Y: begin
               send_uart_data = 1'b1;
               deq = 1'b0;
               uart_data_tx = queue_out;
               if (uart_data_sent)
                 next_state = (deq_idx < enq_idx) ? DEQ : WAIT;
               else
                 next_state = SEND_Y;
               end
       PREP_N: begin
               send_uart_data = 1'b0;
               deq = 1'b0;
               uart_data_tx = 8'd0;
               next_state = SEND_N; 
               end
       SEND_N: begin
               send_uart_data = 1'b1;
               deq = 1'b0;
               uart_data_tx = 8'd0;
               next_state = (uart_data_sent) ? WAIT : SEND_N;
               end
      default: begin
               send_uart_data = 1'b0;
               deq = 1'b0;
               uart_data_tx = 8'd0;
               next_state = WAIT;
               end
    endcase
  end

endmodule
