module top_module (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);
    always @(posedge clk)begin
        if(!resetn)
            q <= 16'd0;
        else begin
            case (byteena)
            2'b10:
                q <= (q&16'h00FF)|(d&16'hFF00);
            2'b11:
                q <= d;
            2'b01: 
                q <= (q&16'hFF00)|(d&16'h00FF);
            2'b00: 
                q <= q;
            default: q <= q;
            endcase
            
        end
    end

endmodule