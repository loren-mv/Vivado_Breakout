`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 05:54:11 PM
// Design Name: 
// Module Name: minitop
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


module minitop(
    input wire [13:0]current_score,
    input wire [13:0]high_score,
    input wire clk,
    output wire [6:0]cathode,
    output wire [7:0]AN
    );
    
    wire out_clk;
    clock_divider clk1(.in_clk(clk),.out_clk(out_clk));
    segFSM seg1(.current_score(current_score),.high_score(high_score),.clk(out_clk),.cathode(cathode),.anode(AN));
endmodule
