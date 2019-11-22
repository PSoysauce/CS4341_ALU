/**
	Module for the lightsaber color registers (Red, Green, and Blue)
	Values allowed are from 0 to 255 (7-bits).
*/
module LightSaberColor(clk, en, Ri, Gi, Bi, Ro, Go, Bo);
    input clk;
    input en;
    input [7:0] Ri;
    input [7:0] Gi;
    input [7:0] Bi;

    output [7:0] Ro;
    output [7:0] Go;
    output [7:0] Bo;
    
    wire [1:0] rdout;
    wire [1:0] gdout;
    wire [1:0] bdout;
    wire [7:0] rmout;
    wire [7:0] gmout;
    wire [7:0] bmout;
    
    Dec1x2 redDec (en, rdout);
    Mux2_8bit redMux (Ri, 8'b00000000, rdout, rmout);

    Dec1x2 greenDec (en, gdout);
    Mux2_8bit greenMux (Ri, 8'b00000000, gdout, gmout);
    
    Dec1x2 blueDec (en, bdout);
    Mux2_8bit blueMux (Ri, 8'b00000000, bdout, bmout);
    
    DFF red[7:0] (clk, rmout, Ro);
    DFF green[7:0] (clk, gmout, Go);
    DFF blue[7:0] (clk, bmout, Bo);

endmodule