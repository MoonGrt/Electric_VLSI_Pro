`timescale 1ns / 1ps
module divider(
    input  wire [7:0] AC_Red,
    input  wire [7:0] DC_Red,
    input  wire [7:0] AC_IR,
    input  wire [7:0] DC_IR,
    input  wire EN,
    input  wire [1:0] Format,
    output reg  [11:0] sat = 0
);

wire [9:0] sum = AC_Red+DC_Red+AC_IR+DC_IR;

always @(*) begin
    if (EN)
//        sat = {2'b00, sum};
            sat = 12'b101111100010;
end


//// 使用case语句版本
//always @(*) begin
//    if (EN) begin
//        case ({AC_Red, DC_Red})
//            16'h0000: sat = 12'h000;
//            16'h0001: sat = 12'h001;
//            16'h0002: sat = 12'h002;
//            16'h0003: sat = 12'h003;
//            16'h0004: sat = 12'h004;
//            // ...
//            16'hFFFF: sat = 12'hFFF;
//            default: sat = 12'h000;  // Default case, although it's not strictly necessary
//        endcase
//    end
//end

//// 使用初始化存储器块版本
//reg [11:0] lut [65535:0];  // 256-entry LUT with 6-bit wide entries
//initial begin
//    // Initialize the LUT with values
//    lut[16'h0000] = 12'h000;
//    lut[16'h0001] = 12'h001;
//    lut[16'h0002] = 12'h002;
//    lut[16'h0003] = 12'h003;
//    lut[16'h0004] = 12'h004;
//    // ...
//    lut[16'hFFFF] = 12'hFFF;
//end
//always @(*) begin
//    if (EN)
//        sat = lut[{AC_Red, DC_Red}];
//    else
//        sat = 12'h000;  // Output 0 when enable is low
//end

endmodule
