/**
	Module for the lightsaber length registers (Integer, Decimal)

    Inputs:
    clk - Clock
    en - Enable (if power is on)
    Ini - Integer is 2 bits as lightsaber can't be longer than 3 meters.
    Deci - Decimal is 6 bits as that is the max required to reach .99

    Ouputs:
    Ino - 2-bits representing integer length in meters
    Deco - 6-bits representing decimal length in meters

    Uses 1x2 Decoders, 2 Channel 2-bit Mux, 2 Channel 6-bit Mux, and D-Flip-Flops
*/
module LightsaberLength(clk, en, Ini, Deci, Ino, Deco);
    // Input
    input clk;
    input en;
    input [1:0] Ini;
    input [5:0] Deci;

    // Output
    output [1:0] Ino;
    output [5:0] Deco;

    wire [1:0] inDout;
    wire [1:0] inMout;
    wire [1:0] decDout;
    wire [5:0] decMout;

    // Enable Mux >> Inputs are 0 if module is not enabled
    Dec1x2 inDec (en, inDout);
    Mux2_2bit inMux (Ini, 2'b00, inDout, inMout);

    Dec1x2 decDec (en, decDout);
    Mux2_6bit decMux (Deci, 6'b000000, decDout, decMout);

    // Blade length setting
    DFF int[1:0] (clk, inMout, Ino);
    DFF decimal[5:0] (clk, decMout, Deco);

endmodule
