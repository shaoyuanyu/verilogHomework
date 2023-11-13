module comparator(
    input [3:0]A,
    input [3:0]B,
    output Out
);
    wire unsigned [4:0] X;
    wire signed [3:0] Y;
    wire signed [3:0] Z;
    assign Y = A;
    assign Z = B;
    assign X = Y-Z;
    assign Out = X[4];

endmodule