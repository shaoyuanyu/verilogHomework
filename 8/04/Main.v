module top_module (
    input clk,
    input [7:0] d, 
    input areset,   // asynchronous reset
    output reg [7:0] q
);
    integer i;
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            for (i=0; i<=7; i=i+1) begin
                q[i] = 0;
            end
        else
            for (i=0; i<=7; i=i+1) begin
                q[i] = d[i];
            end
    end

endmodule
