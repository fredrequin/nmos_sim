module NMOS_DEMUX8
(
    input  A,
    input  S0,
    input  S1,
    input  S2,
    output B0,
    output B1,
    output B2,
    output B3,
    output B4,
    output B5,
    output B6,
    output B7
);

reg [7:0] _r_B;

always @(*) begin
    if (A) begin
        case ({S2, S1, S0})
            3'b000 : _r_B = 8'b00000001;
            3'b001 : _r_B = 8'b00000010;
            3'b010 : _r_B = 8'b00000100;
            3'b011 : _r_B = 8'b00001000;
            3'b100 : _r_B = 8'b00010000;
            3'b101 : _r_B = 8'b00100000;
            3'b110 : _r_B = 8'b01000000;
            3'b111 : _r_B = 8'b10000000;
        endcase
    end
    else begin
        _r_B = 8'b00000000;
    end
end

assign B0 = _r_B[0];
assign B1 = _r_B[1];
assign B2 = _r_B[2];
assign B3 = _r_B[3];
assign B4 = _r_B[4];
assign B5 = _r_B[5];
assign B6 = _r_B[6];
assign B7 = _r_B[7];

endmodule
