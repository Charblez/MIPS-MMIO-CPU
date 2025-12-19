//----------------------------------------------------------------------------------------------------
// Filename: ForwardingUnit.sv
// Author: Charles Bassani
// Description: Forwards WB results to EX Stage
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module ForwardingUnit
(
    input  logic        EX_MEM_regWrite,
    input  logic [4:0]  EX_MEM_rd,
    input  logic [31:0] EX_MEM_aluRes,
    input  logic        EX_MEM_memRead,
    input  logic        MEM_WB_regWrite,
    input  logic [4:0]  MEM_WB_rd,
    input  logic [31:0] MEM_WB_data,
    input  logic [4:0]  ID_EX_rs,
    input  logic [4:0]  ID_EX_rt,

    output logic        fwdA_en,
    output logic [31:0] fwdA_data,
    output logic        fwdB_en,
    output logic [31:0] fwdB_data
);

//----------------------------------------------------------------------------------------------------
// Module Logic
//----------------------------------------------------------------------------------------------------
always_comb begin
    fwdA_en   = 1'b0;
    fwdB_en   = 1'b0;
    fwdA_data = 32'd0;
    fwdB_data = 32'd0;

    // Forwarding for RS
    if(EX_MEM_regWrite && !EX_MEM_memRead && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs)) begin
        fwdA_en   = 1'b1;
        fwdA_data = EX_MEM_aluRes;
    end
    else if(MEM_WB_regWrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rs)) begin
        fwdA_en   = 1'b1;
        fwdA_data = MEM_WB_data;
    end

    // Forwarding for RT
    if(EX_MEM_regWrite && !EX_MEM_memRead && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rt)) begin
        fwdB_en   = 1'b1;
        fwdB_data = EX_MEM_aluRes;
    end
    else if(MEM_WB_regWrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rt)) begin
        fwdB_en   = 1'b1;
        fwdB_data = MEM_WB_data;
    end
    
end
endmodule