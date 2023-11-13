`timescale 1ps/1ps
module top_module();
    reg x,y;
    wire out; 

    initial begin
        x<=0;
        y<=0;
        #10
        x<=0;
        y<=1;
        #10
        x<=1;
        y<=0;
        #10
        x<=1;
        y<=1;
    end
    
    andgate a({x,y},out);

endmodule