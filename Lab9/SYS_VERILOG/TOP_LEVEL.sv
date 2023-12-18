// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: full APB bus system with 2 slave: a serial multiplier and a pwm generator.

module TOP_LEVEL #(
    parameter   int unsigned    DATA_WIDTH  =   32,
    parameter   int unsigned    SIZE_WIDTH  =   8,
    parameter   int unsigned    OP_A_WIDTH  =   16,
    parameter   int unsigned    OP_B_WIDTH  =   16,
    parameter   int unsigned    NUM_SLAVE   =   2
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

    logic   [NUM_SLAVE-1:0]                 M_PCLK_int, M_PRESETn_int, M_PSEL_int, M_PENABLE_int, M_PWRITE_int, M_PREADY_int, M_PSLAVEERR_int;
    logic   [NUM_SLAVE-1:0][DATA_WIDTH-1:0] M_PRDATA_int, M_PADDR_int, M_PWDATA_int;

    APB_BUS #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_SLAVE(NUM_SLAVE)
    ) apb_bus_i (
        //Slave Port
        .S_PCLK         ( PCLK      ),
        .S_PRESETn      ( PRESETn   ),
        .S_PADDR        ( PADDR     ),
        .S_PSEL         ( PSEL      ),
        .S_PENABLE      ( PENABLE   ),
        .S_PWRITE       ( PWRITE    ),
        .S_PWDATA       ( PWDATA    ),
        .S_PREADY       ( PREADY    ),
        .S_PRDATA       ( PRDATA    ),
        .S_PSLAVEERR    ( PSLAVEERR ),
        //Master ports
        .M_PCLK         ( M_PCLK_int    ),
        .M_PRESETn      ( M_PRESETn_int ),
        .M_PADDR        ( M_PADDR_int   ),
        .M_PSEL         ( M_PSEL_int    ),
        .M_PENABLE      ( M_PENABLE_int ),
        .M_PWRITE       ( M_PWRITE_int  ),
        .M_PWDATA       ( M_PWDATA_int  ),
        .M_PREADY       ( M_PREADY_int  ),
        .M_PRDATA       ( M_PRDATA_int  ),
        .M_PSLAVEERR    ( M_PSLAVEERR_int )
    );

    APB_SERIAL_MULTIPLIER #(
        .DATA_WIDTH(DATA_WIDTH),
        .OP_A_WIDTH(OP_A_WIDTH),
        .OP_B_WIDTH(OP_B_WIDTH)
    ) apb_serial_multiplier_i (
        .PCLK         ( M_PCLK_int[0]    ),
        .PRESETn      ( M_PRESETn_int[0] ),
        .PADDR        ( M_PADDR_int[0]   ),
        .PSEL         ( M_PSEL_int[0]    ),
        .PENABLE      ( M_PENABLE_int[0] ),
        .PWRITE       ( M_PWRITE_int[0]  ),
        .PWDATA       ( M_PWDATA_int[0]  ),
        .PREADY       ( M_PREADY_int[0]  ),
        .PRDATA       ( M_PRDATA_int[0]  ),
        .PSLAVEERR    ( M_PSLAVEERR_int[0] )
    );

    APB_PWM #(
            .DATA_WIDTH(DATA_WIDTH),
            .SIZE_WIDTH(SIZE_WIDTH)
    ) apb_pwm_i ( 
            .PCLK       ( M_PCLK_int[1]         ),
            .PRESETn    ( M_PRESETn_int[1]      ),
            .PADDR      ( M_PADDR_int[1]        ),
            .PSEL       ( M_PSEL_int[1]         ),   
            .PENABLE    ( M_PENABLE_int[1]      ),
            .PWRITE     ( M_PWRITE_int[1]       ),
            .PWDATA     ( M_PWDATA_int[1]       ),
            .PREADY     ( M_PREADY_int[1]       ),
            .PRDATA     ( M_PRDATA_int[1]       ),      
            .PSLAVEERR  ( M_PSLAVEERR_int[1]    ),
            .PWM        ( PWM                   )
    );
    
endmodule