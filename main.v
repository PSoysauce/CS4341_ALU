/*
	Glassless
	Main control file
	
*/

// Import module files as they are completed
`include "util.v"			// Contains all of the basic components we need
`include "colorRegs.v"		// Lightsaber color 
`include "configReg.v"		// Lightsaber blade configuration
`include "power.v"			// Lightsaber power 
`include "lengthRegs.v"
`include "onOffReg.v"

module Test_FSM() ;
    parameter k = 5;

	//---------------------------------------------
	// Inputs
	//---------------------------------------------
	reg clk;
	reg rst;

	// Color Inputs
	reg [7:0] Ri;
    reg [7:0] Gi;
    reg [7:0] Bi;
    wire [7:0] Ro;
    wire [7:0] Go;
    wire [7:0] Bo;

    // Length Inputs
    reg [1:0] Ini;
    reg [5:0] Deci;
    wire [1:0] Ino;
    wire [5:0] Deco;

    // OnOff Inputs
    reg oni;
    wire ono;
    wire controlledClk = ono & clk;

	// Blade configuration
	reg [1:0] configSet;
    wire [1:0] configOut;

	// Power
	reg [1:0] powerUse;
	reg powerMode;
	reg [7:0] startPower;
	wire [7:0] powerOut;
	wire powerWarn;

	//---------------------------------------------
	// All the modules needed
	//---------------------------------------------
	LightsaberOnOff onTest(clk, oni, ono);
	LightSaberColor Test(clk, ono, Ri, Gi, Bi, Ro, Go, Bo);
	LightSaberBladeConfig LSBCT(clk, ono, configSet, configOut);
	LightsaberLength lengthTest(clk, ono, Ini, Deci, Ino, Deco);
	Power powerTest(clk, ono, rst, powerUse, powerMode, powerOut, powerWarn);

	//---------------------------------------------
	// Clock 
	//---------------------------------------------
	initial
		begin
		forever
			begin
				#5 
				clk = 0;
				#5
				clk = 1;
			end
	end	
	
	//---------------------------------------------
	// Debug display
	//---------------------------------------------
	initial
		begin
		#1 ///Offset the Square Wave
		$display("CLK|| Rin | Gin | Bin || Rout | Gout | Bout | BC | POUT | Length    | PWARN |");
		$display("---++-----+-----+-----++------+------+------+----+------+-----------+-------+");
		forever
			begin
			#10
				$display(" %b || %3d | %3d | %3d || %3d  | %3d  | %3d  | %3d | %d | %d.%d ft   | %b     |", controlledClk, Ri, Gi, Bi, Ro, Go, Bo, configOut, powerOut, Ino, Deco, powerWarn);
			end
	end	
	
	//---------------------------------------------   
	// Input test section, changing inputs manually
	//---------------------------------------------    
	initial 
		begin
			#2 //Offset the Square Wave
			#10
				rst = 1;
				oni = 0;
			#20
				$display("Lightsaber on, recharging...");
				rst = 0;
				oni = 1;
                Ri = 128;	// Set color to gray
                Gi = 128;
                Bi = 128;
                Ini = 1;	// Set blade length to 1.5 ft
                Deci = 50;
				configSet = 2;	// Set blade config to double
				powerUse = 1;	// Set power usage to trainning
				powerMode = 0;	// Set power mode to recharging
            #1900
            	oni = 0;
				$display("Lightsaber off");
			#50
				oni = 1;
				$display("Lightsaber on");
			#50
				$display("Now in trainning mode");
				oni = 1;
                Ri = 128;
                Gi = 0;
                Bi = 128;
                Ini = 2;
                Deci = 33;
				configSet = 3;
				powerUse = 1;
				powerMode = 1;
            #1000
				powerUse = 1;
			#1000
			$finish;
		end

endmodule