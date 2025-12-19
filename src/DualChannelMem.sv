//----------------------------------------------------------------------------------------------------
// Filename: DualChannelMem.sv
// Author: Charles Bassani
// Description: Implementation of dual port RAM with bus collision detection
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module DualChannelMem
(
    input  logic clk,
    output logic bus_col,

    //Port A
    input  logic [3:0]  we_a,
    input  logic [31:0] addr_a, 
    input  logic [31:0] wdata_a, 
    output logic [31:0] rdata_a, 

    //Port A
    input  logic [3:0]  we_b,
    input  logic [31:0] addr_b, 
    input  logic [31:0] wdata_b, 
    input  logic [3:0]  mask_b,
    output logic [31:0] rdata_b
);

//----------------------------------------------------------------------------------------------------
// Module Registers
//----------------------------------------------------------------------------------------------------
logic [7:0] ram [0:8191];

//----------------------------------------------------------------------------------------------------
// Module Logic
//----------------------------------------------------------------------------------------------------
always_ff @(posedge clk) begin
    bus_col <= we_a && we_b & (addr_a == addr_b);

    case(we_a)
        4'b0000: rdata_a <= ram[addr_a];
        4'b0001: begin
            ram[addr_a]     <= wdata_a[7:0];
        end
        4'b0011: begin
            ram[addr_a + 1] <= wdata_a[7:0];
            ram[addr_a]     <= wdata_a[15:8];
        end
        4'b1111: begin
            ram[addr_a + 3] <= wdata_a[7:0];
            ram[addr_a + 2] <= wdata_a[15:8];
            ram[addr_a + 1] <= wdata_a[23:16];
            ram[addr_a]     <= wdata_a[31:24];
        end
    endcase

    case(we_b)
        4'b0000: rdata_b <= ram[addr_b];
        4'b0001: begin
            ram[addr_b]     <= wdata_b[7:0];
        end
        4'b0011: begin
            ram[addr_b + 1] <= wdata_b[7:0];
            ram[addr_b]     <= wdata_b[15:8];
        end
        4'b1111: begin
            ram[addr_b + 3] <= wdata_b[7:0];
            ram[addr_b + 2] <= wdata_b[15:8];
            ram[addr_b + 1] <= wdata_b[23:16];
            ram[addr_b]     <= wdata_b[31:24];
        end
    endcase
end

endmodule