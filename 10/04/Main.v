module top_module (
    input clk,
    input w, R, E, L,
    output reg Q
);
    wire temp1;
    wire temp2;
    assign Q=0;
    
    assign temp1=E?w:Q;
    assign temp2=L?R:temp1;
       always@(posedge clk)begin
        Q=temp2;
    end

endmodule