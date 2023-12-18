// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: APB bus to handle STORE in peripheral registers

module apb_periph_store (
    input   logic           PCLK,
    input   logic           PRESETn,
    input   logic   [31:0]  PWDATA,
    input   logic   [31:0]  PADDR,
    input   logic           wenable,
    output  logic   [31:0]  PERIOD,     // ADDRESS 0x0
    output  logic   [31:0]  PULSE,      // ADDRESS 0x4
    output  logic   [7:0]   SIZE,       // ADDRESS 0x8
    output  logic           ENABLE      // ADDRESS 0xC
);

localparam int unsigned ADDR_PERIOD = 32'h0;
localparam int unsigned ADDR_PULSE  = 32'h4;
localparam int unsigned ADDR_SIZE   = 32'h8;
localparam int unsigned ADDR_ENABLE = 32'hC;

logic   [31:0]    size_int, enable_int;

ff #( .WIDTH(32)    )   ff_PERIOD   ( .clk_i(PCLK), .rst_ni(PRESETn), .enable_i(wenable & (PADDR == ADDR_PERIOD)), 
    .d(PWDATA), .q(PERIOD)  );
ff #( .WIDTH(32)    )   ff_PULSE    ( .clk_i(PCLK), .rst_ni(PRESETn), .enable_i(wenable & (PADDR == ADDR_PULSE)), 
    .d(PWDATA), .q(PULSE)   );
ff #( .WIDTH(32)    )   ff_SIZE     ( .clk_i(PCLK), .rst_ni(PRESETn), .enable_i(wenable & (PADDR == ADDR_SIZE)), 
    .d(PWDATA), .q(size_int)    );

assign SIZE = size_int[7:0];

ff #( .WIDTH(32)    )   ff_ENABLE   ( .clk_i(PCLK), .rst_ni(PRESETn), .enable_i(wenable & (PADDR == ADDR_ENABLE)), 
    .d(PWDATA), .q(enable_int)  );

assign ENABLE = enable_int[0];

endmodule