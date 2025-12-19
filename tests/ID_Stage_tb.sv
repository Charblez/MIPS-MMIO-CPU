//----------------------------------------------------------------------------------------------------
// Filename: ID_Stage_tb.sv
// Author: Charles Bassani
// Description: Testbench for ID_Stage
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module ID_Stage_tb;

//----------------------------------------------------------------------------------------------------
// Test Registers
//----------------------------------------------------------------------------------------------------
logic        clk;
logic        rst;
logic [31:0] pc_in;
logic [31:0] instruction_in;
logic [31:0] writeData_WB;
logic [4:0]  writeAddr_WB;
logic        regWrite_WB;
logic [31:0] pc_out;
logic [31:0] instruction_out;
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
logic        zeroExt;
logic [3:0]  aluOp;
logic        useSign; 
logic [31:0] rsData; 
logic [31:0] rtData;

//----------------------------------------------------------------------------------------------------
// Device Under Test
//----------------------------------------------------------------------------------------------------
ID_Stage dut
(
    .clk(clk),
    .rst(rst),
    .pc_in(pc_in),
    .instruction_in(instruction_in),
    .writeData_WB(writeData_WB),
    .writeAddr_WB(writeAddr_WB),
    .regWrite_WB(regWrite_WB),
    .pc_out(pc_out),
    .instruction_out(instruction_out),
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
    .zeroExt(zeroExt),
    .aluOp(aluOp),
    .useSign(useSign),
    .rsData(rsData),
    .rtData(rtData) 
);

//----------------------------------------------------------------------------------------------------
// Waveform Generation
//----------------------------------------------------------------------------------------------------
initial begin
    $dumpfile("build/ID_Stage_tb_wave.vcd");
    $dumpvars(0, ID_Stage_tb);
end

//----------------------------------------------------------------------------------------------------
// Test Logic
//----------------------------------------------------------------------------------------------------
initial clk = 0;
always #5 clk = ~clk;

initial begin
    //Initialize inputs
    rst = 1;
    pc_in = 32'h1000_0000;
    instruction_in = 32'hFFFFFFFF;
    regWrite_WB = 0;
    writeAddr_WB = 5'd0;
    writeData_WB = 32'd0;
    #10;
    $display("After RESET: pc_out=%h instruction_out=%h (expect 0,0)", pc_out, instruction_out);

    //End RST
    rst = 0;

    //Write to register $1
    writeAddr_WB = 5'd1;
    writeData_WB = 32'hAAAA_AAAA;
    regWrite_WB = 1;
    #10;

    //Disable Write
    regWrite_WB = 0;

    // Write to register $2
    writeAddr_WB = 5'd2;
    writeData_WB = 32'h5555_5555;
    regWrite_WB = 1;
    #10;
    regWrite_WB = 0;

    //Decode R-type ADD: rs=$1, rt=$2
    pc_in = 32'h0040_0000;
    instruction_in = 32'b000000_00001_00010_00011_00000_100000; // ADD $3,$1,$2
    #10;
    $display("ADD: pc_out=%h instruction_out=%h aluOp=%h useSign=%b regWrite=%b", pc_out, instruction_out, aluOp, useSign, regWrite);
    $display("    RF rsData=%h rtData=%h (expect AAAAAAAA, 55555555)", rsData, rtData);

    //Decode I-type ANDI: rs=$1, rt=$2
    pc_in = 32'h0040_0008;
    instruction_in = 32'b001100_00001_00010_0000000000001111; // ANDI $2,$1,0xF
    #10;
    $display("ANDI: aluOp=%h useSign=%b zeroExt=%b", aluOp, useSign, zeroExt);
    $display("    RF rsData=%h (expect AAAAAAAA)", rsData);

    //Mid-operation reset
    rst = 1;
    #10;
    $display("During RESET: pc_out=%h instruction_out=%h (expect 0,0)", pc_out, instruction_out);
    rst = 0;

    //BEQ: verify control decoding
    pc_in = 32'h0040_000C;
    instruction_in = 32'b000100_00001_00010_0000000000000100; // BEQ $1,$2,offset
    #10;
    $display("BEQ: aluOp=%h branch=%b beq=%b", aluOp, branch, beq);

    $finish;
end
endmodule