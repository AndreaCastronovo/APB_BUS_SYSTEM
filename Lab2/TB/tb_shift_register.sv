// STUDENT: Andrea Castronovo
// N.MATRI: 0001029122
//
// DESCRIPTION:	Testbench of shift_register

`timescale 1ns/1ps
module tb_shift_register();

	localparam int unsigned WIDTH 	= 8;

	logic [WIDTH-1:0] 	par_in, par_out;
	logic [1:0]		ctrl;
	logic			ser_in, ser_out;
	logic			clk, rstn;
	
	shift_register #(
		.WIDTH ( WIDTH )
	) DUT ( 
		.clk	(clk), 
		.rstn	(rstn), 
		.ctrl	(ctrl), 
		.par_in	(par_in), 
		.par_out(par_out),
		.ser_in	(ser_in),
		.ser_out(ser_out) 
	);

	always begin
		#5 clk = !clk;
	end
	
	initial begin
		clk = 0;
		rstn = 0;
		par_in = 32'b11010010;
		ser_in = '1;
		ctrl = 2'b00;

		#10
		rstn = 1;

		@(negedge clk);
		ctrl = 'b11; 	// Store parallel input
	
		#10
		@(negedge clk);
		ctrl = 'b01;

		#30
		@(negedge clk);
		ctrl= 'b10;
		
		#40
		$stop;
	end
endmodule