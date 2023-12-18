// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: flip-flop with enable

module ff #( 
    parameter int unsigned WIDTH = 32
) (
    input  logic                    clk_i,
    input  logic                    rst_ni,
    input  logic                    enable_i,
    input  logic    [WIDTH-1:0]     d,
    output logic    [WIDTH-1:0]     q
);

    always_ff @( posedge clk_i, negedge rst_ni  ) begin : flip_flop
        if(~rst_ni)
            q <= '0;
        else if(enable_i)
            q <= d;
    end

endmodule