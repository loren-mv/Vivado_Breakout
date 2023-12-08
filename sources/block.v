`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 06:20:39 PM
// Design Name: 
// Module Name: block
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


module block
     #(
    P_WIDTH=30, //30    // half the paddle width
    P_HEIGHT=5,//5,     // half the paddle height     
    IX=20,         // initial horizontal position of square centre
    IY=20,         // initial vertical position of square centre
    IX_DIR=0,       // initial horizontal direction: 0 idle, 1 is left, 2 is right
    D_WIDTH=640,    // width of display
    D_HEIGHT=480    // height of display
    )
    (
    input wire toggle,
    input wire [1:0] com,
    input wire mode,        // mode
    input wire start,       // start flag
    input wire [11:0] i_x1, // paddle left edge
    input wire [11:0] i_x2, // paddle right edge
    input wire i_clk,         // base clock
    input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_animate,     // animate when input is high
    output reg [11:0] o_x1,  // square left edge: 12-bit value: 0-4095
    output reg [11:0] o_x2,  // square right edge
    output reg [11:0] o_y1,  // square top edge
    output reg [11:0] o_y2,   // square bottom edge
    output reg [8:0] score,
    output reg endgame = 0
    );
    
    reg [11:0] x = IX;   // horizontal position of square centre
    reg [11:0] y = IY;   // vertical position of square centre
    
    always @(*)
    begin
        o_x1 = x - P_WIDTH;  // left edge
        o_x2 = x + P_WIDTH;  // right edge
        o_y1 = y - P_HEIGHT;  // top edge
        o_y2 = y + P_HEIGHT;  // bottom edge
    end
    
endmodule
