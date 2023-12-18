// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: testbench of top level module

`timescale 1ns/1ps
module testbench ();

logic 			PCLK;
logic 			PRESETn;
logic [31:0]	PADDR;
logic    		PSEL;
logic           PENABLE;
logic 			PWRITE;
logic [31:0]    PWDATA;
logic        	PREADY;
logic [31:0] 	PRDATA;
logic        	PSLAVEERR;

logic [7:0]	    PWM;

// DUT instance
TOP_LEVEL #(
	.DATA_WIDTH ( 32 ),
	.SIZE_WIDTH ( 8  ),
    .OP_A_WIDTH ( 16 ),
    .OP_B_WIDTH ( 16 ),
    .NUM_SLAVE  ( 2  )
) DUT ( 
	.PCLK(PCLK), 
	.PRESETn(PRESETn), 
	.PADDR(PADDR), 
	.PSEL(PSEL), 
	.PENABLE(PENABLE), 
	.PWRITE(PWRITE), 
	.PWDATA(PWDATA), 
	.PREADY(PREADY), 
	.PRDATA(PRDATA), 
	.PSLAVEERR(PSLAVEERR), 
	.PWM(PWM) 
);
   
always begin
    #5 PCLK = !PCLK;
end
   
logic [31:0] mul_result;

initial begin
	PCLK    = 0;
	PRESETn = 0;
	PADDR   = 0;
	PSEL    = 0;
	PENABLE = 0;
	PWRITE  = 0; 
	PWDATA  = 0;

    #10

	PRESETn = 1;

    @(negedge PCLK);
    @(negedge PCLK);
	
	// STORE MULTIPLICATION OPERAND A ---------------------------------------

	// Try to hits a non-mapped region of ports 
	PADDR   = 32'h5000;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 2;
        
    @(negedge PCLK);

	PADDR   = 32'h5000;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 2;

    #2

	if (~PSLAVEERR) begin
		$display("ERROR, PSLAVEERROR must be 1!");
		$stop;
	end

    @(negedge PCLK);

	// A ------> 5
	PADDR   = 32'h0FF0;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 5;

    @(negedge PCLK);

	PADDR   = 32'h0FF0;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 5;
        
    @(negedge PCLK);

    // STORE MULTIPLICATION OPERAND B --------------------------------------
    // Try to hits a non-mapped region of slave 
	PADDR   = 32'h0FFF;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 2;
        
    @(negedge PCLK);

	PADDR   = 32'h0FFF;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 2;

    #2

	if (~PSLAVEERR) begin
		$display("ERROR, PSLAVEERROR must be 1!");
		$stop;
	end

    @(negedge PCLK);

	// B ------> 4
	PADDR   = 32'h02C4;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 4;

    @(negedge PCLK);

	PADDR   = 32'h02C4;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 4;
        
    @(negedge PCLK);

    // STORE MULTIPLICATION START --------------------------------------

    // START ------> 1
	PADDR   = 32'h000C;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 1;

    @(negedge PCLK);

	PADDR   = 32'h000C;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 1;
        
    @(negedge PCLK);

    // START ------> 0
	PADDR   = 32'h000C;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 0;

    @(negedge PCLK);

	PADDR   = 32'h000C;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 0;
        
    @(negedge PCLK);

    // LOAD MULTIPLICATION RESULT --------------------------------------

	PADDR   = 32'h0008;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 0; 
        
    @(negedge PCLK);

	PADDR   = 32'h0008;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 0; 

	@(posedge PREADY); // wait until mul finish

    if (PRDATA != 32'd20) begin
		$display("ERROR, data mismatching!");
		$stop;
	end

    mul_result = PRDATA;

    @(negedge PCLK);

    // STORE PWM PERIOD ----------------------------------------------
    
	// PERIOD ----> 20 Clk
	PADDR   = 32'h1000;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = mul_result;
        
    @(negedge PCLK);

	PADDR   = 32'h1000;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = mul_result;

    @(negedge PCLK);

	// PULSE ------> 10 Clk
	PADDR   = 32'h1004;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = mul_result/2;

    @(negedge PCLK);

	PADDR   = 32'h1004;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = mul_result/2;
        
    @(negedge PCLK);
    
	// SIZE -------> 5
	PADDR   = 32'h1008;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = mul_result/4;

	@(negedge PCLK);

	PADDR   = 32'h1008;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = mul_result/4;
        
    @(negedge PCLK);

	// ENABLE
	PADDR   = 32'h100C;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 1;
        
    @(negedge PCLK);

	PADDR   = 32'h100C;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 1;
        
    @(negedge PCLK);

	PADDR   = 0;
	PSEL    = 0;
	PENABLE = 0;
	PWRITE  = 0; 
	PWDATA  = 0;
        
    @(negedge PCLK);
    @(negedge PCLK);
    @(negedge PCLK);
    @(negedge PCLK);

    #2000

	$display("Testbench complete.");
    $stop;
    end
   
endmodule
