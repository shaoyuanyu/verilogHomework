module RegFile(  
    input clk,  
    // 写使能信号  
    input rf_wen,  
    // 读地址  
    input [4:0] rf_addr_r1,  
    input [4:0] rf_addr_r2,  
    // 写入地址和写入数据  
    input [4:0] rf_addr_w,  
    input [31:0] rf_data_w,  
    // 输出端口  
    output reg [31:0] rf_data_r1,  
    output reg [31:0] rf_data_r2  
);
    reg [31:0] file[31:0];
    
    integer i;
    initial begin
        for (i=0; i<32; i=i+1) begin
            file[i] = 32'b0; 
        end
    end
    
    assign rf_data_r1 = file[rf_addr_r1];
    assign rf_data_r2 = file[rf_addr_r2];
    
    always @(negedge clk) begin
        if (rf_wen)
            file[rf_addr_w] <= rf_data_w;
    end

endmodule