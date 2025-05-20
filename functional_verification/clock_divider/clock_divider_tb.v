`include "/home/naveensodad/MAJOR_PROJECT/RTL/clock_divider/clock_divider.v"
`timescale 1ps / 1ps

module clock_divider_tb;

    reg reference_clk = 0;
    reg reset = 0;
    reg clk_divider_enable = 0;
    reg [5:0] division_ratio = 6'd0;
    wire output_clk;

    clock_divider uut (
        .reference_clk(reference_clk),
        .reset(reset),
        .clk_divider_enable(clk_divider_enable),
        .division_ratio(division_ratio),
        .output_clk(output_clk)
    );

    always #20 reference_clk = ~reference_clk;

    initial begin
        $dumpfile("/home/naveensodad/MAJOR_PROJECT/vcdfiles/clock_divider_dump.vcd");  // Output VCD
        $dumpvars(0, clock_divider_tb);

        // Reset
        reset = 0;
        #80;
        reset = 1;

        // Disabled initially
        clk_divider_enable = 0;
        #130;

        // Enable clock divider
        clk_divider_enable = 1;
        division_ratio = 6'd5;
        #830;

        division_ratio = 6'd3;
        #3000;

        division_ratio = 6'd8;
        #800;

        division_ratio = 6'd6;
        #800;

        $finish;
    end
endmodule

