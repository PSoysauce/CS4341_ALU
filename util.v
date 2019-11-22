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
// 1:2 Decoder
// Based off observation of using shorthand if statements and multiplexer assembly
//=============================================
module Dec1x2(in, out);
	input in;           // 1-bit Input
	output [1:0]out;    // 2-bit Output

    // Shorthand if statement, convienent for a 1:2 decoder
	assign out = in ? 2'b10 : 2'b01;
    
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
// 4-Channel, 8-Bit Multiplexer
//=============================================
module Mux4_8bit(a3, a2, a1, a0, s, b);
	parameter k = 8;                // Eight Bits Wide
	input [k-1:0] a3, a2, a1, a0;   // Inputs
	input [3:0]   s;                // One-hot select
	output[k-1:0] b;
	assign b = ({k{s[3]}} & a3) | 
               ({k{s[2]}} & a2) | 
               ({k{s[1]}} & a1) |
               ({k{s[0]}} & a0) ;
endmodule

//=============================================
// 2-Channel, 8-Bit Multiplexer
// Modified from 4-Channel, 5-Bit Multiplexer
//=============================================
module Mux2_8bit(a1, a0, s, b);
	parameter k = 8;        // Eight Bits Wide
	input [k-1:0] a1, a0;   // Inputs
	input [1:0]   s;        // One-hot select
	output[k-1:0] b;
	assign b = ({k{s[1]}} & a1) |
               ({k{s[0]}} & a0);
endmodule

//=============================================
// 2-Channel, 1-Bit Multiplexer
//=============================================
module Mux2(a1, a0, s, b);
	parameter k = 1;        // One bit wide
	input [k-1:0] a1, a0;   // Inputs
	input [1:0]   s;        // One-hot select
	output[k-1:0] b;
	assign b = ({k{s[1]}} & a1) |
               ({k{s[0]}} & a0);
endmodule

//=============================================
// 2-Channel, 1-Bit Multiplexer
//=============================================
module Mux2_2bit(a1, a0, s, b);
	parameter k = 2;        // One bit wide
	input [k-1:0] a1, a0;   // Inputs
	input [1:0]   s;        // One-hot select
	output[k-1:0] b;
	assign b = ({k{s[1]}} & a1) |
               ({k{s[0]}} & a0);
endmodule

//=============================================
// 2-Channel, 1-Bit Multiplexer
//=============================================
module Mux2_6bit(a1, a0, s, b);
	parameter k = 6;        // One bit wide
	input [k-1:0] a1, a0;   // Inputs
	input [1:0]   s;        // One-hot select
	output[k-1:0] b;
	assign b = ({k{s[1]}} & a1) |
               ({k{s[0]}} & a0);
endmodule

// The following three modules are taken from Dr. Becker's sample code 
//   given in HW2 assignment document
module Add_half (input a, b, output c_out, sum);
  xor G1(sum, a, b);
  and G2(c_out, a, b);
endmodule

module Add_full (input a, b, c_in, output c_out, sum);
  wire w1, w2, w3;
  Add_half M1(a, b, w1, w2);
  Add_half M0(w2, c_in, w3, sum);
  or (c_out, w1, w3);
endmodule

module Add_rca_4 (input [3:0] a, b, input c_in, output c_out, output [3:0] sum);
  wire c_in1, c_in2, c_in3, c_in4;
  Add_full M0 (a[0], b[0], c_in, c_in1, sum[0]);
  Add_full M1 (a[1], b[1], c_in1, c_in2, sum[1]);
  Add_full M2 (a[2], b[2], c_in2, c_in3, sum[2]);
  Add_full M3 (a[3], b[3], c_in3, c_out, sum[3]);
endmodule

module Add_rca_8 (input [7:0] a, b, input c_in, output c_out, output [7:0] sum);
   wire c_in4;
   Add_rca_4 M0 (a[3:0], b[3:0], c_in, c_in4, sum[3:0]);
   Add_rca_4 M1 (a[7:4], b[7:4], c_in4, c_out, sum[7:4]);
endmodule

module Add_Sub_8_bit (a, b, m, c_out, sum_out);
    input [7:0] a;
    input [7:0] b;
    input m;

    output [7:0] sum_out;
    output c_out;

    wire [7:0] bx;

    xor XOR_FLIP_0 (bx[0], m, b[0]);
    xor XOR_FLIP_1 (bx[1], m, b[1]);
    xor XOR_FLIP_2 (bx[2], m, b[2]);
    xor XOR_FLIP_3 (bx[3], m, b[3]);
    xor XOR_FLIP_4 (bx[4], m, b[4]);
    xor XOR_FLIP_5 (bx[5], m, b[5]);
    xor XOR_FLIP_6 (bx[6], m, b[6]);
    xor XOR_FLIP_7 (bx[7], m, b[7]);

    Add_rca_8 add(a, bx, m, c_out, sum_out);

endmodule