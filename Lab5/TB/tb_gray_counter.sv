// STUDENT: Andrea Castronovo
// N.MATRI: 0001029122
//
// DESCRIPTION:	Testbench gray counter

`timescale 1ns/1ps
module testbench ();
   
   localparam WIDTH = 3;
   logic rst_n;
   logic clk;
   logic en;
   logic up_down;
   logic [WIDTH-1:0] out_gray;
   logic [2**WIDTH-1:0] out_hot;
   
   gray_counter #(
    .BITS( WIDTH )
   ) DUT ( 
        .clk(clk), 
        .rst_n(rst_n), 
        .en(en), 
        .up_down(up_down), 
        .out_gray(out_gray),
        .out_hot(out_hot) 
    );
   
   always
    begin
        #5 clk = !clk;
    end
   
   initial
    begin
        clk     = 1'b0;
        rst_n    = 1'b0;
        en      = 1'b0;
        up_down = 1'b1;

        #10
        
        @(negedge clk);
        rst_n    = 1'b1;

        #10
        @(negedge clk);
        en      = 1'b1;

        #70
        @(negedge clk);
        up_down = 1'b0;

        #90
        @(negedge clk);
        en      = 1'b0;

        #30
        $stop;
    end
   
endmodule
