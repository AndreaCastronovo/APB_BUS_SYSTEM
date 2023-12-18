// STUDENT: Andrea Castronovo
// N.MATRI: 0001029122
//
// DESCRIPTION:	Testbench traffic light

`timescale 1ns/1ps
module testbench ();
   
   logic rstn;
   logic clk;
   logic red;
   logic yellow;
   logic green;
   
   traffic_light DUT ( 
        .clk(clk), 
        .rstn(rstn), 
        .red(red), 
        .yellow(yellow), 
        .green(green) 
    );
   
   always
    begin
        #5 clk = !clk;
    end
   
   initial
    begin
        clk   = 1'b0;
        rstn  = 1'b0;

        #10
    
        rstn  = 1'b1;
        
        repeat(640)
            @(negedge clk);
        
        $stop;
    end
   
endmodule
