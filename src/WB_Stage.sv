//----------------------------------------------------------------------------------------------------
// Filename: WB_Stage.sv
// Author: Charles Bassani
// Description: Writes data back to register file
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module WB_Stage
(
    //Absorbed
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] pc,
    input  logic [31:0] instruction,
    input  logic        regDst,
    input  logic        regWrite,
    input  logic        memToReg,
    input  logic        jal,
    input  logic [31:0] aluRes,
    input  logic        scSuccess,
    input  logic [31:0] memData,

    //Outputs
    output logic        wbEn,
    output logic [4:0]  wbAddr,
    output logic [31:0] wbData
);

//----------------------------------------------------------------------------------------------------
// Module Registers
//----------------------------------------------------------------------------------------------------
logic [4:0]  rd;
logic [4:0]  rt;

//----------------------------------------------------------------------------------------------------
// Module Logic
//----------------------------------------------------------------------------------------------------
assign rd = instruction[15:11];
assign rt = instruction[20:16];

always_comb begin
    wbEn = regWrite;
    wbAddr = jal ? 5'd31 : (regDst ? rd : rt);
    wbData = jal ? (pc + 4) : (scSuccess ? 32'd1 : (memToReg ? memData : aluRes));
end
endmodule