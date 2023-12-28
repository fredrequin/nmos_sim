module NMOS_CT
(
    input  C1,
    input  C2,
    input  DI,
    output DO,
    input  LD,
    input  M,
    input  S,
    input  CI,
    output CO,
    output Q,
    output Q_n
);

`ifdef CLK_GEN
    wire _clk = `CLK_GEN.main_clk;
`else
    wire _clk = 1'b0;
`endif

    reg  _r_D_phi1;
    reg  _r_D_phi2;

    always @(posedge _clk) begin : PHI2_PULSE
    
        if (C2) begin
            if (LD) begin
                _r_D_phi2 <= DI;
            end
            else if (M) begin
                _r_D_phi2 <= S;
            end
            else begin
                _r_D_phi2 <= _r_D_phi1 ^ CI;
            end
        end
    end

    always @(posedge _clk) begin : PHI1_PULSE
    
        if (C1) begin
            _r_D_phi1 <= _r_D_phi2;
        end
    end

    assign DO  =  _r_D_phi1;

    assign CO  =  _r_D_phi1 & CI;

    assign Q   =  _r_D_phi1;
    assign Q_n = ~_r_D_phi1;

endmodule
