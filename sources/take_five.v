`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/08/2024 03:07:09 AM
// Design Name: 
// Module Name: take_five
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


module take_five(
    input clk,
    input reset,
    input start_break,  
    output reg [6:0] minutes = 5,
    output reg [6:0] seconds = 0
);
    reg [31:0] cnt = 0;
    reg running = 0;
    reg bb = 0;

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            minutes <= 5;
            seconds <= 0;
            cnt <= 0;
            running <= 0;
        end else if (start_break && !running && !bb) begin
            running <= 1;
            minutes <= 5;
            seconds <= 0;
        end else if (running) begin
            cnt <= cnt + 1;
            if (cnt >= 100000000) begin 
                cnt <= 0;
                if (seconds > 0) seconds <= seconds - 1;
                else if (minutes > 0) begin
                    seconds <= 59;
                    minutes <= minutes - 1;
                end else begin
                    running <= 0; 
                    bb <= 0;
                    end
                    
            end
        end
    end
endmodule