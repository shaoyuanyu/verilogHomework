module moore_1101 (
    input clk,
    input clr,
    input din,
    output  reg dout
);
    parameter S0=0, S1=1, S2=2, S3=3, S4=4;
    reg[4:0] state;
    reg[4:0] nstate;
    
    always@(posedge clk or posedge clr) begin
        if(clr)
            state <= S0;
        else
            state <= nstate;
    end

    always@(*) begin
        if(clr)
            nstate <= S0;
        else
            case(state)
                S0     : nstate <= din? S1: S0;
                S1     : nstate <= din? S2: S0;
                S2     : nstate <= din? S2: S3;
                S3     : nstate <= din? S4: S0;
                S4     : nstate <= din? S2: S0;
                default: nstate <= S0;
            endcase
    end

    assign dout = (state ==S4) ? 1 : 0;

endmodule