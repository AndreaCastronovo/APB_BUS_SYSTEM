// STUDENT: Andrea Castronovo
// N.MATRI: 0001029122
//
// DESCRIPTION:	Design of a full adder with behavioral description

module full_adder_beh(
	input	logic	A,
	input	logic	B,
	input 	logic	CIN,
	output 	logic	SUM,
	output 	logic	COUT
);
	assign SUM 		= A ^ B ^ CIN;
	//assign COUT 	= (A & CIN) ^ (B & (A ^ CIN));
	assign COUT 	= A & B | CIN & (A ^ B);
	

endmodule