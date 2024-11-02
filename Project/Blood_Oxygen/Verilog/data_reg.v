`timescale 1ns / 1ps

module data_reg(
    input  wire [15:0] format_data,
    output wire  [11:0] threshold
);

wire [15:0] format_data_store = format_data;
assign threshold = 12'b101111100000; // "95"

endmodule
