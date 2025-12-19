//----------------------------------------------------------------------------------------------------
// Filename: IF_Stage.sv
// Author: Charles Bassani
// Description: Fetches Instructions
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module IF_Stage
(
    input  logic        clk,
    input  logic        rst,
    input  logic        stall,
    input  logic        flush,

    // --- PC Interface ---
    input  logic [31:0] pc_in,
    output logic [31:0] pc_out,
    
    // -- External Mem Interface ---
    input  logic [31:0] i_mem_rdata,
    output logic [31:0] i_mem_addr,

    // --- Pipeline Output ---
    output logic [31:0] instruction_out
);

//----------------------------------------------------------------------------------------------------
// Module Logic
//----------------------------------------------------------------------------------------------------
assign instruction_out = (flush) ? 32'b0 : i_mem_rdata;
assign i_mem_addr = pc_out;

always_ff @(posedge clk or posedge rst) begin
    if(rst) pc_out <= 32'h00400000;
    else if(!stall) pc_out <= pc_in;
end


endmodule