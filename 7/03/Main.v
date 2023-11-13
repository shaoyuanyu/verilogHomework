module top_module (
    input wire d, 
    input wire ena,
    output reg q
);
    assign q=0;
    always @(posedge ena or posedge d)
    begin
        if (ena)
            q <= d;
    end

endmodule