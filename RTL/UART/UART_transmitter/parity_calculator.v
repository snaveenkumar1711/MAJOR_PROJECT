module parity_calculator # (
    parameter DATA_WIDTH = 8
)
(
    input clk,
    input reset,
    input parity_type,
    input parity_enable,
    input data_valid,
    input [DATA_WIDTH - 1:0] parallel_data,
    
    output reg parity_bit
);


    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            parity_bit <= 1'b0;
        end
        else if (parity_enable && data_valid) begin
            if (parity_type) begin
                // Odd parity
                parity_bit <= ~^parallel_data;
            end
            else begin
                // Even parity
                parity_bit <= ^parallel_data;
            end
        end
    end

endmodule
