module top_module ( 
    input clk, 
    input [7:0] d, 
    input [1:0] sel, 
    output reg [7:0] q 
);
    wire [7:0] s0, s1, s2, s3;
    
    assign s0 = d;
    my_dff8 m1(clk, s0, s1);
    my_dff8 m2(clk, s1, s2);
    my_dff8 m3(clk, s2, s3);
    
    always @(*) begin
        if (sel == 0)
            q <= s0;
        else if (sel == 1)
            q <= s1;
        else if (sel == 2)
            q <= s2;
        else
            q <= s3;
    end
    
endmodule