// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: APB bus to handle STORE in peripheral registers

module apb_periph_store #(
    parameter   DATA_WIDTH  =   32,
    parameter   SIZE_WIDTH  =   8
)(
    input   logic                       PCLK,
    input   logic                       PRESETn,
    input   logic   [DATA_WIDTH-1:0]    PWDATA,
    input   logic   [DATA_WIDTH-1:0]    PADDR,
    input   logic                       wenable,
    output  logic   [DATA_WIDTH-1:0]    PERIOD,     // ADDRESS 0x0
    output  logic   [DATA_WIDTH-1:0]    PULSE,      // ADDRESS 0x4
    output  logic   [SIZE_WIDTH-1:0]    SIZE,       // ADDRESS 0x8
    output  logic                       ENABLE      // ADDRESS 0xC
);

localparam int unsigned ADDR_PERIOD = 4'h0;
localparam int unsigned ADDR_PULSE  = 4'h4;
localparam int unsigned ADDR_SIZE   = 4'h8;
localparam int unsigned ADDR_ENABLE = 4'hC;

logic   [DATA_WIDTH-1:0]    size_int, enable_int;

ff #( .WIDTH(DATA_WIDTH)    )   ff_PERIOD   ( .clk_i(PCLK), .rst_ni(PRESETn), .enable_i(wenable & (PADDR[3:0] == ADDR_PERIOD)), 
    .d(PWDATA), .q(PERIOD)  );
ff #( .WIDTH(DATA_WIDTH)    )   ff_PULSE    ( .clk_i(PCLK), .rst_ni(PRESETn), .enable_i(wenable & (PADDR[3:0] == ADDR_PULSE)), 
    .d(PWDATA), .q(PULSE)   );
ff #( .WIDTH(DATA_WIDTH)    )   ff_SIZE     ( .clk_i(PCLK), .rst_ni(PRESETn), .enable_i(wenable & (PADDR[3:0] == ADDR_SIZE)), 
    .d(PWDATA), .q(size_int)    );

assign SIZE = size_int[SIZE_WIDTH-1:0];

ff #( .WIDTH(DATA_WIDTH)    )   ff_ENABLE   ( .clk_i(PCLK), .rst_ni(PRESETn), .enable_i(wenable & (PADDR[3:0] == ADDR_ENABLE)), 
    .d(PWDATA), .q(enable_int)  );

assign ENABLE = enable_int[0];

endmodule