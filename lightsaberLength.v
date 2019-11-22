/**
	Module for the lightsaber length registers (Integer, Decimal)
    Integer is 2 bits as lightsaber can't be longer than 3 meters.
    Decimal is 6 bits as that is the max required to reach .99
*/
module LightsaberLength(clk, Ini, Deci Ino, Deco);
    input clk;
    input [1:0] Ini;
    input [5:0] Deci

    output [7:0] Ro;
    output [7:0] Go;
    
    DFF integer[1:0] (clk, Ini, Ino);
    DFF decimal[5:0] (clk, Deci, Deco);

endmodule
