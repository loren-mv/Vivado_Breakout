`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2023 05:05:23 PM
// Design Name: 
// Module Name: 7segFSM
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


module segFSM(
        input wire clk,
        input wire [13:0] current_score, //ADD SECOND NUM INPUT, EDIT ACCORDINGLY
        input wire [13:0] high_score,
        output reg [6:0] cathode,
        output reg [7:0] anode
    );
     reg [15:0] bcd1 = 0;
     reg [15:0] bcd2 = 0;
     reg [3:0] in_num;
    // instantiate decoder that decodes the four bit number into the cathode
    wire [7:0] anode_wire; 
    wire [6:0] cw; 
    integer i;

    decoder decoder_fsm(.number(in_num),.cathode(cw),.AN(anode_wire));
    reg [2:0] state; // stores state of FSM
    initial begin
        state = 3'b000;
        anode = 8'b11111111;
    end
    
    always @(posedge clk) begin //cycles through states to change anode
        state <= state + 1;
    end
    
always@(state) begin
    anode = 8'b00000000;
    case(state) //quickly runs through each screen
        3'b000 : anode = 8'b11111110;
        3'b001 : anode = 8'b11111101;
        3'b010 : anode = 8'b11111011;
        3'b011 : anode = 8'b11110111;
        3'b100 : anode = 8'b11101111;
        3'b101 : anode = 8'b11011111;
        3'b110 : anode = 8'b10111111;
        3'b111 : anode = 8'b01111111;
    endcase
 end
 
 always @(current_score)begin
    bcd1 = 0;
     
     for (i=0;i<14;i=i+1) begin					//Iterate once for each bit in input number
       if (bcd1[3:0] >= 5) bcd1[3:0] = bcd1[3:0] + 3;		//If any BCD digit is >= 5, add three
	   if (bcd1[7:4] >= 5) bcd1[7:4] = bcd1[7:4] + 3;
	   if (bcd1[11:8] >= 5) bcd1[11:8] = bcd1[11:8] + 3;
	   if (bcd1[15:12] >= 5) bcd1[15:12] = bcd1[15:12] + 3;
	   bcd1 = {bcd1[14:0],current_score[13-i]};				//Shift one bit, and shift in proper bit from input 
       end
  end
  
  always @(high_score)begin
    bcd2 = 0;     
     for (i=0;i<14;i=i+1) begin					//Iterate once for each bit in input number
       if (bcd2[3:0] >= 5) bcd2[3:0] = bcd2[3:0] + 3;		//If any BCD digit is >= 5, add three
	   if (bcd2[7:4] >= 5) bcd2[7:4] = bcd2[7:4] + 3;
	   if (bcd2[11:8] >= 5) bcd2[11:8] = bcd2[11:8] + 3;
	   if (bcd2[15:12] >= 5) bcd2[15:12] = bcd2[15:12] + 3;
	   bcd2 = {bcd2[14:0],high_score[13-i]};				//Shift one bit, and shift in proper bit from input 
       end
  end
 
 
 always@(state) 
    case(state)
        3'b000 : in_num = bcd1[3:0];
        3'b001 : in_num = bcd1[7:4];
        3'b010 : in_num = bcd1[11:8];
        3'b011 : in_num = bcd1[15:12];
        3'b100 : in_num = bcd2[3:0];
        3'b101 : in_num = bcd2[7:4];
        3'b110 : in_num = bcd2[11:8];
        3'b111 : in_num = bcd2[15:12];
    endcase

always@(cw) 
cathode = cw;

		// set anode (which display do you want to set?)
		//   hint: if state == 0, then set only the LSB of anode to zero,
		//         if state == 1, then set only the second to LSB to zero.
		// set the four bit number to be the approprate slice of the 16-bit number

    
endmodule
