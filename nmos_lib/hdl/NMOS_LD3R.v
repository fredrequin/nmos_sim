module NMOS_LD3R
(
    input  R,   // Reset input
    input  C1,  // PHI1 clock
    input  D,   // Data input
    input  LD,  // Load input
    output Q    // Register output
);

`ifdef CLK_GEN
    wire _clk = `CLK_GEN.main_clk;
`else
    wire _clk = 1'b0;
`endif

    reg _r_D_phi2 /* verilator public */;

    always @(posedge _clk) begin : LOAD_PULSE
    
        if (R) begin
            _r_D_phi2 <= 1'b0;
        end
        else if (LD) begin
            _r_D_phi2 <= D;
        end
    end

    reg _r_D_phi1;

    always @(posedge _clk) begin : PHI1_PULSE
    
        if (C1) begin
            _r_D_phi1 <= _r_D_phi2;
        end
    end

    assign Q   =  _r_D_phi1;

endmodule
