module top_module (
    input clk,
    input  reset,   // synchronous reset
    input [7:0] d,
    output reg [7:0] q
);
    integer i;
    
    always @(posedge clk) begin
        if (reset)
            for (i=0; i<=7; i=i+1) begin
                q[i] <= 0;
            end
        else
            for (i=0; i<=7; i=i+1) begin
                q[i] <= d[i];
            end
    end

endmodule