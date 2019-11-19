/*
	Glassless
	Main control file
	
*/

// Import module files as they are completed
`include "util.v"			// Contains all of the basic components we need
`include "colorRegs.v"		// Lightsaber color 
`include "configReg.v"		// Lightsaber blade configuration
`include "power.v"			// Lightsaber power 

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

	// Blade configuration
	reg [1:0] configSet;
    wire [1:0] configOut;

	// Power
	reg [1:0] powerUse;
	reg powerMode;
	reg [7:0] startPower;
	wire [7:0] powerOut;

	//---------------------------------------------
	// All the modules needed
	//---------------------------------------------
	LightSaberColor Test(clk, Ri, Gi, Bi, Ro, Go, Bo);
	LightSaberBladeConfig LSBCT(clk, configSet, configOut);
	Power powerTest(clk, rst, powerUse, powerMode, powerOut);

	reg [7:0] a;
	reg [7:0] b;
	reg m;
	wire co;
	wire [7:0] sum;

	//Add_Sub_8_bit powerUser(a, b, m, co, sum);
	// assign co = (1'b1 & a[7]) &&
	// 			!(1'b0 & a[6]) &&
	// 			(1'b1 & a[5]) &&
	// 			(1'b1 & a[4]) &&
	// 			!(1'b0 & a[3]) &&
	// 			!(1'b0 & a[2]) &&
	// 			(1'b1 & a[1]) &&
	// 			!(1'b0 & a[0]);
	// initial begin
	// 	m = 1;
	// 	a = 178;
	// 	b = 3;
	// 	#15
	// 	$display("  %b", a);
	// 	$display("----------");
	// 	$display("  %b", co);
	// 	a = 188;
	// 	#15
	// 	$display("  %b", a);
	// 	$display("  %b", co);
		

	// end
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
		$display("CLK| Rin      | Gin      | Bin      | Rout     | Gout     | Bout     | BC | POUT     ");
		$display("---+----------+----------+----------+----------+----------+----------+----+----------");
		forever
			begin
			#10
				$display(" %b | %b | %b | %b | %b | %b | %b | %b | %d | %b %b", clk, Ri, Gi, Bi, Ro, Go, Bo, configOut, powerOut, powerTest.selDec, powerTest.limMin);
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
			#20
				rst = 0;
                Ri = 255;
                Gi = 255;
                Bi = 255;
				configSet = 2;
				powerUse = 1;
				powerMode = 0;
            #1900
                Ri = 128;
                Gi = 0;
                Bi = 128;
				configSet = 3;
				powerUse = 1;
				powerMode = 1;
            #1000
				powerUse = 1;
			#1000
			$finish;
		end

endmodule