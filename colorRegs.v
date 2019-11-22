/**
	Module for the lightsaber color registers (Red, Green, and Blue)
	Values allowed are from 0 to 255 (7-bits).

    Inputs:
    clk - Clock
    en - Enable (if power is on)
    Ri - 8-bit Red color value 
    Gi - 8-bit Green color value
    Bi - 8-bit Blue color value

    Output:
    Ro - 8-bit Red color value 
    Go - 8-bit Green color value
    Bo - 8-bit Blue color value
    
    Uses 1x2 Decoders, 2 Channel 8-bit MUXs, and D-Flip-Flops
*/
module LightSaberColor(clk, en, Ri, Gi, Bi, Ro, Go, Bo);
    // Input
    input clk;
    input en;
    input [7:0] Ri;
    input [7:0] Gi;
    input [7:0] Bi;

    // Output
    output [7:0] Ro;
    output [7:0] Go;
    output [7:0] Bo;
    
    // Enable Mux >> Inputs are 0 if module is not enabled
    wire [1:0] rdout;
    wire [7:0] rmout;
    Dec1x2 redDec (en, rdout);
    Mux2_8bit redMux (Ri, 8'b00000000, rdout, rmout);

    wire [1:0] gdout;
    wire [7:0] gmout;
    Dec1x2 greenDec (en, gdout);
    Mux2_8bit greenMux (Gi, 8'b00000000, gdout, gmout);
    
    wire [1:0] bdout;
    wire [7:0] bmout;
    Dec1x2 blueDec (en, bdout);
    Mux2_8bit blueMux (Bi, 8'b00000000, bdout, bmout);
    
    // Color registers
    DFF red[7:0] (clk, rmout, Ro);
    DFF green[7:0] (clk, gmout, Go);
    DFF blue[7:0] (clk, bmout, Bo);

endmodule