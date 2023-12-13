`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2023 10:25:35 AM
// Design Name: 
// Module Name: scoretrack
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


module scoretrack(
    input wire [13:0]input_score,
    output reg [13:0]high_score = 0
    );
    always@(input_score)begin
        if(input_score > high_score)
            high_score = input_score;
        else 
            high_score = high_score;
    end
    
endmodule
