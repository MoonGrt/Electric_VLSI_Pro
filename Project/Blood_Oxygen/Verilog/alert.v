`timescale 1ns / 1ps

module Alert(
    input  wire [11:0] SAT,
    input  wire [11:0] threshold,
    output wire Warn
);

assign Warn = (SAT > threshold) ? 1 : 0;

endmodule
