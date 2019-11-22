/*
    Power module
    Handles recharging and power usage, along with warning
    
    Inputs:
    clk - Clock
    en - Enable (if power is on)
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

    Uses 1x2 Decoders, 2x4 Decoders, 2 Channel 2-Bit MUXs, 2 Channel 8-Bit MUXs, 4 Channel 8-bit MUXs, and
      8-bit adder/substractor
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

    // Enable Mux >> Clock is grounded if not enabled and 
    //   values do not change as a result
    wire [1:0] enDout;
    wire enClk;
    Dec1x2 enDec (en, enDout);
    Mux2 clkMux (clk, 1'b0, enDout, enClk);
    
    // Output initialization on reset;
    wire [1:0] rstDout;
    wire [7:0] rstMout;
    Dec1x2 rstDec (rst, rstDout);
    Mux2_8bit rstMux (8'b00000000, powerOutput, rstDout, rstMout);

    // Setting the adder/substractor values (what to add by/substract by) based on
    //   powerSetting
    wire [3:0] powerUsageDout;
    wire [7:0] powerUsageMout;
	Dec2x4 powerUsageDec (powerSetting, powerUsageDout);
    Mux4_8bit powerUsageMux (8'b00000011, 8'b00000010, 8'b00000001, 8'b00000000, powerUsageDout, powerUsageMout);

    // Calculating new power output
    wire powerUsageCalcCout;        // Note: This goes unused
    wire [7:0] powerUsageCalcOut;
    Add_Sub_8_bit powerUsageCalc (powerOutput, powerUsageMout, powerMode, powerUsageCalcCout, powerUsageCalcOut);

    // Power assignment section
    wire selDec;                    // Whether or not to continue allowing power output updates (allow power changes)
    assign selDec = (limMax & !powerMode) || (limMin & powerMode) || rst;

    wire [1:0] powerDout;
    wire [7:0] powerMout;
    Dec1x2 powerDec (selDec, powerDout);
    Mux2_8bit powerMux (rstMout, powerUsageCalcOut, powerDout, powerMout);
    DFF power[7:0] (enClk, powerMout, powerOutput);

    // Limits and power warn check
    wire limMax;
    wire limMin;

    assign limMax = (powerOutput >= 179) ? 1 : 0;
    assign limMin = (powerOutput == 0) ? 1 : ((powerOutput < 2) && (powerSetting == 2) ? 1 : ((powerOutput < 3) && (powerSetting == 3) ? 1 : 0));
    assign powerWarn = (powerOutput < 45) ? 1 : 0;
    
endmodule