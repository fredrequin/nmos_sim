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
        
        if (SA) _r_Q <= A | FF;
        if (SB) _r_Q <= B | FF;
        if (SC) _r_Q <= C | FF;
    end

    assign Q = _r_Q;

endmodule
