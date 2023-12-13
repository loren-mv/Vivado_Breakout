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
    output reg [3:0] VGA_B, // blue channels
    output wire [6:0] seg, // 7-segment segments 
    output wire [7:0] AN // 7-segment anodes
    );

    wire [3:0] tempr1, tempr2, tempr3;
    wire [3:0] tempg1, tempg2, tempg3;
    wire [3:0] tempb1, tempb2, tempb3;
    wire [3:0] gamer1, gamer2, gamer3, gamer4, gamer5, gamer6, gamer7, gamer8;
    wire [3:0] gameg1, gameg2, gameg3, gameg4, gameg5, gameg6, gameg7, gameg8;
    wire [3:0] gameb1, gameb2, gameb3, gameb4, gameb5, gameb6, gameb7, gameb8;
    wire hs1, hs2, hs3;
    wire vs1, vs2, vs3;
    wire gamevs1, gamevs2, gamevs3, gamevs4, gamevs5, gamevs6, gamevs7, gamevs8; 
    wire gamehs1, gamehs2, gamehs3, gamehs4, gamehs5, gamehs6, gamehs7, gamehs8;
    wire [3:0] klvl;
    wire [3:0] temp_state;
    
    wire [8:0] curr_score1,curr_score2,curr_score3,curr_score4,curr_score5,curr_score6,curr_score7,curr_score8; 
    wire [8:0] highest_score1,highest_score2,highest_score3,highest_score4,highest_score5,highest_score6,highest_score7,highest_score8; 
    reg [8:0] temphighscore;
    reg [8:0] tempscore; // current score bits
    
    reg endgame; // game over flag
    wire eg1, eg2, eg3, eg4,eg5,eg6,eg7,eg8;
    reg win;
    wire win1,win2,win3,win4,win5,win6,win7,win8;
    wire other_out;
    wire [1:0] BTN_LR; // bit 0 - right, bit 1 - left
    
    parameter SM = 4'b1111, LS = 4'b0001, GO = 4'b0010;
    //set encoding for screen states
    parameter L1 = 4'b0011, L2 = 4'b0100, L3 = 4'b0101, L4  = 4'b0110, L5 = 4'b0111, L6 = 4'b1000, L7 = 4'b1001, L8 = 4'b1010;
    //set all of the encoding for levels
    level_select level(.level_in(klvl),.current_state(temp_state),.other_in(other_out),.win(win),.lose(endgame),.clk(clk)); 
    
    keyboard_top paddle_inputs(.CLK100MHZ(clk),.PS2_CLK(PS2_CLK),.PS2_DATA(PS2_DATA),.UART_TXD(UART_TXD),.level(klvl),.move_right(BTN_LR[0]),.other_out(other_out),.move_left(BTN_LR[1])); //get key inputs for paddle
        
    menu_screen menu(.CLK(clk),.VGA_HS(hs1),.VGA_VS(vs1),.VGA_R(tempr1),.VGA_G(tempg1),.VGA_B(tempb1)); // start menu driver
    
    level_screen lev(.CLK(clk),.VGA_HS(hs2),.VGA_VS(vs2),.VGA_R(tempr2),.VGA_G(tempg2),.VGA_B(tempb2)); //level select screen driver
    
    game_over game(.CLK(clk),.VGA_HS(hs3),.VGA_VS(vs3),.VGA_R(tempr3),.VGA_G(tempg3),.VGA_B(tempb3)); //game over screen driver
    
    minitop display(.clk(clk),.cathode(seg),.AN(AN),.current_score(tempscore),.high_score(temphighscore)); //scoreboard
    
    scoretrack score1(.input_score(curr_score1),.high_score(highest_score1));
    scoretrack score2(.input_score(curr_score2),.high_score(highest_score2));
    scoretrack score3(.input_score(curr_score3),.high_score(highest_score3));
    scoretrack score4(.input_score(curr_score4),.high_score(highest_score4));
    scoretrack score5(.input_score(curr_score5),.high_score(highest_score5));
    scoretrack score6(.input_score(curr_score6),.high_score(highest_score6));
    scoretrack score7(.input_score(curr_score7),.high_score(highest_score7));
    scoretrack score8(.input_score(curr_score8),.high_score(highest_score8));
    
     game #(.MAXSCORE(85))breakout1 (.mode(temp_state == L1), .CLK(clk), .BTN_LR(BTN_LR), .VGA_HS(gamehs1), .VGA_VS(gamevs1), //changed to test
    .VGA_R(gamer1), .VGA_G(gameg1), .VGA_B(gameb1), .endgame(eg1),.win(win1), .score(curr_score1)); // initialize level1
     
     game2 #(.MAXSCORE(85)) breakout2 (.mode(temp_state == L2), .CLK(clk), .BTN_LR(BTN_LR), .VGA_HS(gamehs2), .VGA_VS(gamevs2), //changed to test
    .VGA_R(gamer2), .VGA_G(gameg2), .VGA_B(gameb2), .endgame(eg2),.win(win2), .score(curr_score2)); // initialize level2
    
     game3 #(.MAXSCORE(65)) breakout3 (.mode(temp_state == L3), .CLK(clk), .BTN_LR(BTN_LR), .VGA_HS(gamehs3), .VGA_VS(gamevs3), //changed to test
    .VGA_R(gamer3), .VGA_G(gameg3), .VGA_B(gameb3), .endgame(eg3),.win(win3), .score(curr_score3)); // initialize level3
    
     game4 #(.MAXSCORE(65))breakout4 (.mode(temp_state == L4), .CLK(clk), .BTN_LR(BTN_LR), .VGA_HS(gamehs4), .VGA_VS(gamevs4), //changed to test
    .VGA_R(gamer4), .VGA_G(gameg4), .VGA_B(gameb4), .endgame(eg4),.win(win4), .score(curr_score4)); // initialize level4
    
     game5 #(.MAXSCORE(110)) breakout5 (.mode(temp_state == L5), .CLK(clk), .BTN_LR(BTN_LR), .VGA_HS(gamehs5), .VGA_VS(gamevs5), //changed to test
    .VGA_R(gamer5), .VGA_G(gameg5), .VGA_B(gameb5), .endgame(eg5),.win(win5), .score(curr_score5)); // initialize level5
    
     game6 #(.MAXSCORE(110)) breakout6 (.mode(temp_state == L6), .CLK(clk), .BTN_LR(BTN_LR), .VGA_HS(gamehs6), .VGA_VS(gamevs6), //changed to test
    .VGA_R(gamer6), .VGA_G(gameg6), .VGA_B(gameb6), .endgame(eg6),.win(win6), .score(curr_score6)); // initialize level6
    
     game7 #(.MAXSCORE(90)) breakout7 (.mode(temp_state == L7), .CLK(clk), .BTN_LR(BTN_LR), .VGA_HS(gamehs7), .VGA_VS(gamevs7), //changed to test
    .VGA_R(gamer7), .VGA_G(gameg7), .VGA_B(gameb7), .endgame(eg7),.win(win7), .score(curr_score7)); // initialize level7
    
     game8 #(.MAXSCORE(90)) breakout8 (.mode(temp_state == L8), .CLK(clk), .BTN_LR(BTN_LR), .VGA_HS(gamehs8), .VGA_VS(gamevs8), //changed to test
    .VGA_R(gamer8), .VGA_G(gameg8), .VGA_B(gameb8), .endgame(eg8),.win(win8), .score(curr_score8)); // initialize level8
    
   
 always@(temp_state)begin
        case(temp_state)
        SM: begin
            VGA_B = tempb1;
            VGA_G = tempg1;
            VGA_R = tempr1;
            VGA_VS = vs1;
            VGA_HS = hs1;
            temphighscore = 0;
            tempscore = 0;
            endgame = 0;
            win=0;
        end
        LS: begin
            VGA_B = tempb2;
            VGA_G = tempg2;
            VGA_R = tempr2;
            VGA_VS = vs2;
            VGA_HS = hs2;
            temphighscore = 0;
            tempscore = 0;
            endgame = 0;
            win=0;
        end
        GO: begin
            VGA_B = tempb3;
            VGA_G = tempg3;
            VGA_R = tempr3;
            VGA_VS = vs3;
            VGA_HS = hs3;
            temphighscore = 0;
            tempscore = 0;
            endgame = 0;
            win=0;
        end
        L1: begin
            VGA_B = gameb1;
            VGA_G = gameg1;
            VGA_R = gamer1;
            VGA_VS = gamevs1;
            VGA_HS = gamehs1;
            temphighscore = highest_score1;
            tempscore = curr_score1;
            endgame = eg1;
            win = win1;
        end
        L2: begin
            VGA_B = gameb2;
            VGA_G = gameg2;
            VGA_R = gamer2;
            VGA_VS = gamevs2;
            VGA_HS = gamehs2;
            temphighscore = highest_score2;
            tempscore = curr_score2;
            endgame = eg2;
            win = win2;
        end
        L3: begin
            VGA_B = gameb3;
            VGA_G = gameg3;
            VGA_R = gamer3;
            VGA_VS = gamevs3;
            VGA_HS = gamehs3;
            temphighscore = highest_score3;
            tempscore = curr_score3;
            endgame = eg3;
            win = win3;
        end
        L4: begin
            VGA_B = gameb4;
            VGA_G = gameg4;
            VGA_R = gamer4;
            VGA_VS = gamevs4;
            VGA_HS = gamehs4;
            temphighscore = highest_score4;
            tempscore = curr_score4;
            endgame = eg4;
            win = win4;
        end
        L5: begin
            VGA_B = gameb5;
            VGA_G = gameg5;
            VGA_R = gamer5;
            VGA_VS = gamevs5;
            VGA_HS = gamehs5;
            temphighscore = highest_score5;
            tempscore = curr_score5;
            endgame = eg5;
            win = win5;
        end
        L6: begin
            VGA_B = gameb6;
            VGA_G = gameg6;
            VGA_R = gamer6;
            VGA_VS = gamevs6;
            VGA_HS = gamehs6;
            temphighscore = highest_score6;
            tempscore = curr_score6;
            endgame = eg6;
            win = win6;
        end
        L7: begin
            VGA_B = gameb7;
            VGA_G = gameg7;
            VGA_R = gamer7;
            VGA_VS = gamevs7;
            VGA_HS = gamehs7;
            temphighscore = highest_score7;
            tempscore = curr_score7;
            endgame = eg7;
            win = win7;
        end
        L8: begin
            VGA_B = gameb8;
            VGA_G = gameg8;
            VGA_R = gamer8;
            VGA_VS = gamevs8;
            VGA_HS = gamehs8;
            temphighscore = highest_score8;
            tempscore = curr_score8;
            endgame = eg8;
            win = win8;
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

