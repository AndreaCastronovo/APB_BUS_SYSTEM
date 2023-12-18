// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: APB bus interface with PWM modualtion

module APB_PWM #(
    parameter   int unsigned    DATA_WIDTH  =   32,
    parameter   int unsigned    SIZE_WIDTH  =   8
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

    
    // Registers
    logic   [DATA_WIDTH-1:0]    PERIOD;     // ADDRESS 0x0
    logic   [DATA_WIDTH-1:0]    PULSE;      // ADDRESS 0x4
    logic   [SIZE_WIDTH-1:0]    SIZE;       // ADDRESS 0x8
    logic                       ENABLE;     // ADDRESS 0xC

    apb_interface_pwm #(
        .DATA_WIDTH(DATA_WIDTH),
        .SIZE_WIDTH(SIZE_WIDTH)
    ) apb_interface_pwm_i (
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
        .PERIOD     ( PERIOD    ),
        .PULSE      ( PULSE     ),
        .SIZE       ( SIZE      ),
        .ENABLE     ( ENABLE    )
    );

    // PWM
    pwm_generator #(
        .DATA_WIDTH(DATA_WIDTH),
        .SIZE_WIDTH(SIZE_WIDTH)
    ) pwm_generator_i (
        .clk        ( PCLK      ),
        .rstn       ( PRESETn   ),
        .PERIOD     ( PERIOD    ),
        .PULSE      ( PULSE     ),
        .SIZE       ( SIZE      ),
        .ENABLE     ( ENABLE    ),
        .PWM        ( PWM       )
    );

endmodule