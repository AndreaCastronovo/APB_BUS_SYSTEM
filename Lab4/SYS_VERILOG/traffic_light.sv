// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: Traffic light

module traffic_light
(
    input   logic   clk,
    input   logic   rstn,
    output  logic   red,
    output  logic   yellow,
    output  logic   green
);

    // Wait cycles
    localparam RED_WAIT     = 100 - 1; //
    localparam GREEN_WAIT   = 200 - 1; // Counter starts from 0
    localparam YELLOW_WAIT  = 10;
    // Minimum number of bits to represent max count
    localparam BIT_COUNT    = $clog2(GREEN_WAIT + YELLOW_WAIT);
    // Internal signal
    logic [BIT_COUNT-1:0]   count_o;
    logic                   clr;
    logic                   full_green, full_red, full_y2g, full_y2r;

    // FSM
    enum {RED_S, GREEN_S, YELLOW_S} cs, ns;

    always_ff @( posedge clk, negedge rstn ) begin
        if (~rstn)
            cs  <=  RED_S;
        else
            cs  <=  ns;
    end

    always_comb begin
        case (cs)
            RED_S:
                if(full_red)    ns = YELLOW_S;
                else            ns = RED_S;

            GREEN_S:
                if(full_green)  ns = YELLOW_S;
                else            ns = GREEN_S;

            YELLOW_S:
                if(full_y2g)        ns = GREEN_S;
                else if(full_y2r)   ns = RED_S;
                else                ns = YELLOW_S;

            default
                ns = RED_S;
        endcase
    end

    assign  red     = (cs == RED_S);
    assign  yellow  = (cs == YELLOW_S);
    assign  green   = (cs == GREEN_S);  

    // Counter
    counter_clr #( .WIDTH(BIT_COUNT) ) counter_i ( .clk_i(clk), .rstn_i(rstn), .clr_i(clr), .count_o(count_o) );

    assign clr          =   ((full_y2g | full_y2r) & cs == YELLOW_S & ns != cs);    // Clear counter only at the end of yellow-state
    assign full_y2r     =   (count_o == GREEN_WAIT + YELLOW_WAIT);
    assign full_y2g     =   (count_o == RED_WAIT + YELLOW_WAIT);
    assign full_green   =   (count_o == GREEN_WAIT);
    assign full_red     =   (count_o == RED_WAIT);
    


endmodule