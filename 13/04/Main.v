module top_module (
    input clk,
    input reset,
    input enable,
    output reg [3:0] Q
);
    initial Q=4'b0001;

    always@(posedge clk) begin
        if (reset) begin
            if (enable) Q=0;
            else Q=1;
        end
        if (enable) begin
            if (Q==12) Q=1;
            else Q=Q+1;
        end
    end

endmodule