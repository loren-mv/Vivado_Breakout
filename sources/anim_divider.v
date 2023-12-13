`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 11:28:25 PM
// Design Name: 
// Module Name: anim_divider
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


module anim_divider(
input wire CLK,
output reg out_clk
);

reg [25:0] counter;

always @(posedge CLK) begin
    if (counter == 50_000_000 - 1) begin
        counter <= 0;
        out_clk <= ~out_clk; // Toggle the output clock
    end else begin
        counter <= counter + 1;
    end
end

endmodule
