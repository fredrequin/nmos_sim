module NMOS_PASS
(
    input  G,   // Gate (clock)
    input  D,   // Drain (input)
    output S    // Source (output)
);

`ifdef CLK_GEN
    wire _clk = `CLK_GEN.main_clk;
`else
    wire _clk = 1'b0;
`endif

    reg _r_D_pass;

    always @(posedge _clk) begin : GATE_PULSE
    
        if (G) begin
            _r_D_pass <= D;
        end
    end

    assign S = _r_D_pass;

endmodule
