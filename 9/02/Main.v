module top_module (
    input clock,
    input a,
    output reg p,
    output reg q
);
    initial begin
        p = 0;
        q = 0;
    end
    
    always @(a or clock) begin
        if ( clock )
            p <= a;
    end
    
    always @(negedge clock) begin
        q <= a;
    end

endmodule