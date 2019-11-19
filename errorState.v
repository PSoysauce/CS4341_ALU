//Jonathan Tygielski
//CS 4341.001
//I implemented this program using iverilog and notepad++ and I got iverilog
//from the website http://bleyer.org/icarus/.


//Saturation Counter
module SaturationCounter(clk, rst, up, down, load, loadMax, in, out) ;
  parameter n = 9;
  
//Parameters
  input clk, rst, up, down, load, loadMax ;
  input [n-1:0] in ;
  output [n-1:0] out ;
  
//Local Variables 
  wire [n-1:0] next, outpm1,outDown,outUp ;
  wire [n-1:0] max;
  wire [n-1:0] mux2out;
  wire [1:0] selectMax;
 
//Load Max Count
  Dec       maxDec  (loadMax, selectMax);  
  Mux2 #(n) muxSat  (in, max, selectMax, mux2out);
  DFF  #(n) maxcount(clk, mux2out, max) ;

//Main Counter Control
  assign outUp    = (max> out) ? out + {{n-1{down}},1'b1} : max;
  assign outDown  = (0  < out) ? out + {{n-1{down}},1'b1} : 0;
  assign outpm1   = ({down}>0)? {outDown} :{outUp};
  
  DFF #(n) count   (clk, next, out) ;
  Mux4 #(n) mux(
	out, 
	in, 
	outpm1, 
	{n{1'b0}},
        {
		(~rst & ~up & ~down & ~load),
        (~rst & load),
        (~rst & (up | down)),
        rst
		},
	next) ;

endmodule


//D Flip-Flop
module DFF(clk,in,out);
  parameter n = 1;
  input  clk;
  input [n-1:0] in;
  output [n-1:0]out;
  reg [n-1:0]out;
  
  always @(posedge clk)
  out = in;
endmodule

module Dec(a,b);
    input a;
    output [1:0]b;
    assign b = 1<<a;
endmodule

//2 channel multiplexer
module Mux2(a1, a0, s, b);
    parameter k = 9; //9 bits
    input [k-1:0] a1,a0;
    input[2-1:0] s;
    output[k-1:0 ]b;
    assign b = ({k{s[1]}} & a1) | ({k{s[0]}} & a0);
endmodule

//Multiplexer
module Mux4(a3, a2, a1, a0, s, b) ;
	parameter k = 9 ;	//Nine Bits Wide
	input [k-1:0] a3, a2, a1, a0 ; 
	input [3:0]   s ;
	output[k-1:0] b ;
	assign b = ({k{s[3]}} & a3) | 
               ({k{s[2]}} & a2) | 
               ({k{s[1]}} & a1) |
               ({k{s[0]}} & a0) ;
endmodule


//This is the error state module which warns the user when the power cell of the lightsaber has reached a critical level.
//Lightsaber can have full power for 3 minutes or 180 seconds. When it reaches 45 seconds a mesage will warn user the battery
//is dying and needs to be charged back up. 
module error_state();
    parameter n = 9;
    reg clk, rst;
    reg up, down, load, loadMax;
    reg [n-1:0]in;
    wire [n-1:0]out;

    SaturationCounter sc(clk, rst, up, down, load, loadMax, in, out);
	
    initial begin
       clk = 1;
       #5 clk = 0;
       $display("Clock | Reset | Up | Down | Load | Load MaxTime |  In | MaxTime | BatteryTime|");
       forever
        begin
            #5 clk = 1;
            $display("  %b   |   %b   |  %b |  %b   |  %b   |     %b        | %d |  %d    |   %d      |",clk,rst,up,down,load,loadMax,in,sc.max,out);
            #5 clk = 0;
        end
    end
	
	//Stimuli
	initial begin
		rst = 0 ; ;
		#0
		//Reset to 0
		#15 rst = 1;
		#10 rst = 0;
		
		#10 up=0; down=0; load=0; loadMax=1; in=9'b010110100;
		#10 up=0; down=0; load=1; loadMax=0; in=9'b010110100;
		#10 up=0; down=1; load=0; loadMax=0; in=9'b000101101;
		#1340
		
		//Reset to 0
		#10 rst = 1;
		#10 rst = 0;
			#2 up=0; down=0; load=1; loadMax=0; in=9'b000101101;
			
			$display("\nLightsaber power level has reached critical level - needs charging soon!\n");
			
			#10 up=0; down=1; load=0; loadMax=0; in=9'b000000000;
			#475
			#10 up=0; down=0; load=0; loadMax=0; in=9'b000000000;
			
			$display("\nLightsaber is out of battery.");
		    $finish;
	end
endmodule