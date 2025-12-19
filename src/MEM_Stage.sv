// Filename: MEM_Stage.sv
// Author: Charles Bassani
// Description: Data memory interface stage
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module MEM_Stage
(
    input  logic        clk,
    input  logic        rst,
    input  logic        stall,

    // --- Control Signals ---
    input  logic        memRead,
    input  logic        memWrite,
    input  logic [1:0]  mMask,
    input  logic        atomic,
    input  logic        zeroExt,
    
    // --- Data Inputs ---
    input  logic [31:0] rtData,
    input  logic [31:0] aluRes_in,

    // --- Memory Arbiter Interface ---
    input  logic [31:0] arb_rdata,
    output logic        arb_req,
    output logic [3:0]  arb_we,
    output logic [31:0] arb_addr,
    output logic [31:0] arb_wdata,

    // --- Pipeline Pass Throughs ---
    input  logic [31:0] pc_in,
    input  logic [31:0] instruction_in,
    input  logic        regDst_in,
    input  logic        regWrite_in,
    input  logic        memToReg_in,
    input  logic        jal_in,
    
    // --- Pipeline Outputs ---
    output logic [31:0] pc_out,
    output logic [31:0] instruction_out,
    output logic        regDst_out,
    output logic        regWrite_out,
    output logic        memToReg_out,
    output logic        jal_out,
    output logic [31:0] aluRes_out,

    // --- Combinational Outputs ---
    output logic        scSuccess_out,
    output logic [31:0] memData_out
);

//----------------------------------------------------------------------------------------------------
// Module Registers
//----------------------------------------------------------------------------------------------------
logic        linkActive;
logic [31:0] linkAddr;
logic        sc_condition_met;
logic [1:0]  addr_offset;

logic [7:0]  byte_chunk;
logic [15:0] half_chunk;

logic [7:0]  lsb;
logic [7:0]  lisb;
logic [7:0]  misb;
logic [7:0]  msb;
logic        addr_offset_msb;

logic [15:0] lsc;
logic [15:0] msc;

logic        byte_chunk_sign;
logic        half_chunk_sign;

//----------------------------------------------------------------------------------------------------
// Module Logic
//----------------------------------------------------------------------------------------------------
assign addr_offset = aluRes_in[1:0];
assign sc_condition_met = linkActive && (linkAddr == aluRes_in);
assign arb_req = memRead || memWrite;
assign arb_addr = aluRes_in;
assign addr_offset_msb = addr_offset[1];

assign lsb = arb_rdata[7:0];
assign lisb = arb_rdata[15:8];
assign misb = arb_rdata[23:16];
assign msb = arb_rdata[31:24];

assign lsc = arb_rdata[15:0];
assign msc = arb_rdata[31:16];

assign byte_chunk_sign = byte_chunk[7];
assign half_chunk_sign = half_chunk[15];

always_ff @(posedge clk or posedge rst) begin
    if(rst) begin
        linkActive <= 1'b0;
        linkAddr   <= 32'd0;
    end 
    else if (!stall) begin
        //Load Linked
        if(memRead && atomic) begin
            linkActive <= 1'b1;
            linkAddr   <= aluRes_in;
        end
        //Store Conditional
        else if(memWrite && atomic) begin
            linkActive <= 1'b0;
        end
    end
end

always_comb begin
    // Defaults
    arb_we    = 4'b0000;
    arb_wdata = 32'b0;

    if(memWrite && (!atomic || (atomic && sc_condition_met))) begin
        
        case(mMask) 
            // BYTE
            2'b00: begin 
                case(addr_offset)
                    2'b00: begin arb_we = 4'b0001; arb_wdata = rtData; end
                    2'b01: begin arb_we = 4'b0010; arb_wdata = rtData << 8; end
                    2'b10: begin arb_we = 4'b0100; arb_wdata = rtData << 16; end
                    2'b11: begin arb_we = 4'b1000; arb_wdata = rtData << 24; end
                endcase
            end

            // HALF
            2'b01: begin 
                if (addr_offset_msb == 0) begin // Bottom
                    arb_we = 4'b0011; 
                    arb_wdata = rtData; 
                end 
                else begin                 // Top
                    arb_we = 4'b1100; 
                    arb_wdata = rtData << 16;
                end
            end

            // WORD 
            2'b10: begin 
                arb_we = 4'b1111; arb_wdata = rtData;
            end
            
            default: arb_we = 4'b0000;
        endcase
    end
end

always_comb begin
    case(addr_offset)
        2'b00: byte_chunk = lsb;
        2'b01: byte_chunk = lisb;
        2'b10: byte_chunk = misb;
        2'b11: byte_chunk = msb;
    endcase

    if(addr_offset_msb == 0) half_chunk = lsc;
    else                     half_chunk = msc;

    case(mMask)
        2'b00: begin
            if(zeroExt) memData_out = {24'b0, byte_chunk};
            else        memData_out = {{24{byte_chunk_sign}}, byte_chunk};
        end

        2'b01: begin
            if(zeroExt) memData_out = {16'b0, half_chunk};
            else        memData_out = {{16{half_chunk_sign}}, half_chunk};
        end

        2'b10: memData_out = arb_rdata;

        default: memData_out = arb_rdata;
    endcase
end

always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            pc_out          <= 32'd0;
            instruction_out <= 32'd0;
            regDst_out      <= 1'b0;
            regWrite_out    <= 1'b0;
            memToReg_out    <= 1'b0;
            jal_out         <= 1'b0;
            aluRes_out      <= 32'd0;
            scSuccess_out   <= 1'b0;
        end
        else if (!stall) begin
            // Direct Connections
            pc_out          <= pc_in;
            instruction_out <= instruction_in;
            regDst_out      <= regDst_in;
            regWrite_out    <= regWrite_in;
            memToReg_out    <= memToReg_in;
            jal_out         <= jal_in;
            aluRes_out      <= aluRes_in;

            if (atomic && memWrite) scSuccess_out <= sc_condition_met;
            else scSuccess_out <= 1'b0; // Default to 0 for non-SC ops
        end
    end

endmodule