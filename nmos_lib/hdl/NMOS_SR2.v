module NMOS_SR2
(
    input  C1,  // PHI1 clock
    input  C2,  // PHI2 clock
    input  R,   // Reset input
    input  S,   // Set input
    output D,   // Combinational output
    output Q    // Registered output
);

`ifdef CLK_GEN
    wire _clk = `CLK_GEN.main_clk;
`else
    wire _clk = 1'b0;
`endif

    reg  _r_D_phi1;
    reg  _r_D_phi2;

    wire _w_D_phi2 = (_r_D_phi1 | S) & ~R;

    always @(posedge _clk) begin : PHI2_PULSE
    
        if (C2) begin
            _r_D_phi2 <= _w_D_phi2;
        end
    end

    always @(posedge _clk) begin : PHI1_PULSE
    
        if (C1) begin
            _r_D_phi1 <= _r_D_phi2;
        end
    end
    
    assign D = _w_D_phi2;
    assign Q = _r_D_phi1;

endmodule
