//CREATED BY CHRIS LALLO
//MODIFIED BY US
module random_number(clk, rst, in, o);
	input clk, rst;
	input [2:0]in;
	output reg [3:0]o;
	reg [31:0]ff;
	
	always @(posedge clk or negedge rst)
	begin
		if (rst == 1'b0)
			ff <= 32'd758932; //arbitrary starting value
		else
			case (in) //has 8 different outputs
				3'b000 : ff <= {ff[30:24], ff[2] ^ ff[23] ^ ff[11],
									ff[22:16], ff[14] ^ ff[20] ^ ff[5],
									ff[14:8], ff[13] ^ ff[19] ^ ff[7],
									ff[6:0], ff[26] ^ ff[3] ^ ff[29]};
									
				3'b001 : ff <= {ff[30:24], ff[4] ^ ff[21] ^ ff[13],
									ff[22:16], ff[16] ^ ff[5] ^ ff[10],
									ff[14:8], ff[26] ^ ff[19] ^ ff[7],
									ff[6:0], ff[3] ^ ff[17] ^ ff[25]};
									
				3'b010 : ff <= {ff[30:24], ff[21] ^ ff[17] ^ ff[4],
									ff[22:16], ff[14] ^ ff[25] ^ ff[8],
									ff[14:8], ff[7] ^ ff[14] ^ ff[15],
									ff[6:0], ff[23] ^ ff[30] ^ ff[22]};
				3'b011 : ff <= {ff[30:24], ff[17] ^ ff[17] ^ ff[4],
									ff[22:16], ff[14] ^ ff[25] ^ ff[8],
									ff[14:8], ff[1] ^ ff[19] ^ ff[12],
									ff[6:0], ff[3] ^ ff[30] ^ ff[22]};
				3'b100: ff <= {ff[30:24], ff[12] ^ ff[17] ^ ff[4],
									ff[22:16], ff[1] ^ ff[25] ^ ff[8],
									ff[14:8], ff[19] ^ ff[19] ^ ff[0],
									ff[6:0], ff[6] ^ ff[12] ^ ff[22]};
				3'b101: ff <= {ff[30:24], ff[19] ^ ff[2] ^ ff[4],
									ff[22:16], ff[24] ^ ff[25] ^ ff[7],
									ff[14:8], ff[11] ^ ff[19] ^ ff[12],
									ff[7:1], ff[4] ^ ff[30] ^ ff[22]};
				3'b110: ff <= {ff[18:12], ff[1] ^ ff[0] ^ ff[4],
									ff[22:16], ff[14] ^ ff[25] ^ ff[8],
									ff[14:8], ff[2] ^ ff[19] ^ ff[1],
									ff[6:0], ff[30] ^ ff[31] ^ ff[22]};
				3'b111: ff <= {ff[12:6], ff[17] ^ ff[27] ^ ff[24],
									ff[23:17], ff[1] ^ ff[5] ^ ff[18],
									ff[14:8], ff[12] ^ ff[29] ^ ff[12],
									ff[6:0], ff[23] ^ ff[30] ^ ff[22]};
									
				default : begin end
			endcase
					
	end
		
		always @(*)
			o = {ff[25], ff[3], ff[19], ff[29]};
endmodule 