module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] result
);
    wire w1;
    
    add16 add16_1(
        .a(a[15:0]),
        .b(b[15:0]^{16{sub}}),
        .cin(sub),
        .sum(result[15:0]),
        .cout(w1)
    );
    
    add16 add16_2(
        .a(a[31:16]),
        .b(b[31:16]^{16{sub}}),
        .cin(w1),
        .sum(result[31:16]),
        .cout()
    );

endmodule