`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 08:10:44 PM
// Design Name: 
// Module Name: level_top
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


module level_top(
    input wire clk,
    input wire win,
    input wire lose,
    output reg VGA_HS,
    output reg VGA_VS,
    output reg [3:0] VGA_R,
    output reg [3:0] VGA_G,
    output reg [3:0] VGA_B,
    input wire PS2_CLK,
    input wire PS2_DATA,
    output wire UART_TXD,
    output reg [6:0] seg, // 7-segment segments 
    output reg [7:0] AN // 7-segment anodes
    );
    wire [3:0] klvl;
    wire other_out;
    wire [3:0] temp_state;
    wire [1:0] LR;
    wire [3:0] tempr1, tempr2, tempr3, gamer;
    wire [3:0] tempg1, tempg2, tempg3, gameg;
    wire [3:0] tempb1, tempb2, tempb3, gameb;
    wire hs1, hs2, hs3, gamehs;
    wire vs1, vs2, vs3, gamevs;
    wire [13:0] current_score, high_score;
    wire win, lose;
           
    parameter SM = 4'b1111, LS = 4'b0001, GO = 4'b0010;
    //set encoding for screen states
    parameter L1 = 4'b0011, L2 = 4'b0100, L3 = 4'b0101, L4  = 4'b0110, L5 = 4'b0111, L6 = 4'b1000, L7 = 4'b1001, L8 = 4'b1010;
    //set all of the encoding for levels
    
    game breakout(.CLK(clk),.BTN_LR(LR),.VGA_HS(gamehs),.VGA_VS(gamevs),.VGA_R(gamer),.VGA_G(gameg),.VGA_B(gameb),.win(win),.endgame(lose),.score(current_score));
    
    keyboard_top keys(.CLK100MHZ(clk),.PS2_CLK(PS2_CLK),.PS2_DATA(PS2_DATA),.level(klvl),.UART_TXD(UART_TXD),.other_out(other_out),.move_right(LR[0]),.move_left(LR[1]));
    
    level_select level(.level_in(klvl),.current_state(temp_state),.other_in(other_out),.win(win),.lose(lose),.clk(clk));
    
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
