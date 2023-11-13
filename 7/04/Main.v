module top_module (
    input clk,
    input in, 
    output reg out
);
	initial
    	out = 0;
    
    reg d;
    
    assign d = in^out;

    always @(posedge clk) begin
        out <= d;
        //d <= in^out;
    end

endmodule