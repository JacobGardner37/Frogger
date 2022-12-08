module seven_segment_negative(i,o);

input i;
output reg [6:0]o; // a, b, c, d, e, f, g

always @(*)
begin
	case(i)
	1'd1: o = 7'b1111110;
	default: o = 7'b1111111;
endcase
end
endmodule