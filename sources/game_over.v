`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2020 01:08:34 PM
// Design Name: 
// Module Name: menu_screen
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


module game_over (
    input wire CLK,             // board clock: 100 MHz on Arty/Basys3/Nexys
    output wire VGA_HS,       // horizontal sync output
    output wire VGA_VS,       // vertical sync output
    output reg [3:0] VGA_R,     // 4-bit VGA red output
    output reg [3:0] VGA_G,     // 4-bit VGA green output
    output reg [3:0] VGA_B      // 4-bit VGA blue output
    );

    // wire rst = RST_BTN;  // reset is active high on Basys3 (BTNC)

    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511
    wire animate;  // high when we're ready to animate at end of drawing
    wire active;   // high during active pixel drawing

    
    reg [15:0] cnt = 0; // clock divider count
    reg pix_stb = 0; // pixel clock   
    reg [25:0] counter = 0; // 26-bit counter, initialized to 0
    wire out_clk;
   
    anim_divider framedivider(.CLK(CLK), .out_clk(out_clk));

    always @(posedge CLK)
    begin
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000
    end
     
    vga640x480 display (
        .i_clk(CLK),
        .i_pix_stb(pix_stb),
        .o_hs(VGA_HS), 
        .o_vs(VGA_VS), 
        .o_x(x), 
        .o_y(y),
        .o_animate(animate),
        .o_active(active)
    ); // vga 640x480 driver
    
localparam SCREEN_WIDTH = 640; // screen width
    localparam SCREEN_HEIGHT = 480; // screen height
    localparam VRAM_DEPTH = SCREEN_WIDTH * SCREEN_HEIGHT; 
    localparam VRAM_A_WIDTH = 19;  // 2^19 > 640 x 480
    localparam VRAM_D_WIDTH = 6;   // colour bits per pixel

    reg [VRAM_A_WIDTH-1:0] address; // bitmap address
    wire [VRAM_D_WIDTH-1:0] dataout; // bitmap to vga

    sram #(
        .ADDR_WIDTH(VRAM_A_WIDTH), 
        .DATA_WIDTH(VRAM_D_WIDTH), 
        .DEPTH(VRAM_DEPTH), 
        .MEMFILE("game_over_frame1_edit.mem"))
        vram(
        .i_addr(address), 
        .i_clk(CLK), 
        .i_write(0),
        .i_data(0), 
        .o_data(dataout)
    ); // memory map reader instance


    wire [VRAM_D_WIDTH-1:0] dataout2; // bitmap to vga



    reg [11:0] palette [0:63];  // 64 x 12-bit colour palette entries
    reg [11:0] color; // color bits for vga
    
  initial
        $readmemh("game_over_frame1_edit_palette.mem", palette);  // bitmap palette to load
 
    
     
 always @(posedge CLK)
    begin
        address <= y * SCREEN_WIDTH + x; // assign address of bitmap

        if (active) begin
            color <= palette[dataout]; // draw bitmap colors
            end
        else    
            color <= 0; // draw nothing
           
        // assign ball color white and bitmap to corresponding colors
       
        VGA_R[3] <= color[11];
        VGA_G[3] <= color[7];
        VGA_B[3] <= color[3];
        VGA_R[2] <= color[10];
        VGA_G[2] <= color[6];
        VGA_B[2] <= color[2];
        VGA_R[1] <= color[9];
        VGA_G[1] <= color[5];
        VGA_B[1] <= color[1];
        VGA_R[0] <= color[8];
        VGA_G[0] <= color[4];
        VGA_B[0] <= color[0];

        if( (out_clk == 0) && (x>143) && (x<495) && (y>150) && (y < 330)) begin
        VGA_R[3] <= 0;
        VGA_G[3] <= 0;
        VGA_B[3] <= 0;
        VGA_R[2] <= 0;
        VGA_G[2] <= 0;
        VGA_B[2] <= 0;
        VGA_R[1] <= 0;
        VGA_G[1] <= 0;
        VGA_B[1] <= 0;
        VGA_R[0] <= 0;
        VGA_G[0] <= 0;
        VGA_B[0] <= 0;
        end
    end
    
    
endmodule

