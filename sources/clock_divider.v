`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2023 10:32:08 AM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(
    input in_clk,
    output reg out_clk
    );
    reg[31:0] count;
 
	initial begin
		out_clk =0;
		count = 0;
	end
	
	always @(posedge in_clk)
	begin
	   if(count == 50000) begin //50000000 for 1 second clock
	       out_clk = ~out_clk;
	       count = 0;
	   end else begin
	       count <= count + 1;
	   end
	 end
	   

		// increment count by one
		// if count equals to some big number (that you need to calculate),
		//   then flip the output clock,
		//   and reset count to zero.
endmodule
