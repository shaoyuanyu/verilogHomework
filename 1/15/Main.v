`timescale 1ps/1ps
module top_module();
    reg clk = 0;
    parameter CYCLE = 10;
    dut dut(clk);
    always #5 clk<=~clk;
endmodule