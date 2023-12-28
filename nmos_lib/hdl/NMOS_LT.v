module NMOS_LT
(
    input  LPRD,
    input  LPLD,
    input  OE,
    inout  DB,
    input  DI,
    output DO
);

`ifdef CLK_GEN
    wire _clk = `CLK_GEN.main_clk;
`else
    wire _clk = 1'b0;
`endif

    reg _r_LP;
    
    always @(posedge _clk) begin : LPEN_LATCH
    
        if (LPLD) begin
            _r_LP <= DI;
        end
    end

    wire _w_DBO = (LPRD) ? _r_LP : DI;

    assign DB = (OE) ? _w_DBO : 1'bZ;

    assign DO = DB;

endmodule
