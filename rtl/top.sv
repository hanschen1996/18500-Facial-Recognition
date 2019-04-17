`default_nettype none
`include "vj_weights.vh"
`define NUM_SAVED_FACES_TIMES_16 1600
`define bauds_per_clock 54
`define MAX_CLOCK_COUNT 50

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
  
  logic clock, reset;
  logic laptop_img_rdy;
  logic save_uart_data;
  logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][7:0] laptop_img;
  logic [7:0] row_idx, col_idx;

  logic uart_data_rdy, send_uart_data, uart_data_sent;
  logic [7:0] uart_data_rx, uart_data_tx;

  logic [31:0] accum;
  logic [31:0] pyramid_number;
  logic [1:0][31:0] face_coords;
  logic face_coords_ready, vj_pipeline_done, downscale_laptop_img;
  logic [`LAPTOP_HEIGHT-1:0][`LAPTOP_WIDTH-1:0][7:0] curr_image_down;
  assign pyramid_number[31:4] = 28'd0;

  logic [7:0] queue_out;
  logic [`NUM_SAVED_FACES_TIMES_16:0][7:0] saved_faces;
  logic [31:0] enq_idx, deq_idx;
  logic enq, deq;
  logic [31:0] clock_count;
  logic clock_count_en, clock_count_rst;

  logic laptop_can_receive;
  assign laptop_can_receive = uart_cts;
  logic fpga_can_receive;
  assign uart_rts = fpga_can_receive;
  assign fpga_can_receive = 1'b1;

  assign reset = GPIO_SW_C;
  clk_wiz_0 cw(.clk_out1(clock), .reset(1'b0), .clk_in1_p(sys_clk_p), .clk_in1_n(sys_clk_n));

  uart_to_img u_i(.uart_data_rdy, .clock, .reset, .row_idx, .col_idx, .laptop_img_rdy, .save_uart_data);

  detect_face t(.laptop_img, .clock, .laptop_img_rdy, .reset, .face_coords, 
                .face_coords_ready, .pyramid_number(pyramid_number[3:0]), 
                .accum, .vj_pipeline_done, .downscale_laptop_img, 
                .curr_image_down);
  
  uart_rcvr u_r(.clock, .reset, .uart_data(uart_data_rx), .uart_data_rdy, .uart_rx);
  uart_tcvr u_t(.clock, .reset, .uart_data(uart_data_tx), .send_uart_data, .uart_tx, .uart_data_sent);

  always_ff @(posedge clock, posedge reset) begin: set_laptop_img
    if (reset) begin
      laptop_img <= 'd0;
    end else begin
      if (save_uart_data) laptop_img[row_idx][col_idx] <= uart_data_rx;
      else if (downscale_laptop_img) laptop_img <= curr_image_down;
    end
  end

  always_ff @(posedge clock, posedge reset) begin: queue_data
    if (reset) begin
      saved_faces <= 'd0;
      deq_idx <= 32'd0;
      enq_idx <= 32'd0;
    end else begin
      if (enq && (enq_idx < `NUM_SAVED_FACES_TIMES_16)) begin
        saved_faces[enq_idx] <= pyramid_number[7:0];
        saved_faces[enq_idx+32'd1] <= pyramid_number[15:8];
        saved_faces[enq_idx+32'd2] <= pyramid_number[23:16];
        saved_faces[enq_idx+32'd3] <= pyramid_number[31:24];
        saved_faces[enq_idx+32'd4] <= face_coords[1][7:0];
        saved_faces[enq_idx+32'd5] <= face_coords[1][15:8];
        saved_faces[enq_idx+32'd6] <= face_coords[1][23:16];
        saved_faces[enq_idx+32'd7] <= face_coords[1][31:24];
        saved_faces[enq_idx+32'd8] <= face_coords[0][7:0];
        saved_faces[enq_idx+32'd9] <= face_coords[0][15:8];
        saved_faces[enq_idx+32'd10] <= face_coords[0][23:16];
        saved_faces[enq_idx+32'd11] <= face_coords[0][31:24];
        saved_faces[enq_idx+32'd12] <= accum[7:0];
        saved_faces[enq_idx+32'd13] <= accum[15:8];
        saved_faces[enq_idx+32'd14] <= accum[23:16];
        saved_faces[enq_idx+32'd15] <= accum[31:24];
        enq_idx <= enq_idx + 32'd16;
      end else if (deq && (deq_idx < enq_idx)) begin
        queue_out <= saved_faces[deq_idx];
        deq_idx <= deq_idx + 32'd1;
      end else if (deq_idx == enq_idx) begin
        enq_idx <= 32'd0;
        deq_idx <= 32'd0;
      end
    end
  end

  always_ff @(posedge clock, posedge reset) begin: clock_counter
    if(reset) begin
      clock_count <= 32'd0;
    end else if (clock_count_rst) begin
      clock_count <= 32'd0;
    end else if (clock_count_en) begin
      clock_count <= clock_count + 32'd1;
    end
  end

  logic q_state;
  localparam LISTENING = 1'b0;
  localparam BUFFER = 1'b1;

  always_ff @(posedge clock, posedge reset) begin : queue_fsm_states
    if (reset) begin
      q_state <= LISTENING;
    end else begin
      if (q_state == LISTENING) q_state <= (face_coords_ready) ? BUFFER : LISTENING;
      else if (q_state == BUFFER) q_state <= (clock_count == `MAX_CLOCK_COUNT) ? LISTENING : BUFFER;
    end
  end

  always_comb begin: queue_fsm_signals
    case (q_state)
      LISTENING: begin
                 enq = face_coords_ready;
                 clock_count_en = face_coords_ready;
                 clock_count_rst = 1'b0;
                 end
      BUFFER: begin
              enq = 1'b0;
              clock_count_en = 1'b1;
              clock_count_rst = (clock_count == `MAX_CLOCK_COUNT);
              end
      default: begin
               enq = 1'b0;
               clock_count_en = 1'b0;
               clock_count_rst = 1'b1;
               end
    endcase  
  end

  results_to_uart r_u(.enq_idx, .deq_idx, .vj_pipeline_done, .uart_data_sent, 
                      .clock, .reset, .queue_out, .send_uart_data, .deq,
                      .uart_data_tx);
  
endmodule

module uart_to_img(
  input logic clock, reset, uart_data_rdy,
  output logic [7:0] row_idx, col_idx,
  output logic laptop_img_rdy, save_uart_data);

  /*----------------------------------------------------------------------------
   *-Counters-------------------------------------------------------------------
   *--------------------------------------------------------------------------*/

  logic row_ctr_en, col_ctr_en;
  logic max_row_idx, max_col_idx;

  assign max_row_idx = (row_idx == `LAPTOP_HEIGHT-1);
  assign max_col_idx = (col_idx == `LAPTOP_WIDTH-1);

  always_ff @(posedge clock, posedge reset) begin: row_index_counter
    if (reset) begin
      row_idx <= 8'd0;
    end else if (row_ctr_en) begin
      row_idx <= (max_row_idx) ? 8'd0 : row_idx + 8'd1;
    end
  end

  always_ff @(posedge clock, posedge reset) begin: col_index_counter
    if (reset) begin
      col_idx <= 8'd0;
    end else if (col_ctr_en) begin
      col_idx <= (max_col_idx) ? 8'd0 : col_idx + 8'd1;
    end
  end

  /*----------------------------------------------------------------------------
   *-FSM------------------------------------------------------------------------
   *--------------------------------------------------------------------------*/

  logic [1:0] state;
  localparam WAIT = 2'd0;
  localparam SAVING = 2'd1;
  localparam DONE = 2'd2;

  always_ff @(posedge clock, posedge reset) begin: fsm_states
    if (reset) begin
      state <= WAIT;
    end else begin
      if (state == WAIT) state <= (uart_data_rdy) ? SAVING : WAIT;
      else if (state == SAVING) state <= (uart_data_rdy & max_row_idx & max_col_idx) ? DONE : SAVING;
      else if (state == DONE) state <= WAIT;
    end
  end

  always_comb begin: fsm_outputs
    case (state)
      WAIT: begin
            row_ctr_en = 1'b0;
            col_ctr_en = uart_data_rdy;
            save_uart_data = uart_data_rdy;
            laptop_img_rdy = 1'b0;
            end
      SAVING: begin
              row_ctr_en = max_col_idx & uart_data_rdy;
              col_ctr_en = uart_data_rdy;
              save_uart_data = uart_data_rdy;
              laptop_img_rdy = 1'b0;
              end
      DONE: begin
            row_ctr_en = 1'b0;
            col_ctr_en = 1'b0;
            save_uart_data = 1'b0;
            laptop_img_rdy = 1'b1;
            end
      default: begin
               row_ctr_en = 1'b0;
               col_ctr_en = 1'b0;
               save_uart_data = 1'b0;
               laptop_img_rdy = 1'b0;
               end
    endcase
  end

endmodule

module results_to_uart(
  input logic [31:0] enq_idx, deq_idx, 
  input logic vj_pipeline_done, uart_data_sent, clock, reset,
  input logic [7:0] queue_out,
  output logic send_uart_data, deq, 
  output logic [7:0] uart_data_tx);

  logic [2:0] sd_state;
  localparam WAIT = 3'd0;
  localparam DEQ = 3'd1;
  localparam PREP_Y = 3'd2;
  localparam SEND_Y = 3'd3;
  localparam PREP_N = 3'd4;
  localparam SEND_N = 3'd5;

  always_ff @(posedge clock, posedge reset) begin: send_data_fsm_states
    if (reset) begin
      sd_state <= WAIT;
    end else begin
      if (sd_state == WAIT) begin
        if (vj_pipeline_done && enq_idx > 7'd0) sd_state <= DEQ;
        else if (vj_pipeline_done && enq_idx == 7'd0) sd_state <= SEND_N;
        else sd_state <= WAIT;
      end else if (sd_state == DEQ) sd_state <= PREP_Y;
      else if (sd_state == PREP_Y) sd_state <= SEND_Y;
      else if (sd_state == SEND_Y) begin
        if (uart_data_sent && deq_idx < enq_idx) sd_state <= DEQ;
        else if (uart_data_sent && deq_idx == enq_idx) sd_state <= WAIT;
        else sd_state <= SEND_Y;
      end else if (sd_state == PREP_N) sd_state <= SEND_N; 
      else if (sd_state == SEND_N) sd_state <= (uart_data_sent) ? WAIT : SEND_N;
    end
  end

  always_comb begin : send_data_fsm_signals
    case (sd_state)
      WAIT: begin
            send_uart_data = 1'b0;
            deq = 1'b0;
            uart_data_tx = 8'd0;
            end
      DEQ: begin
           send_uart_data = 1'b0;
           deq = 1'b1;
           uart_data_tx = 8'd0;
           end
      PREP_Y: begin
              send_uart_data = 1'b0;
              deq = 1'b0;
              uart_data_tx = queue_out;
              end
      SEND_Y: begin
              send_uart_data = 1'b1;
              deq = 1'b0;
              uart_data_tx = queue_out;
              end
      PREP_N: begin
              send_uart_data = 1'b0;
              deq = 1'b0;
              uart_data_tx = 8'd0;
              end
      SEND_N: begin
              send_uart_data = 1'b1;
              deq = 1'b0;
              uart_data_tx = 8'd0;
              end
      default: begin
               send_uart_data = 1'b0;
               deq = 1'b0;
               uart_data_tx = 8'd0;
               end
    endcase
  end

endmodule