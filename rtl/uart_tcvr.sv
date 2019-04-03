`default_nettype none
`define bauds_per_clock 54

module uart_tcvr(
  input logic clock, reset,
  input logic [7:0] uart_data,
  input logic send_uart_data,
  output logic uart_tx, uart_data_sent);

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
    end else begin
      if (state == WAIT) state <= (send_uart_data) ? START : WAIT;
      else if (state == START) state <= (clk_cnt == `bauds_per_clock) ? DATA : START;
      else if (state == DATA) begin
        state <= (uart_data_cnt == 4'd7 && clk_cnt == `bauds_per_clock) ? STOP : DATA;
      end else if (state == STOP) state <= (clk_cnt == `bauds_per_clock) ? BUFFER : STOP;
      else if (state == BUFFER) state <= WAIT;
    end
  end

  always_comb begin
    uart_data_sent = (state == BUFFER);
    case (state)
      WAIT,
      BUFFER: begin
              clk_cnt_rst = 1'b1;
              clk_cnt_en = 1'b0;
              uart_data_cnt_rst = 1'b1;
              uart_data_cnt_en = 1'b0;
              uart_tx = 1'b1;
              end
      START: begin
             clk_cnt_rst = (clk_cnt == `bauds_per_clock);
             clk_cnt_en = 1'b1;
             uart_data_cnt_rst = 1'b1;
             uart_data_cnt_en = 1'b0;
             uart_tx = 1'b0;
             end
      DATA: begin 
            clk_cnt_rst = (clk_cnt == `bauds_per_clock);
            clk_cnt_en = 1'b1;
            uart_data_cnt_rst = 1'b0;
            uart_data_cnt_en = (clk_cnt == `bauds_per_clock);
            uart_tx = uart_data[uart_data_cnt];
            end
      STOP: begin 
            clk_cnt_rst = (clk_cnt == `bauds_per_clock);
            clk_cnt_en = 1'b1;
            uart_data_cnt_rst = 1'b1;
            uart_data_cnt_en = 1'b0;
            uart_tx = 1'b1;
            end
      default: begin
               clk_cnt_rst = 1'b1;
               clk_cnt_en = 1'b0;
               uart_data_cnt_rst = 1'b1;
               uart_data_cnt_en = 1'b0;
               uart_tx = 1'b1;
               end
    endcase
  end

endmodule