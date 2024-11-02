`timescale 1ns / 1ps

module top(
    input  wire [7:0] AC,
    input  wire [7:0] DC,
	input  wire en, clk,
	output wire fA, fB, ADC_clk,
	output wire Red, IR,
	output wire Warn,
    output wire tx
);

// Parameters
parameter CLK_FREQ        = 32768;
parameter LASER_ON_PARAM  = 400;
parameter LASER_OFF_PARAM = 100;
parameter DATA_DELY       = 1000;

wire [1:0]  Format;
wire        EN_divider, EN_format;
wire [11:0] sat;
wire [11:0] sat_data;
wire        laser_ctrl;
wire [7:0]  AC_Red;
wire [7:0]  DC_Red;
wire [7:0]  AC_IR ;
wire [7:0]  DC_IR ;
wire [1:0]  data_valid;
wire [1:0]  reg_ctrl;
wire [11:0] threshold;
wire [15:0] format_data;

REG REG (
    .AC     ( AC     ),
    .DC     ( DC     ),
    .laser_ctrl   ( laser_ctrl   ),
    .reg_ctrl(reg_ctrl),
    .data_valid     (data_valid),
    .clk    ( clk    ),
    .AC_Red ( AC_Red ),
    .DC_Red ( DC_Red ),
    .AC_IR  ( AC_IR  ),
    .DC_IR  ( DC_IR  )
);

ctrl #(
    .CLK_FREQ        ( CLK_FREQ        ),
    .LASER_ON_PARAM  ( LASER_ON_PARAM  ),
    .LASER_OFF_PARAM ( LASER_OFF_PARAM ),
    .DATA_DELY       ( DATA_DELY       ))
ctrl(
    .en             ( en        ),
    .clk            ( clk       ),
    .Red            ( Red ),
    .IR             ( IR  ),
    .fA             ( fA  ),
    .fB             ( fB  ),
    .ADC_clk        ( ADC_clk  ),
    .laser_ctrl     ( laser_ctrl),
    .data_valid     ( data_valid),
    .reg_ctrl       (reg_ctrl),
    .EN_divider     ( EN_divider        ),
    .EN_format      ( EN_format ),
    .Format         ( Format    )
);


divider divider (
    .AC_Red    ( AC_Red    ),
    .DC_Red    ( DC_Red    ),
    .AC_IR     ( AC_IR     ),
    .DC_IR     ( DC_IR     ),
    .EN        ( EN_divider        ),
    .Format    ( Format    ),
    .sat        ( sat )
);


//uart_tx #(
//	.CLK_FREQ   ( CLK_FREQ  ),  // clock frequency (Mhz)
//	.BAUD_RATE  ( BAUD_RATE ))  // serial baud rate
//uart_tx (
//    .clk        ( clk ),    // clock input
//    .din        ( sat ),    // data to send
//    .EN      ( EN_format  ),    // sent enable
//    .tx       ( tx  )     // serial data output
//);

format format (
    .clk     ( clk ),    // clock input
    .din     ( sat ),    // data to send
    .en      ( EN_format  ),    // sent enable
    .format_data (format_data),
    .tx      ( tx  )     // serial data output
);

Alert Alert(
    .SAT      ( sat ),      // 
    .threshold(threshold),
    .Warn     ( Warn  )     // 
);

data_reg data_reg(
    .format_data    (format_data),
    .threshold      (threshold)
);

endmodule
