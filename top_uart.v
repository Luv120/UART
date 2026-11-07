module top_uart(
    input clk,
    input reset,
    input tx_start,
    input [7:0] tx_data,
    input [8:0] baud_div,
    output [7:0] rx_data,
    output tx
);

transmitter tx_inst(
    .tx(tx),
    .data(tx_data),
    .clk(clk),
    .tx_start(tx_start),
    .baud_div(baud_div),
    .reset(reset)
);

reciever rx_inst(
    .data_r(rx_data),
    .rx(tx),
    .baud_div(baud_div),
    .clk(clk),
    .reset(reset)
);

endmodule
