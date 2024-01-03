module osc_28m
(
    input  wire  main_clk,
    output wire  C28M
);

    reg [2:0] r_x1_ctr;
    
    // 143.181815 MHz -> 28.636363 MHz
    always @ (posedge main_clk) begin : OSC_28MHZ
    
        r_x1_ctr <= (r_x1_ctr[2]) ? 3'd0 : r_x1_ctr + 3'd1;
    end
    
    assign C28M = r_x1_ctr[2];

endmodule
