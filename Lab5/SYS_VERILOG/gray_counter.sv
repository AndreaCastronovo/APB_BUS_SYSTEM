// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: Write a 3-bits Gray code counter with reset asynchronous active low, enable input and up or down flag

module gray_counter #( parameter int unsigned BITS = 3 )
(
    input   logic   clk,
    input   logic   rst_n,
    input   logic   en,
    input   logic   up_down,
    output  logic   [BITS-1:0]  out_gray,
    output  logic   [(2**BITS)-1:0] out_hot
);

    logic [BITS-1:0]    int_sign;

    // Module
    counter_en_updown #( .WIDTH(BITS) ) binary_counter_i ( .clk_i(clk), .rstn_i(rst_n), .up_down(up_down), .enable(en), .count_o(int_sign) );
    b2gray # ( .WIDTH(BITS) ) binary2gray_i ( .count_bin(int_sign), .count_gray(out_gray) ); 
    b2hot_encod #( .WIDTH(BITS) ) binary2hotencoding_i ( .count_bin(int_sign), .count_hot(out_hot) );

endmodule