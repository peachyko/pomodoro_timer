`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/07/2024 03:51:42 AM
// Design Name: 
// Module Name: uart_sel
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


module uart_sel(
    input clk,
    input [7:0] r_data,
    output reg [1:0] sel
);
    always @(posedge clk) begin
        case(r_data)
            8'h30: sel = 2'b00; // 10 sec
            8'h31: sel = 2'b01; // 20 min
            8'h32: sel = 2'b10; // 25 mins
            8'h33: sel = 2'b11; // 30 sec
            default: sel = 2'b00; 
        endcase
    end
endmodule
