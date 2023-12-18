// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: APB bus to handle LOAD in peripheral registers

module apb_periph_load(
    input   logic           PCLK,
    input   logic           PRESETn,
    output  logic   [31:0]  PRDATA,
    input   logic   [31:0]  PADDR,
    input   logic           renable,
    input   logic   [31:0]  PERIOD,     // ADDRESS 0x0
    input   logic   [31:0]  PULSE,      // ADDRESS 0x4
    input   logic   [7:0]   SIZE,       // ADDRESS 0x8
    input   logic           ENABLE      // ADDRESS 0xC
);

localparam int unsigned ADDR_PERIOD = 32'h0;
localparam int unsigned ADDR_PULSE  = 32'h4;
localparam int unsigned ADDR_SIZE   = 32'h8;
localparam int unsigned ADDR_ENABLE = 32'hC;

logic   [31:0]  PRDATA_q;

always_comb begin : READ_DATA
    case (PADDR)
        ADDR_PERIOD:    PRDATA_q = PERIOD;
        ADDR_PULSE:     PRDATA_q = PULSE;
        ADDR_SIZE:      PRDATA_q = SIZE + 32'd0;
        ADDR_ENABLE:    PRDATA_q = ENABLE + 32'd0;
        default:        PRDATA_q = 32'd0;
    endcase
end

assign PRDATA = renable ? PRDATA_q : 0;

endmodule