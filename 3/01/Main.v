module top_module( 
    input [2:0] in,
    output [1:0] out 
);
    reg [1:0] width;
    reg [1:0] cnt;

    always @ (in)begin
        cnt='d0;
        for(width=0;width<3;width=width+1)begin
            if(in[width])
                cnt=cnt+1'b1;
            else
                cnt=cnt;
        end
    end
    
    assign out=cnt;

endmodule