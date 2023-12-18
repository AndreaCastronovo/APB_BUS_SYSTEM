// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: Flip-Flop register

module flip_flop
(
	input 	logic clk,
	input 	logic rstn,
	input 	logic in,
	output	logic out
);

	always_ff@(posedge clk, negedge rstn) begin
		if (rstn == 1'b0)
			out <= 1'b0;
		else
			out <= in;
	end
endmodule
