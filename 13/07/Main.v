module alu(
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALUOp,
    output reg [31:0] C
);
    integer i;
    always @ (*) begin
        case (ALUOp)
			3'b000: C=A+B;
			3'b001: C=A-B;
			3'b010: C=A&B;
			3'b011: C=A|B;	
			3'b100: C=A>>B;
			3'b101: begin
                C=A;
                for(i=0;i<B;i=i+1)begin
                    C=C>>1;
                    C[31]=A[31];
                end
            end
			3'b110: C=A>B?1:0;
            3'b111: begin
                if(A[31]==1&&B[31]==0)
                    C=0;
                else if(A[31]==1&&B[31]==1)
                    C=1;
                else if(A[31]==1&&B[31]==1)
                    C=(~A[30:0]>~B[30:0])?1:0;
                else
                    C=(A[30:0]>B[30:0])?1:0;
            end
		endcase
    end

endmodule 