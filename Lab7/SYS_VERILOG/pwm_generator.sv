// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: PWM generator

module pwm_generator(
    input   logic           clk,
    input   logic           rstn,
    input   logic   [31:0]  PERIOD,
    input   logic   [31:0]  PULSE,
    input   logic   [7:0]   SIZE,
    input   logic           ENABLE,
    output  logic   [7:0]   PWM
);

// Counter
localparam int unsigned MAX_COUNT = $clog2(32); // log2 of #bits of PERIOD
logic [MAX_COUNT-1:0]   count_o; 
logic                   reset_counter;

counter_clr_en #( .WIDTH(MAX_COUNT) ) coutner_clr_en_i (
    .clk_i      ( clk ),
    .rstn_i     ( rstn ),
    .clr_i      ( reset_counter ),
    .enable_i   ( ENABLE ),
    .count_o    ( count_o )
);


// FSM
enum {IDLE, HCLK, LCLK} cs, ns;

always_ff @( posedge clk, negedge rstn ) begin
    if (~rstn)
        cs  <=  IDLE;
    else if( ~ENABLE)
        cs  <=  IDLE;
    else
        cs  <=  ns;
end

always_comb begin
    case (cs)
        IDLE:
            ns = HCLK;

        HCLK:
            if(count_o == PULSE)    ns = LCLK;
            else                    ns = HCLK;

        LCLK:
            if(count_o == 0)    ns = HCLK;  // clear counter PERIOD - 1
            else                ns = LCLK;

        default
            ns = IDLE;
    endcase
end

assign PWM              = (cs == HCLK) ? SIZE : 8'd0;
assign reset_counter    = ~ENABLE | (count_o == PERIOD - 1);  // Idle clear or at the end of low clock phase


endmodule