//----------------------------------------------------------------------------------------------------
// Filename: MainControlUnit_tb.sv
// Author: Charles Bassani
// Description: Testbench for MainControlUnit
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module MainControlUnit_tb;

//----------------------------------------------------------------------------------------------------
// Test Registers
//----------------------------------------------------------------------------------------------------
logic [31:0] instruction_in;
logic        regDst;
logic        regWrite;
logic        aluSrc;
logic        branch;
logic        jump;
logic        memRead;
logic        memWrite;
logic        memToReg;
logic        atomic;
logic [3:0]  mMask;
logic        beq;
logic        jal;
logic        jr;
logic        lui;
logic [5:0]  opcode;
logic [5:0]  funct;
logic        zeroExt;

//----------------------------------------------------------------------------------------------------
// Device Under Test
//----------------------------------------------------------------------------------------------------
MainControlUnit dut
(
    .instruction_in(instruction_in),
    .regDst(regDst),
    .regWrite(regWrite),
    .aluSrc(aluSrc),
    .branch(branch),
    .jump(jump),
    .memRead(memRead),
    .memWrite(memWrite),
    .memToReg(memToReg),
    .atomic(atomic),
    .mMask(mMask),
    .beq(beq),
    .jal(jal),
    .jr(jr),
    .lui(lui),
    .zeroExt(zeroExt)
);

//----------------------------------------------------------------------------------------------------
// Waveform Generation
//----------------------------------------------------------------------------------------------------
initial begin
    $dumpfile("build/MainControlUnit_tb_wave.vcd");
    $dumpvars(0, MainControlUnit_tb);
end

//----------------------------------------------------------------------------------------------------
// Test Logic
//----------------------------------------------------------------------------------------------------
assign instruction_in = {opcode, 20'b0, funct};

initial begin
    //Initialize Signals
    opcode = 0;
    funct = 0;

    //R-Type not jr
    #10;

    //R-type jr
    funct = 6'h08;
    #10;

    //BEQ
    opcode = 6'h04;
    #10;

    //BNE
    opcode = 6'h05;
    #10;

    //LW
    opcode = 6'h23;
    #10;

    //SW
    opcode = 6'h2b;
    #10;

    //J
    opcode = 6'h02;
    #10;
    
    //JAL
    opcode = 6'h03;
    #10;

    //ORI for zeroExt
    opcode = 6'h0d;
    #10;

    $finish;
end



endmodule;