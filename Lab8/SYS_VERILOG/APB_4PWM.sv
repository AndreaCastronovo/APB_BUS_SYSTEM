// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: APB 4 PWM system

module APB_4PWM #(
    parameter   DATA_WIDTH  =   32,
    parameter   SIZE_WIDTH  =   8,
    parameter   NUM_SLAVE   =   4
)(
    input   logic                               PCLK,
    input   logic                               PRESETn,
    input   logic [DATA_WIDTH-1:0]              PADDR,
    input   logic                               PSEL,
    input   logic                               PENABLE,
    input   logic                               PWRITE,
    input   logic [DATA_WIDTH-1:0]              PWDATA,
    output  logic                               PREADY,
    output  logic [DATA_WIDTH-1:0]              PRDATA,
    output  logic                               PSLAVEERR,
    output  logic [NUM_SLAVE-1:0][SIZE_WIDTH-1:0] PWM
);

logic   [NUM_SLAVE-1:0]                 M_PCLK_int, M_PRESETn_int, M_PSEL_int, M_PENABLE_int, M_PWRITE_int, M_PREADY_int, M_PSLAVEERR_int;
logic   [NUM_SLAVE-1:0][DATA_WIDTH-1:0] M_PRDATA_int, M_PADDR_int, M_PWDATA_int;

APB_BUS #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .NUM_SLAVE  ( NUM_SLAVE )
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

genvar 		i;

generate begin
	for ( i=0; i<NUM_SLAVE; i++ ) begin
		APB_PWM #(
            .DATA_WIDTH(DATA_WIDTH),
            .SIZE_WIDTH(SIZE_WIDTH)
        ) apb_pwm_i ( 
            .PCLK       ( M_PCLK_int[i]         ),
            .PRESETn    ( M_PRESETn_int[i]      ),
            .PADDR      ( M_PADDR_int[i]        ),
            .PSEL       ( M_PSEL_int[i]         ),   
            .PENABLE    ( M_PENABLE_int[i]      ),
            .PWRITE     ( M_PWRITE_int[i]       ),
            .PWDATA     ( M_PWDATA_int[i]       ),
            .PREADY     ( M_PREADY_int[i]       ),
            .PRDATA     ( M_PRDATA_int[i]       ),      
            .PSLAVEERR  ( M_PSLAVEERR_int[i]    ),
            .PWM        ( PWM[i]                )
        );
	end
end
endgenerate
    
endmodule