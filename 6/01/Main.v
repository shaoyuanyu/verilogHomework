module top_module (
    input x, 
    input y, 
    output z
);
    wire a1,a2,b1,b2;

    A IA1(
        .x(x),
        .y(y),
        .z(a1)
    );
    B IB1(
        .x(x),
        .y(y),
        .z(b1)
    );
    A IA2(
        .x(x),
        .y(y),
        .z(a2)
    );
    B IB2(
        .x(x),
        .y(y),
        .z(b2)
    );

    assign z = (a1|b1) ^ (a2&b2);

endmodule