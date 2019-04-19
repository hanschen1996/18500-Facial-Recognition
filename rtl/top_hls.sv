`default_nettype none
`include "vj_weights.vh"
`define NUM_SAVED_FACES_TIMES_13 390
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

module top(
  input logic sys_clk_p, sys_clk_n, GPIO_SW_C,
  input  logic uart_rx, uart_cts,
  output logic uart_tx, uart_rts);
  
  logic laptop_can_receive;
  assign laptop_can_receive = uart_cts;
  logic fpga_can_receive;
  assign uart_rts = fpga_can_receive;
  assign fpga_can_receive = 1'b1;

  logic clock, reset;

  assign reset = GPIO_SW_C;
  clk_wiz_0 cw(.clk_out1(clock), .reset(1'b0), .clk_in1_p(sys_clk_p), 
               .clk_in1_n(sys_clk_n));

  logic [7:0] uart_data_rx;
  logic uart_data_rdy;

  uart_rcvr u_r(.clock, .reset, .uart_data(uart_data_rx), .uart_data_rdy, 
                .uart_rx);

  logic [31:0] accum;
  logic [3:0] pyramid_number;
  logic [1:0][31:0] face_coords;
  logic face_coords_ready, vj_pipeline_done;
  logic [31:0] faces_found;
  assign accum = faces_found;

  detect_face_wrapper df(.ap_clk(clock), .ap_rst(reset), .ap_start(uart_data_rdy), 
                         .ap_done(face_coords_ready), .ap_idle(), .ap_ready(), .ap_return(faces_found),
                         .result_x1_address0(), .result_x1_ce0(1'b1), .result_x1_we0(), .result_x1_d0(),
                         .result_x2_address0(), .result_x2_ce0(1'b1), .result_x2_we0(), .result_x2_d0(),
                         .result_y1_address0(), .result_y1_ce0(1'b1), .result_y1_we0(), .result_y1_d0(),
                         .result_y2_address0(), .result_y2_ce0(1'b1), .result_y2_we0(), .result_y2_d0(),
                         .result_score_address0(), .result_score_ce0(1'b1), .result_score_we0(), .result_score_d0());
                 
  assign pyramid_number = 'd0;
  assign face_coords = 'd0;

  logic [7:0] queue_out;
  logic [`NUM_SAVED_FACES_TIMES_13:0][7:0] saved_faces;
  logic [31:0] enq_idx, deq_idx;
  logic enq, deq;

  assign enq = face_coords_ready;

  always_ff @(posedge clock, posedge reset) begin: queue_data
    if (reset) begin
      saved_faces <= 'd0;
      deq_idx <= 32'd0;
      enq_idx <= 32'd0;
    end else begin
      if (enq && (enq_idx < `NUM_SAVED_FACES_TIMES_13)) begin
        saved_faces[enq_idx] <= {4'd0, pyramid_number};
        saved_faces[enq_idx+32'd1] <= face_coords[1][7:0];
        saved_faces[enq_idx+32'd2] <= face_coords[1][15:8];
        saved_faces[enq_idx+32'd3] <= face_coords[1][23:16];
        saved_faces[enq_idx+32'd4] <= face_coords[1][31:24];
        saved_faces[enq_idx+32'd5] <= face_coords[0][7:0];
        saved_faces[enq_idx+32'd6] <= face_coords[0][15:8];
        saved_faces[enq_idx+32'd7] <= face_coords[0][23:16];
        saved_faces[enq_idx+32'd8] <= face_coords[0][31:24];
        saved_faces[enq_idx+32'd9] <= accum[7:0];
        saved_faces[enq_idx+32'd10] <= accum[15:8];
        saved_faces[enq_idx+32'd11] <= accum[23:16];
        saved_faces[enq_idx+32'd12] <= accum[31:24];
        enq_idx <= enq_idx + 32'd13;
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