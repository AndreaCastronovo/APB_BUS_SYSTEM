// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: Serial multiplier

module serial_multiplier #( 
    parameter int unsigned OP_X_WIDTH = 16,
    parameter int unsigned OP_Y_WIDTH = 16,
    localparam int unsigned OUT_WIDTH  = OP_Y_WIDTH + OP_X_WIDTH
) (
    input   logic                       clk,
    input   logic                       rst_n,
    input   logic                       start,
    input   logic   [OP_X_WIDTH-1:0]    in_x,
    input   logic   [OP_Y_WIDTH-1:0]    in_y,
    output  logic                       valid_out,
    output  logic   [OUT_WIDTH-1:0]     out_mul
);
    

    // Load operand X --------------------------------------------------------------------------------------
    logic   [OUT_WIDTH-1:0] extend, in_x_ext, in_x_d, in_x_q, in_x_shifted;
    logic                   load_op;

    assign extend   = '0;
    assign in_x_ext = in_x + extend;     // Operand extension at 32-bit's
    
    assign in_x_d = load_op ? in_x_ext : in_x_shifted;    // First load or left shifted operand

    always_ff @( posedge clk, negedge rst_n ) begin : operand_x
        if(~rst_n)
            in_x_q <= '0;
        else 
            in_x_q <= in_x_d;
    end

    assign in_x_shifted = in_x_q << 1;
    
    // Load operand Y --------------------------------------------------------------------------------------
    logic   [OP_Y_WIDTH-1:0]  in_y_d, in_y_q, in_y_shifted;
    
    assign in_y_d = load_op ? in_y : in_y_shifted;    // First load or left shifted operand

    always_ff @( posedge clk, negedge rst_n ) begin : operand_y
        if(~rst_n)
            in_y_q <= '0;
        else 
            in_y_q <= in_y_d;
    end

    assign in_y_shifted = in_y_q >> 1;

    // MAC -----------------------------------------------------------------------------------------------
    logic   [OUT_WIDTH-1:0] mul, sum_d, sum_q;
    logic                   clear;

    assign mul      = in_x_q & {OUT_WIDTH{in_y_q[0]}}; // each x bits in & with bit at position 0 of y shifted at each clock
    assign sum_d    = mul + sum_q;

    always_ff @( posedge clk, negedge rst_n ) begin : operand_out
        if(~rst_n)
            sum_q <= '0;
        else if(clear)
            sum_q <= '0;
        else 
            sum_q <= sum_d;
    end
    
    assign out_mul = sum_q;

    // FSM -----------------------------------------------------------------------------------------------
    logic   enable;

    localparam int unsigned MAX_SIZE = (OP_X_WIDTH > OP_Y_WIDTH) ? OP_X_WIDTH : OP_Y_WIDTH;    // Maximum size;
    logic   [$clog2(MAX_SIZE)-1:0]  count_o;
    
    enum {IDLE, LOAD, MUL, OUT} cs, ns;   // Define of state

    always_ff @( posedge clk, negedge rst_n ) begin : fsm
        if (~rst_n)
            cs  <=  IDLE;
        else
            cs  <=  ns;
    end

    // Next state & output
    always_comb begin
        case (cs)
            IDLE:   if(start)       ns = LOAD;
                    else            ns = IDLE;      

            LOAD:                   ns = MUL;

            MUL:    if(count_o == 15)   ns = OUT;
                    else                ns = MUL;

            OUT:    if(start)       ns = LOAD;
                    else            ns = IDLE;     
                        
            default:                ns = IDLE;
        endcase
    end

    assign  load_op     = (cs == LOAD);
    assign  clear       = (cs == OUT);
    assign  enable      = (cs == MUL);
    assign  valid_out   = clear;

    // Counter ------------------------------------------------------------------------------------------
    counter_clr_en #( .WIDTH($clog2(MAX_SIZE)) ) counter_i ( .clk_i(clk), .rstn_i(rst_n), .clr_i(clear), 
        .enable_i(enable), .count_o(count_o) );

endmodule