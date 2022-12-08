module three_decimal_vals_w_neg (
input [7:0]val,
output [6:0]seg7_lsb,
output [6:0]seg7_midsb,
output [6:0]seg7_msb
);
reg [3:0] result_one_digit;
reg [3:0] result_ten_digit;
reg [3:0] result_hundred_digit;

reg [7:0]twos_comp;

/* convert the binary value into 3 signals of negative, one and ten digit */
always@(*)
begin
if (val[7] ==1'b1)
begin
 twos_comp = val * -1;
 end
 else 
 begin
 twos_comp = val;
end
begin
	  result_one_digit = twos_comp % 10;
	  result_ten_digit = (twos_comp % 100) / 10;
	  result_hundred_digit = twos_comp / 100;
end
end

/* instantiate the modules for each of the seven seg decoders including the negative one */
seven_segment one(result_one_digit, seg7_lsb);
seven_segment ten(result_ten_digit, seg7_midsb);
seven_segment hundred(result_hundred_digit, seg7_msb);

endmodule