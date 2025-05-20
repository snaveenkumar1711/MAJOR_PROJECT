module clock_divider (
    input reference_clk,
    input reset,
    input clk_divider_enable,
    input [5:0] division_ratio,

    output output_clk
);

    reg [4:0] counter;
    reg divided_clk;
    reg odd_toggle;
    reg [5:0] prev_division_ratio;

    wire [4:0] ratio_divided_by_two;
    wire enable;

    always @(posedge reference_clk or negedge reset) begin
        if (~reset) begin
            divided_clk <= 1'b0;
            odd_toggle <= 1'b1;
            counter <= 5'b0;
            prev_division_ratio <= 6'd0;
        end
        else if (enable) begin
            // Reset state on division_ratio change
            if (division_ratio != prev_division_ratio) begin
                counter <= 5'd0;
                odd_toggle <= 1'b1;
                divided_clk <= 1'b0;
                prev_division_ratio <= division_ratio;
            end
            else if (~division_ratio[0]) begin  // even division
                if (counter == (ratio_divided_by_two - 1)) begin
                    divided_clk <= ~divided_clk;
                    counter <= 5'd0;
                end else begin
                    counter <= counter + 1;
                end
            end
            else begin  // odd division
                if ((counter == (ratio_divided_by_two - 1) && odd_toggle) ||
                    (counter == ratio_divided_by_two && !odd_toggle)) begin
                    divided_clk <= ~divided_clk;
                    odd_toggle <= ~odd_toggle;
                    counter <= 5'd0;
                end else begin
                    counter <= counter + 1;
                end
            end
        end
    end

    assign enable = clk_divider_enable & (division_ratio > 6'd1);
    assign ratio_divided_by_two = division_ratio >> 1;
    assign output_clk = clk_divider_enable ? divided_clk : reference_clk;

endmodule

