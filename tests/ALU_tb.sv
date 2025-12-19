//----------------------------------------------------------------------------------------------------
// Filename: ALU_tb.sv
// Author: Charles Bassani
// Description: Testbench for ALU
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module ALU_tb;

//----------------------------------------------------------------------------------------------------
// Test Registers
//----------------------------------------------------------------------------------------------------
logic [31:0] a;
logic [31:0] b;
logic [4:0]  shamt;
logic [3:0]  aluOp;
logic        useSign;
logic        zero;
logic        overflow;
logic        cout;
logic [31:0] res;

//----------------------------------------------------------------------------------------------------
// Device Under Test
//----------------------------------------------------------------------------------------------------
ALU dut
(
    .a(a),
    .b(b),
    .shamt(shamt),
    .aluOp(aluOp),
    .useSign(useSign),
    .zero(zero),
    .overflow(overflow),
    .cout(cout),
    .res(res)
);

//----------------------------------------------------------------------------------------------------
// Waveform Generation
//----------------------------------------------------------------------------------------------------
initial begin
    $dumpfile("build/ALU_tb_wave.vcd");
    $dumpvars(0, ALU_tb);
end

//----------------------------------------------------------------------------------------------------
// Test Logic
//----------------------------------------------------------------------------------------------------
initial begin
    //ADD unsigned
    a = 32'd5; 
    b = 32'd3; 
    aluOp = 4'h0; 
    useSign = 1'b0; 
    shamt = 0;
    #10 $display("ADD U: %0d + %0d = %0d | cout=%b overflow=%b zero=%b", a, b, res, cout, overflow, zero);

    //ADD (unsigned overflow
    a = 32'hFFFF_FFFF;
    b = 32'd1; 
    aluOp = 4'h0; 
    useSign = 1'b0;
    #10 $display("ADD U overflow: %h + %h = %h | cout=%b overflow=%b", a, b, res, cout, overflow);

    //SUB unsigned
    a = 32'd10; 
    b = 32'd3; 
    aluOp = 4'h1; 
    useSign = 1'b0;
    #10 $display("SUB U: %0d - %0d = %0d | cout=%b overflow=%b zero=%b", a, b, res, cout, overflow, zero);

    //SUB unsigned overflow
    a = 32'd3; 
    b = 32'd10; 
    aluOp = 4'h1; 
    useSign = 1'b0;
    #10 $display("SUB U underflow: %0d - %0d = %0d | cout=%b overflow=%b", a, b, res, cout, overflow);

    //AND / OR / NOR
    a = 32'hA5A5_F0F0; 
    b = 32'h0F0F_FFFF; 
    useSign = 1'b0;
    aluOp = 4'h2; #10 $display("AND: %h & %h = %h", a, b, res);
    aluOp = 4'h3; #10 $display("OR : %h | %h = %h", a, b, res);
    aluOp = 4'h4; #10 $display("NOR: ~(%h | %h) = %h", a, b, res);

    //Shifts
    a = 32'h0000_000F; 
    shamt = 4;
    aluOp = 4'h5; #10 $display("SLL: %h << %0d = %h", a, shamt, res);
    aluOp = 4'h6; #10 $display("SRL: %h >> %0d = %h", a, shamt, res);

    //SLT unsigned
    a = 32'd5; 
    b = 32'd9; 
    aluOp = 4'h7; 
    useSign = 1'b0;
    #10 $display("SLT U: %0d < %0d -> %0d", a, b, res);

    //Signed addition overflow
    a = 32'sh7FFF_FFFF; 
    b = 32'sh1; 
    aluOp = 4'h0; 
    useSign = 1'b1;
    #10 $display("ADD S overflow: %d + %d = %d | overflow=%b", a, b, res, overflow);

    //Signed subtraction overflow
    a = -32'sh7FFF_FFFF; 
    b = 32'sh1; 
    aluOp = 4'h1; 
    useSign = 1'b1;
    #10 $display("SUB S overflow: %d - %d = %d | overflow=%b", a, b, res, overflow);

    //SLT signed
    a = -32'd5; 
    b = 32'd3; 
    aluOp = 4'h7; 
    useSign = 1'b1;
    #10 $display("SLT S: %d < %d -> %d", a, b, res);

    //Zero flag test
    a = 32'd5; 
    b = 32'd5; 
    aluOp = 4'h1; 
    useSign = 1'b0;
    #10 $display("ZERO test (5-5): res=%d zero=%b", res, zero);

    $finish;
end

endmodule