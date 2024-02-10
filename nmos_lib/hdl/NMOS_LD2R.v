module NMOS_LD2R
(
    input  C1,  // PHI1 clock
    input  D,   // Data input
    input  LD,  // Load input
    output Q,   // Register output
    output Q_n
);

`ifdef CLK_GEN
    wire _clk = `CLK_GEN.main_clk;
`else
    wire _clk = 1'b0;
`endif

    reg _r_D_phi2 /* verilator public */;

    always @(posedge _clk) begin : LOAD_PULSE
    
        if (LD) begin
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
    assign Q_n = ~_r_D_phi1;

endmodule
