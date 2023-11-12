module mult8(
    input [7:0]a,
    input [7:0]b, 
    output reg [15:0] p
);
	reg [3:0] i;
	
	always@(*) begin
		p = 0;
		for (i = 0 ; i <8 ; i = i + 1) begin
			if (b[i] == 1) p = (a <<i) + p;
			else p = p;
		end
		i = 0;
	end

endmodule
