// STUDENT: Andrea Castronovo
// N.MATRI: 0001029122
//
// DESCRIPTION:	Testbench serial multiplier

`timescale 1ns/1ps
module testbench ();

localparam int unsigned OP_X_WIDTH  = 16;
localparam int unsigned OP_Y_WIDTH  = 16;
localparam int unsigned RES_WIDTH   = OP_X_WIDTH + OP_Y_WIDTH;
localparam int unsigned N_TESTS     = 10;

// Tb internal signals
logic clk, rstn, start, valid;
logic [OP_X_WIDTH-1:0]  x;
logic [OP_Y_WIDTH-1:0]  y;
logic [RES_WIDTH-1:0]   out;

// DUT instance
serial_multiplier #( 
    .OP_X_WIDTH(OP_X_WIDTH), 
    .OP_Y_WIDTH(OP_Y_WIDTH) 
) DUT (
    .clk(clk), 
    .rst_n(rstn), 
    .start(start),
    .in_x(x), 
    .in_y(y),
    .valid_out(valid),
    .out_mul(out) 
);

always
  begin
     #5 clk = !clk;
  end

initial begin
    
    clk   = 1'b0;
    rstn  = 1'b0;
    x     = 0;
    y     = 0;
    start = 0;      

    #10
    rstn  = 1'b1;
 
    @(negedge clk);
    @(negedge clk);
 
    // Repeat N_TESTS times the following block
    repeat(N_TESTS) begin
    @(negedge clk);
    x   =   $urandom_range(0,10);
    y   =   $urandom_range(0,10);

    #10
    @(negedge clk);

    start = 1'b1;

    #10
    @(negedge clk);

    start = 1'b0;

    #10

    @(posedge valid);
    end

    #10

    $stop;
  end

endmodule
