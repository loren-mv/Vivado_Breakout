`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2020 09:03:24 PM
// Design Name: 
// Module Name: topmodule
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


module top(
    input wire clk, // 100 Mhz clock
    input wire PS2_CLK,  //Keyboard Clock
    input wire PS2_DATA, //Keyboard Data
    output wire UART_TXD, //Keyboard Out
    output reg VGA_HS, // horizontal sync
    output reg VGA_VS, // vertical sync
    output reg [3:0] VGA_R, // red channels
    output reg [3:0] VGA_G, // green channels
    output reg [3:0] VGA_B//, // blue channels
    //output reg [6:0] seg, // 7-segment segments 
    //output reg [7:0] AN // 7-segment anodes
    );

    wire [3:0] tempr1, tempr2, tempr3, gamer;
    wire [3:0] tempg1, tempg2, tempg3, gameg;
    wire [3:0] tempb1, tempb2, tempb3, gameb;
    wire hs1, hs2, hs3, gamehs;
    wire vs1, vs2, vs3, gamevs;
    wire [3:0] klvl;
    wire [3:0] temp_state;

    
    //wire [6:0] c_seg, h_seg; // current score segments
    //wire [7:0] c_anode, h_anode; // high score segments
    
    wire [8:0] curr_score, highest_score; // current score bits
    //wire slow_clk; // 7-segment clock 
    
    wire endgame; // game over flag
    wire win;
    wire other_out;
    wire [1:0] BTN_LR; // bit 0 - right, bit 1 - left
    
    parameter SM = 4'b1111, LS = 4'b0001, GO = 4'b0010;
    //set encoding for screen states
    parameter L1 = 4'b0011, L2 = 4'b0100, L3 = 4'b0101, L4  = 4'b0110, L5 = 4'b0111, L6 = 4'b1000, L7 = 4'b1001, L8 = 4'b1010;
    //set all of the encoding for levels
    level_select level(.level_in(klvl),.current_state(temp_state),.other_in(other_out),.win(win),.lose(endgame),.clk(clk)); 
    
    keyboard_top paddle_inputs(.CLK100MHZ(clk),.PS2_CLK(PS2_CLK),.PS2_DATA(PS2_DATA),.UART_TXD(UART_TXD),.level(klvl),.move_right(BTN_LR[0]),.other_out(other_out),.move_left(BTN_LR[1])); //get key inputs for paddle
    
    game breakout1(.mode(temp_state == L1), .CLK(clk), .BTN_LR(BTN_LR), .VGA_HS(gamehs), .VGA_VS(gamevs), //changed to test
    .VGA_R(gamer), .VGA_G(gameg), .VGA_B(gameb), .endgame(endgame),.win(win), .score(curr_score)); // initialize pong game
    
    menu_screen menu(.CLK(clk),.VGA_HS(hs1),.VGA_VS(vs1),.VGA_R(tempr1),.VGA_G(tempg1),.VGA_B(tempb1)); // start menu driver
    
    level_screen lev(.CLK(clk),.VGA_HS(hs2),.VGA_VS(vs2),.VGA_R(tempr2),.VGA_G(tempg2),.VGA_B(tempb2)); //level select screen driver
    
    game_over game(.CLK(clk),.VGA_HS(hs3),.VGA_VS(vs3),.VGA_R(tempr3),.VGA_G(tempg3),.VGA_B(tempb3)); //game over screen driver
    
    
 always@(temp_state)begin
        case(temp_state)
        SM: begin
        VGA_B = tempb1;
        VGA_G = tempg1;
        VGA_R = tempr1;
        VGA_VS = vs1;
        VGA_HS = hs1;
        end
        LS: begin
        VGA_B = tempb2;
        VGA_G = tempg2;
        VGA_R = tempr2;
        VGA_VS = vs2;
        VGA_HS = hs2;
        end
        GO: begin
        VGA_B = tempb3;
        VGA_G = tempg3;
        VGA_R = tempr3;
        VGA_VS = vs3;
        VGA_HS = hs3;
        end
        L1: begin
        VGA_B = gameb;
        VGA_G = gameg;
        VGA_R = gamer;
        VGA_VS = gamevs;
        VGA_HS = gamehs;
        end
        default: begin
        VGA_B = 0;
        VGA_G = 0;
        VGA_R = 0;
        VGA_VS = 0;
        VGA_HS = 0;
        end
        endcase
     end
endmodule

