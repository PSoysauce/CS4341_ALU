//=============================================
// Power module
// Possible set values:
//   0 - Off
//   1 - Single
//   2 - Double
//   3 - Hilted
//=============================================
module Power(clk, rst, powerSetting, powerMode, powerOutput);
    input clk;
    input rst;
    input [1:0] powerSetting;
    input powerMode;

    output [7:0] powerOutput;

    wire [3:0] powerUsageSel;
    wire [7:0] powerUsage1;
    wire powerUserCarryOut;
    wire [7:0] powerUserOutput;
    wire limMax;
    wire limMin;
    wire selDec;
    wire [1:0] dec2out;
    wire [1:0] dec2out2;
    wire [7:0] transfer;
    wire [7:0] transfer2;

	Dec2x4 dec (powerSetting, powerUsageSel);
    Mux4_8bit powerUsage(8'b00000011, 8'b00000010, 8'b00000001, 8'b00000000, powerUsageSel, powerUsage1);
    Add_Sub_8_bit powerUser(powerOutput, powerUsage1, powerMode, powerUserCarryOut, powerUserOutput);

    Dec1x2 dec2rst (rst, dec2out2);
    Mux2_8bit resetSel (8'b00000000, powerOutput, dec2out2, transfer2);

    // assign limMax = (1'b1 & powerOutput[7]) &&
	// 			    !(1'b0 & powerOutput[6]) &&
	// 			    (1'b1 & powerOutput[5]) &&
    //                 (1'b1 & powerOutput[4]) &&
    //                 !(1'b0 & powerOutput[3]) &&
    //                 !(1'b0 & powerOutput[2]) &&
    //                 (1'b1 & powerOutput[1]) &&
    //                 (1'b1 & powerOutput[0]);
    
    // assign limMin = !(1'b0 & powerOutput[7]) &&
    //                 !(1'b0 & powerOutput[6]) &&
    //                 !(1'b0 & powerOutput[5]) &&
    //                 !(1'b0 & powerOutput[4]) &&
    //                 !(1'b0 & powerOutput[3]) &&
    //                 !(1'b0 & powerOutput[2]) &&
    //                 !(1'b0 & powerOutput[1]) &&
    //                 !(1'b0 & powerOutput[0]);
    assign limMax = (powerOutput >= 179) ? 1 : 0;
    assign limMin = (powerOutput <= 0) ? 1 : 0;

    assign selDec = (limMax & !powerMode) || (limMin & powerMode) || rst;
    Dec1x2 dec2 (selDec, dec2out);
    Mux2_8bit sel (transfer2, powerUserOutput, dec2out, transfer);
    DFF power[7:0] (clk, transfer, powerOutput);

endmodule

module PowerCalc(powerSetting, powerMode, powerInput, powerOutput);
    input [1:0] powerSetting;
    input powerMode;
    input [7:0] powerInput;

    output [7:0] powerOutput;

    wire [3:0] powerUsageSel;
    wire [7:0] powerUsage2;
    wire powerUserCarryOut;
    //wire [7:0] powerUserOutput;

    Dec2x4 dec (powerSetting, powerUsageSel);
    Mux4_8bit powerUsage(8'b00000011, 8'b00000010, 8'b00000001, 8'b00000000, powerUsageSel, powerUsage2);
    Add_Sub_8_bit powerUser(powerInput, powerUsage2, powerMode, powerUserCarryOut, /*powerUserOutput*/ powerOutput);
endmodule
