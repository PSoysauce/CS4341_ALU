/**
	Module for the lightsaber configuration (2-bits).
	Uses a D Flip-Flop, 4-Channel 2-bit MUX, and 2x4 decoder
*/
module LightSaberBladeConfig(clk, Set, Out);
    input clk;
    input [1:0] Set;
    output [1:0] Out;
    
	wire [3:0] decOut;
    wire [1:0] transfer;

	Dec2x4 dec (Set, decOut);
    Mux4 sel (2'b11, 2'b10, 2'b01, 2'b00, decOut, transfer);
    DFF conf[1:0] (clk, transfer, Out);

endmodule