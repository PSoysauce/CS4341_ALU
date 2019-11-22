/**
	Module for the lightsaber length registers (Integer, Decimal)
    Integer is 2 bits as lightsaber can't be longer than 3 meters.
    Decimal is 6 bits as that is the max required to reach .99
*/
module LightsaberOnOff(clk, Oni, Ono);
    input clk;
    input  Oni;

    output Ono;
    
    DFF on(clk, Oni, Ono);

endmodule
