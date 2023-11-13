module ALUCt(
	input rst,
	input [5:0] funct,
	input [1:0] alu_ct_op,
	output reg [3:0] alu_ct
);
	always @(*) begin
		if (!rst)
			alu_ct <= 0;
		else begin
			case (alu_ct_op)
				2'b00: alu_ct <= 4'b0010;
				2'b01: alu_ct <= 4'b0110;
				2'b10: begin
					case (funct)
						6'b100001: alu_ct = 4'b0010;
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