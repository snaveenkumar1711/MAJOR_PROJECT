`include "/home/naveensodad/MAJOR_PROJECT/RTL/bus_synchronizer/bus_synchronizer.v"

module data_synchronizer #(
    parameter STAGE_COUNT = 2,
    parameter BUS_WIDTH = 8
)
(
    input clk,
    input reset,
    input asynchronous_data_valid,
    input [BUS_WIDTH - 1:0] asynchronous_data,

    output reg Q_pulse_generator,
    output reg synchronous_data_valid,
    output reg [BUS_WIDTH - 1:0] synchronous_data
);

    wire synchronized_enable;
    wire pulse_generator_output;

    // Bit synchronizer to synchronize the data valid signal
    bus_synchronizer #(
        .STAGE_COUNT(STAGE_COUNT),
        .BUS_WIDTH(1)
    )
    U_bus_synchronizer (
        .clk(clk),
        .reset(reset),
        .asynchronous_data(asynchronous_data_valid),

        .synchronous_data(synchronized_enable)
    );


    // Pulse generator register
    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            Q_pulse_generator <= 1'b0;
        end
        else begin
            Q_pulse_generator <= synchronized_enable;
        end
    end
    assign pulse_generator_output = synchronized_enable & (~Q_pulse_generator);


    // Data valid register
    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            synchronous_data_valid <= 1'b0;
        end
        else begin
            synchronous_data_valid <= pulse_generator_output;
        end
    end

    // Synchronized data register
    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            synchronous_data <= 'b0;
        end
        else if (pulse_generator_output) begin
            synchronous_data <= asynchronous_data;
        end
    end


endmodule
