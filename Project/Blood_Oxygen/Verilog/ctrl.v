`timescale 1ns / 1ps

module ctrl #(
    parameter CLK_FREQ = 32_768,
    parameter LASER_ON_PARAM  = 400, // laser on time
    parameter LASER_OFF_PARAM = 100, // laser on time
    parameter DATA_DELY = 1024       // 
)(
    input  wire en, clk,
    output wire Red, IR,
    output wire fA, fB, ADC_clk,
    output wire laser_ctrl,
    output wire [1:0] data_valid,
    output wire [1:0] reg_ctrl,
    output wire EN_divider,
    output wire EN_format,
    output reg  [1:0] Format = 2'b00
);

localparam LASER_ON_TIME  = CLK_FREQ * LASER_ON_PARAM / 1000;
localparam LASER_OFF_TIME = CLK_FREQ * LASER_OFF_PARAM / 1000;

reg [$clog2(CLK_FREQ)-1:0] cnt;
always @(posedge clk or negedge en) begin
    if (~en)
        cnt <= 0;
    else if (cnt == CLK_FREQ-1)
        cnt <= 0;
    else
        cnt <= cnt + 1;
end

// ADC Block Clock Generator
assign fA = cnt[13];
assign fB = 0;
assign ADC_clk = cnt[4];

// ADC Register Controller Generate R/W Signal
wire [$clog2(CLK_FREQ)-1:0] cnt_valid;
assign cnt_valid = laser_ctrl ? cnt-(LASER_ON_TIME+LASER_OFF_TIME):cnt;
assign data_valid[0] = (cnt_valid>DATA_DELY)&&(cnt_valid<LASER_ON_TIME-DATA_DELY);
assign data_valid[1] = (cnt_valid>DATA_DELY+LASER_ON_TIME)&&(cnt_valid<LASER_ON_TIME+LASER_OFF_TIME-DATA_DELY);
assign reg_ctrl[0] = (cnt_valid==LASER_ON_TIME-DATA_DELY-1)|(cnt_valid==LASER_ON_TIME+LASER_OFF_TIME-DATA_DELY-1);
assign reg_ctrl[1] = (cnt_valid==LASER_ON_TIME+LASER_OFF_TIME-DATA_DELY-1);

// IR and Red Controller
assign IR = en ? (cnt<LASER_ON_TIME) : 0;
assign Red = en ? (cnt>LASER_ON_TIME+LASER_OFF_TIME)&&(cnt<LASER_ON_TIME*2+LASER_OFF_TIME) : 0;
assign laser_ctrl = cnt>(LASER_ON_TIME+LASER_OFF_TIME);

// Divider and Format Controller(Providing EN, Format Signals)
assign EN_divider = (cnt>LASER_ON_TIME*2+LASER_OFF_TIME*2-DATA_DELY/2-1)&&(cnt<LASER_ON_TIME*2+LASER_OFF_TIME*2-DATA_DELY/4-1);
assign EN_format = cnt>LASER_ON_TIME*2+LASER_OFF_TIME*2-DATA_DELY/4-1;

endmodule
