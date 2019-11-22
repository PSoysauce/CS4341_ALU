/**
	Module for the lightsaber length registers (Integer, Decimal)
    Integer is 2 bits as lightsaber can't be longer than 3 meters.
    Decimal is 6 bits as that is the max required to reach .99
*/
module LightsaberLength(clk, en, Ini, Deci, Ino, Deco);
    input clk;
    input en;
    input [1:0] Ini;
    input [5:0] Deci;

    output [1:0] Ino;
    output [5:0] Deco;

    wire [1:0] inDout;
    wire [1:0] inMout;
    wire [1:0] decDout;
    wire [5:0] decMout;

    Dec1x2 inDec (en, inDout);
    Mux2_2bit inMux (Ini, 2'b00, inDout, inMout);

    Dec1x2 decDec (en, decDout);
    Mux2_6bit decMux (Deci, 6'b000000, decDout, decMout);

    
    DFF int[1:0] (clk, inMout, Ino);
    DFF decimal[5:0] (clk, decMout, Deco);

endmodule
