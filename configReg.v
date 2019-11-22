/**
	Module for the lightsaber configuration (2-bits).

    Inputs:
    clk - Clock
    en - Enable (if power is on)
    Set - Blade configuration
        0 - Off
        1 - Single
        2 - Double
        3 - Hilted
    
    Output:
    Out - 2-bits representing current blade configuration setting
    
	Uses a D Flip-Flops, 4-Channel 2-bit MUX, 2-Channel 2-bit MUX, 1x2 Decoder,
     and 2x4 Decoder
*/
module LightSaberBladeConfig(clk, en, Set, Out);
    // Input
    input clk;
    input en;
    input [1:0] Set;

    // Output
    output [1:0] Out;
    
    // Enable Mux >> Input is 0 if module is not enabled
    wire [1:0] enDout;
    wire [1:0] enMout;

    Dec1x2 enDec (en, enDout);
    Mux2_2bit enMux (Set, 2'b00, enDout, enMout);

    // Blade configuration mux setting
    wire [3:0] bcDout;
    wire [1:0] bcMout;

	Dec2x4 bcDec (enMout, bcDout);
    Mux4 bcMux (2'b11, 2'b10, 2'b01, 2'b00, bcDout, bcMout);
    DFF conf[1:0] (clk, bcMout, Out);

endmodule