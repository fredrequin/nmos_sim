module Alice_tb
(
    input wire main_rst,
    input wire main_clk,
    input wire ntscn_pal
);

    wire C28M;

    osc_28m X1
    (
        .main_clk (main_clk),
        .C28M     (C28M)
    );

    //=========================================================================
    // Clocks generation
    //=========================================================================

    wire  [2:0] C1, C2, C3, C4;
    wire  [2:0] CCK, CCKQ, C7M, CDAC;
    
    Alice_clk_gen U_clk_gen
    (
        .main_clk (main_clk),
        .ena_28m  (C28M),
        // 3.546895 MHz / 3.579545 clocks
        .C1       (C1),
        .C2       (C2),
        .C3       (C3),
        .C4       (C4),
        // 7.093790 MHz / 7.159090 MHz clocks
        .C7M      (C7M),
        .CDAC     (CDAC)
    );
 
    assign CCK    = C1;
    assign CCKQ   = C3;
    
    wire w_C1_rise = C1[1];
    wire w_C1_fall = C1[2];

    wire w_C2_rise = C2[1];
    wire w_C2_fall = C2[2];

    wire w_C3_rise = C3[1];
    wire w_C3_fall = C3[2];

    wire w_C4_rise = C4[1];
    wire w_C4_fall = C4[2];

    //=========================================================================
    // Translated Kicad schematic
    //=========================================================================
    
    wire [15:0] w_data_bus;
    wire  [8:1] w_hor_ctr;
    wire [10:0] w_ver_ctr;

    Alice DUT
    (
        .RESET     (main_rst),
        .PHI1      (w_C3_rise),
        .PHI2      (w_C1_rise),
        .CCKR      (w_C1_rise),
        .CCKF      (w_C1_fall),

        .DB        (w_data_bus),
        .HCTR      (w_hor_ctr),
        .VCTR      (w_ver_ctr),
        .LPEN      (1'b1),
        .NTSCN_PAL (ntscn_pal),

        .HSYNC     (/* open */),
        .VSYNC     (/* open */),
        .CSYNC     (/* open */)
    );

endmodule
