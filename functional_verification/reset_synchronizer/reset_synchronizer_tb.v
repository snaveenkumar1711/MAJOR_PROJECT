`include "/home/naveensodad/MAJOR_PROJECT/RTL/reset_synchronizer/reset_synchronizer.v"
`timescale 1ps / 1ps

module reset_synchronizer_tb;

    // Inputs
    reg clk = 0;
    reg reset = 0;

    // Output
    wire reset_synchronized;

    // Instantiate the DUT (Device Under Test)
    reset_synchronizer #(
        .STAGE_COUNT(2)
    ) uut (
        .clk(clk),
        .reset(reset),
        .reset_synchronized(reset_synchronized)
    );

    // Clock generation: 50% duty cycle, 20ps period
    always #10 clk = ~clk;

    initial begin
        // Generate waveform dump
        $dumpfile("/home/naveensodad/MAJOR_PROJECT/vcdfiles/reset_synchronizer.vcd");
        $dumpvars(0, reset_synchronizer_tb);

        // Test sequence

        // Initial state
        reset = 0;
        #25;

        // First deassertion of reset
        reset = 1;
        #49;

        // Assert reset again
        reset = 0;
        #24;

        // Deassert reset again
        reset = 1;
        #39;

        // Pulse reset again
        reset = 0;
        #86;

        // Deassert
        reset = 1;
        #28;

        // Again reset pulse
        reset = 0;
        #43;

        // Deassert reset
        reset = 1;
        #29;

        // Reset again
        reset = 0;
        #86;

        // Deassert one last time
        reset = 1;
        #39;

        // Final reset
        reset = 0;
        #86;

        // Finish simulation
        $finish;
    end

endmodule

