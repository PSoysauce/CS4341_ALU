// Name - Patrick Soisson
// Class - 4341.001
// iVerilog can be found here: https://github.com/steveicarus/iverilog
//=============================================
// Saturation Counter
//=============================================
module SaturationCounter(clk, rst, up, down, load, loadMax, in, out) ;
  parameter n = 9;
  
//---------------------------------------------
// Parameters
//---------------------------------------------
  input clk, rst, up, down, load, loadMax ;
  input [n-1:0] in ;
  output [n-1:0] out ;
  
//---------------------------------------------
// Local Variables
//---------------------------------------------  
  wire [n-1:0] next, outpm1,outDown,outUp ;
  wire [n-1:0] max;
  wire [n-1:0] mux2out;
  wire [1:0] selectMax;

//---------------------------------------------  
// Load Max Count
//---------------------------------------------

  Dec       maxDec  (loadMax, selectMax);  
  Mux2 #(n) muxSat  (in, max, selectMax, mux2out);
  DFF  #(n) maxcount(clk, mux2out, max) ;

//---------------------------------------------  
// Main Counter Control
//--------------------------------------------- 
  
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

//=============================================
// D Flip-Flop
//=============================================
module DFF(clk,in,out);
  parameter n = 1;
  input  clk;
  input [n-1:0] in;
  output [n-1:0]out;
  reg [n-1:0]out;
  
  always @(posedge clk)//<--This is the statement that makes the circuit behave with TIME
  out = in;
endmodule

//D Flip-Flop
module Dec(a,b);
    input a;
    output [1:0]b;
    assign b = 1<<a;
endmodule

//2 channel multiplexer
module Mux2(a1, a0, s, b);
    parameter k = 5; //5 bits
    input [k-1:0]a1,a0;
    input[2-1:0]s;
    output[k-1:0]b;
    assign b = ({k{s[1]}} & a1) | ({k{s[0]}} & a0);
endmodule

 //=============================================
// 4-Channel, 2-Bit Multiplexer
//=============================================

module Mux4(a3, a2, a1, a0, s, b) ;
	parameter k = 5 ;//Five Bits Wide
	input [k-1:0] a3, a2, a1, a0 ;  // inputs
	input [3:0]   s ; // one-hot select
	output[k-1:0] b ;
	assign b = ({k{s[3]}} & a3) | 
               ({k{s[2]}} & a2) | 
               ({k{s[1]}} & a1) |
               ({k{s[0]}} & a0) ;
endmodule

module Add(C, O, A, B);
   input [3:0] A;
   input [3:0] B;
   output [3:0] O;
   output       C;

   assign {C, O} = A + B;
endmodule

//=============================================
// Test Bench
//=============================================
module recharge() ;
    parameter n = 9;
    //GET VARIABLE current battery percentage
    reg [n:0]battery;
    reg clk, rst;
    reg up, down, load, loadMax;
    reg [n-1:0]in;
    wire [n-1:0]out;
    wire [9:0] outputs;

    

    SaturationCounter sc(clk, rst, up, down, load, loadMax, in, out);
    initial begin
       battery = 'b0000001111;
       clk = 1;
       #5 clk = 0;
       $display("Clock | Reset | Up | Down | Load | Load Max | In | Max | Out |");
       forever
        begin
            #5 clk = 1; 

            $display("  %b   |   %b   |  %b |  %b   |  %b   |     %b    | %d |  %d |  %d |", clk,rst,up,down,load,loadMax, in, sc.max,out+battery);
            
            #5 clk = 0;
        end
    end
      
	//Stimuli
    initial begin
        rst = 0;
        #0
        #15
        rst = 1;
        #10
        rst=0;
        #10 up=0;down=0;load=0;loadMax=1;in=9'b111111111;
        #10 up=0;down=0;load=1;loadMax=0;in=9'b000000000;
        #10 up=1;down=0;load=0;loadMax=0;in=9'b000000000;
        #10000
        // #10 rst=0;
        // #10 up=0;down=0;load=1;loadMax=0;in=9'b111111111;
        // #10 up=1;down=1;load=0;loadMax=0;in=9'b000000000;
        // #10000
        // #10 up=0;down=0;load=0;loadMax=0;in=9'b000000000;
        // #10 up=0;down=0;load=0;loadMax=0;in=5'b00000;
        // #330
        // #10  rst = 0;
        // #10 up=0;down=0;load=1;loadMax=0;in=5'b01111;
        // #10 up=0;down=1;load=0;loadMax=0;in=5'b00000;
        // #200
        // #10 up=0;down=0;load=0;loadMax=0;in=5'b00000;

        battery = battery + out;
        $display("%battery count",battery);
        $finish;
    end
    // initial begin
    //     rst = 0;
    //     #0
    //     #15
    //     rst = 1;
    //     #10
    //     rst = 0;
    //     #10 up=0;down=0;load=0;loadMax=1;in=5'b11111;
    //     #10 up=0;down=0;load=1;loadMax=0;in=5'b00000;
    //     #10 up=1;down=0;load=0;loadMax=0;in=5'b00000;
    //     #330
    //     #10  rst = 0;
    //     #10 up=0;down=0;load=1;loadMax=0;in=5'b01111;
    //     #10 up=0;down=1;load=0;loadMax=0;in=5'b00000;
    //     #200
    //     #10 up=0;down=0;load=0;loadMax=0;in=5'b00000;
    //     $finish;
    // end
    
endmodule
