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
    B_WIDTH=30, //30    // half the paddle width
    B_HEIGHT=5,//5,     // half the paddle height     
    IX=20,         // initial horizontal position of square centre
    IY=20,         // initial vertical position of square centre
    IX_DIR=0,       // initial horizontal direction: 0 idle, 1 is left, 2 is right
    D_WIDTH=640,    // width of display
    D_HEIGHT=480,    // height of display
    S_SIZE = 5
    )
    (
    input wire toggle,
    input wire [1:0] com,
    input wire mode,         // mode
    input wire start,        // start flag
    input wire [11:0] i_x1,  // paddle left edge
    input wire [11:0] i_x2,  // paddle right edge
    input wire i_clk,        // base clock
    input wire i_ani_stb,    // animation clock: pixel clock is 1 pix/frame
    input wire i_animate,    // animate when input is high
    input wire col_detected, // square detected a collision
    input wire [11:0] s_x,   // square center x position
    input wire [11:0] s_y,   // square center y position
    output reg [11:0] o_x1,  // square left edge: 12-bit value: 0-4095
    output reg [11:0] o_x2,  // square right edge
    output reg [11:0] o_y1,  // square top edge
    output reg [11:0] o_y2,  // square bottom edge
    output reg [8:0] score,
    output reg [1:0] hit_block = 0
    );

    reg [11:0] x = IX;   // horizontal position of block centre
    reg [11:0] y = IY;   // vertical position of block centre

    always @(*)
    begin
        o_x1 = x - B_WIDTH;  // left edge
        o_x2 = x + B_WIDTH;  // right edge
        o_y1 = y - B_HEIGHT;  // top edge
        o_y2 = y + B_HEIGHT;  // bottom edge
    end
    
    always @ (posedge i_clk) begin
    
       if(!mode)begin
            x = IX;   // horizontal position of block centre
            y = IY;   // vertical position of block centre
       end

        //collision from bottom
        // 2 pixel buffer
        if( (s_y <= y + B_HEIGHT + S_SIZE) && (s_y >=y + B_HEIGHT + S_SIZE - 2) &&
            (s_x <= x + B_WIDTH + S_SIZE) && (s_x >= x - B_WIDTH - S_SIZE) ) begin
            hit_block = 2'b01;
            x = 3000;
            y = 3000;
            end

        //collision from top
        // 2 pixel buffer
        else if( (s_y >= y - B_HEIGHT - S_SIZE) && (s_y <= y - B_HEIGHT - S_SIZE + 2) &&
            (s_x <= x + B_WIDTH + S_SIZE) && (s_x >= x - B_WIDTH - S_SIZE) ) begin
           hit_block = 2'b01;       
           x = 3000;
           y = 3000;
           end

        //collision from right
        // 2 pixel buffer
         else if( (s_x <= x + B_WIDTH + S_SIZE) && (s_x >= x + B_WIDTH + S_SIZE - 2) && 
            (s_y <= y + B_HEIGHT + S_SIZE) && (s_y >= y - B_HEIGHT - S_SIZE) ) begin
            hit_block = 2'b10;
            x = 3000;
            y = 3000;
            end

        //collision from left
        // 2 pixel buffer
        else if( (s_x >= x - B_WIDTH - S_SIZE) && (s_x <= x - B_WIDTH - S_SIZE + 2) &&
            (s_y <= y + B_HEIGHT + S_SIZE) && (s_y >= y - B_HEIGHT - S_SIZE) ) begin
           hit_block = 2'b10;
           x = 3000;
           y = 3000;
           end

        //edge case: if hit from exactly the corner
        else if( (s_x == x - B_WIDTH - S_SIZE && (s_y == y - B_HEIGHT - S_SIZE)) ||
                  (s_x == x + B_WIDTH + S_SIZE && (s_y == y - B_HEIGHT - S_SIZE)) ||
                  (s_x == x - B_WIDTH - S_SIZE && (s_y == y + B_HEIGHT + S_SIZE)) ||
                  (s_x == x + B_WIDTH + S_SIZE && (s_y == y + B_HEIGHT + S_SIZE)) ) begin
           
            hit_block = 2'b11;
            x = 3000;
            y = 3000;
            end
        
          //else if(hit_block != 2'b00) hit_block = 2'b00;
          else if(col_detected == 1) hit_block = 2'b00;
                 
    
    end
    
    
    

endmodule