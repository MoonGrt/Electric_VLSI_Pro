`timescale 1ns / 1ps
module tb_top;

// top Parameters
parameter T = 30518;


// top Inputs
reg  [15:0] AC  = 0;
reg  [15:0] DC  = 0;
reg         en  = 0;
reg         clk = 0;

// top Outputs
wire  Red  ;
wire  IR   ;
wire  Warn   ;
wire  tx         ;

initial
begin
    forever #(T/2) clk = ~clk;
end

initial
begin
    #(T*100) 
        en = 1;
        DC <= 159;
    #(T*13200)
        DC <= 124;
        AC <= 89;
    #(T*10000)
        DC <= 163;
end

top  u_top (
    .AC          ( AC          ),
    .DC          ( DC          ),
    .en          ( en          ),
    .clk         ( clk         ),
    .Red   ( Red   ),
    .IR    ( IR    ),
    .Warn    ( Warn ),
    .tx          ( tx          )
);

endmodule