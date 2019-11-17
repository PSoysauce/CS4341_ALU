/**
	Module for the lightsaber configuration (2-bits).
	Uses a D Flip-Flop, 4-Channel 2-bit MUX, and 2x4 decoder
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
// 2:4 Decoder
// Based off observation of using shorthand if statements and multiplexer assembly
//=============================================
module Dec2x4(in, out);
	input [1:0] in;           	// 2-bit Input
	output [3:0]out;    		// 4-bit Output

    // Shorthand if statement, convienent for a 1:2 decoder
	assign out = in[0] && in[1] ? 4'b1000 : (in[1] ? 4'b0100 : (in[0] ? 4'b0010 : 4'b0001));
    
endmodule

//=============================================
// 4-Channel, 2-Bit Multiplexer
//=============================================
module Mux4(a3, a2, a1, a0, s, b);
	parameter k = 2;                // Two Bits Wide
	input [k-1:0] a3, a2, a1, a0;   // Inputs
	input [3:0]   s;                // One-hot select
	output[k-1:0] b;
	assign b = ({k{s[3]}} & a3) | 
               ({k{s[2]}} & a2) | 
               ({k{s[1]}} & a1) |
               ({k{s[0]}} & a0) ;
endmodule

//=============================================
// Lightsaber configuration module
// Possible set values:
//   0 - Off
//   1 - Single
//   2 - Double
//   3 - Hilted
//=============================================
module LightSaberBladeConfig(clk, Set, Out);
    input clk;
    input [1:0] Set;
    output [1:0] Out;
    
	wire [3:0] decOut;
    wire [1:0] transfer;

	Dec2x4 dec (Set, decOut);
    Mux4 sel (2'b11, 2'b10, 2'b01, 2'b00, decOut, transfer);
    DFF conf[1:0] (clk, transfer, Out);

endmodule

//=============================================
// Test Bench
//=============================================
module Test_FSM() ;

	//---------------------------------------------
	// Inputs
	//---------------------------------------------
	reg clk;
	reg [1:0] configSet;
    wire [1:0] configOut;

	//---------------------------------------------
	// * The actual module that must be included *
	//--------------------------------------------- 
	LightSaberBladeConfig Test(clk, configSet, configOut);
	
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
		$display("CLK| Rin      | Gin      ");
		$display("---+----------+----------");
		forever
			begin
			#5
				$display(" %b | %b | %b ", clk, configSet, configOut);
			end
	end	
	
	//---------------------------------------------   
	// Input test section, changing inputs manually
	//---------------------------------------------    
	initial 
		begin
			#2 //Offset the Square Wave
			#10
                configSet = 0;
            #30
                configSet = 1;
			#30
				configSet = 2;
			#30
				configSet = 3;
            #40
			$finish;
		end

endmodule