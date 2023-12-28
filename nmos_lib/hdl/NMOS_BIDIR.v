module NMOS_BIDIR
(
    input  OE_n, // Output enable
    input  I,    // Input
    output O,    // Output
    inout  IO    // Bidir
);

    assign IO = (OE_n) ? 1'bZ : I;
    assign O  = IO;

endmodule
