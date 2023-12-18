// STUDENT: Andrea Castronovo
// N.MATRI: 0001029122
//
// DESCRIPTION:	Testbench of ripple_carry_adder

`timescale 1ns/1ps
module tb_ripple_carry_adder();

	localparam int unsigned WIDTH 	= 4;
	localparam int unsigned N_TESTS	= 10;

	logic [WIDTH-1:0] 	A, B, SUM;
	logic				CIN, COUT;
	
	ripple_carry_adder #(
		.WIDTH ( WIDTH )
	) DUT ( 
		.A(A), 
		.B(B), 
		.CIN(CIN), 
		.SUM(SUM), 
		.COUT(COUT) 
	);

	initial begin
		A 	= 1;
		B	= 1;
		CIN	= 1;
		
		repeat(N_TESTS) begin
			A 	= $urandom_range(0, 15);
			B 	= $urandom_range(0, 15);
			CIN	= $urandom_range(0,1);
	
			#2;
		
		end
		$stop;
	end
endmodule