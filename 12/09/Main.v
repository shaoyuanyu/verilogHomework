module add1 ( 
    input a, 
    input b, 
    input cin,   
    output sum, 
    output cout 
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));

endmodule

module add2(
    input [1:0]a, 
    input [1:0]b, 
    input cin,   
    output [1:0]sum, 
    output cout 
);
    wire cout1;
    add1 ins1(
        a[0],
        b[0],
        cin,
        sum[0],
        cout1
    );
    add1 ins2(
        a[1],
        b[1],
        cout1,
        sum[1],
        cout
    );

endmodule

module add4(
    input [3:0]a, 
    input [3:0]b, 
    input cin,   
    output [3:0]sum, 
    output cout 
);
    wire cout2;
    add2 ins1(
        a[1:0],
        b[1:0],
        cin,
        sum[1:0],
        cout2
    );
    add2 ins2(
        a[3:2],
        b[3:2],
        cout2,
        sum[3:2],
        cout
    );

endmodule

module add8(
    input [7:0]a, 
    input [7:0]b, 
    input cin,   
    output [7:0]sum, 
    output cout 
);
    wire cout3;
    add4 ins1(
        a[3:0],
        b[3:0],
        cin,
        sum[3:0],
        cout3
    );
    add4 ins2(
        a[7:4],
        b[7:4],
        cout3,
        sum[7:4],
        cout
    );

endmodule

module add16(
    input [15:0]a, 
    input [15:0]b, 
    input cin,   
    output [15:0]sum, 
    output cout 
);
    wire cout4;
    add8 ins1(
        a[7:0],
        b[7:0],
        cin,
        sum[7:0],
        cout4
    );
    add8 ins2(
        a[15:8],
        b[15:8],
        cout4,
        sum[15:8],
        cout
    );

endmodule

module rcadd32(
    input [31:0]a,
    input [31:0]b,
    input cin,
    output [31:0]sum,
    output cout
);
    wire cout5;

    add16 ins1(
        a[15:0],
        b[15:0],
        cin,
        sum[15:0],
        cout5
    );
    add16 ins2(
        a[31:16],
        b[31:16],
        cout5,
        sum[31:16],
        cout
    );

endmodule
    
