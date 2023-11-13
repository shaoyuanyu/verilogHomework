module mult8(
    input [7:0]a,
    input [7:0]b, 
    output reg [15:0] p
);
reg[3:0] i;
 
always@(*)
begin
	p = 0 ;
	for(i = 0 ; i <8 ; i = i + 1)
	begin
        if(b[i] == 1)
		begin
            p = (a <<i) + p;
		end
		else p = p;
	end
	i = 0;
end
endmodule
`timescale 1ns/1ns
 
module multi_tb;
 
 
reg [7:0] DIN1,DIN2;
wire [15:0] DOUT;
 
integer i,j;
 
    mult8 U_multi(.a(DIN1),.b(DIN2),.p(DOUT));
 
initial
begin	
	DIN2 = 0;
	for(j = 0; j<100; j = j+1)
	begin
		DIN2 = DIN2 + 1;
		DIN1 = 0;
		for(i = 0; i<100; i = i+1)
		begin
			#1000 DIN1 = DIN1 + 1;
		end
	end
end
 
 
endmodule

