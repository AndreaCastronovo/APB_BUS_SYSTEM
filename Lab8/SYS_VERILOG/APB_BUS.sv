// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: APB bus system

module APB_BUS #(
    parameter   DATA_WIDTH  =   32,
    parameter   NUM_SLAVE   =   4
)(
    //Slave Port
    input   logic                                   S_PCLK,
    input   logic                                   S_PRESETn,
    input   logic   [DATA_WIDTH-1:0]                S_PADDR,
    input   logic                                   S_PSEL,
    input   logic                                   S_PENABLE,
    input   logic                                   S_PWRITE,
    input   logic   [DATA_WIDTH-1:0]                S_PWDATA,
    output  logic                                   S_PREADY,
    output  logic   [DATA_WIDTH-1:0]                S_PRDATA,
    output  logic                                   S_PSLAVEERR,
    //Master ports
    output  logic   [NUM_SLAVE-1:0]                 M_PCLK,
    output  logic   [NUM_SLAVE-1:0]                 M_PRESETn,
    output  logic   [NUM_SLAVE-1:0][DATA_WIDTH-1:0] M_PADDR,
    output  logic   [NUM_SLAVE-1:0]                 M_PSEL,
    output  logic   [NUM_SLAVE-1:0]                 M_PENABLE,
    output  logic   [NUM_SLAVE-1:0]                 M_PWRITE,
    output  logic   [NUM_SLAVE-1:0][DATA_WIDTH-1:0] M_PWDATA,
    input   logic   [NUM_SLAVE-1:0]                 M_PREADY,
    input   logic   [NUM_SLAVE-1:0][DATA_WIDTH-1:0] M_PRDATA,
    input   logic   [NUM_SLAVE-1:0]                 M_PSLAVEERR
);

logic [NUM_SLAVE-1:0] flag_slave;

// Memory map
localparam int unsigned ADDR_fSLAVE = 32'h0000;
localparam int unsigned ADDR_tSLAVE = 32'h0FFF;

genvar 		i;
generate begin
    for ( i=0; i<NUM_SLAVE; i++ ) begin
        assign flag_slave[i] = (ADDR_fSLAVE + (i * 16'h1000) <= S_PADDR) & (S_PADDR <= ADDR_tSLAVE + (i * 16'h1000));
    end
 end
endgenerate

// Signal connection
assign M_PCLK       = {NUM_SLAVE{S_PCLK}};
assign M_PRESETn    = {NUM_SLAVE{S_PRESETn}};
assign M_PADDR      = {NUM_SLAVE{S_PADDR}};
assign M_PWRITE     = {NUM_SLAVE{S_PWRITE}};
assign M_PWDATA     = {NUM_SLAVE{S_PWDATA}};
assign M_PENABLE    = {NUM_SLAVE{S_PENABLE}};


always_comb begin : signal_connection_slave
    integer j;
    S_PREADY = 1'b0;
    S_PRDATA = 1'b0;
    S_PSLAVEERR = 1'b0;
    for (j = 0; j < NUM_SLAVE; j++) begin
        M_PSEL[j] = 1'b0;
        if (flag_slave[j]) begin
            S_PREADY = M_PREADY[j];
            S_PRDATA = M_PRDATA[j];
            S_PSLAVEERR = M_PSLAVEERR[j];
            M_PSEL[j] = S_PSEL;
            break;
        end
    end

    if (j == NUM_SLAVE) begin
        S_PSLAVEERR = 1'b1; //non-mapped memory
    end
end
    
endmodule