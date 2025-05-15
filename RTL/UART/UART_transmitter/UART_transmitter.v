`include "/home/naveensodad/MAJOR_PROJECT/RTL/UART/UART_transmitter/UART_transmitter_FSM.v"
`include "/home/naveensodad/MAJOR_PROJECT/RTL/UART/UART_transmitter/serializer.v"
`include "/home/naveensodad/MAJOR_PROJECT/RTL/UART/UART_transmitter/parity_calculator.v"
`include "/home/naveensodad/MAJOR_PROJECT/RTL/UART/UART_transmitter/output_multiplexer.v"


module UART_transmitter #(
    parameter DATA_WIDTH = 8
)
(
    input clk,
    input reset,
    input parity_type,
    input parity_enable,
    input data_valid,
    input [DATA_WIDTH - 1:0] parallel_data,

    output serial_data_out,
    output busy

);

    // Bit select values of the output mux
    localparam [1:0] START_BIT_SELECT = 2'b00;
    localparam [1:0] STOP_BIT_SELECT = 2'b01;
    localparam [1:0] SERIAL_DATA_BIT_SELECT = 2'b10;
    localparam [1:0] PARITY_BIT_SELECT = 2'b11;

    // Internal signals' decalaration
    wire serial_enable;
    wire [$clog2(DATA_WIDTH) - 1:0] serial_data_index;
    wire [1:0] bit_select;
    wire serial_data;
    wire parity_bit;

    UART_transmitter_FSM #(
        .DATA_WIDTH(DATA_WIDTH),
        .START_BIT_SELECT(START_BIT_SELECT),
        .STOP_BIT_SELECT(STOP_BIT_SELECT),
        .SERIAL_DATA_BIT_SELECT(SERIAL_DATA_BIT_SELECT),
        .PARITY_BIT_SELECT(PARITY_BIT_SELECT)
    )  
    U_UART_transmitter_FSM (
        .clk(clk),
        .reset(reset),
        .data_valid(data_valid),
        .parity_enable(parity_enable),
        .serial_enable(serial_enable),
        .bit_select(bit_select),
        .serial_data_index(serial_data_index),
        .busy(busy)
    );


    serializer #(
        .DATA_WIDTH(DATA_WIDTH)
    )
    U_serializer (
        .clk(clk),
        .reset(reset),
        .parallel_data(parallel_data),
        .serial_enable(serial_enable),
        .serial_data_index(serial_data_index),
        .serial_data(serial_data)
    );


    parity_calculator #(
        .DATA_WIDTH(DATA_WIDTH)
    ) 
    U_parity_calculator (
        .clk(clk),
        .reset(reset),
        .parity_type(parity_type),
        .parity_enable(parity_enable),
        .data_valid(data_valid),
        .parallel_data(parallel_data),
        .parity_bit(parity_bit)
    );


    output_multiplexer # (
        .START_BIT_SELECT(START_BIT_SELECT),
        .STOP_BIT_SELECT(STOP_BIT_SELECT),
        .SERIAL_DATA_BIT_SELECT(SERIAL_DATA_BIT_SELECT),
        .PARITY_BIT_SELECT(PARITY_BIT_SELECT)
    ) U_output_multiplexer (
        .bit_select(bit_select),
        .serial_data(serial_data),
        .parity_bit(parity_bit),
        .mux_out(serial_data_out)
    );

endmodule
