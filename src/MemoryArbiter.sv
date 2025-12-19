//----------------------------------------------------------------------------------------------------
// Filename: MemoryArbiter.sv
// Author: Charles Bassani
// Description: 
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

//----------------------------------------------------------------------------------------------------
// Module Declaration
//----------------------------------------------------------------------------------------------------
module MemoryArbiter
(
    // --- Port A --- 
    input  logic [31:0] addr_a,
    output logic [31:0] rdata_a,

    // --- Port B ---
    input  logic [31:0] addr_b,
    input  logic [3:0]  we_b,
    input  logic        re_b,
    input  logic [31:0] wdata_b,
    output logic [31:0] rdata_b,

    // --- RAM Interface ---
    input  logic [31:0] rdata_ram,
    output logic [31:0] addr_ram,
    output logic [31:0] wdata_ram,
    output logic [3:0]  we_ram,

    // --- Control Logic ---
    output logic        stall
);

//----------------------------------------------------------------------------------------------------
// Module Registers
//----------------------------------------------------------------------------------------------------
logic [31:0] addr_v;
logic [15:0] upper_half;
logic [15:0] lower_half;
logic [31:0] mapped_addr;

//----------------------------------------------------------------------------------------------------
// Module Logic
//----------------------------------------------------------------------------------------------------
assign upper_half = addr_v[31:16];
assign lower_half = addr_v[15:0];
assign addr_ram = {mapped_addr[31:2], 2'b00};

always_comb begin
    if(re_b || (|we_b)) begin
        addr_v = addr_b;
        wdata_ram = wdata_b;
        we_ram = we_b;
        stall = 1'b1;

        rdata_a = 32'b0;
        rdata_b = rdata_ram;
    end
    else begin
        addr_v = addr_a;
        wdata_ram = 32'b0;
        we_ram = 4'h0;
        stall  = 1'b0;

        rdata_a = rdata_ram;
        rdata_b = 32'b0;
    end

    //Address Translation
    if(upper_half >= 16'h7FFF) mapped_addr = {16'h0002, lower_half};
    else if(upper_half >= 16'h1001) mapped_addr = {16'h0001, lower_half};
    else if(upper_half >= 16'h0040) mapped_addr = {16'h0000, lower_half};
    else mapped_addr = {16'h0003, lower_half};
    $display("mapped addr: %d", mapped_addr);

end

endmodule