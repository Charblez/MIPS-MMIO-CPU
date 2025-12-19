//----------------------------------------------------------------------------------------------------
// Filename: EX_Stage.sv
// Author: Charles Bassani
// Description: Executes instructions
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module EX_Stage
(
    input  logic        clk,
    input  logic        rst,
    input  logic        stall,

    // --- Control Signals ---
    input  logic        aluSrc,
    input  logic        beq,
    input  logic        lui,
    input  logic        zeroExt,
    input  logic [3:0]  aluOp,
    input  logic        useSign,

    // --- Forwarding Unit Signals ---
    input  logic        fwdA_en,
    input  logic        fwdB_en,
    input  logic [31:0] fwdA_data,
    input  logic [31:0] fwdB_data,
    
    // --- Pipeline Inputs ---
    input  logic [31:0] pc_in,
    input  logic [31:0] instruction_in,
    input  logic        regDst_in,
    input  logic        regWrite_in,
    input  logic        branch_in,
    input  logic        jump_in,
    input  logic        memRead_in,
    input  logic        memWrite_in,
    input  logic        memToReg_in,
    input  logic        atomic_in,
    input  logic [3:0]  mMask_in,
    input  logic        jal_in,
    input  logic [31:0] rsData_in,
    input  logic [31:0] rtData_in,

    // --- Pipeline Outputs ---
    output logic [31:0] pc_out,
    output logic [31:0] instruction_out,
    output logic        regDst_out,
    output logic        regWrite_out,
    output logic        memRead_out,
    output logic        memWrite_out,
    output logic        memToReg_out,
    output logic        atomic_out,
    output logic [3:0]  mMask_out,
    output logic        jal_out,
    output logic [31:0] rsData_out,
    output logic [31:0] rtData_out,
    output logic [31:0] aluRes_out,
    output logic        zeroExt_out,

    // --- Combinational Outputs ---
    output logic        branch_out,
    output logic [31:0] branchTarget_out
);


//----------------------------------------------------------------------------------------------------
// Module Registers
//----------------------------------------------------------------------------------------------------
logic [31:0] extImm;
logic [31:0] pcPlus4;

logic        zero;
logic        cout;
logic        overflow;

logic [31:0] aluRes;

//----------------------------------------------------------------------------------------------------
// Nested Modules
//----------------------------------------------------------------------------------------------------
ALU alu_inst
(
    .a(fwdA_en ? fwdA_data : rsData_in),
    .b(aluSrc ? extImm : (fwdB_en ? fwdB_data : rtData_in)),
    .shamt(lui ? 5'd16: instruction_in[10:6]),
    .aluOp(aluOp),
    .useSign(lui ? 1'b0 : useSign),
    .zero(zero),
    .overflow(overflow),
    .cout(cout),
    .res(aluRes)
);

//----------------------------------------------------------------------------------------------------
// Module Logic
//----------------------------------------------------------------------------------------------------
assign extImm = zeroExt ? {16'b0, instruction_in[15:0]} : {{16{instruction_in[15]}}, instruction_in[15:0]};
assign pcPlus4 = pc_in + 4;

assign branchTarget_out = pcPlus4 + (extImm << 2);
assign branch_out = branch_in && (beq ^ ~zero);

logic [31:0] next_rtData;

always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        pc_out <= 32'd0;
        instruction_out <= 32'd0;
        regDst_out <= 0;
        regWrite_out <= 0;
        memRead_out <= 0;
        memWrite_out <= 0;
        memToReg_out <= 0;
        atomic_out <= 0;
        mMask_out <= 0;
        jal_out <= 0;
        rsData_out <= 32'd0;
        rtData_out <= 32'd0;

        aluRes_out <= 32'd0;
        zeroExt_out <= 1'b0;
    end
    else if (!stall) begin
        // Pass throughs
        pc_out <= pc_in;
        instruction_out <= instruction_in;
        regDst_out <= regDst_in;
        regWrite_out <= regWrite_in;
        memRead_out <= memRead_in;
        memWrite_out <= memWrite_in;
        memToReg_out <= memToReg_in;
        atomic_out <= atomic_in;
        mMask_out <= mMask_in;
        jal_out <= jal_in;
        rsData_out <= rsData_in;
        rtData_out <= fwdB_en ? fwdB_data : rtData_in;

        // Combinational Outputs
        aluRes_out <= aluRes;
        zeroExt_out <= zeroExt;
    end
end
endmodule