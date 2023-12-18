// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: APB bus interface for pwm generator

module apb_interface_pwm #(
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
    output  logic   [DATA_WIDTH-1:0]    PRDATA,
    output  logic                       PREADY,
    output  logic                       PSLAVEERR,
    output  logic   [DATA_WIDTH-1:0]    PERIOD,
    output  logic   [DATA_WIDTH-1:0]    PULSE,
    output  logic   [SIZE_WIDTH-1:0]    SIZE,
    output  logic                       ENABLE
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

    logic   [DATA_WIDTH-1:0]    size_int, enable_int;

    ff #(   
        .WIDTH(DATA_WIDTH)    
    )   ff_PERIOD   ( 
        .clk_i      ( PCLK      ), 
        .rst_ni     ( PRESETn   ), 
        .enable_i   ( wenable & (PADDR[3:0] == ADDR_PERIOD)), 
        .d          ( PWDATA    ), 
        .q          ( PERIOD    )  
    );

    ff #( 
        .WIDTH(DATA_WIDTH)    
    )   ff_PULSE    ( 
        .clk_i      ( PCLK      ),
        .rst_ni     ( PRESETn   ),
        .enable_i   ( wenable & (PADDR[3:0] == ADDR_PULSE)), 
        .d          ( PWDATA    ), 
        .q          ( PULSE     )   
    );

    ff #( 
        .WIDTH(DATA_WIDTH)    
    )   ff_SIZE     ( 
        .clk_i      ( PCLK      ),
        .rst_ni     ( PRESETn   ),
        .enable_i   ( wenable & (PADDR[3:0] == ADDR_SIZE)), 
        .d          ( PWDATA    ), 
        .q          ( size_int  )    
    );

    assign SIZE = size_int[SIZE_WIDTH-1:0];

    ff #( 
        .WIDTH(DATA_WIDTH)    
    )   ff_ENABLE   ( 
        .clk_i      ( PCLK      ), 
        .rst_ni     ( PRESETn   ), 
        .enable_i   ( wenable & (PADDR[3:0] == ADDR_ENABLE)), 
        .d          ( PWDATA    ), 
        .q          ( enable_int)  
    );

    assign ENABLE = enable_int[0];
    

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