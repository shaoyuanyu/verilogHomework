module top_module(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] sum
);
    wire cout1,cout2,cout3;
    wire [15:0]temp_sum1;
    wire [15:0]temp_sum2;
    wire [15:0]temp_sum3;

    add16 ins1(
        a[15:0],
        b[15:0],
        0,
        temp_sum1[15:0],
        cout1
    );
    add16 ins2(
        a[31:16],
        b[31:16],
        0,
        temp_sum2[15:0],
        cout2
    );
    add16 ins3(
        a[31:16],
        b[31:16],
        1,
        temp_sum3[15:0],
        cout3
    );

    assign sum = cout1 ? {temp_sum3, temp_sum1} : {temp_sum2, temp_sum1};

endmodule
