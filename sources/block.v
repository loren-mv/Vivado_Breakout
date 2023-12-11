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
    D_HEIGHT=480    // height of display
    )
    (
    input wire toggle,
    input wire [1:0] com,
    input wire mode,        // mode
    input wire start,       // start flag
    input wire endgame,
    input wire [11:0] i_x1, // paddle left edge
    input wire [11:0] i_x2, // paddle right edge
    input wire i_clk,         // base clock
    input wire i_ani_stb,     // animation clock: pixel clock is 1 pix/frame
    input wire i_animate,     // animate when input is high
    input wire [11:0] s_x,  // square center x position
    input wire [11:0] s_y,  // square center y position
    input wire col_detected,
    output reg [11:0] o_x1,  // block left edge: 12-bit value: 0-4095
    output reg [11:0] o_x2,  // block right edge
    output reg [11:0] o_y1,  // block top edge
    output reg [11:0] o_y2,   //block bottom edge
    output reg [8:0] score,
    output reg [1:0] hit_block = 0 //left bit if hit horizontally, right bit if hit vertically
    );
    
    reg [11:0] x = IX;   // horizontal position of block centre
    reg [11:0] y = IY;   // vertical position of block centre
    
    //detect collision of block and square
    always @ (*) begin 
     o_x1 = x - B_WIDTH;  // left edge    
     o_x2 = x + B_WIDTH;  // right edge   
     o_y1 = y - B_HEIGHT;  // top edge    
     o_y2 = y + B_HEIGHT; // bottom edge 
     end         

 
 
    always @ (posedge i_clk)
    begin
    /*
          if(endgame) begin
            x = IX;
            y = IY;
          end
          */
    //checking if ball collided vertically (hit_block == 01)
            //bottom
        //if (i_animate & i_ani_stb & !endgame) begin    
        if(s_y == y + B_HEIGHT + 10 && (s_x <= x + B_WIDTH + 10 && s_x >= x - B_WIDTH - 10) ) begin
        /*
            o_x1 =3000;  // left edge
            o_x2 =3000;  // right edge
            o_y1 =3000;  // top edge
            o_y2 =3000;  // bottom edge
            
            */
            hit_block = 2'b01;
            
            x = 3000;
            y = 3000;
            
            end
            
            //top
        else if(s_y == y - B_HEIGHT - 10 && (s_x <= x + B_WIDTH + 10 && s_x >= x - B_WIDTH - 10) ) begin
            /*
            o_x1 =3000;  // left edge
            o_x2 =3000;  // right edge
            o_y1 =3000;  // top edge
            o_y2 =3000;  // bottom edge
            */
            hit_block = 2'b01;       
            x = 3000;
            y = 3000;
            
            end
     
     //checking if ball collided horit=zontally (hit_block == 10)
            //right
         else if(s_x == x + B_WIDTH + 10 && (s_y <= y + B_HEIGHT + 10 && s_y >= y - B_HEIGHT - 10) ) begin
           /*
            o_x1 =3000;  // left edge
            o_x2 =3000;  // right edge
            o_y1 =3000;  // top edge
            o_y2 =3000;  // bottom edge
            */
            
            hit_block = 2'b10;
            x = 3000;
            y = 3000;
            end
            
            //left
         else if(s_x == x - B_WIDTH - 10 && (s_y <= y + B_HEIGHT + 10 && s_y >= y - B_HEIGHT - 10) ) begin
            /*
            o_x1 =3000;  // left edge
            o_x2 =3000;  // right edge
            o_y1 =3000;  // top edge
            o_y2 =3000;  // bottom edge
            */          
            hit_block = 2'b10;
          
            x = 3000;
            y = 3000;
            end
              
          
          else if( (s_x == x - B_WIDTH - 10 && (s_y == y - B_HEIGHT - 10)) ||
                   (s_x == x + B_WIDTH + 10 && (s_y == y - B_HEIGHT - 10)) ||
                   (s_x == x - B_WIDTH - 10 && (s_y == y + B_HEIGHT + 10)) ||
                   (s_x == x + B_WIDTH + 10 && (s_y == y + B_HEIGHT + 10)) ) begin
            /*
            o_x1 =3000;  // left edge
            o_x2 =3000;  // right edge
            o_y1 =3000;  // top edge
            o_y2 =3000;  // bottom edge
            */
                        
            hit_block = 2'b11;
          
            x = 3000;
            y = 3000;
            end
          
          //else if(hit_block != 2'b00) hit_block = 2'b00;
          else if(col_detected == 1) hit_block = 2'b00;
            
      
            
        //end
    end    
endmodule
