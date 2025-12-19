//----------------------------------------------------------------------------------------------------
// Filename: RegisterFile.sv
// Author: Charles Bassani
// Description: Registers for CPU
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module RegisterFile
(
    input  logic        clk,
    input  logic        rst,
    input  logic        writeEn,
    input  logic [4:0]  writeAddr,
    input  logic [31:0] writeData,
    input  logic [4:0]  readAddr1,
    input  logic [4:0]  readAddr2,
    output logic [31:0] readData1,
    output logic [31:0] readData2
);

//----------------------------------------------------------------------------------------------------
// Module Registers
//----------------------------------------------------------------------------------------------------
logic [31:0] regs [31:0];

//----------------------------------------------------------------------------------------------------
// Module Logic
//----------------------------------------------------------------------------------------------------
initial regs[0] = 0;

assign readData1 = regs[readAddr1];
assign readData2 = regs[readAddr2];

always_ff @(negedge clk or posedge rst) begin
    if(rst) begin
        for (int i = 0; i < 32; ++i) regs[i] <= 32'd0;
    end
    else begin
        if(writeEn && (writeAddr != 5'd0)) regs[writeAddr] <= writeData;
        regs[0] <= 32'd0;
    end
end

endmodule