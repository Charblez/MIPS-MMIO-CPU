//----------------------------------------------------------------------------------------------------
// Filename: ALUControlUnit.sv
// Author: Charles Bassani
// Description: Produces ALU Control Signals
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module ALUControlUnit
(
    input  logic [31:0] instruction_in,
    output logic [3:0]  aluOp,
    output logic        useSign 
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
    //Default signals
    aluOp = 4'h0;
    useSign = 1'b0;

    if(opcode == 6'h00) begin //R
        case(funct)
            6'h20: begin //ADD
                aluOp = 4'h0;
                useSign = 1'b1;
            end
            6'h21: aluOp = 4'h0; //ADDU
            6'h24: aluOp = 4'h2; //AND
            6'h08: aluOp = 4'h0; //JR
            6'h27: aluOp = 4'h4; //NOR
            6'h25: aluOp = 4'h3; //OR
            6'h2A: begin //SLT
                aluOp = 4'h7;
                useSign = 1'b1;
            end
            6'h2B: aluOp = 4'h7; //SLTU
            6'h00: aluOp = 4'h5; //SLL
            6'h02: aluOp = 4'h6; //SRL
            6'h22: begin //SUB
                aluOp = 4'h1;
                useSign = 1'b1;
            end
            6'h23: aluOp = 4'h1; //SUBU
        endcase
    end
    else begin
        case(opcode)
            6'h08: begin //ADDI
                aluOp = 4'h0;
                useSign = 1'b1;
            end
            6'h09: aluOp = 4'h0; //ADDIU
            6'h0C: aluOp = 4'h2; //ANDI
            6'h04: aluOp = 4'h1; //BEQ
            6'h05: aluOp = 4'h1; //BNE
            6'h02: aluOp = 4'h0; //J
            6'h03: aluOp = 4'h0; //JAL
            6'h24: aluOp = 4'h0; //LBU
            6'h25: aluOp = 4'h0; //LHU
            6'h30: aluOp = 4'h0; //LL
            6'h0F: aluOp = 4'h5; //LUI
            6'h23: aluOp = 4'h0; //LW
            6'h0D: aluOp = 4'h3; //ORI
            6'h0A: begin //SLTI
                aluOp = 4'h7;
                useSign = 1'b1;
            end
            6'h0B: aluOp = 4'h7; //SLTIU
            6'h28: aluOp = 4'h0; //SB
            6'h38: aluOp = 4'h0; //SC
            6'h29: aluOp = 4'h0; //SH
            6'h2B: aluOp = 4'h0; //SW
        endcase
    end
end


endmodule