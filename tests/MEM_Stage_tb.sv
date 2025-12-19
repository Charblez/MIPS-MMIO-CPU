//----------------------------------------------------------------------------------------------------
// Filename: MEM_Stage_tb.sv
// Author: Charles Bassani
// Description: Testbench for MEM_Stage
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module MEM_Stage_tb;

//----------------------------------------------------------------------------------------------------
// Test Registers
//----------------------------------------------------------------------------------------------------
logic        clk;
logic        rst;
logic        memRead;
logic        memWrite;
logic [3:0]  mMask;
logic [31:0] rtData;
logic        atomic;
logic        regDst_in;
logic        regWrite_in;
logic        memToReg_in;
logic        jal_in;
logic        jr_in;
logic [31:0] aluRes_in;

logic        regDst_out;
logic        regWrite_out;
logic        memToReg_out;
logic        jal_out;
logic        jr_out;
logic [31:0] aluRes_out;
logic        scSuccess_out;
logic [31:0] memData;
//----------------------------------------------------------------------------------------------------
// Device Under Test
//----------------------------------------------------------------------------------------------------
MEM_Stage dut
(
    .clk(clk),
    .rst(rst),
    .memRead(memRead),
    .memWrite(memWrite),
    .mMask(mMask),
    .rtData(rtData),
    .atomic(atomic),
    .regDst_in(regDst_in),
    .regWrite_in(regWrite_in),
    .memToReg_in(memToReg_in),
    .jal_in(jal_in),
    .jr_in(jr_in),
    .aluRes_in(aluRes_in),
    .regDst_out(regDst_out),
    .regWrite_out(regWrite_out),
    .memToReg_out(memToReg_out),
    .jal_out(jal_out),
    .jr_out(jr_out),
    .aluRes_out(aluRes_out),
    .scSuccess_out(scSuccess_out),
    .memData(memData)
);

//----------------------------------------------------------------------------------------------------
// Waveform Generation
//----------------------------------------------------------------------------------------------------
initial begin
    $dumpfile("build/MEM_Stage_tb_wave.vcd");
    $dumpvars(0, MEM_Stage_tb);
end

//----------------------------------------------------------------------------------------------------
// Test Logic
//----------------------------------------------------------------------------------------------------
initial begin
    $finish;
end

endmodule