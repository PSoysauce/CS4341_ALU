/**
	Module for the lightsaber color registers (Red, Green, and Blue)
	Values allowed are from 0 to 255 (7-bits).
*/
module LightSaberColor(clk, Ri, Gi, Bi, Ro, Go, Bo);
    input clk;
    input [7:0] Ri;
    input [7:0] Gi;
    input [7:0] Bi;

    output [7:0] Ro;
    output [7:0] Go;
    output [7:0] Bo;
    
    DFF red[7:0] (clk, Ri, Ro);
    DFF green[7:0] (clk, Gi, Go);
    DFF blue[7:0] (clk, Bi, Bo);

endmodule