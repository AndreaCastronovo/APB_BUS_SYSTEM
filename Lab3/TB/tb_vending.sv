// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: Testbench of vending machine

`timescale 1ns/1ps
module tb_vending();

	logic			dime, niche, out;
	logic			clk, rstn;
	
	vending #() DUT ( 
		.clk	(clk), 
		.rstn	(rstn), 
		.dime	(dime), 
		.niche	(niche), 
		.out    (out) 
	);

	always begin
		#5 clk = !clk;
	end
	
	initial begin
        clk = 0;
        niche = 0;
        dime = 0;
	rstn = 0;
	#10
	rstn = 1;


        #30
        // 5+5+5
        @(negedge clk)
        niche = 1;
	@(negedge clk)
	@(negedge clk)
	@(negedge clk)
        niche = 0;

        // 5+10
        @(negedge clk)
        @(negedge clk)
        niche = 1;
        @(negedge clk)
        niche = 0;
        dime = 1;
        @(negedge clk)
        // from COFFEE to TEN
        // 10+5
        @(negedge clk)
        niche = 1;
        dime = 0;
        @(negedge clk)
        niche = 0;
        dime = 0;
        #30

        // 10+10
        @(negedge clk)
        @(negedge clk)
        dime = 1;
        @(negedge clk)
        @(negedge clk)
        dime = 0;
		
	#40
	$stop;
	end
endmodule