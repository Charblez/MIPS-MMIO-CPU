//----------------------------------------------------------------------------------------------------
// Filename: Memory.sv
// Author: Charles Bassani
// Description: RAM
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module Memory #
(
    parameter arg_numRegs = 8192,
    parameter arg_indexWidth = $clog2(arg_numRegs)
)
(
    input logic clk,
    input logic rst,
    input logic writeEn,
    input logic [3:0] mMask,
    input logic [arg_indexWidth-1:0] writeAddr,
    input logic [31:0] writeData,
    input logic [arg_indexWidth-1:0] readAddr,
    output logic [31:0] readData
);

//----------------------------------------------------------------------------------------------------
// Module Registers
//----------------------------------------------------------------------------------------------------
logic [7:0] mem [0:arg_numRegs-1];
 
//----------------------------------------------------------------------------------------------------
// Module Logic
//----------------------------------------------------------------------------------------------------
always_ff @(negedge clk or posedge rst) begin
    if (rst) begin
        for(int i = 0; i < arg_numRegs; i++) begin
            mem[i] <= 8'h00;
        end
    end
    else if(writeEn) begin
        case(mMask)
            4'b0001: mem[writeAddr] <= writeData[7:0];
            4'b0011: begin
                mem[writeAddr+1] <= writeData[7:0];
                mem[writeAddr] <= writeData[15:8];
            end
            4'b1111: begin
                mem[writeAddr+3] <= writeData[7:0];
                mem[writeAddr+2] <= writeData[15:8];
                mem[writeAddr+1] <= writeData[23:16];
                mem[writeAddr] <= writeData[31:24];
            end
        endcase
    end
end

always_comb begin
    case (mMask)
        4'b0001: readData = { {24{1'b0}}, mem[readAddr]};
        4'b0011: readData = { {16{1'b0}}, mem[readAddr], mem[readAddr+1]};
        4'b1111: readData = { mem[readAddr], mem[readAddr+1], mem[readAddr+2], mem[readAddr+3]};
        default: readData = 32'bx;
    endcase
end


endmodule
