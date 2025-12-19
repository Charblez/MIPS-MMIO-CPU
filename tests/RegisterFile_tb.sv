//----------------------------------------------------------------------------------------------------
// Filename: RegisterFile_tb.sv
// Author: Charles Bassani
// Description: Testbench for RegisterFile
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module RegisterFile_tb;

//----------------------------------------------------------------------------------------------------
// Test Registers
//----------------------------------------------------------------------------------------------------
logic        clk;
logic        rst;
logic        writeEn;
logic [5:0]  writeAddr;
logic [31:0] writeData;
logic [5:0]  readAddr1;
logic [5:0]  readAddr2;
logic [31:0] readData1;
logic [31:0] readData2;

//----------------------------------------------------------------------------------------------------
// Device Under Test
//----------------------------------------------------------------------------------------------------
RegisterFile dut
(
    .clk(clk),
    .rst(rst),
    .writeEn(writeEn),
    .writeAddr(writeAddr),
    .writeData(writeData),
    .readAddr1(readAddr1),
    .readAddr2(readAddr2),
    .readData1(readData1),
    .readData2(readData2)
);

//----------------------------------------------------------------------------------------------------
// Waveform Generation
//----------------------------------------------------------------------------------------------------
initial begin
    $dumpfile("build/RegisterFile_tb_wave.vcd");
    $dumpvars(0, RegisterFile_tb);
end

//----------------------------------------------------------------------------------------------------
// Test Logic
//----------------------------------------------------------------------------------------------------
initial clk = 0;
always #5 clk = ~clk;

initial begin
    //Initialize signals
    rst = 1'b1;
    writeEn = 1'b0;
    writeAddr = 5'b0;
    writeData = 5'b0;
    readAddr1 = 5'b0;
    readAddr2 = 5'b0;

    //Reset
    #10;
    rst = 1'b0;

    //Write registers
    $display("Writing registers: 5 = AAAA_BBBB, 10 = 12345678, 15 = DEADBEEF");
    writeEn = 1;

    writeAddr = 5;  
    writeData = 32'hAAAA_BBBB; 
    #10;

    writeAddr = 10; 
    writeData = 32'h1234_5678; 
    #10;

    writeAddr = 15; 
    writeData = 32'hDEAD_BEEF; 
    #10;

    writeEn = 0;
    #10;

    //Read back registers
    $display("Reading registers");
    readAddr1 = 5;  
    readAddr2 = 10; 
    #10;
    $display("readData1 = %h, readData2 = %h: expected (AAAABBBB, 12345678)", readData1, readData2);

    readAddr1 = 15; 
    readAddr2 = 0; 
    #10;
    $display("readData1 = %h, readData2 = %h: expected (DEADBEEF, 00000000)", readData1, readData2);

    // Test reset clears all
    $display("Reset");
    rst = 1; #10; 
    rst = 0; #10;

    // Check if cleared
    readAddr1 = 5;  
    readAddr2 = 10; 
    #10;
    $display("readData1 = %h, readData2 = %h: expected (00000000, 00000000)", readData1, readData2);

    $finish;
end
endmodule