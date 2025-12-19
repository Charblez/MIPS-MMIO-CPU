//----------------------------------------------------------------------------------------------------
// Filename: tb_CPUCore.sv
// Description: Testbench for CPUCore with simulated Unified Memory
//----------------------------------------------------------------------------------------------------
`timescale 1ns/1ps

module CPUCore_tb;

    //------------------------------------------------------------------------------------------------
    // Signals
    //------------------------------------------------------------------------------------------------
    logic        clk;
    logic        rst;
    
    // RAM Interface
    logic [31:0] ram_rdata;
    logic [31:0] ram_addr;
    logic [31:0] ram_wdata;
    logic [3:0]  ram_we;

    // Simulation Control
    int cycle_count = 0;

    //------------------------------------------------------------------------------------------------
    // DUT Instantiation
    //------------------------------------------------------------------------------------------------
    CPUCore dut (
        .clk       (clk),
        .rst       (rst),
        .ram_rdata (ram_rdata),
        .ram_addr  (ram_addr),
        .ram_wdata (ram_wdata),
        .ram_we    (ram_we)
    );

    //------------------------------------------------------------------------------------------------
    // Clock Generation
    //------------------------------------------------------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock (10ns period)
    end

    //------------------------------------------------------------------------------------------------
    // Memory Simulation (4KB Byte-Addressable Memory)
    //------------------------------------------------------------------------------------------------
    logic [7:0] main_memory [0:4095]; 

    // Synchronous Memory Read/Write logic
    always @(posedge clk) begin
        // WRITE (Little Endian Assumption)
        if (ram_we[0]) main_memory[ram_addr + 3] <= ram_wdata[7:0];
        if (ram_we[1]) main_memory[ram_addr + 2] <= ram_wdata[15:8];
        if (ram_we[2]) main_memory[ram_addr + 1] <= ram_wdata[23:16];
        if (ram_we[3]) main_memory[ram_addr + 0] <= ram_wdata[31:24];

        // READ (Little Endian Assumption)
        // If your design expects combinatorial read (async), move this to "always_comb"
        // Most realistic CPUs expect 1 cycle latency for RAM.
        
    end

    always_comb begin
        ram_rdata <= {
            main_memory[ram_addr + 3],
            main_memory[ram_addr + 2],
            main_memory[ram_addr + 1],
            main_memory[ram_addr + 0]
        };
    end

    //------------------------------------------------------------------------------------------------
    // Helper Task: Load Program
    //------------------------------------------------------------------------------------------------
    task load_program();
        // You can use $readmemh("program.hex", main_memory) here for real files.
        // Below is a manual loading of a few dummy instructions for demonstration.
        // Assuming MIPS-like encoding (Little Endian byte order in memory).
        
        integer i;
        // Clear memory
        for (i = 0; i < 4096; i++) main_memory[i] = 8'h00;

        $display("Loading Program into Simulation Memory...");
        
        // Addr 0x00: ADDI $1, $0, 10  (Machine Code: 0x2001000A)
        // Write 0A, 00, 01, 20
        main_memory[0] = 8'h0A; main_memory[1] = 8'h00; main_memory[2] = 8'h01; main_memory[3] = 8'h20;

        // Addr 0x04: ADDI $2, $0, 5   (Machine Code: 0x20020005)
        main_memory[4] = 8'h05; main_memory[5] = 8'h00; main_memory[6] = 8'h02; main_memory[7] = 8'h20;

        // Addr 0x08: ADD  $3, $1, $2  (Machine Code: 0x00221820)
        // Result in $3 should be 15 (0xF)
        main_memory[8] = 8'h20; main_memory[9] = 8'h18; main_memory[10] = 8'h22; main_memory[11] = 8'h00;
        
        // Addr 0x0C: SW   $3, 64($0)  (Machine Code: 0xAC030040)
        // Store value 15 into memory address 64 (0x40)
        main_memory[12] = 8'h40; main_memory[13] = 8'h00; main_memory[14] = 8'h03; main_memory[15] = 8'hAC;
    endtask

    //------------------------------------------------------------------------------------------------
    // Test Sequence
    //------------------------------------------------------------------------------------------------
    initial begin
        // 1. Initialize
        rst = 1;
        load_program();

        // 2. Hold Reset
        #20;
        rst = 0;
        $display("Reset released. CPU Start.");

        // 3. Run Simulation
        wait (cycle_count >= 100);
        $display("Hit Max Cycles. Stopping.");
        $finish;
    end

    initial begin
    $dumpfile("build/CPUCore_tb_wave.vcd");
    $dumpvars(0, CPUCore_tb);
end

    //------------------------------------------------------------------------------------------------
    // Monitoring / Logging
    //------------------------------------------------------------------------------------------------
    always @(posedge clk) begin
        if (!rst) begin
            cycle_count++;

            // Monitor Write Back Stage (Did an instruction finish?)
            if (dut.WB_en) begin
                $display("[Time %0t] WB: Reg[%0d] <= 0x%h", $time, dut.WB_addr, dut.WB_data);
            end

            // Monitor Memory Writes
            if (ram_we != 0) begin
                $display("[Time %0t] MEM: Wrote 0x%h to Addr 0x%h (Mask: %b)", 
                         $time, ram_wdata, ram_addr, ram_we);
            end
            
            // Monitor PC (using hierarchical reference to internal signal)
            // This is useful to see where the CPU is currently fetching
            $display("PC: %h, Stall: %h, Arb stall: %h, Hazard stall: %h, Instruction: %h", dut.IF_pc_current, dut.IF_stall_final, dut.arb_stall, dut.hazard_stall, dut.IF_instr_raw);
            $display("  RAM addr: %h, RAM_wdata: %h, RAM_we: %h, RAM_rdata: %h", dut.ram_addr, dut. ram_wdata, dut.ram_we, dut.ram_rdata);
            $display("  ARB a: %h, ARB b: %h, ARB b we: %h, ARB b re: %h, ARB wdata: %h, ARB rdata: %h", dut.IF_pc_current, dut.arb_addr_from_mem, dut.arb_we_from_mem, dut.arb_req_from_mem, dut.arb_wdata_from_mem, dut.arb_data_to_cpu_mem);
        end
    end

endmodule