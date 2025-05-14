module serializer #(
    parameter DATA_WIDTH = 8
)
(
    input clk,
    input reset,
    input [DATA_WIDTH - 1:0] parallel_data,
    input serial_enable,
    input [$clog2(DATA_WIDTH) - 1:0] serial_data_index,
    
    output reg serial_data
);

    // The 'D' signal of the serial data register (output signal)
    wire D_serial_data;

    assign D_serial_data = parallel_data[serial_data_index];

    // Serial data register
    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            serial_data <= 1'b0;
        end
        else if (serial_enable) begin
            serial_data <= D_serial_data;
        end
    end


endmodule
