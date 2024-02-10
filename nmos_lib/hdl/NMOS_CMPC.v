module NMOS_CMPC
(
    input   DB, // Data bus
    input   VV, // Beamcounter value
    input   LQ, // Load pos/addr (IR1)
    input   LM, // Load mask (IR2)
    input   C1, // PHI1 clock
    input   CI, // Carry in
    output  CO  // Carry out
);

`ifdef CLK_GEN
    wire _clk = `CLK_GEN.main_clk;
`else
    wire _clk = 1'b0;
`endif

    reg  _r_Q_phi2 /* verilator public */;
    reg  _r_M_phi2 /* verilator public */;

    always @(posedge _clk) begin : LOAD_PULSE
    
        if (LQ) begin
            _r_Q_phi2 <= DB;
        end
        if (LM) begin
            _r_M_phi2 <= DB;
        end
    end

    reg _r_A_phi1;
    reg _r_B_phi1;

    always @(posedge _clk) begin : PHI1_PULSE
    
        if (C1) begin
            _r_A_phi1 <= VV;
            _r_B_phi1 <= (_r_M_phi2) ? _r_Q_phi2 : VV;
        end
    end
    
    reg _r_CO_phi1;

    always @(*) begin : SUBTRACTOR
        case ({ _r_A_phi1, _r_B_phi1, CI })
            3'b000 : _r_CO_phi1 = 1'b0;
            3'b001 : _r_CO_phi1 = 1'b1;
            3'b010 : _r_CO_phi1 = 1'b1;
            3'b011 : _r_CO_phi1 = 1'b1;
            3'b100 : _r_CO_phi1 = 1'b0;
            3'b101 : _r_CO_phi1 = 1'b0;
            3'b110 : _r_CO_phi1 = 1'b0;
            3'b111 : _r_CO_phi1 = 1'b1;
        endcase
    end
    
    assign CO = _r_CO_phi1;

endmodule
