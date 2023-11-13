module top_module (
    input in1,
    input in2,
    input in3,
    output out
);
	wire a1;
    assign a1 = ~(in1^in2);
    assign out = a1 ^ in3;

endmodule;