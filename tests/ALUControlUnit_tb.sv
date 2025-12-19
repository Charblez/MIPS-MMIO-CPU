//----------------------------------------------------------------------------------------------------
// Filename: ALUControlUnit_tb.sv
// Author: Charles Bassani
// Description: Testbench for ALUControlUnit
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module ALUControlUnit_tb;

//----------------------------------------------------------------------------------------------------
// Test Registers
//----------------------------------------------------------------------------------------------------
logic [31:0] instruction_in;
logic [3:0]  aluOp;
logic        useSign;

//----------------------------------------------------------------------------------------------------
// Device Under Test
//----------------------------------------------------------------------------------------------------
ALUControlUnit dut
(
    .instruction_in(instruction_in),
    .aluOp(aluOp),
    .useSign(useSign)
);

//----------------------------------------------------------------------------------------------------
// Waveform Generation
//----------------------------------------------------------------------------------------------------
initial begin
    $dumpfile("build/ALUControlUnit_tb_wave.vcd");
    $dumpvars(0, ALUControlUnit_tb);
end

//----------------------------------------------------------------------------------------------------
// Test Logic
//----------------------------------------------------------------------------------------------------
initial begin
    //R-type: ADD
    instruction_in = 32'b000000_00000_00000_00000_00000_100000; //funct = 0x20
    #10 $display("R-ADD : aluOp=%h useSign=%b (expect 0,1)", aluOp, useSign);

    //R-type: ADDU
    instruction_in = 32'b000000_00000_00000_00000_00000_100001; //funct = 0x21
    #10 $display("R-ADDU: aluOp=%h useSign=%b (expect 0,0)", aluOp, useSign);

    //R-type: SUB
    instruction_in = 32'b000000_00000_00000_00000_00000_100010; //funct = 0x22
    #10 $display("R-SUB : aluOp=%h useSign=%b (expect 1,1)", aluOp, useSign);

    //R-type: AND
    instruction_in = 32'b000000_00000_00000_00000_00000_100100; //funct = 0x24
    #10 $display("R-AND : aluOp=%h useSign=%b (expect 2,0)", aluOp, useSign);

    //R-type: OR
    instruction_in = 32'b000000_00000_00000_00000_00000_100101; //funct = 0x25
    #10 $display("R-OR  : aluOp=%h useSign=%b (expect 3,0)", aluOp, useSign);

    //R-type: NOR
    instruction_in = 32'b000000_00000_00000_00000_00000_100111; //funct = 0x27
    #10 $display("R-NOR : aluOp=%h useSign=%b (expect 4,0)", aluOp, useSign);

    //R-type: SLL
    instruction_in = 32'b000000_00000_00000_00000_00000_000000; //funct = 0x00
    #10 $display("R-SLL : aluOp=%h useSign=%b (expect 5,0)", aluOp, useSign);

    //R-type: SRL
    instruction_in = 32'b000000_00000_00000_00000_00000_000010; //funct = 0x02
    #10 $display("R-SRL : aluOp=%h useSign=%b (expect 6,0)", aluOp, useSign);

    //R-type: SLT
    instruction_in = 32'b000000_00000_00000_00000_00000_101010; //funct = 0x2A
    #10 $display("R-SLT : aluOp=%h useSign=%b (expect 7,1)", aluOp, useSign);

    //I-type: ADDI
    instruction_in = 32'b001000_00000_00000_0000000000000000; //opcode = 0x08
    #10 $display("I-ADDI: aluOp=%h useSign=%b (expect 0,1)", aluOp, useSign);

    //I-type: ADDIU
    instruction_in = 32'b001001_00000_00000_0000000000000000; //opcode = 0x09
    #10 $display("I-ADDIU: aluOp=%h useSign=%b (expect 0,0)", aluOp, useSign);

    //I-type: ANDI
    instruction_in = 32'b001100_00000_00000_0000000000000000; //opcode = 0x0C
    #10 $display("I-ANDI: aluOp=%h useSign=%b (expect 2,0)", aluOp, useSign);

    //I-type: ORI
    instruction_in = 32'b001101_00000_00000_0000000000000000; //opcode = 0x0D
    #10 $display("I-ORI : aluOp=%h useSign=%b (expect 3,0)", aluOp, useSign);

    //I-type: SLTI
    instruction_in = 32'b001010_00000_00000_0000000000000000; //opcode = 0x0A
    #10 $display("I-SLTI: aluOp=%h useSign=%b (expect 7,1)", aluOp, useSign);

    //I-type: SLTIU
    instruction_in = 32'b001011_00000_00000_0000000000000000; //opcode = 0x0B
    #10 $display("I-SLTIU: aluOp=%h useSign=%b (expect 7,0)", aluOp, useSign);

    //I-type: LUI
    instruction_in = 32'b001111_00000_00000_0000000000000000; //opcode = 0x0F
    #10 $display("I-LUI : aluOp=%h useSign=%b (expect 5,0)", aluOp, useSign);

    //I-type: BEQ
    instruction_in = 32'b000100_00000_00000_0000000000000000; //opcode = 0x04
    #10 $display("I-BEQ : aluOp=%h useSign=%b (expect 1,0)", aluOp, useSign);

    //I-type: BNE
    instruction_in = 32'b000101_00000_00000_0000000000000000; //opcode = 0x05
    #10 $display("I-BNE : aluOp=%h useSign=%b (expect 1,0)", aluOp, useSign);

    //Memory: LW
    instruction_in = 32'b100011_00000_00000_0000000000000000; //opcode = 0x23
    #10 $display("I-LW  : aluOp=%h useSign=%b (expect 0,0)", aluOp, useSign);

    //Memory: SW
    instruction_in = 32'b101011_00000_00000_0000000000000000; //opcode = 0x2B
    #10 $display("I-SW  : aluOp=%h useSign=%b (expect 1,0)", aluOp, useSign);

    $finish;
end

endmodule