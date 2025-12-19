//----------------------------------------------------------------------------------------------------
// Filename: EX_Stage_tb.sv
// Author: Charles Bassani
// Description: Testbench for EX_Stage
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module EX_Stage_tb;

//----------------------------------------------------------------------------------------------------
// Test Registers
//----------------------------------------------------------------------------------------------------


//----------------------------------------------------------------------------------------------------
// Device Under Test
//----------------------------------------------------------------------------------------------------
EX_Stage dut 
(
    .clk(clk),
    .rst(rst),
    .pc_in(pc_in),
    .instruction_in(instruction_in),
    .aluSrc(aluSrc),
    .beq(beq),
    .lui(lui),
    .zeroExt(zeroExt),
    .aluOp(aluOp),
    .useSign(useSign),
    .rsData_in(rsData_in),
    .rtData_in(rtData_in),

    .regDst_in(regDst_in),
    .regWrite_in(regWrite_in),
    .branch_in(branch_in),
    .jump_in(jump_in),
    .memRead_in(memRead_in),
    .memWrite_in(memWrite_in),
    .memToReg_in(memToReg_in),
    .atomic_in(atomic_in),
    .mMask_in(mMask_in),
    .jal_in(jal_in),
    .jr_in(jr_in),

    .pc_out(pc_out),
    .regDst_out(regDst_out),
    .regWrite_out(regWrite_out),
    .branch_out(branch_out),
    .jump_out(jump_out),
    .memRead_out(memRead_out),
    .memWrite_out(memWrite_out),
    .memToReg_out(memToReg_out),
    .atomic_out(atomic_out),
    .mMask_out(mMask_out),
    .jal_out(jal_out),
    .jr_out(jr_out),
    .rsData_out(rsData_out)
    .rtData_out(rtData_out)

    .aluRes(aluRes),
    .branchTarget(branchTarget),
    .jumpTarget(jumpTarget)
);

//----------------------------------------------------------------------------------------------------
// Waveform Generation
//----------------------------------------------------------------------------------------------------
initial begin
    $dumpfile("build/EX_Stage_tb_wave.vcd");
    $dumpvars(0, EX_Stage_tb);
end

//----------------------------------------------------------------------------------------------------
// Test Logic
//----------------------------------------------------------------------------------------------------
initial clk = 0;
always #5 clk = ~clk;

initial begin
    
    $finish;
end

endmodule