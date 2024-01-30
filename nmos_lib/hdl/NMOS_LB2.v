module NMOS_LB2
(
    input  C1,  // PHI1 clock
    input  C2,  // PHI2 clock
    input  DA,  // Data input #1
    input  LA,  // Load input #1
    input  DB,  // Data input #2
    input  LB,  // Load input #2
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
    
        if (LA | LB) begin
            _r_D_phi2 <= DA & LA | DB & LB;
        end
        else if (C2) begin
            _r_D_phi2 <= _r_D_phi1;
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
