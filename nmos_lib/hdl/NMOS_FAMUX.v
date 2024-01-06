module NMOS_FAMUX
(
    input  A,
    input  B,
    input  C,
    input  SA,
    input  SB,
    input  SC,
    input  FF,
    output Q
);

`ifdef CLK_GEN
    wire _clk = `CLK_GEN.main_clk;
`else
    wire _clk = 1'b0;
`endif

    reg _r_Q;

    always @(posedge _clk) begin
        
        if (SA) _r_Q <= A;
        if (SB) _r_Q <= B;
        if (SC) _r_Q <= C;
    end

    assign Q = (FF) ? 1'b1 : _r_Q;

endmodule
