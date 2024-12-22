`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2024 03:52:12 AM
// Design Name: 
// Module Name: pomodoro
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pomodoro(
    input clk, reset_n, pause, rx, read,
    output [6:0] sseg, [7:0] AN, 
    output dp_control,rd_empty, done_signal,
    output [1:0] sel
    );

    reg [31:0] target_value;
    wire [7:0] r_data;
    wire [3:0] min_tens, min_ones, sec_tens, sec_ones;
    wire [6:0] minutes, seconds;
    wire  pause_pedge,read_pedge;
    wire [6:0] break_mins, break_secs;
    wire [3:0] break_ones, break_s_ones, break_s_tens;
    
    //start and pause button
    button P(
        .clk(clk),
        .reset_n(reset_n),
        .noisy(pause),
        .debounced(),
        .p_edge(pause_pedge),
        .n_edge(),
        ._edge()
    );
    //to read the input from the terminal
    button read_uart(
        .clk(clk),
        .reset_n(reset_n),
        .noisy(read),
        .debounced(),
        .p_edge(read_pedge),
        .n_edge(),
        ._edge()
    );
    //uart instantiating for the rx
    uart #(.DBIT(8), .SB_TICK(16)) uart_driver(
        .clk(clk),
        .reset_n(reset_n),
        .r_data(r_data),
        .rd_uart(read_pedge),//button to read data
        .rx_empty(rd_empty),
        .rx(rx),
        .w_data(8'b0),
        .wr_uart(0),//button to write data
        .tx_full(),
        .tx(),
        .TIMER_FINAL_VALUE(11'd650) // baud rate = 9600 bps
    );
    
    //to convert the hex from r_data to sel, sel is used to select the timer start time
    uart_sel selection_control (.clk(clk) , .r_data(r_data) , .sel(sel));
    
    //countdown timer, start time is depending on sel
    timer_control counter (.clk(clk), .reset(reset_n), .pause(pause_pedge) , .done(done_signal), .time_sel(sel), .minutes(minutes), .seconds(seconds));
    
    //5 minute break after timer is done counting
    take_five break(.clk(clk),.reset(reset_n),.start_break(done_signal), .minutes(break_mins),.seconds(break_secs));
    
    //bcd conversion 
    bin2bcd conv_minutes(.bin(minutes), .bcd({min_tens, min_ones}));
    bin2bcd conv_seconds(.bin(seconds), .bcd({sec_tens, sec_ones}));
    bin2bcd conv_break_minutes(.bin(break_mins), .bcd({4'b0000, break_ones}));
    bin2bcd conv_break_seconds(.bin(break_secs), .bcd({break_s_tens, break_s_ones}));
    
    //sseg driver
    sseg_driver display(clk, reset_n, 
    {~done_signal, min_tens, 1'b1},
    {~done_signal, min_ones, 1'b0},
    {~done_signal, sec_tens, 1'b1},
    {~done_signal, sec_ones, 1'b1},
    6'b0,
    {done_signal, break_ones, 1'b0},
    {done_signal, break_s_tens, 1'b1},
    {done_signal, break_s_ones, 1'b1},
    sseg, AN, dp_control);

endmodule
