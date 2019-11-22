/*
    Power module
    
    Inputs:
    rst - Should be set to 0 initialially before using
    powerSetting -
        0 - Off
        1 - Low power use (or recharging amount)
        2 - Moderate power use
        3 - High power use
    powerMode -
        0 - Recharging
        1 - Using

    Outputs:
    powerOutput - Current power level (in seconds)
    powerWarn - Indicates if the power levels are low (below 44 seconds)

*/
module Power(clk, en, rst, powerSetting, powerMode, powerOutput, powerWarn);
    // Input
    input clk;
    input en;
    input rst;
    input [1:0] powerSetting;
    input powerMode;

    // Output
    output [7:0] powerOutput;
    output powerWarn;

    // Intermediate wires
    wire [1:0] enDout;
    wire enClk;
    
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

    Dec1x2 enDec (en, enDout);
    Mux2 clkMux (clk, 1'b0, enDout, enClk);

	Dec2x4 dec (powerSetting, powerUsageSel);
    Mux4_8bit powerUsage(8'b00000011, 8'b00000010, 8'b00000001, 8'b00000000, powerUsageSel, powerUsage1);
    Add_Sub_8_bit powerUser(powerOutput, powerUsage1, powerMode, powerUserCarryOut, powerUserOutput);

    Dec1x2 dec2rst (rst, dec2out2);
    Mux2_8bit resetSel (8'b00000000, powerOutput, dec2out2, transfer2);

    assign limMax = (powerOutput >= 179) ? 1 : 0;
    assign limMin = (powerOutput == 0) ? 1 : ((powerOutput < 2) && (powerSetting == 2) ? 1 : ((powerOutput < 3) && (powerSetting == 3) ? 1 : 0));
    assign powerWarn = (powerOutput < 45) ? 1 : 0;
    
    assign selDec = (limMax & !powerMode) || (limMin & powerMode) || rst;
    Dec1x2 dec2 (selDec, dec2out);
    Mux2_8bit sel (transfer2, powerUserOutput, dec2out, transfer);
    DFF power[7:0] (enClk, transfer, powerOutput);

endmodule