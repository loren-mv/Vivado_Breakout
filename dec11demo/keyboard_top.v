`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 10:42:57 PM
// Design Name: 
// Module Name: keyboard_top
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


module keyboard_top(
    input wire CLK100MHZ,
    input wire PS2_CLK,
    input wire PS2_DATA,
    output wire [3:0] level,
    output wire other_out,
    output wire move_right,
    output wire move_left,
    output reg UART_TXD
);

reg CLK50MHZ = 0;
always @ (posedge CLK100MHZ) begin
    CLK50MHZ <= ~ CLK50MHZ;
end

PS2Receiver keyboard(
    .clk(CLK50MHZ),
    .kclk(PS2_CLK),
    .kdata(PS2_DATA),
    .level(level),
    .other_out(other_out),
    .right(move_right),
    .left(move_left)
);

endmodule
