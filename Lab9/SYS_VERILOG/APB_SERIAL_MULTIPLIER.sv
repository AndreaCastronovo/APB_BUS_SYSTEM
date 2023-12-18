// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: APB bus interface with serial multiplier

module APB_SERIAL_MULTIPLIER #(
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
    output  logic                       PREADY,
    output  logic   [DATA_WIDTH-1:0]    PRDATA,
    output  logic                       PSLAVEERR
);

    logic   [OP_A_WIDTH-1:0]    IN_A;
    logic   [OP_B_WIDTH-1:0]    IN_B;
    logic   [OUT_WIDTH-1:0]     OUT;
    logic                       START, valid_out;  

    apb_interface_serial_mul #(
        .DATA_WIDTH(DATA_WIDTH),
        .OP_A_WIDTH(OP_A_WIDTH),
        .OP_B_WIDTH(OP_B_WIDTH)
    ) apb_interface_i (
        .PCLK       ( PCLK      ),
        .PRESETn    ( PRESETn   ),
        .PADDR      ( PADDR     ),
        .PSEL       ( PSEL      ),
        .PENABLE    ( PENABLE   ),
        .PWRITE     ( PWRITE    ),
        .PWDATA     ( PWDATA    ),
        .PRDATA     ( PRDATA    ),
        .PREADY     ( PREADY    ),
        .PSLAVEERR  ( PSLAVEERR ),
        .IN_A       ( IN_A      ), 
        .IN_B       ( IN_B      ), 
        .OUT        ( OUT       ),
        .START      ( START     ),
        .valid_out  ( valid_out )
    );

    serial_multiplier #(
        .OP_X_WIDTH(OP_A_WIDTH),
        .OP_Y_WIDTH(OP_B_WIDTH)
    ) serial_multiplier_i (
        .clk        ( PCLK      ),
        .rst_n      ( PRESETn   ),
        .start      ( START     ),
        .in_x       ( IN_A      ),
        .in_y       ( IN_B      ),
        .valid_out  ( valid_out ),
        .out_mul    ( OUT       )
    );


endmodule