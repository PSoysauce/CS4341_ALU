/**
	Module for the lightsaber configuration (2-bits).
	Uses a D Flip-Flop, 4-Channel 2-bit MUX, and 2x4 decoder
*/
module LightSaberBladeConfig(clk, en, Set, Out);
    input clk;
    input en;
    input [1:0] Set;
    output [1:0] Out;
    
	wire [3:0] decOut;
    wire [1:0] transfer;

    wire [1:0] setDout;
    wire [1:0] setMout;

    Dec1x2 setDec (en, setDout);
    Mux2_2bit setMux (Set, 2'b00, setDout, setMout);

	Dec2x4 dec (setMout, decOut);
    Mux4 sel (2'b11, 2'b10, 2'b01, 2'b00, decOut, transfer);
    DFF conf[1:0] (clk, transfer, Out);

endmodule