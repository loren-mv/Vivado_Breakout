`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2023 11:35:14 PM
// Design Name: 
// Module Name: game3
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


module game8#(
    MAXSCORE = 90
)
(
    input wire mode,
    input wire CLK, // 100 Mhz clock
    input wire [1:0] BTN_LR, // left and right buttons
    output wire VGA_HS, // horizontal sync
    output wire VGA_VS, // vertical sync
    output reg [3:0] VGA_R, // red channels
    output reg [3:0] VGA_G, // green channels
    output reg [3:0] VGA_B, // blue channels
    output wire endgame, // game end flag
    output wire [8:0] score,
    output wire win
    );

    localparam PW = 60; // paddle width
    localparam PH = 5; // paddle height
    localparam PY = 480 - 2*PH; // initial paddle y
    localparam PX = 320; // initial paddle x

    localparam BX = 127;
    localparam BY = 150;
    localparam BW = 30; // block width
    localparam BH = 10; // block height

    localparam IX = 320; // intial ball x
    localparam IY = 470 - PH - PH - 30; //initial ball y
    localparam B_SIZE = 5; // ball size
    localparam speed_x = 5;
    localparam speed_y = 5;
    
    localparam BUFFER = 3; //collison buffer pixels

    reg [15:0] cnt = 0; // pixel clock counter
    reg pix_stb = 0; // pixel clock

    wire [9:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [8:0] y;  // current pixel y position:  9-bit value: 0-511
    wire animate;  // high when we're ready to animate at end of drawing
    wire collide; // collision flag
    wire [43:0] hit_block;
    wire [21:0] col_detected;
    

    reg sq_a, sq_b; //sq_c, sq_d, sq_e, sq_f, sq_g, sq_h; // registers to assign objects
    reg sq_b1, sq_b2, sq_b3, sq_b4, sq_b5, sq_b6, sq_b7, sq_b8, sq_b9, sq_b10, sq_b11, sq_b12, sq_b13;
    reg sq_b14, sq_b15, sq_b16, sq_b17, sq_b18;
    
    wire [11:0] s_x, s_y; //center of square

    wire [11:0] sq_a_x1, sq_a_x2, sq_a_y1, sq_a_y2; // positions bits for ball
    wire [11:0] sq_b_x1, sq_b_x2, sq_b_y1, sq_b_y2; // position bits for paddle
    
    wire [11:0] sq_b1_x1, sq_b1_x2, sq_b1_y1, sq_b1_y2;
    wire [11:0] sq_b2_x1, sq_b2_x2, sq_b2_y1, sq_b2_y2;
    wire [11:0] sq_b3_x1, sq_b3_x2, sq_b3_y1, sq_b3_y2;
    wire [11:0] sq_b4_x1, sq_b4_x2, sq_b4_y1, sq_b4_y2;
    wire [11:0] sq_b5_x1, sq_b5_x2, sq_b5_y1, sq_b5_y2;
    wire [11:0] sq_b6_x1, sq_b6_x2, sq_b6_y1, sq_b6_y2;
    wire [11:0] sq_b7_x1, sq_b7_x2, sq_b7_y1, sq_b7_y2;
    wire [11:0] sq_b8_x1, sq_b8_x2, sq_b8_y1, sq_b8_y2;
    wire [11:0] sq_b9_x1, sq_b9_x2, sq_b9_y1, sq_b9_y2;
    wire [11:0] sq_b10_x1, sq_b10_x2, sq_b10_y1, sq_b10_y2;
    wire [11:0] sq_b11_x1, sq_b11_x2, sq_b11_y1, sq_b11_y2;
    wire [11:0] sq_b12_x1, sq_b12_x2, sq_b12_y1, sq_b12_y2;
    wire [11:0] sq_b13_x1, sq_b13_x2, sq_b13_y1, sq_b13_y2;
    wire [11:0] sq_b14_x1, sq_b14_x2, sq_b14_y1, sq_b14_y2;
    wire [11:0] sq_b15_x1, sq_b15_x2, sq_b15_y1, sq_b15_y2;
    wire [11:0] sq_b16_x1, sq_b16_x2, sq_b16_y1, sq_b16_y2;
    wire [11:0] sq_b17_x1, sq_b17_x2, sq_b17_y1, sq_b17_y2;
    wire [11:0] sq_b18_x1, sq_b18_x2, sq_b18_y1, sq_b18_y2;
    
    wire active; // active flag during game over sequence
    wire [1:0] com; // bits to check paddle direction

    //assign col_detected[21:18] = 4'b1111;
   // assign hit_block[43:36] = 0;
    
    always @(posedge CLK)
    begin
        {pix_stb, cnt} <= cnt + 16'h4000;  // divide by 4: (2^16)/4 = 0x4000
    end

    vga640x480 display (
        .i_clk(CLK),
        .i_pix_stb(pix_stb),
        .i_rst(endgame),
        .o_hs(VGA_HS), 
        .o_vs(VGA_VS), 
        .o_x(x), 
        .o_y(y),
        .o_animate(animate)
    ); // vga 640x480 driver

    paddle #(.P_WIDTH(PW), .P_HEIGHT(PH), .IX(PX), .IY(PY)) p(
        .endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        .BTN_LR(BTN_LR),
        .o_x1(sq_b_x1),
        .o_x2(sq_b_x2),
        .o_y1(sq_b_y1),
        .o_y2(sq_b_y2),
        .active(active),
        .com(com)
        ); // paddle instance

    square #(.PY(PY), .PH(PH), .IX(IX), .IY(IY), .H_SIZE(B_SIZE), .speed_x(speed_x), .speed_y(speed_y),.MAXSCORE(MAXSCORE)) b0 (
        .toggle(1),
        .com(com),
        .mode(mode),
        .start(active),
        .i_x1(sq_b_x1),
        .i_x2(sq_b_x2),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        .hit_block(hit_block),
        .o_x1(sq_a_x1),
        .o_x2(sq_a_x2),
        .o_y1(sq_a_y1),
        .o_y2(sq_a_y2),
        .x(s_x),
        .y(s_y),
        .endgame(endgame),
        .score(score),
        .col_detected(col_detected),
        .win_game(win)
    ); // ball instance
    
    block #(.B_WIDTH(BH), .B_HEIGHT(BW), .IX(BX), .IY(BY), .BUFF(BUFFER)) b1(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
        .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[17]),
        .o_x1(sq_b1_x1),
        .o_x2(sq_b1_x2),
        .o_y1(sq_b1_y1),
        .o_y2(sq_b1_y2),
        .com(com),
        .hit_block(hit_block[35:34])
    );
    
    block #(.B_WIDTH(BH), .B_HEIGHT(BW), .IX(BX), .IY(BY + 66), .BUFF(BUFFER)) b2(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        .mode(mode),
        //.start(active),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[16]),
        .o_x1(sq_b2_x1),
        .o_x2(sq_b2_x2),
        .o_y1(sq_b2_y1),
        .o_y2(sq_b2_y2),
        .com(com),
        .hit_block(hit_block[33:32])
    );
    
    block #(.B_WIDTH(BW), .B_HEIGHT(BH), .IX(BX + 46), .IY(BY - 33), .BUFF(BUFFER)) b3(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
        .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[15]),
        .o_x1(sq_b3_x1),
        .o_x2(sq_b3_x2),
        .o_y1(sq_b3_y1),
        .o_y2(sq_b3_y2),
        .com(com),
        .hit_block(hit_block[31:30])
    );
    
    block #(.B_WIDTH(BW), .B_HEIGHT(BH), .IX(BX + 46), .IY(BY + 33), .BUFF(BUFFER)) b4(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
        .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[14]),
        .o_x1(sq_b4_x1),
        .o_x2(sq_b4_x2),
        .o_y1(sq_b4_y1),
        .o_y2(sq_b4_y2),
        .com(com),
        .hit_block(hit_block[29:28])
    );
    
    block #(.B_WIDTH(BW), .B_HEIGHT(BH), .IX(BX + 46), .IY(BY + 99), .BUFF(BUFFER)) b5(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
        .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[13]),
        .o_x1(sq_b5_x1),
        .o_x2(sq_b5_x2),
        .o_y1(sq_b5_y1),
        .o_y2(sq_b5_y2),
        .com(com),
        .hit_block(hit_block[27:26])
    );
    
    block #(.B_WIDTH(BW), .B_HEIGHT(BH), .IX(BX + 134 + 10), .IY(BY - 33), .BUFF(BUFFER)) b6(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
        .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[12]),
        .o_x1(sq_b6_x1),
        .o_x2(sq_b6_x2),
        .o_y1(sq_b6_y1),
        .o_y2(sq_b6_y2),
        .com(com),
        .hit_block(hit_block[25:24])
    );
    
    block #(.B_WIDTH(BH), .B_HEIGHT(BW), .IX(BX + 88 + 10), .IY(BY), .BUFF(BUFFER)) b7(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
        .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[11]),
        .o_x1(sq_b7_x1),
        .o_x2(sq_b7_x2),
        .o_y1(sq_b7_y1),
        .o_y2(sq_b7_y2),
        .com(com),
        .hit_block(hit_block[23:22])
    );
    
    block #(.B_WIDTH(BH), .B_HEIGHT(BW), .IX(BX + 88 + 10), .IY(BY + 66), .BUFF(BUFFER)) b8(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
        .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[10]),
        .o_x1(sq_b8_x1),
        .o_x2(sq_b8_x2),
        .o_y1(sq_b8_y1),
        .o_y2(sq_b8_y2),
        .com(com),
        .hit_block(hit_block[21:20])
    );
    
    block #(.B_WIDTH(BW), .B_HEIGHT(BH), .IX(BX + 134 + 10), .IY(BY + 99), .BUFF(BUFFER)) b9(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
        .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[9]),
        .o_x1(sq_b9_x1),
        .o_x2(sq_b9_x2),
        .o_y1(sq_b9_y1),
        .o_y2(sq_b9_y2),
        .com(com),
        .hit_block(hit_block[19:18])
    );
    
    
    block #(.B_WIDTH(BW), .B_HEIGHT(BH), .IX(BX + 254 + 10), .IY(BY - 33), .BUFF(BUFFER)) b10(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
         .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[8]),
        .o_x1(sq_b10_x1),
        .o_x2(sq_b10_x2),
        .o_y1(sq_b10_y1),
        .o_y2(sq_b10_y2),
        .com(com),
        .hit_block(hit_block[17:16])
    );
    
    
    block #(.B_WIDTH(BW), .B_HEIGHT(BH), .IX(BX + 254 + 10), .IY(BY + 33), .BUFF(BUFFER)) b11(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
        .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[7]),
        .o_x1(sq_b11_x1),
        .o_x2(sq_b11_x2),
        .o_y1(sq_b11_y1),
        .o_y2(sq_b11_y2),
        .com(com),
        .hit_block(hit_block[15:14])
    );
    
     block #(.B_WIDTH(BW), .B_HEIGHT(BH), .IX(BX + 254 + 10), .IY(BY + 99), .BUFF(BUFFER)) b12(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
        .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[6]),
        .o_x1(sq_b12_x1),
        .o_x2(sq_b12_x2),
        .o_y1(sq_b12_y1),
        .o_y2(sq_b12_y2),
        .com(com),
        .hit_block(hit_block[13:12])
    );
    
     block #(.B_WIDTH(BH), .B_HEIGHT(BW), .IX(BX + 300 + 10), .IY(BY), .BUFF(BUFFER)) b13(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
        .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[5]),
        .o_x1(sq_b13_x1),
        .o_x2(sq_b13_x2),
        .o_y1(sq_b13_y1),
        .o_y2(sq_b13_y2),
        .com(com),
        .hit_block(hit_block[11:10])
    );
    
    //incomplete from 14 to 22
    block #(.B_WIDTH(BH), .B_HEIGHT(BW), .IX(BX + 300 + 10), .IY(BY + 66), .BUFF(BUFFER)) b14(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
        .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[4]),
        .o_x1(sq_b14_x1),
        .o_x2(sq_b14_x2),
        .o_y1(sq_b14_y1),
        .o_y2(sq_b14_y2),
        .com(com),
        .hit_block(hit_block[9:8])
    );
    
    block #(.B_WIDTH(10), .B_HEIGHT(36), .IX(BX + 333 + 10), .IY(BY - 6), .BUFF(BUFFER)) b15(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
        .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[3]),
        .o_x1(sq_b15_x1),
        .o_x2(sq_b15_x2),
        .o_y1(sq_b15_y1),
        .o_y2(sq_b15_y2),
        .com(com),
        .hit_block(hit_block[7:6])
    );
    
    block #(.B_WIDTH(10), .B_HEIGHT(36), .IX(BX + 333 + 10), .IY(BY + 72), .BUFF(BUFFER)) b16(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
        .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[2]),
        .o_x1(sq_b16_x1),
        .o_x2(sq_b16_x2),
        .o_y1(sq_b16_y1),
        .o_y2(sq_b16_y2),
        .com(com),
        .hit_block(hit_block[5:4])
    );
    
    block # (.B_WIDTH(10), .B_HEIGHT(36), .IX(BX + 366 + 10), .IY(BY - 6), .BUFF(BUFFER)) b17(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
        .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[1]),
        .o_x1(sq_b17_x1),
        .o_x2(sq_b17_x2),
        .o_y1(sq_b17_y1),
        .o_y2(sq_b17_y2),
        .com(com),
        .hit_block(hit_block[3:2])
    );
    
        block #(.B_WIDTH(10), .B_HEIGHT(36), .IX(BX + 366 + 10), .IY(BY + 72), .BUFF(BUFFER)) b18(
     //.endgame(endgame|!mode),
        .i_clk(CLK), 
        .i_ani_stb(pix_stb),
        .i_animate(animate),
        //.start(active),
        .mode(mode),
        .s_x(s_x),
        .s_y(s_y),
        .col_detected(col_detected[0]),
        .o_x1(sq_b18_x1),
        .o_x2(sq_b18_x2),
        .o_y1(sq_b18_y1),
        .o_y2(sq_b18_y2),
        .com(com),
        .hit_block(hit_block[1:0])
    );
    
    always @ (*)
    begin
            sq_a = ((x > sq_a_x1) & (y > sq_a_y1) & (x < sq_a_x2) & (y < sq_a_y2)) ? 1 : 0; // draw ball edges
            sq_b = ((x > sq_b_x1) & (y > sq_b_y1) & (x < sq_b_x2) & (y < sq_b_y2)) ? 1 : 0; // draw paddle edges      
            
            sq_b1 = ((x > sq_b1_x1) & (y > sq_b1_y1) & (x < sq_b1_x2) & (y < sq_b1_y2)) ? 1 : 0; 
            sq_b2 = ((x > sq_b2_x1) & (y > sq_b2_y1) & (x < sq_b2_x2) & (y < sq_b2_y2)) ? 1 : 0; 
            sq_b3 = ((x > sq_b3_x1) & (y > sq_b3_y1) & (x < sq_b3_x2) & (y < sq_b3_y2)) ? 1 : 0; 
            sq_b4 = ((x > sq_b4_x1) & (y > sq_b4_y1) & (x < sq_b4_x2) & (y < sq_b4_y2)) ? 1 : 0; 
            sq_b5 = ((x > sq_b5_x1) & (y > sq_b5_y1) & (x < sq_b5_x2) & (y < sq_b5_y2)) ? 1 : 0; 
            sq_b6 = ((x > sq_b6_x1) & (y > sq_b6_y1) & (x < sq_b6_x2) & (y < sq_b6_y2)) ? 1 : 0; 
            sq_b7 = ((x > sq_b7_x1) & (y > sq_b7_y1) & (x < sq_b7_x2) & (y < sq_b7_y2)) ? 1 : 0; 
            sq_b8 = ((x > sq_b8_x1) & (y > sq_b8_y1) & (x < sq_b8_x2) & (y < sq_b8_y2)) ? 1 : 0; 
            sq_b9 = ((x > sq_b9_x1) & (y > sq_b9_y1) & (x < sq_b9_x2) & (y < sq_b9_y2)) ? 1 : 0;
            sq_b10 = ((x > sq_b10_x1) & (y > sq_b10_y1) & (x < sq_b10_x2) & (y < sq_b10_y2)) ? 1 : 0;   
            sq_b11 = ((x > sq_b11_x1) & (y > sq_b11_y1) & (x < sq_b11_x2) & (y < sq_b11_y2)) ? 1 : 0;   
            sq_b12 = ((x > sq_b12_x1) & (y > sq_b12_y1) & (x < sq_b12_x2) & (y < sq_b12_y2)) ? 1 : 0;   
            sq_b13 = ((x > sq_b13_x1) & (y > sq_b13_y1) & (x < sq_b13_x2) & (y < sq_b13_y2)) ? 1 : 0;   
            sq_b14 = ((x > sq_b14_x1) & (y > sq_b14_y1) & (x < sq_b14_x2) & (y < sq_b14_y2)) ? 1 : 0;   
            sq_b15 = ((x > sq_b15_x1) & (y > sq_b15_y1) & (x < sq_b15_x2) & (y < sq_b15_y2)) ? 1 : 0; 
            sq_b16 = ((x > sq_b16_x1) & (y > sq_b16_y1) & (x < sq_b16_x2) & (y < sq_b16_y2)) ? 1 : 0;   
            sq_b17 = ((x > sq_b17_x1) & (y > sq_b17_y1) & (x < sq_b17_x2) & (y < sq_b17_y2)) ? 1 : 0;
            sq_b18 = ((x > sq_b18_x1) & (y > sq_b18_y1) & (x < sq_b18_x2) & (y < sq_b18_y2)) ? 1 : 0;
    end

    always @(posedge pix_stb)
    begin
        // assign ball(s) and paddle color white
        VGA_R[3] <= (sq_a | sq_b | sq_b1 |  sq_b2 |  sq_b3 |  sq_b4 |  sq_b5 |  sq_b6 |  sq_b7 |  sq_b8 |  sq_b9  | sq_b10 |  sq_b11 |  sq_b12 |  sq_b13 |  sq_b14 |  sq_b15 |  sq_b16 |  sq_b17 |  sq_b18 ); 
        VGA_G[3] <= (sq_a | sq_b | sq_b1 |  sq_b2 |  sq_b3 |  sq_b4 |  sq_b5 |  sq_b6 |  sq_b7 |  sq_b8 |  sq_b9  | sq_b10 |  sq_b11 |  sq_b12 |  sq_b13 |  sq_b14 |  sq_b15 |  sq_b16 |  sq_b17 |  sq_b18 ); 
        VGA_B[3] <= (sq_a | sq_b | sq_b1 |  sq_b2 |  sq_b3 |  sq_b4 |  sq_b5 |  sq_b6 |  sq_b7 |  sq_b8 |  sq_b9  | sq_b10 |  sq_b11 |  sq_b12 |  sq_b13 |  sq_b14 |  sq_b15 |  sq_b16 |  sq_b17 |  sq_b18 ); 
        VGA_R[2] <= (sq_a | sq_b | sq_b1 |  sq_b2 |  sq_b3 |  sq_b4 |  sq_b5 |  sq_b6 |  sq_b7 |  sq_b8 |  sq_b9  | sq_b10 |  sq_b11 |  sq_b12 |  sq_b13 |  sq_b14 |  sq_b15 |  sq_b16 |  sq_b17 |  sq_b18 ); 
        VGA_G[2] <= (sq_a | sq_b | sq_b1 |  sq_b2 |  sq_b3 |  sq_b4 |  sq_b5 |  sq_b6 |  sq_b7 |  sq_b8 |  sq_b9  | sq_b10 |  sq_b11 |  sq_b12 |  sq_b13 |  sq_b14 |  sq_b15 |  sq_b16 |  sq_b17 |  sq_b18 ); 
        VGA_B[2] <= (sq_a | sq_b | sq_b1 |  sq_b2 |  sq_b3 |  sq_b4 |  sq_b5 |  sq_b6 |  sq_b7 |  sq_b8 |  sq_b9  | sq_b10 |  sq_b11 |  sq_b12 |  sq_b13 |  sq_b14 |  sq_b15 |  sq_b16 |  sq_b17 |  sq_b18 ); 
        VGA_R[1] <= (sq_a | sq_b | sq_b1 |  sq_b2 |  sq_b3 |  sq_b4 |  sq_b5 |  sq_b6 |  sq_b7 |  sq_b8 |  sq_b9  | sq_b10 |  sq_b11 |  sq_b12 |  sq_b13 |  sq_b14 |  sq_b15 |  sq_b16 |  sq_b17 |  sq_b18 ); 
        VGA_G[1] <= (sq_a | sq_b | sq_b1 |  sq_b2 |  sq_b3 |  sq_b4 |  sq_b5 |  sq_b6 |  sq_b7 |  sq_b8 |  sq_b9  | sq_b10 |  sq_b11 |  sq_b12 |  sq_b13 |  sq_b14 |  sq_b15 |  sq_b16 |  sq_b17 |  sq_b18 ); 
        VGA_B[1] <= (sq_a | sq_b | sq_b1 |  sq_b2 |  sq_b3 |  sq_b4 |  sq_b5 |  sq_b6 |  sq_b7 |  sq_b8 |  sq_b9  | sq_b10 |  sq_b11 |  sq_b12 |  sq_b13 |  sq_b14 |  sq_b15 |  sq_b16 |  sq_b17 |  sq_b18 ); 
        VGA_R[0] <= (sq_a | sq_b | sq_b1 |  sq_b2 |  sq_b3 |  sq_b4 |  sq_b5 |  sq_b6 |  sq_b7 |  sq_b8 |  sq_b9  | sq_b10 |  sq_b11 |  sq_b12 |  sq_b13 |  sq_b14 |  sq_b15 |  sq_b16 |  sq_b17 |  sq_b18 ); 
        VGA_G[0] <= (sq_a | sq_b | sq_b1 |  sq_b2 |  sq_b3 |  sq_b4 |  sq_b5 |  sq_b6 |  sq_b7 |  sq_b8 |  sq_b9  | sq_b10 |  sq_b11 |  sq_b12 |  sq_b13 |  sq_b14 |  sq_b15 |  sq_b16 |  sq_b17 |  sq_b18 ); 
        VGA_B[0] <= (sq_a | sq_b | sq_b1 |  sq_b2 |  sq_b3 |  sq_b4 |  sq_b5 |  sq_b6 |  sq_b7 |  sq_b8 |  sq_b9  | sq_b10 |  sq_b11 |  sq_b12 |  sq_b13 |  sq_b14 |  sq_b15 |  sq_b16 |  sq_b17 |  sq_b18 ); 
        
    end
endmodule
