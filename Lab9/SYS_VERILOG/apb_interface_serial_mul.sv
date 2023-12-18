// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: APB bus interface for serial multiplier

module apb_interface_serial_mul #(
    parameter int unsigned DATA_WIDTH = 32,
    parameter int unsigned OP_A_WIDTH = 16,
    parameter int unsigned OP_B_WIDTH = 16,
    localparam int unsigned OUT_WIDTH  = OP_A_WIDTH + OP_B_WIDTH
)(
    input   logic                       PCLK,
    input   logic                       PRESETn,
    input   logic   [DATA_WIDTH-1:0]    PADDR,
    input   logic                       PSEL,   
    input   logic                       PENABLE,
    input   logic                       PWRITE,
    input   logic   [DATA_WIDTH-1:0]    PWDATA,
    output  logic   [DATA_WIDTH-1:0]    PRDATA,
    output  logic                       PSLAVEERR,
    output  logic                       PREADY,
    output  logic   [OP_A_WIDTH-1:0]    IN_A,
    output  logic   [OP_B_WIDTH-1:0]    IN_B,
    input   logic   [OUT_WIDTH-1:0]     OUT,
    output  logic                       START,
    input   logic                       valid_out
);

    logic   wenable, renable;
    
    localparam int unsigned ADDR_IN_A   = 4'h0;
    localparam int unsigned ADDR_IN_B   = 4'h4;
    localparam int unsigned ADDR_OUT    = 4'h8;
    localparam int unsigned ADDR_START  = 4'hC;

    // Read_Write flag 
    assign wenable = PSEL & PENABLE & PWRITE;
    assign renable = PSEL & PENABLE & ~PWRITE;

    always_comb begin : slave_error
        if (PSEL & PADDR[3:0] != ADDR_IN_A & PADDR[3:0] != ADDR_IN_B & PADDR[3:0] != ADDR_OUT & PADDR[3:0] != ADDR_START) 
            PSLAVEERR = 1'b1;
        else
            PSLAVEERR = 1'b0;
    end

    assign PREADY = (renable & (PADDR[3:0] == ADDR_OUT)) ? valid_out : PENABLE;

    // Write/Store 
    logic   [DATA_WIDTH-1:0]    IN_A_int, IN_B_int, START_int;

    ff #( 
        .WIDTH(DATA_WIDTH)    
    )   ff_IN_A   ( 
        .clk_i      ( PCLK      ), 
        .rst_ni     ( PRESETn   ), 
        .enable_i   ( wenable & (PADDR[3:0] == ADDR_IN_A)), 
        .d          ( PWDATA    ), 
        .q          ( IN_A_int  )
    );

    assign  IN_A = IN_A_int[OP_A_WIDTH-1:0];

    ff #( 
        .WIDTH(DATA_WIDTH)    
    )   ff_IN_B    ( 
        .clk_i      ( PCLK      ), 
        .rst_ni     ( PRESETn   ), 
        .enable_i   ( wenable & (PADDR[3:0] == ADDR_IN_B)), 
        .d          ( PWDATA    ), 
        .q          ( IN_B_int  )   
    );

    assign IN_B = IN_B_int[OP_B_WIDTH-1:0];

    ff #( 
        .WIDTH(DATA_WIDTH)    
    )   ff_START     ( 
        .clk_i      ( PCLK      ), 
        .rst_ni     ( PRESETn   ), 
        .enable_i   ( wenable & (PADDR[3:0] == ADDR_START)), 
        .d          ( PWDATA    ), 
        .q          ( START_int )    
    );

    assign START = START_int[0];

    
    // Read/Load
    assign PRDATA = (renable & (PADDR[3:0] == ADDR_OUT)) ? OUT : '0;

endmodule