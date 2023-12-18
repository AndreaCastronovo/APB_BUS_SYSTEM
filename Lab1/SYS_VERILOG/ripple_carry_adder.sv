// STUDENT: Andrea Castronovo
// N.MATRI: 0001029122
//
// DESCRIPTION:	Design a 4-bit ripple carry adder using full_adder_beh module

module ripple_carry_adder #( parameter int unsigned WIDTH = 4)
(
	input	logic [WIDTH-1:0] 	A,
	input 	logic [WIDTH-1:0] 	B,
	input 	logic 				CIN,
	output 	logic [WIDTH-1:0] 	SUM,
	output 	logic 				COUT
);
	logic [WIDTH:0]	INT;

	genvar 		i;
	generate begin
		for ( i=0; i<WIDTH; i++ ) begin
			full_adder_beh fa_i ( .A(A[i]), .B(B[i]), .CIN(INT[i]), .SUM(SUM[i]), .COUT(INT[i+1]) );
		end
	 end
	endgenerate
	
	assign INT[0] = CIN;
	assign COUT = INT[WIDTH];

endmodule