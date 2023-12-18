// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: Binary to gray conversion

module b2gray #( parameter int unsigned WIDTH = 3)
(
    input  [WIDTH-1:0]  count_bin,
    output [WIDTH-1:0]  count_gray
);
    // Right shift and ex-or
    assign count_gray = count_bin ^ (count_bin >> 1);
    
endmodule