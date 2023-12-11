//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineer: Thomas Kappenman
// 
// Create Date: 03/03/2015 09:33:36 PM
// Design Name: 
// Module Name: PS2Receiver
// Project Name: Nexys4DDR Keyboard Demo
// Target Devices: Nexys4DDR
// Tool Versions: 
// Description: PS2 Receiver module used to shift in keycodes from a keyboard plugged into the PS2 port
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PS2Receiver(
    input wire clk,
    input wire kclk,
    input wire kdata,
    //output [31:0] keycodeout,
    output reg [3:0] level,
    output reg left,
    output reg right
    );
    
    
    wire kclkf, kdataf;
    reg [7:0]datacur;
    reg [7:0]dataprev;
    reg [3:0]cnt;
    reg [31:0]keycode;
    reg flag;
    

    initial begin
        keycode[31:0]<=0'h00000000;
        cnt<=4'b0000;
        flag<=1'b0;
    end
    
debouncer debounce(
    .clk(clk),
    .I0(kclk),
    .I1(kdata),
    .O0(kclkf),
    .O1(kdataf)
);
    
always@(negedge(kclkf))begin
    case(cnt)
    0:;//Start bit
    1:datacur[0]<=kdataf;
    2:datacur[1]<=kdataf;
    3:datacur[2]<=kdataf;
    4:datacur[3]<=kdataf;
    5:datacur[4]<=kdataf;
    6:datacur[5]<=kdataf;
    7:datacur[6]<=kdataf;
    8:datacur[7]<=kdataf;
    9:flag<=1'b1;
    10:flag<=1'b0;
    
    endcase
        if(cnt<=9) cnt<=cnt+1;
        else if(cnt==10) cnt<=0;
        
end


always @(posedge flag)begin
    if (dataprev!=datacur)begin
        keycode[31:24]<=keycode[23:16];
        keycode[23:16]<=keycode[15:8];
        keycode[15:8]<=dataprev;
        keycode[7:0]<=datacur;
        dataprev<=datacur;
    end
    
    case(datacur)
        'h16: begin level = 1; end
        'h1E: begin level = 2; end
        'h26: begin level = 3; end
        'h25: begin level = 4; end
        'h2E: begin level = 5; end
        'h36: begin level = 6; end
        'h3D: begin level = 7; end
        'h3E: begin level = 8; end
        'h1C: begin left = 1; end //A
        'h23: begin right = 1; end //D
    endcase
    
    case({dataprev,datacur})
        'hF016: begin level = 1; end
        'hF01E: begin level = 2; end
        'hF026: begin level = 3; end
        'hF025: begin level = 4; end
        'hF02E: begin level = 5; end
        'hF036: begin level = 6; end
        'hF03D: begin level = 7; end
        'hF03E: begin level = 8; end
        'hF01C: begin left = 0; end // A
        'hF023: begin right = 0; end // D
     endcase
    
end

endmodule