// STUDENT: Andrea Castronovo
// N.MATRI: 1029122
//
// DESCRIPTION: Coffe vending machine with MOORE FSM


module vending
(
    input   logic   clk,
    input   logic   rstn,
    input   logic   dime,
    input   logic   niche,
    output  logic   out
);

    // Define of State
    enum {IDLE, FIVE, TEN, COFFEE} cs, ns;

    always_ff @( posedge clk, negedge rstn ) begin
        if (~rstn)
            cs  <=  IDLE;
        else
            cs  <=  ns;
    end

    // Next state & output
    always_comb begin
        case (cs)
            IDLE: begin
                if(niche)       ns = FIVE;
                else if(dime)   ns = TEN;
                else            ns = IDLE;      
            end
            FIVE: begin
                if(niche)       ns = TEN;
                else if(dime)   ns = COFFEE;
                else            ns = FIVE;
            end
            TEN: begin
                if(niche | dime)    ns = COFFEE;
                else                ns = TEN;
            end
            COFFEE: begin
                if(niche)       ns = FIVE;
                else if(dime)   ns = TEN;
                else            ns = IDLE;    
            end
            default:                ns = IDLE;
        endcase
    end

    assign  out = (cs == COFFEE);

endmodule