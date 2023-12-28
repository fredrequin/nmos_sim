module NMOS_CMPD
(
    input  DB,
    input  VV,
    input  LD,
    input  C1,
    input  EQI,
    output EQO
);

`ifdef CLK_GEN
    wire _clk = `CLK_GEN.main_clk;
`else
    wire _clk = 1'b0;
`endif

    reg  _r_D_phi2;

    always @(posedge _clk) begin : LOAD_PULSE
    
        if (LD) begin
            _r_D_phi2 <= DB;
        end
    end

    reg _r_D_phi1;

    always @(posedge _clk) begin : PHI1_PULSE
    
        if (C1) begin
            _r_D_phi1 <= _r_D_phi2;
        end
    end

    assign EQO = (_r_D_phi1 == VV) ? EQI : 1'b0;

endmodule
