//----------------------------------------------------------------------------------------------------
// Filename: HazardUnit.sv
// Author: Charles Bassani
// Description: Handles Hazards
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module HazardUnit
(
    input  logic        ID_EX_memRead,
    input  logic        EX_MEM_memWrite,
    input  logic [4:0]  ID_EX_rt,
    input  logic [4:0]  IF_ID_rs,
    input  logic [4:0]  IF_ID_rt,

    output logic        PCWrite,
    output logic        IF_ID_Write,
    output logic        ID_EX_Flush,
    output logic        stall
);

//----------------------------------------------------------------------------------------------------
// Module Logic
//----------------------------------------------------------------------------------------------------
always_comb begin

    stall       = 0;
    PCWrite     = 1;
    IF_ID_Write = 1;
    ID_EX_Flush = 0;

    //Load-use Hazard
    if(ID_EX_memRead && ((ID_EX_rt == IF_ID_rs) || (ID_EX_rt == IF_ID_rt))) begin
        stall       = 1;
        PCWrite     = 0;
        IF_ID_Write = 0;
        ID_EX_Flush = 1;
    end
end

endmodule