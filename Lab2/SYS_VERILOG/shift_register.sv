// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: Design an 8-bit SHIFT REGISTER with asynchronous reset

module shift_register #( parameter WIDTH = 8)
(
	input 	logic 				clk, 	// clock
	input 	logic 				rstn, 	// reset
	input 	logic [1:0] 		ctrl, 	// control
	input 	logic [WIDTH-1:0] 	par_in, // parallel input
	input 	logic 				ser_in, // serial input
	output	logic [WIDTH-1:0] 	par_out,// parallel output
	output 	logic 				ser_out // serial output
);
	// Variable
	genvar i;
	int unsigned j;
	// Signal
	logic				ser_out_int;
	logic [WIDTH-1:0]	ff_d;

	// Generate flip flop register
	generate begin
		for( i = 0; i < WIDTH; i++ ) begin
			flip_flop ff_i (.clk(clk), .rstn(rstn), .in(ff_d[i]), .out(par_out[i]));	
		end
	end
	endgenerate
	
	flip_flop ff_ser_out (.clk(clk), .rstn(rstn), .in(ser_out_int), .out(ser_out));

	// Combinational
	always_comb begin
		case(ctrl)
			2'b00: begin
				// pre_ff multiplexer
				ff_d = par_out;
				// serial_out mux
				ser_out_int = '0;
			end
			2'b10: begin 	// Shift right
				// pre_ff multiplexer
				ff_d[WIDTH-1] = ser_in;
				for( j = 0; j < WIDTH-1; j++ ) begin
					ff_d[j] = par_out[j+1];	
				end
				// serial_out mux
				ser_out_int = par_out[0];
			end
			2'b01: begin	// Shift left
				// pre_ff multiplexer
				ff_d[0] = ser_in;
				for( j = 1; j < WIDTH; j++ ) begin
					ff_d[j] = par_out[j-1];	
				end
				// serial_out mux
				ser_out_int = par_out[WIDTH-1];
			end
			2'b11: begin
				// pre_ff multiplexer
				for( j = 0; j < WIDTH; j++ ) begin
					ff_d[j] = par_in[j];
				end
				// serial_out mux
				ser_out_int = '0;
			end
			default: begin
				ff_d = par_out;
				ser_out_int = '0;
			end
		endcase
	end

endmodule
