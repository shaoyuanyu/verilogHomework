module top_module (
    input clk,
    input reset,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q);
    
    always@(posedge clk) begin
        if(reset)begin
            q=0;
        end
        else begin
        if(shift_ena)
            q <= {q[2:0],data};
        else if(count_ena) begin
            if(q == 4'd0)
                q <= 4'd15;
           else 
                q <= q -1'b1;
           end
        end
    end

endmodule

