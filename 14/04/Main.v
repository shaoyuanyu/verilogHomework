module DataMem(
	input clk, mem_wen, mem_ren,
	input [31:0] mem_addr,
	input [31:0] mem_data_i,
	output reg [31:0] mem_data_o
);
	reg [7:0] data_mem0[0:66535];
	reg [7:0] data_mem1[0:66535];
	reg [7:0] data_mem2[0:66535];
	reg [7:0] data_mem3[0:66535];

	always @(negedge clk) begin
		if (mem_wen) begin
			data_mem0[mem_addr[31:2]] <= mem_data_i[7:0];
			data_mem1[mem_addr[31:2]] <= mem_data_i[15:8];
			data_mem2[mem_addr[31:2]] <= mem_data_i[23:16];
			data_mem3[mem_addr[31:2]] <= mem_data_i[31:24];
		end
	end

	always @(*) begin
		if (mem_ren) begin
			mem_data_o[7:0] <= data_mem0[mem_addr[31:2]];
			mem_data_o[15:8] <= data_mem1[mem_addr[31:2]];
			mem_data_o[23:16] <= data_mem2[mem_addr[31:2]];
			mem_data_o[31:24] <= data_mem3[mem_addr[31:2]];
		end else mem_data_o <= 0;
	end

endmodule