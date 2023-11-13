`timescale 1ns / 1ps

module IFU(
    input clk, rst,
    input alu_zero, ct_branch, ct_jump,
    output [31:0] inst
);
    reg [31:0] pc;
    reg [31:0] instRom[65535:0];
    wire [31:0] ext_data;
    
    initial $readmemh("inst.data", instRom);
    
    assign inst = instRom[pc[17:2]];
    
    assign ext_data = {{16{inst[15]}},inst[15:0]};
    
    always @(posedge clk) begin
        if (!rst) pc<=0;
        else begin
            if (ct_jump)
                pc <= {pc[31:28], inst[15:0], 2'b00};
            else if (ct_branch && alu_zero)
                pc <= pc + 4 + ext_data*4;
            else
                pc <= pc + 4;
        end
    end

endmodule


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


module ALU(
    input rst,
    input [3:0] alu_ct,
    input [31:0] alu_src1, alu_src2,
    output alu_zero,
    output reg [31:0] alu_res
);
    assign alu_zero = (alu_res == 0) ? 1 : 0;
    
    always @(*) begin
        if (!rst) alu_res <= 32'b0; 
        else begin
            case (alu_ct)
                4'b0010: alu_res = alu_src1 + alu_src2;
                4'b0110: alu_res = alu_src1 - alu_src2;
                default: alu_res = 32'b0;
            endcase
        end
    end

endmodule


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
		end
	end

endmodule


module ALUCt(
    input rst,
    input [5:0] funct,
    input [1:0] alu_ct_op,
    output reg [3:0] alu_ct
);
    always @(*) begin
        if (!rst)
            alu_ct = 0;
        else begin
            case (alu_ct_op)
                2'b00: alu_ct = 4'b0010;
                2'b01: alu_ct = 4'b0110;
                2'b10: begin
                    case (funct)
                        6'b100001:alu_ct = 4'b0010;
                        default: alu_ct = 0;
                    endcase 
                end
                default: alu_ct = 0;
            endcase
        end
    end
endmodule

module Control(
    input rst,
    input[5:0] ct_inst,
    input[5:0] aluct_inst,
    output ct_rf_dst,
    output ct_rf_wen,
    output ct_alu_src,
    output[3:0] ct_alu,
    output ct_mem_wen,
    output ct_mem_ren,
    output ct_data_rf,
    output ct_branch,
    output ct_jump
);

    reg r, lw, sw, beq, j, addiu;
    reg [1:0] ct_alu_op;

    ALUCt aluct0(
        .rst(rst),
        .funct(aluct_inst),
        .alu_ct_op(ct_alu_op),
        .alu_ct(ct_alu)
    );

    assign r = (~ct_inst[5]) && (~ct_inst[4]) && (~ct_inst[3]) && (~ct_inst[2]) && (~ct_inst[1]) && (~ct_inst[0]);
    assign lw = (ct_inst[5]) && (~ct_inst[4]) && (~ct_inst[3]) && (~ct_inst[2]) && (ct_inst[1]) && (ct_inst[0]);
    assign sw = (ct_inst[5]) && (~ct_inst[4]) && (ct_inst[3]) && (~ct_inst[2]) && (ct_inst[1]) && (ct_inst[0]);
    assign beq = (~ct_inst[5]) && (~ct_inst[4]) && (~ct_inst[3]) && (ct_inst[2]) && (~ct_inst[1]) && (~ct_inst[0]);
    assign j = (~ct_inst[5]) && (~ct_inst[4]) && (~ct_inst[3]) && (~ct_inst[2]) && (ct_inst[1]) && (~ct_inst[0]);
    assign addiu = (~ct_inst[5]) && (~ct_inst[4]) && (ct_inst[3]) && (~ct_inst[2]) && (~ct_inst[1]) && (ct_inst[0]);
    assign ct_rf_dst = rst ? r : 0;
    assign ct_rf_wen = rst ? (r || lw || addiu) : 0;
    assign ct_alu_src = lw || sw || addiu;
    assign ct_alu_op[1:0] = {r, beq};
    assign ct_branch = beq;
    assign ct_mem_ren = lw;
    assign ct_mem_wen = sw;
    assign ct_data_rf = lw;
    assign ct_jump = j;
endmodule


module CPU(
	input clk, rst
);
	// ifu
	wire [31:0] inst;
	// control unit
	wire ct_rf_dst, ct_rf_wen, ct_alu_src, ct_data_rf, ct_branch, ct_jump, ct_mem_wen, ct_mem_ren;
	wire [3:0] ct_alu;
	// regFile
	wire [4:0] rf_addr_w;
	wire [31:0] rf_data_r1, rf_data_r2, rf_data_w;
	// ALU
	wire alu_zero;
	wire [31:0] alu_src2;
	wire [31:0] alu_res;
	// extend data
	wire [31:0] ext_data;
	// dataMem
	wire[31:0] mem_data_o;

	//
	assign rf_addr_w = ct_rf_dst ? inst[15:11] : inst[20:16];
	assign rf_data_w = ct_data_rf ? mem_data_o : alu_res;
	assign ext_data = {{16{inst[15]}}, inst[15:0]};
	assign alu_src2 = ct_alu_src ? ext_data : rf_data_r2;


	IFU ifu0(
		.clk(clk),
		.rst(rst),
		.alu_zero(alu_zero),
		.ct_branch(ct_branch),
		.ct_jump(ct_jump),
		.inst(inst)
	);

	Control control0(
		.rst(rst),
		.ct_inst(inst[31:26]),
		.aluct_inst(inst[5:0]),
		.ct_rf_dst(ct_rf_dst),
		.ct_rf_wen(ct_rf_wen),
		.ct_alu_src(ct_alu_src),
		.ct_alu(ct_alu),
		.ct_mem_wen(ct_mem_wen),
		.ct_mem_ren(ct_mem_ren),
		.ct_data_rf(ct_data_rf),
		.ct_branch(ct_branch),
		.ct_jump(ct_jump)
	);

	RegFile rf0(
		.clk(clk),
		.rf_wen(ct_rf_wen),
		.rf_addr_r1(inst[25:21]),
		.rf_addr_r2(inst[20:16]),
		.rf_addr_w(rf_addr_w),
		.rf_data_w(rf_data_w),
		.rf_data_r1(rf_data_r1),
		.rf_data_r2(rf_data_r2)
	);

	ALU alu0(
		.rst(rst),
		.alu_ct(ct_alu),
		.alu_src1(rf_data_r1),
		.alu_src2(alu_src2),
		.alu_zero(alu_zero),
		.alu_res(alu_res)
	);

	DataMem dm0(
		.clk(clk),
		.mem_wen(ct_mem_wen),
		.mem_ren(ct_mem_ren),
		.mem_addr(alu_res),
		.mem_data_i(rf_data_r2),
		.mem_data_o(mem_data_o)
	);

endmodule