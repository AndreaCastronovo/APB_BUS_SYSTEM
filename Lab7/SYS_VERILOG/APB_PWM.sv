// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: APB bus with PWM modualtion

module APB_PWM
(
    input   logic           PCLK,
    input   logic           PRESETn,
    input   logic   [31:0]  PADDR,
    input   logic           PSEL,   
    input   logic           PENABLE,
    input   logic           PWRITE,
    input   logic   [31:0]  PWDATA,
    output  logic           PREADY,
    output  logic   [31:0]  PRDATA,
    output  logic           PSLAVEERR,

    output  logic   [7:0]   PWM
);

    logic   wenable, renable;

    // Assignments
    assign wenable = PSEL & PENABLE & PWRITE;
    assign renable = PSEL & PENABLE & ~PWRITE;
    assign PREADY = PENABLE;
    assign PSLAVEERR = 1'b0;

    // Registers
    logic   [31:0]  PERIOD;     // ADDRESS 0x0
    logic   [31:0]  PULSE;      // ADDRESS 0x4
    logic   [7:0]   SIZE;       // ADDRESS 0x8
    logic           ENABLE;     // ADDRESS 0xC

    // APB write/store operation
    apb_periph_store apb_periph_store_i (
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
    apb_periph_load apb_periph_load_i (
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
    pwm_generator pwm_generator_i (
        .clk        ( PCLK ),
        .rstn       ( PRESETn ),
        .PERIOD     ( PERIOD ),
        .PULSE      ( PULSE ),
        .SIZE       ( SIZE ),
        .ENABLE     ( ENABLE ),
        .PWM        ( PWM )
    );

endmodule