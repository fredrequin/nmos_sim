module Alice_clk_gen
(
    // Master clock (85.125480 MHz / 85.909089 MHz)
    input  wire       main_clk,
    // 28.375160 MHz / 28.636363 MHz AGNUS clock
    input  wire       ena_28m,
    // 3.546895 MHz / 3.579545 MHz Chip RAM clocks
    output reg  [2:0] C1,
    output reg  [2:0] C2,
    output reg  [2:0] C3,
    output reg  [2:0] C4,
    // 7.093790 MHz / 7.159090 MHz CPU clock
    output reg  [2:0] C7M,
    // 7.093790 MHz / 7.159090 MHz Color DAC clock
    output reg  [2:0] CDAC
);

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
    
    always @ (posedge main_clk) begin : CLOCK_GEN
    
        if (ena_28m) begin
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

    always @ (posedge main_clk) begin : CLOCK_3M5_BUF
    
        // C1 clock
        C1[0] <= r_clko_3m5[0];
        C1[1] <= (r_clko_3m5 == 2'b00) ? ena_28m &  r_clk_14m : 1'b0;
        C1[2] <= (r_clko_3m5 == 2'b11) ? ena_28m &  r_clk_14m : 1'b0;
        // C2 clock
        C2[0] <= r_clke_3m5[0];
        C2[1] <= (r_clke_3m5 == 2'b00) ? ena_28m & ~r_clk_14m : 1'b0;
        C2[2] <= (r_clke_3m5 == 2'b11) ? ena_28m & ~r_clk_14m : 1'b0;
        // C3 clock
        C3[0] <= r_clko_3m5[1];
        C3[1] <= (r_clko_3m5 == 2'b01) ? ena_28m &  r_clk_14m : 1'b0;
        C3[2] <= (r_clko_3m5 == 2'b10) ? ena_28m &  r_clk_14m : 1'b0;
        // C4 clock
        C4[0] <= r_clke_3m5[1];
        C4[1] <= (r_clke_3m5 == 2'b01) ? ena_28m & ~r_clk_14m : 1'b0;
        C4[2] <= (r_clke_3m5 == 2'b10) ? ena_28m & ~r_clk_14m : 1'b0;
    end

    //=============================================================================
    // C7M & CDAC 7.0 MHz clocks generation (6 LUTs)
    //=============================================================================

    always @ (posedge main_clk) begin : CLOCK_7M0_BUF
    
        // C7M clock : NOT (C1 XOR C3)
        C7M[0]  <= (r_clko_3m5[0] == r_clko_3m5[1]) ?                 1'b1 : 1'b0;
        C7M[1]  <= (r_clko_3m5[0] != r_clko_3m5[1]) ? ena_28m &  r_clk_14m : 1'b0;
        C7M[2]  <= (r_clko_3m5[0] == r_clko_3m5[1]) ? ena_28m &  r_clk_14m : 1'b0;
        // CDAC# clock : C2 XOR C4
        CDAC[0] <= (r_clke_3m5[0] != r_clke_3m5[1]) ?                 1'b1 : 1'b0;
        CDAC[1] <= (r_clke_3m5[0] == r_clke_3m5[1]) ? ena_28m & ~r_clk_14m : 1'b0;
        CDAC[2] <= (r_clke_3m5[0] != r_clke_3m5[1]) ? ena_28m & ~r_clk_14m : 1'b0;
    end

endmodule
