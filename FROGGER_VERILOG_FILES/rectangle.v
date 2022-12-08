//Given a starting x and y position, it will send out the x and y values of every pixel within a rectangle of specified length and width
//useful in drawing a background and each object you want to display
//Written by jacob gardner and lucian pfister
module rectangle(clock,rst,colour,x, y, L, W, plot, newX, newY, Color);
input clock,rst;
input [8:0]x;
input [7:0]y;
input [2:0]colour;
input plot; //say if you want to display this rectangle
input [8:0] L; // The length of the rectangle you want to create (X direction)
input [7:0] W; // The width of the rectangle you're creating (Y direction)

output reg [8:0] newX; // the x value to output
output reg [7:0] newY; // the y value to output
output[2:0] Color;
assign Color = colour;

reg [2:0] S;
reg [2:0] NS;
reg [8:0] i; //counts the current x value over from the default position
parameter START = 3'd0,
FCOND = 3'd1,
XINC = 3'd2,
YINC = 3'd5,
FINC = 3'd3,
EXIT = 3'd4,
ERROR = 3'hF;

always @(posedge clock or negedge rst)
begin
	if (rst == 1'b0) 
		S <= START;
	else
		S <= NS;
end

always @(*)
begin
	case (S)
		START: NS <= FCOND;
		FCOND: begin
			if(i < L && newY <= (y + W)) // keep going to xinc as long as we're not at the end of a line, or the bottom corner of rectangle
				NS <= XINC;
			else if (i == L && newY != (y + W)) // go to yinc as long as we're at the end of a line and not at the bottom of rectangle
				NS <= YINC;
			else 
				NS <= EXIT;
		end
		FINC: NS <= FCOND;
		XINC: NS <= FINC;
		YINC: NS <= FCOND;
		default NS <= ERROR;
			
	endcase	
end

always @(posedge clock)
begin
		case (S)
			START:begin
			//set everything to default values
			newX = x; 
			newY = y;
			i <= 9'd0;
			end
			XINC:newX <= newX + 1'b1; // add 1 to x
			YINC: begin
			newY = newY + 1'b1; // add 1 to y
			newX <= x;  //reset x to default value
			i <= 9'd0; // reset counter
			end
			FINC: i <= i + 1'd1; //add 1 to counter
		endcase
end
endmodule