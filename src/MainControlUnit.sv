//----------------------------------------------------------------------------------------------------
// Filename: MainControlUnit.sv
// Author: Charles Bassani
// Description: Produces Control Signals
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module MainControlUnit
(
    input  logic [31:0] instruction_in,
    output logic        regDst,
    output logic        regWrite,
    output logic        aluSrc,
    output logic        branch,
    output logic        jump,
    output logic        memRead,
    output logic        memWrite,
    output logic        memToReg,
    output logic        atomic,
    output logic [1:0]  mMask,
    output logic        beq,
    output logic        jal,
    output logic        jr,
    output logic        lui,
    output logic        zeroExt
);

//----------------------------------------------------------------------------------------------------
// Module Registers
//----------------------------------------------------------------------------------------------------
logic [5:0] opcode;
logic [5:0] funct;

//----------------------------------------------------------------------------------------------------
// Module Logic
//----------------------------------------------------------------------------------------------------
assign opcode = instruction_in[31:26];
assign funct = instruction_in[5:0];

always_comb begin
    //Avoid latching
    regDst     = 0;
    regWrite   = 0;
    aluSrc     = 0;
    branch     = 0;
    jump       = 0;
    memRead    = 0;
    memWrite   = 0;
    memToReg   = 0;
    atomic     = 0;
    mMask      = 2'b0;
    beq        = 0;
    jal        = 0;
    jr         = 0;
    lui        = 0;
    zeroExt    = 0;

    case(opcode)
        6'h00: begin // R-type
            if(funct == 6'h08) jr = 1;
            else begin
                regDst   = 1;
                regWrite = 1;
            end
        end

        6'h08: begin // ADDI
            regWrite = 1;
            aluSrc   = 1;
        end

        6'h09: begin // ADDIU
            regWrite = 1;
            aluSrc   = 1;
        end

        6'h0C: begin // ANDI
            regWrite = 1;
            aluSrc   = 1;
            zeroExt  = 1;
        end

        6'h04: begin // BEQ
            branch   = 1;
            beq      = 1;
        end

        6'h05: begin // BNE
            branch   = 1;
        end

        6'h02: begin // J
            jump     = 1;
        end

        6'h03: begin // JAL
            regWrite = 1;
            jump     = 1;
            jal      = 1;
        end

        6'h24: begin // LBU
            regWrite = 1;
            aluSrc   = 1;
            memRead  = 1;
            memToReg = 1;
            mMask    = 2'b00;
            zeroExt  = 1;
        end

        6'h25: begin // LHU
            regWrite = 1;
            aluSrc   = 1;
            memRead  = 1;
            memToReg = 1;
            mMask    = 2'b01;
        end

        6'h30: begin // LL
            regWrite = 1;
            aluSrc   = 1;
            memRead  = 1;
            memToReg = 1;
            atomic   = 1;
        end

        6'h0F: begin // LUI
            regWrite = 1;
            aluSrc   = 1;
            lui      = 1;
        end

        6'h23: begin // LW
            regWrite = 1;
            aluSrc   = 1;
            memRead  = 1;
            memToReg = 1;
            mMask    = 2'b10;
        end

        6'h0D: begin // ORI
            regWrite = 1;
            aluSrc   = 1;
            zeroExt  = 1;
        end

        6'h0A: begin // SLTI
            regWrite = 1;
            aluSrc   = 1;
        end

        6'h0B: begin // SLTIU
            regWrite = 1;
            aluSrc   = 1;
        end

        6'h28: begin // SB
            aluSrc   = 1;
            memWrite = 1;
            mMask    = 2'b00;
        end

        6'h38: begin // SC
            regWrite = 1;
            aluSrc   = 1;
            memWrite = 1;
            atomic   = 1;
        end

        6'h29: begin // SH
            aluSrc   = 1;
            memWrite = 1;
            mMask    = 2'b01;
        end

        6'h2B: begin // SW
            aluSrc   = 1;
            memWrite = 1;
            mMask    = 2'b10;
        end

    endcase
end

endmodule
