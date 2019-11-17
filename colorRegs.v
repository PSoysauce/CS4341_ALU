/**
	Module for the lightsaber color registers (Red, Green, and Blue)
	Values allowed are from 0 to 255 (7-bits).
*/
//=============================================
// D Flip-Flop
//=============================================
module DFF(clk,in,out);
  input  clk;
  input  in;
  output out;
  reg    out;
  
  always @(posedge clk)		//<--This is the statement that makes the circuit behave with TIME
  out = in;
 endmodule

//=============================================
// Lightsaber color module
//=============================================
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

//=============================================
// Test Bench
//=============================================
module Test_FSM() ;
    parameter k = 5;

	//---------------------------------------------
	// Inputs
	//---------------------------------------------
	reg clk;
	reg [7:0] Ri;
    reg [7:0] Gi;
    reg [7:0] Bi;
    wire [7:0] Ro;
    wire [7:0] Go;
    wire [7:0] Bo;

	//---------------------------------------------
	// * The actual module that must be included *
	//---------------------------------------------
	LightSaberColor Test(clk, Ri, Gi, Bi, Ro, Go, Bo);
	
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
		$display("CLK| Rin      | Gin      | Bin      | Rout     | Gout     | Bout     ");
		$display("---+----------+----------+----------+----------+----------+----------");
		forever
			begin
			#5
				$display(" %b | %b | %b | %b | %b | %b | %b", clk, Ri, Gi, Bi, Ro, Go, Bo);
			end
	end	
	
	//---------------------------------------------   
	// Input test section, changing inputs manually
	//---------------------------------------------    
	initial 
		begin
			#2 //Offset the Square Wave
			#10
                Ri = 255;
                Gi = 255;
                Bi = 255;
            #30
                Ri = 128;
                Gi = 0;
                Bi = 128;
            #40
			$finish;
		end

endmodule