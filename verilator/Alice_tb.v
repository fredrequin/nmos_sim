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
    // Translated Kicad schematic
    //=========================================================================
    
    wire [15:0] w_data_bus;
    wire  [8:1] w_hor_ctr;
    wire [10:0] w_ver_ctr;

    Alice DUT
    (
        .PAD_NRST      (~main_rst),
        .PAD_C28M      (C28M),
        .PAD_C7M       (/* open */),
        .PAD_CDAC      (/* open */),
        .PAD_CCK       (/* open */),
        .PAD_CCKQ      (/* open */),

        .DB            (w_data_bus),
        .HCTR          (w_hor_ctr),
        .NHCTR         (/* open */),
        .VCTR          (w_ver_ctr),
        .PAD_PRW       (1'b1),
        .PAD_NBLS      (1'b1),
        .PAD_NAS       (1'b1),
        .PAD_NRGEN     (1'b1),
        .PAD_NDBR      (/* open */),
        .PAD_DMAL      (1'b1),
        .PAD_NLP       (1'b1),
        .PAD_NNTSC_PAL (ntscn_pal),
        .PAD_RRW       (/* open */),
        .PAD_RGA       (/* open */),

        .PAD_HSYNC     (/* open */),
        .PAD_VSYNC     (/* open */),
        .PAD_CSYNC     (/* open */)
    );

endmodule
