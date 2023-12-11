`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 02:35:03 PM
// Design Name: 
// Module Name: keyboard_test_top
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
//Outputs 3 registers level: a level select from 1-8 inclusive
//                    move_right: 1 when d is pressed 0 when released
//                    move_left:  1 when a is pressed 0 when released

module keyboard_top(
    input wire CLK,
    input wire PS2_CLK,
    input wire PS2_DATA,
    //output wire [6:0]SEG,
    //output wire[7:0]AN,
    //output wire DP,
    output wire UART_TXD,
    output wire move_right,
    output wire move_left,
    output wire [3:0] level
    );
    
reg CLK50MHZ=0;    

always @(posedge(CLK))begin
    CLK50MHZ<=~CLK50MHZ;
end

PS2Receiver keyboard (
.clk(CLK50MHZ),
.kclk(PS2_CLK),
.kdata(PS2_DATA),
.level(level),
.right(move_right),
.left(move_left)
);  

endmodule
