// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: Binary to hot encoding conversion

module b2hot_encod #( parameter WIDTH = 3)
(
    input  [WIDTH-1:0]  count_bin,
    output [(2**WIDTH)-1:0]  count_hot
);
    logic [(2**WIDTH)-1:0] initialized;

    always_comb begin : decoder
        initialized               = '0;
        initialized[count_bin]    = 1'b1;
    end

    assign count_hot = initialized;
endmodule