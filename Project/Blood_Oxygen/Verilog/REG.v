`timescale 1ns / 1ps

module REG(
    input  wire clk, laser_ctrl,
    input  wire [1:0] reg_ctrl,
    input  wire [1:0] data_valid,
    input  wire [7:0] AC,
    input  wire [7:0] DC,
    output reg  [7:0] AC_Red = 0,
    output reg  [7:0] DC_Red = 0,
    output reg  [7:0] AC_IR  = 0,
    output reg  [7:0] DC_IR  = 0
);

// DC data gen & store
reg [7:0] Amb=0, Mix=0;
always @(posedge reg_ctrl[0]) begin
    if (data_valid[0])
        Mix <= DC;
    else
        Amb <= DC;
end
always @(negedge reg_ctrl[1]) begin
    if(laser_ctrl)
        DC_Red <= Mix - Amb;
    else 
        DC_IR  <= Mix - Amb;
end

// AC data store
always @(posedge reg_ctrl[1]) begin
    if (laser_ctrl)
        AC_Red <= AC;
    else
        AC_IR  <= AC;
end

endmodule
