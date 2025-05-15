`include "/home/naveensodad/MAJOR_PROJECT/RTL/clock_gating_cell/clock_gating_cell.v"
`timescale 1ps / 1ps

module clock_gating_cell_tb;

    reg clk;
    reg clk_enable;
    wire gated_clock;

    // Instantiate the DUT (Device Under Test)
    clock_gating_cell dut (
        .clk(clk),
        .clk_enable(clk_enable),
        .gated_clock(gated_clock)
    );
    initial begin
	 $dumpfile("/home/naveensodad/MAJOR_PROJECT/vcdfiles/clock_gating_cell_dump.vcd");
        $dumpvars(0, clock_gating_cell_tb);
    end
    // Clock generation: 20 ps period (10 ps high, 10 ps low)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;  // Toggle every 10ps
    end

    // Stimulus
    initial begin
        // Initialize signals
        clk_enable = 0;

        // Apply test vectors as per clock_gating_cell.do
        #25  clk_enable = 1;
        #49  clk_enable = 0;
        #24  clk_enable = 1;
        #39  clk_enable = 0;
        #86  clk_enable = 1;
        #28  clk_enable = 0;
        #43  clk_enable = 1;
        #29  clk_enable = 0;
        #86  clk_enable = 1;
        #39  clk_enable = 0;
        #86;

        // Finish simulation
        $finish;
    end

    // Optional: Monitor signal transitions
    initial begin
        $display("Time\tclk\tclk_enable\tgated_clock");
        $monitor("%0t\t%b\t%b\t\t%b", $time, clk, clk_enable, gated_clock);
    end

endmodule

