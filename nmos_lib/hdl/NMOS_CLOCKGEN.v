module NMOS_CLOCKGEN
(
    input  wire RESET,
    input  wire C28M,

    output reg  C7M,
    output reg  CDAC,
    output wire CCK,
    output wire CCKQ,

    output reg  C1,
    output reg  C1_n,
    output reg  C1R,
    output reg  C1F,

    output reg  C2,
    output reg  C2_n,
    output reg  C2R,
    output reg  C2F,

    output reg  C3,
    output reg  C3_n,
    output reg  C3R,
    output reg  C3F,

    output reg  C4,
    output reg  C4_n,
    output reg  C4R,
    output reg  C4F
);

`ifdef CLK_GEN
    wire _clk = `CLK_GEN.main_clk;
`else
    wire _clk = 1'b0;
`endif

/*
    {head:{
       text: ['tspan', {class:'h3'},'AGNUS clocks generation (from A2000-A schematics)'],
     },
     signal: [
       {name: '28M',            wave: 'pppppppppppppppppppppppppppppppp'},
       {name: '14M (U23A.Q)',   wave: '10101010101010101010101010101010'},
       {name: 'C2 (U24B.Q)',    wave: '1.0...1...0...1...0...1...0...1.'},
       {name: 'C2# (U24B.Q#)',  wave: '0.1...0...1...0...1...0...1...0.'},
       {name: 'C4 (U24A.Q)',    wave: '1...0...1...0...1...0...1...0...'},
       {name: 'C4# (U24A.Q#)',  wave: '0...1...0...1...0...1...0...1...'},
       {name: 'CDAC (U22.Y2)',  wave: '1.0.1.0.1.0.1.0.1.0.1.0.1.0.1.0.'},
       {},
       {name: '14M# (U23A.Q#)', wave: '01010101010101010101010101010101'},
       {name: 'C1 (U25B.Q)',    wave: '10...1...0...1...0...1...0...1..'},
       {name: 'C1# (U25B.Q#)',  wave: '01...0...1...0...1...0...1...0..'},
       {name: 'C3 (U25A.Q)',    wave: '1..0...1...0...1...0...1...0...1'},
       {name: 'C3# (U25A.Q#)',  wave: '0..1...0...1...0...1...0...1...0'},
       {name: '7M (U22.Y1)',    wave: '10.1.0.1.0.1.0.1.0.1.0.1.0.1.0.1'},
     ],
    }
*/

    //=============================================================================
    // Flip-flops for 14 MHz clock and 3.5 MHz clocks (5 LUTS)
    //=============================================================================

    reg       r_clk_14m;
    reg [1:0] r_clko_3m5; // C3, C1 clocks (U25 on A2000-A schematics)
    reg [1:0] r_clke_3m5; // C4, C2 clocks (U24 on A2000-A schematics)
    
    initial begin
        r_clk_14m  = 1'b1;
        r_clko_3m5 = 2'b00;
        r_clke_3m5 = 2'b00;
    end
    
    always @ (posedge _clk) begin : CLOCK_GEN
    
        if (C28M) begin
            // 14 MHz falling edge
            if (r_clk_14m) begin
                // C3 = C1
                r_clko_3m5[1] <= r_clko_3m5[0];
                // C1 = NOT C4
                r_clko_3m5[0] <= ~r_clke_3m5[1];
            end
            // 14 MHz rising edge
            else begin
                // C4 = C2
                r_clke_3m5[1] <= r_clke_3m5[0];
                // C2 = NOT C4
                r_clke_3m5[0] <= ~r_clke_3m5[1];
            end
            // Generate 14 MHz clock
            r_clk_14m <= ~r_clk_14m;
        end
    end

    //=============================================================================
    // C1, C2, C3 & C4 3.5 MHz clocks generation (12 LUTs)
    //=============================================================================

    always @ (posedge _clk) begin : CLOCK_3M5_BUF
    
        // C1 clock
        C1   <=  r_clko_3m5[0];
        C1_n <= ~r_clko_3m5[0];
        C1R  <= (r_clko_3m5 == 2'b00) ? C28M &  r_clk_14m : 1'b0;
        C1F  <= (r_clko_3m5 == 2'b11) ? C28M &  r_clk_14m : 1'b0;
        // C2 clock
        C2   <=  r_clke_3m5[0];
        C2_n <= ~r_clke_3m5[0];
        C2R  <= (r_clke_3m5 == 2'b00) ? C28M & ~r_clk_14m : 1'b0;
        C2F  <= (r_clke_3m5 == 2'b11) ? C28M & ~r_clk_14m : 1'b0;
        // C3 clock
        C3   <=  r_clko_3m5[1];
        C3_n <= ~r_clko_3m5[1];
        C3R  <= (r_clko_3m5 == 2'b01) ? C28M &  r_clk_14m : 1'b0;
        C3F  <= (r_clko_3m5 == 2'b10) ? C28M &  r_clk_14m : 1'b0;
        // C4 clock
        C4   <=  r_clke_3m5[1];
        C4_n <= ~r_clke_3m5[1];
        C4R  <= (r_clke_3m5 == 2'b01) ? C28M & ~r_clk_14m : 1'b0;
        C4F  <= (r_clke_3m5 == 2'b10) ? C28M & ~r_clk_14m : 1'b0;
    end
    
    assign CCK  = C1;
    assign CCKQ = C3;

    //=============================================================================
    // C7M & CDAC 7.0 MHz clocks generation (6 LUTs)
    //=============================================================================

    always @ (posedge _clk) begin : CLOCK_7M0_BUF
    
        // C7M clock : NOT (C1 XOR C3)
        C7M   <= (r_clko_3m5[0] == r_clko_3m5[1]) ? 1'b1 : 1'b0;
        //C7MR  <= (r_clko_3m5[0] != r_clko_3m5[1]) ? C28M &  r_clk_14m : 1'b0;
        //C7MF  <= (r_clko_3m5[0] == r_clko_3m5[1]) ? C28M &  r_clk_14m : 1'b0;
        // CDAC# clock : C2 XOR C4
        CDAC  <= (r_clke_3m5[0] != r_clke_3m5[1]) ? 1'b1 : 1'b0;
        //CDACR <= (r_clke_3m5[0] == r_clke_3m5[1]) ? C28M & ~r_clk_14m : 1'b0;
        //CDACF <= (r_clke_3m5[0] != r_clke_3m5[1]) ? C28M & ~r_clk_14m : 1'b0;
    end

endmodule
