module adder(
    input [3:0] A,
    input [3:0] B,
    input Clk,
    input En,
    output reg [3:0] Sum,
    output reg Overflow
);
	initial begin
    	Sum = 0;
        Overflow = 0;
    end
    
    always @(posedge Clk) begin
        if (En)
        { Overflow, Sum } = A + B;
    end

endmodule