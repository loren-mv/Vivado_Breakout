module keyboard_top(
    input CLK100MHZ,
    input PS2_CLK,
    input PS_DATA,
    output [3:0] level,
    output UART_TXD
)

reg CLK50MHZ = 0;
always @ (posedge CLK100MHZ) begin
    CLK50MHZ <= ~ CLK50MHZ;
end

PS2Receiver keyboard(
    .clk(CLK50MHZ),
    .kclk(PS2_CLK),
    .kdata(PS2_DATA),
    .level(level)
)

endmodule