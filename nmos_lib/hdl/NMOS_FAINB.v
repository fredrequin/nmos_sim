module NMOS_FAINB
(
    input  I,
    input  CK,
    output O
);

`ifdef CLK_GEN
    wire _clk = `CLK_GEN.main_clk;
`else
    wire _clk = 1'b0;
`endif

    reg _r_O;

    always @(posedge _clk) begin

        if (CK) begin
            _r_O <= I;
        end
    end

    assign O = _r_O;

endmodule
