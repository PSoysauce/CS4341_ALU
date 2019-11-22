/**
	Module for the On or Off state for the project
    Inputs:
    clk - Clock
    Oni - this value can turn the lightsaber on or off
    Output:
    Ono - outputs the current state of the lightsaber
*/
module LightsaberOnOff(clk, Oni, Ono);
    input clk;
    input  Oni;

    output Ono;
    
    DFF on(clk, Oni, Ono);

endmodule
