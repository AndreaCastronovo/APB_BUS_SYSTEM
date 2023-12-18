// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: Counter with clear and enable

module counter_clr_en #(
    //! Counter bitwidth 
    parameter int unsigned  WIDTH = 4
)(
    //! Clock
    input   logic               clk_i,
    //! System reset (asynchronous active-low)
    input   logic               rstn_i,
    //! Clear counter signal (synchronous active-high)
    input   logic               clr_i,
    //! Enable counter signal (synchronous active-high)
    input   logic               enable_i,
    //! Counter output signal
    output  logic [WIDTH-1:0]   count_o
);
    //! Internal signals: *_d for combinational signals, *_q for sampled signals
    logic [WIDTH-1:0] count_d, count_q;

    //! Continous assignment for the increment
    assign count_d = count_q + 'd1;

    //! Memory element to store the incremented value
    always_ff @(posedge clk_i, negedge rstn_i) begin
        //! Resetting at low value of system reset signal
        if(~rstn_i)
            count_q <= '0;
        //! Clearing the value when clr_i is active
        else if(clr_i)
            count_q <= 'd0;
        //! Sampling the new value
        else if(enable_i)
            count_q <= count_d;
        else 
            count_q <= count_q;
    end

    //! Assigning count_q to the output of the counter
    assign count_o = count_q;

endmodule