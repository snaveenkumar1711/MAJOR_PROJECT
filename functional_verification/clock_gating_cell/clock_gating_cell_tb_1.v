`include "/home/naveensodad/MAJOR_PROJECT/RTL/clock_gating_cell/clock_gating_cell.v"
`timescale 1ns/1ps

module clock_gating_cell_tb;

    // Inputs
    reg clk;
    reg clk_enable;

    // Output
    wire gated_clock;

    // Instantiate the DUT
    clock_gating_cell uut (
        .clk(clk),
        .clk_enable(clk_enable),
        .gated_clock(gated_clock)
    );

    // Clock generation (period = 10ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5ns
    end

    // Stimulus
    initial begin
	$dumpfile("/home/naveensodad/MAJOR_PROJECT/vcdfiles/clock_gating_cell_dump.vcd");
        $dumpvars(0, clock_gating_cell_tb);

        clk_enable = 1;  // Case 1: Enable high
        #20;

        clk_enable = 0;  // Case 2: Disable
        #20;

        clk_enable = 1;  // Case 3: Re-enable while clk=1 (no update expected)
        #3;              // Midway during clk=1
        clk_enable = 0;  // Quick toggle to 0
        #2;              // Still clk=1, Q should not update
        #5;              // Wait until clk falls
        #5;

        clk_enable = 1;  // Case 4: Change clk_enable during clk=0
        #10;

        $finish;
    end

endmodule

