//module used to give out the current position of each car and log
//psuedo random starting positions and movement are included
//this feeds positions into the rectanglt module to be displayed in the top level module
//written by jacob gardner and lucian pfister

module CarLocationAndMovement(clk, rst, odd, firstOrSecond, yPos, outX, outY, speed, move);
 
//inputs and outputs
input clk, rst, firstOrSecond;
//first or second tells us what number car this is in a particular lane. 
//0 = second car
//1 = first car, should be more left
input [7:0] yPos;
output [8:0] outX;
output [7:0]outY;
output reg move; //output telling when this is moving
input odd; //used to move every other car. ideally reduces chances of unwinnable level
output reg [8:0] speed;
assign outY = yPos;
assign outX = CurrentX;

//current x position
reg [8:0] CurrentX;
//counter for slower clock
reg [31:0] counter;
reg slowClock;
reg reset;

reg [2:0] S;
reg [2:0] NS;
parameter START = 3'd0,
CHECK = 3'd1,
INC = 3'd2,//move the object
EXIT = 3'd4, //DONE
RESETX = 3'd5, //puts x back to default position for cars moving right
SETXRIGHT = 3'd6, //put in default position for cars moving left
ERROR = 3'hF;

wire [3:0] rand_num1; //the outputs of first instantiation of the random number generator
wire [3:0] rand_num2;//the outputs of second instantiation of the random number generator
reg [3:0] increment; //random number1
reg[3:0] increment2; //random number2

random_number rand1(clk,reset, {yPos[7], yPos[6], yPos[3]}, rand_num1);
random_number rand2(clk,reset, {yPos[6], yPos[4], yPos[3]}, rand_num2);

always@(posedge clk)
begin
			counter <= counter + 1'b1;
			if (counter >= 32'd2000000) //counter up to 2 million clock cycles, used throughout module
			begin
				counter <= 32'd0;	
				slowClock = 1'b1;
			end
			else
				slowClock = 1'b0;
end	

always @(posedge clk or negedge rst)
begin
	if (rst == 1'b0)
		S <= START;
	else if (slowClock == 1'b1)
		S <= NS;	
end


always @(*)
begin
	case (S)
		START: NS <= CHECK;
		CHECK: begin
			if(CurrentX >= 9'd320 && CurrentX < 400) //this checks if it is off the right side of the screen. its weird because of verilog's use of <,> on negative numbers
				NS <= RESETX;
			else if (CurrentX > 450 || CurrentX <= 4) //big values are because > and < dont work with negatives
				NS <= SETXRIGHT;
			else
				NS <= INC;
		end
		INC: NS <= CHECK;
		RESETX: NS <= CHECK;
		SETXRIGHT: NS <= CHECK;
		default NS <= ERROR;
	endcase
end

always @(posedge clk)
begin
	if ((slowClock == 1'b1))
	begin
		case (S)
			START:begin 
			reset = 1'b1;
			increment = rand_num1 + rand_num2; 
			increment2 = (rand_num1 + rand_num2 + rand_num1) % 6 + 1;
			if (firstOrSecond == 1)
			CurrentX = (increment * 800 + 9) % 60 *(increment % 2 + 1) + 4; //get pseudo random starting value
			else 
			CurrentX = 150 + (increment * 333 + 3) % 70; //get pseudo random starting value. will be on right side of screen
			end
			INC:
			begin
			move = 1'b1; //say its moving
			if (increment %2 == 1) //this is used to pick what cars move in each direction
			begin
				CurrentX = CurrentX + ((increment * increment2 * (increment +1) % 7) + 2)  + (yPos % 15 ==0); //moves the object by the pseudo random distance
				end
			else 
			begin
				CurrentX = CurrentX - ((increment * increment2 * (increment +1) % 7) + 2)  - (yPos % 15 ==0); // moves in negative direction by pseudo ranodom distance
				end
			end
			CHECK: move = 1'b0; //turn off move
			RESETX: begin
			move = 1'b1;
			CurrentX = 5; //reset things that have gone too far right
			end
			SETXRIGHT: begin
			move=  1'b1;
			CurrentX = 9'd305; //reset things that have gone too far left
			end
		endcase
	end
end


//this always block spits out the speed faster than it would with our slow clock in the other blocks
//important for finding unwinnable levels
always@(*)
begin
if (increment %2 == 1) 
				speed = ((increment * increment2 * (increment +1) % 7) + 2) + (yPos % 15 ==0);
			else 
				speed = -1 * ((increment * increment2 * (increment +1) % 7) + 2) - (yPos % 15 ==0);
end


endmodule