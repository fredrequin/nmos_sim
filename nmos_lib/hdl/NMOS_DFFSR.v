module NMOS_DFFSR
(
    input  C1,  // PHI1 clock
    input  C2,  // PHI2 clock
    input  R,   // Reset input
    input  S,   // Set input
    input  D,   // Data input
    output Q    // Register output
);

`ifdef CLK_GEN
    wire _clk = `CLK_GEN.main_clk;
`else
    wire _clk = 1'b0;
`endif

    reg _r_D_phi2;

    always @(posedge _clk) begin : PHI2_PULSE
    
        if (R | S) begin
            _r_D_phi2 <= S;
        end
        else if (C2) begin
            _r_D_phi2 <= D;
        end
    end

    reg _r_D_phi1;

    always @(posedge _clk) begin : PHI1_PULSE
    
        if (R | S) begin
            _r_D_phi2 <= S;
        end
        else if (C1) begin
            _r_D_phi1 <= _r_D_phi2;
        end
    end

    assign Q   =  _r_D_phi1;

endmodule
