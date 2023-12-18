// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: APB bus with PWM modualtion

module APB_PWM #(
    parameter   DATA_WIDTH  =   32,
    parameter   SIZE_WIDTH  =   8
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
    output  logic                       PSLAVEERR,
    output  logic   [SIZE_WIDTH-1:0]    PWM
);

    logic   wenable, renable;
    
    localparam int unsigned ADDR_PERIOD = 4'h0;
    localparam int unsigned ADDR_PULSE  = 4'h4;
    localparam int unsigned ADDR_SIZE   = 4'h8;
    localparam int unsigned ADDR_ENABLE = 4'hC;

    // Read_Write flag 
    assign wenable = PSEL & PENABLE & PWRITE;
    assign renable = PSEL & PENABLE & ~PWRITE;

    // Output flag
    assign PREADY = PENABLE;
    always_comb begin : slave_error
        if (PSEL & PADDR[3:0] != ADDR_PERIOD & PADDR[3:0] != ADDR_PULSE & PADDR[3:0] != ADDR_SIZE & PADDR[3:0] != ADDR_ENABLE) 
            PSLAVEERR = 1'b1;
        else
            PSLAVEERR = 1'b0;
    end

    // Registers
    logic   [DATA_WIDTH-1:0]    PERIOD;     // ADDRESS 0x0
    logic   [DATA_WIDTH-1:0]    PULSE;      // ADDRESS 0x4
    logic   [SIZE_WIDTH-1:0]    SIZE;       // ADDRESS 0x8
    logic                       ENABLE;     // ADDRESS 0xC

    // APB write/store operation
    apb_periph_store #(
        .DATA_WIDTH(DATA_WIDTH),
        .SIZE_WIDTH(SIZE_WIDTH)
    ) apb_periph_store_i (
        .PCLK       ( PCLK ),
        .PRESETn    ( PRESETn ),
        .PWDATA     ( PWDATA ),
        .PADDR      ( PADDR ),
        .wenable    ( wenable ),
        .PERIOD     ( PERIOD ), 
        .PULSE      ( PULSE ), 
        .SIZE       ( SIZE ),
        .ENABLE     ( ENABLE )
    );
    
    // APB read/load operation
    apb_periph_load #(
        .DATA_WIDTH(DATA_WIDTH),
        .SIZE_WIDTH(SIZE_WIDTH)
    ) 
    apb_periph_load_i (
        .PCLK       ( PCLK ),
        .PRESETn    ( PRESETn ),
        .PRDATA     ( PRDATA ),
        .PADDR      ( PADDR ),
        .renable    ( renable ),
        .PERIOD     ( PERIOD ), 
        .PULSE      ( PULSE ), 
        .SIZE       ( SIZE ),
        .ENABLE     ( ENABLE )
    );

    // PWM

    pwm_generator #(
        .DATA_WIDTH(DATA_WIDTH),
        .SIZE_WIDTH(SIZE_WIDTH)
    )pwm_generator_i (
        .clk        ( PCLK ),
        .rstn       ( PRESETn ),
        .PERIOD     ( PERIOD ),
        .PULSE      ( PULSE ),
        .SIZE       ( SIZE  ),
        .ENABLE     ( ENABLE ),
        .PWM        ( PWM )
    );

endmodule