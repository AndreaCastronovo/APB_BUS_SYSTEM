// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: APB bus to handle LOAD in peripheral registers

module apb_periph_load #(
    parameter   DATA_WIDTH  =   32,
    parameter   SIZE_WIDTH  =   8
)(
    input   logic                       PCLK,
    input   logic                       PRESETn,
    output  logic   [DATA_WIDTH-1:0]    PRDATA,
    input   logic   [DATA_WIDTH-1:0]    PADDR,
    input   logic                       renable,
    input   logic   [DATA_WIDTH-1:0]    PERIOD,     // ADDRESS 0x0
    input   logic   [DATA_WIDTH-1:0]    PULSE,      // ADDRESS 0x4
    input   logic   [SIZE_WIDTH-1:0]    SIZE,       // ADDRESS 0x8
    input   logic                       ENABLE      // ADDRESS 0xC
);

localparam int unsigned ADDR_PERIOD = 4'h0;
localparam int unsigned ADDR_PULSE  = 4'h4;
localparam int unsigned ADDR_SIZE   = 4'h8;
localparam int unsigned ADDR_ENABLE = 4'hC;

logic   [DATA_WIDTH-1:0]  PRDATA_q;

always_comb begin : READ_DATA
    case (PADDR[3:0])
        ADDR_PERIOD:    PRDATA_q = PERIOD;
        ADDR_PULSE:     PRDATA_q = PULSE;
        ADDR_SIZE:      PRDATA_q = SIZE + 32'd0;
        ADDR_ENABLE:    PRDATA_q = ENABLE + 32'd0;
        default:        PRDATA_q = 32'd0;
    endcase
end

assign PRDATA = renable ? PRDATA_q : 0;

endmodule