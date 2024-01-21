module NMOS_TR
(
    input  R,   // Reset input
    input  C1,  // PHI1 clock
    input  C2,  // PHI2 clock
    input  T,   // Toggle input
    output Q,   // Register output
    output Q_n  // Inverted output
);

`ifdef CLK_GEN
    wire _clk = `CLK_GEN.main_clk;
`else
    wire _clk = 1'b0;
`endif

    reg _r_D_phi2;

    always @(posedge _clk) begin : PHI2_PULSE
    
        if (C2) begin
            if (R) begin
                _r_D_phi2 <= 1'b0;
            end
            else begin
                _r_D_phi2 <= _r_D_phi1 ^ T;
            end
        end
    end

    reg _r_D_phi1;

    always @(posedge _clk) begin : PHI1_PULSE
    
        if (C1) begin
            _r_D_phi1 <= _r_D_phi2;
        end
    end

    assign Q   =  _r_D_phi1;
    assign Q_n = ~_r_D_phi1;

endmodule
