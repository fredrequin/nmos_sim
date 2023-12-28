module NMOS_SE
(
    input  R,   // Reset input
    input  C1,  // PHI1 clock
    input  C2,  // PHI2 clock
    inout  DB,  // Data bus
    input  OE,  // Output enable
    input  LD,  // Load input
    input  SE,  // Set/Clear input
    output Q    // Register output
);

`ifdef CLK_GEN
    wire _clk = `CLK_GEN.main_clk;
`else
    wire _clk = 1'b0;
`endif

    reg _r_D_phi2;

    always @(posedge _clk) begin : PHI2_PULSE
    
        if (C2) begin
            if (LD & DB) begin
                _r_D_phi2 <= SE;
            end
            else begin
                _r_D_phi2 <= _r_D_phi1 & ~R;
            end
        end
    end

    reg _r_D_phi1;

    always @(posedge _clk) begin : PHI1_PULSE
    
        if (C1) begin
            _r_D_phi1 <= _r_D_phi2;
        end
    end

    assign DB = (OE) ? _r_D_phi1 : 1'bZ;
    assign Q  = _r_D_phi1;

endmodule
