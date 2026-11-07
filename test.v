module test;
reg clk;
reg reset;
reg tx_start;
reg [7:0] tx_data;
reg [8:0] baud_div;

wire tx;
wire [7:0] rx_data;

// STREAMING_CHUNK:Instantiating the Transmitter...
transmitter tx_inst (
    .tx(tx),
    .data(tx_data),
    .clk(clk),
    .tx_start(tx_start),
    .baud_div(baud_div),
    .reset(reset)
);

// STREAMING_CHUNK:Instantiating the Receiver...
reciever rx_inst (
    .data_r(rx_data),
    .rx(tx),
    .baud_div(baud_div),
    .clk(clk),
    .reset(reset)
);

// STREAMING_CHUNK:Generating the system clock...
// 50MHz clock (10ns high, 10ns low = 20ns period)
always #10 clk = ~clk;

// STREAMING_CHUNK:Defining the stimulus sequence...
initial begin
    // 1. Initialize all inputs
    clk = 0;
    reset = 1;
    tx_start = 0;
    tx_data = 8'h00;
    
    // Each bit takes 20 clock cycles. (20 cycles * 20ns = 400ns per bit)
    baud_div = 9'd20; 

    // 2. Release reset
    #50;
    reset = 0;
    #50;

    // 3. Transmit ONE Test Byte: 8'hA5 (Binary: 10100101)
    // Note: UART sends the Least Significant Bit (LSB) first!
    $display("\n-----------------------------------------------------------");
    $display("[%0t] Starting transmission of 8'hA5 (10100101)...", $time);
    tx_data = 8'hA5;
    
    // Trigger transmission
    tx_start = 1;
    #20;           
    tx_start = 0;

    $monitor($time," State=%b|bit_count=%b|tx=%b|State=%b|bit_counter=%b|Rx_Data=%b",tx_inst.state,tx_inst.bit_counter,tx,rx_inst.state,rx_inst.bit_counter,rx_data);
    #5000 $finish;
end
// STREAMING_CHUNK:Configuring waveform dumping for debug tools...
initial begin
    // Creates a VCD file so you can view the waves in GTKWave or Vivado
    $dumpfile("tb_uart.vcd");
    $dumpvars(0, test);
end
endmodule
