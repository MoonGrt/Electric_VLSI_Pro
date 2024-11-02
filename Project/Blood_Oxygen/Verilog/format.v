`timescale 1ns / 1ps

module format(
    input  wire clk,         // clk signal
    input  wire en,          // enable signal
    input  wire [11:0] din,  // input saturation data
    output wire [15:0] format_data,
    output reg  tx = 1       // serial out
);

reg [23:0] shift_reg = 24'hffffff;
wire [1:0] parity;
wire [7:0] integer_part;
wire [7:0] fraction_part;
assign format_data = {integer_part, fraction_part};
assign integer_part = {1'b0, din[11:5]};
assign fraction_part = din[4:0]*100/32;
assign parity[0] = integer_part[0] ^ integer_part[1] ^ integer_part[2] ^ integer_part[3] ^ 
                   integer_part[4] ^ integer_part[5] ^ integer_part[6] ^ integer_part[7];
assign parity[1] = fraction_part[0] ^ fraction_part[1] ^ fraction_part[2] ^ fraction_part[3] ^ 
                   fraction_part[4] ^ fraction_part[5] ^ fraction_part[6] ^ fraction_part[7];

// shift register
always @(posedge clk) begin
    if (en) begin
        shift_reg <= {4'b0101, integer_part, parity[0], fraction_part, parity[1],2'b11};
    end else begin
        tx <= shift_reg[23];
        shift_reg <= {shift_reg[22:0], 1'b1};  // left shift
    end
end

endmodule