// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: testbench of APB bus with PWM modualtion

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

logic	[7:0]	PWM;

// DUT instance
APB_PWM DUT ( 
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

	// PERIOD ----> 8 Clk
	PADDR   = 0;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 8;
        
    @(negedge PCLK);

	PADDR   = 0;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 8;

    @(negedge PCLK);

	// PULSE ------> 2 Clk
	PADDR   = 4;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 2;

    @(negedge PCLK);

	PADDR   = 4;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 2;
        
    @(negedge PCLK);
    
	// SIZE
	PADDR   = 8;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 10;
        
    @(negedge PCLK);

	PADDR   = 8;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 1; 
	PWDATA  = 10;
        
    @(negedge PCLK);

	// ENABLE
	PADDR   = 12;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 1; 
	PWDATA  = 1;
        
    @(negedge PCLK);

	PADDR   = 12;
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

    #100

	// READ/LOAD PHASE ----------------------------------------

	@(negedge PCLK);
	// PERIOD ----> 8 Clk
	PADDR   = 0;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 0; 
        
    @(negedge PCLK);

	PADDR   = 0;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 0; 
	
	@(posedge PCLK);
	if (PRDATA != 32'd8) begin
		$display("PERIOD data mismatching!");
		$stop;
	end

    @(negedge PCLK);

	// PULSE ------> 2 Clk
	PADDR   = 4;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 0; 

    @(negedge PCLK);

	PADDR   = 4;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 0; 
	
	@(posedge PCLK);
	if (PRDATA != 32'd2) begin
		$display("PULSE data mismatching!");
		$stop;
	end
        
    @(negedge PCLK);
    
	// SIZE
	PADDR   = 8;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 0; 
        
    @(negedge PCLK);

	PADDR   = 8;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 0; 

	@(posedge PCLK);
	if (PRDATA != 32'd10) begin
		$display("SIZE data mismatching!");
		$stop;
	end
        
    @(negedge PCLK);

	// ENABLE
	PADDR   = 12;
	PSEL    = 1;
	PENABLE = 0;
	PWRITE  = 0; 
        
    @(negedge PCLK);

	PADDR   = 12;
	PSEL    = 1;
	PENABLE = 1;
	PWRITE  = 0; 

	@(posedge PCLK);
	if (PRDATA != 32'd1) begin
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
