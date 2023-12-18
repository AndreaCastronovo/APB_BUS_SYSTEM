// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: Positive binary up or down counter with enable

module counter_en_updown #(
    //! Counter bitwidth, default is 3-bit counter    
    parameter int unsigned  WIDTH = 3
)(
    //! Clock
    input   logic               clk_i,
    //! System reset (asynchronous active-low)
    input   logic               rstn_i,
    //! Up or down flag (high to up, low to down)
    input   logic               up_down,
    //! Enable
    input   logic               enable,
    //! Counter output signal
    output  logic [WIDTH-1:0]   count_o
);
    //! Internal signals: *_d for combinational signals, *_q for sampled signals
    logic [WIDTH-1:0] count_d, count_q;

    //! Up or Down selection, sum 1 or -1
    logic signed [WIDTH-1:0] op_sum;
    assign op_sum = up_down ? 32'd1 : 32'hFFFF; 

    //! Continous assignment for the increment
    assign count_d = count_q + signed'(op_sum);

    //! Memory element to store the incremented value
    always_ff @(posedge clk_i, negedge rstn_i) begin
        //! Resetting at low value of system reset signal
        if(~rstn_i)
            count_q <= '0;
        //! Sampling the new value if enable is active
        else if(enable)
            count_q <= count_d;
        //! Store data
        else 
            count_q <= count_q;
    end

    //! Assigning count_q to the output of the counter
    assign count_o = count_q;

endmodule