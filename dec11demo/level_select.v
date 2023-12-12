`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 02:34:17 PM
// Design Name: 
// Module Name: level_select
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


module level_select(
    output reg [3:0]current_state,
    input wire [3:0]level_in,
    input other_in,
    input clk,
    input win,
    input lose
    );
    reg [3:0]next_state;
    
    parameter SM = 4'b1111, LS = 4'b0001, GO = 4'b0010;
    //set encoding for screen states
    parameter L1 = 4'b0011, L2 = 4'b0100, L3 = 4'b0101, L4  = 4'b0110, L5 = 4'b0111, L6 = 4'b1000, L7 = 4'b1001, L8 = 4'b1010;
    //set all of the encoding for levels
    always @(*)
        case(current_state) 
        SM: begin
            next_state = (other_in) ? LS : SM; //next state selection for start menu
            end
        LS: begin //next state selection for Level Select menu
            if(level_in == 4'b0001) begin
                next_state = L1;
            end else if(level_in == 4'b0010)
                next_state = L2;                
            else if(level_in == 4'b0011)
                next_state = L3;
            else if(level_in == 4'b0100)
                next_state = L4;
            else if(level_in == 4'b0101)
                next_state = L5;
            else if(level_in == 4'b0110)
                next_state = L6;
            else if(level_in == 4'b0111)
                next_state = L7;
            else if(level_in == 4'b1000)
                next_state = L8;
            else 
                next_state = LS;
            end
        GO: next_state = (other_in) ? LS : GO;   //next state for game over screen     
        //next state for level states
        L1: begin 
            if(win) 
                next_state = LS;
            else if(lose)
                next_state = GO;
            else next_state = L1;
            end
        L2: begin 
            if(win) 
                next_state = LS;
            else if(lose)
                next_state = GO;
            else next_state = L2;
            end
        L3: begin 
            if(win) 
                next_state = LS;
            else if(lose)
                next_state = GO;
            else next_state = L3;
            end
        L4: begin 
            if(win) 
                next_state = LS;
            else if(lose)
                next_state = GO;
            else next_state = L4;
            end
        L5: begin 
            if(win) 
                next_state = LS;
            else if(lose)
                next_state = GO;
            else next_state = L5;    
            end
        L6: begin 
            if(win) 
                next_state = LS;
            else if(lose)
                next_state = GO;
            else next_state = L6;
            end
        L7: begin 
            if(win) 
                next_state = LS;
            else if(lose)
                next_state = GO;
            else next_state = L7;
            end
        L8: begin 
            if(win) 
                next_state = LS;
            else if(lose)
                next_state = GO;
            else next_state = L8;
            end
        default: next_state = SM;
        endcase
         
    always @(posedge clk) begin
        current_state = next_state; 
    end
   
endmodule
