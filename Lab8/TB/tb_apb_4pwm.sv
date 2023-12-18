// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: testbench of APB bus with 4 PWM modualtion

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

logic [3:0][7:0]	PWM;

// DUT instance
APB_4PWM #(
	.DATA_WIDTH ( 32 ),
	.SIZE_WIDTH ( 8 ),
    .NUM_SLAVE  ( 4 )
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
	
	// WRITE/STORE PHASE ---------------------------------------

	// SLAVE0 --------------------------------------------------

	// PERIOD ----> 2 Clk
	PADDR   = 32'h0000;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 2;
        
    @(negedge PCLK);

	PADDR   = 32'h0000;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 2;

    @(negedge PCLK);

	// PULSE ------> 1 Clk
	PADDR   = 32'h0004;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 1;

    @(negedge PCLK);

	PADDR   = 32'h0004;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 1;
        
    @(negedge PCLK);
    
	// SIZE
	PADDR   = 32'h0009;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 10;
        
	#2

	if (~PSLAVEERR) begin
		$display("ERROR, PSLAVEERROR must be 1!");
		$stop;
	end

    @(negedge PCLK);

	PADDR   = 32'h0008;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 1;

	@(negedge PCLK);

	PADDR   = 32'h0008;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 1;
        
    @(negedge PCLK);

	// ENABLE
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

	PADDR   = 0;
	PSEL    = 0;
	PENABLE = 0;
	PWRITE  = 0; 
	PWDATA  = 0;
    
	// SLAVE1 --------------------------------------------------

	// PERIOD ----> 4 Clk
	PADDR   = 32'h1000;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 4;
        
    @(negedge PCLK);

	PADDR   = 32'h1000;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 4;

    @(negedge PCLK);

	// PULSE ------> 1 Clk
	PADDR   = 32'h1004;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 1;

    @(negedge PCLK);

	PADDR   = 32'h1004;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 1;
        
    @(negedge PCLK);
    
	// SIZE
	PADDR   = 32'h1009;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 10;
        
	#2

	if (~PSLAVEERR) begin
		$display("ERROR, PSLAVEERROR must be 1!");
		$stop;
	end

    @(negedge PCLK);

	PADDR   = 32'h1008;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 10;

	@(negedge PCLK);

	PADDR   = 32'h1008;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 10;
        
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

	// SLAVE3 --------------------------------------------------

	// PERIOD ----> 8 Clk
	PADDR   = 32'h3000;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 8;
        
    @(negedge PCLK);

	PADDR   = 32'h3000;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 8;

    @(negedge PCLK);

	// PULSE ------> 6 Clk
	PADDR   = 32'h3004;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 6;

    @(negedge PCLK);

	PADDR   = 32'h3004;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 6;
        
    @(negedge PCLK);
    
	// SIZE
	PADDR   = 32'h3009;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 255;

	#2
        
	if (~PSLAVEERR) begin
		$display("ERROR, PSLAVEERROR must be 1!");
		$stop;
	end

    @(negedge PCLK);

	PADDR   = 32'h3008;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 255;

	@(negedge PCLK);

	PADDR   = 32'h3008;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 255;
        
    @(negedge PCLK);

	// ENABLE
	PADDR   = 32'h300C;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 1;
        
    @(negedge PCLK);

	PADDR   = 32'h300C;
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

    #1000

	// READ/LOAD PHASE ----------------------------------------

	// SLAVE 2 ------------------------------------------------
	@(negedge PCLK);
	// PERIOD ----> 0 Clk
	PADDR   = 32'h2000;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 0; 
        
    @(negedge PCLK);

	PADDR   = 32'h2000;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 0; 

	#2

	if (PRDATA != 32'd0) begin
		$display("PERIOD data mismatching!");
		$stop;
	end

    @(negedge PCLK);

	// PULSE ------> 0 Clk
	PADDR   = 32'h2004;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 0; 

    @(negedge PCLK);

	PADDR   = 32'h2004;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 0; 

	#2
	
	
	if (PRDATA != 32'd0) begin
		$display("PULSE data mismatching!");
		$stop;
	end
        
    @(negedge PCLK);
    
	// SIZE
	PADDR   = 32'h2008;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 0; 
        
    @(negedge PCLK);

	PADDR   = 32'h2008;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 0; 

	#2


	if (PRDATA != 32'd0) begin
		$display("SIZE data mismatching!");
		$stop;
	end
        
    @(negedge PCLK);

	// ENABLE
	PADDR   = 32'h200C;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 0; 
        
    @(negedge PCLK);

	PADDR   = 32'h200C;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 0; 

	#2


	if (PRDATA != 32'd0) begin
		$display("ENABLE data mismatching!");
		$stop;
	end
        
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
