//Top level module for frogger game
//written by jacob gardner and lucian pfister
//uses VGA modules and random number generator modules gottten from Chris Lallo
//Keyboard module from Montvydas Klumbys


module display(resetn,
			clock,
			PS2CLK, 
			PS2DATA,
			/* Signals for the DAC to drive the monitor. */
			VGA_R,
			VGA_G,
			VGA_B,
			VGA_HS,
			VGA_VS,
			VGA_BLANK,
			VGA_SYNC,
			VGA_CLK, 
			seg7_dig0,
			seg7_dig1,
			seg7_dig2);
			
three_decimal_vals_w_neg two_d(score, seg7_dig0, seg7_dig1, seg7_dig2);
	//INPUT AND OUTPUTS OF DISPLAY MODULE
	input clock, resetn, PS2DATA, PS2CLK; 
	reg [8:0]x;
	reg [7:0]y;
	wire [2:0]colour;
	reg plot;
	reg rst;
	reg [2:0] Color;
	output [9:0] VGA_R;
	output [9:0] VGA_G;
	output [9:0] VGA_B;
	output VGA_HS;
	output VGA_VS;
	output VGA_BLANK;
	output VGA_SYNC;
	output VGA_CLK;
	output [6:0]seg7_dig0;
	output [6:0]seg7_dig1;
	output [6:0]seg7_dig2;
	reg [7:0] score; // the score of the current game. incremented by 1 when the frog reaches the end of a level
	
	//reset signal sent to CarlocationAndMovement modules
	reg carRst;
	
	
	parameter CARLENGTH = 9'd25; //the number of pixels wide each car is
	parameter CARHEIGHT = 8'd19; // the number of pixels tall each car and log is
	parameter FROGLENGTH = 9'd10; // the number of pixels long the frog is
	parameter FROGHEIGHT = 8'd14;// the number of pixels tall the frog is
	parameter LOGLENGTH = 9'd45; // the number of pixels long the logs are
	
	//X,Y, COLORS OF CARS + FROG + LOGS coming from rectangle module
	
	wire [8:0] backgroundX;
	wire [7:0] backgroundY;
	wire [2:0] backgroundColor;
	
	wire [8:0] endGameX;
	wire [7:0] endGameY;
	wire [2:0] endGameColor;
	
	wire [8:0] frogX;
	wire [7:0] frogY;
	wire [2:0] frogColor;

	
	wire [8:0] car1X;
	wire [7:0] car1Y;
	wire [2:0] car1Color;
	
	wire [8:0] car2X;
	wire [7:0] car2Y;
	wire [2:0] car2Color;
	
	wire [8:0] car3X;
	wire [7:0] car3Y;
	wire [2:0] car3Color;
	
	wire [8:0] car4X;
	wire [7:0] car4Y;
	wire [2:0] car4Color;
	
	wire [8:0] car5X;
	wire [7:0] car5Y;
	wire [2:0] car5Color;
	
	wire [8:0] car6X;
	wire [7:0] car6Y;
	wire [2:0] car6Color;
	
	wire [8:0] car7X;
	wire [7:0] car7Y;
	wire [2:0] car7Color;
	
	wire [8:0] car8X;
	wire [7:0] car8Y;
	wire [2:0] car8Color;
	
	wire [8:0] car9X;
	wire [7:0] car9Y;
	wire [2:0] car9Color;
	
	wire [8:0] car10X;
	wire [7:0] car10Y;
	wire [2:0] car10Color;
	
	//X,Y, COLOR OF EACH LOG coming from rectangle modules
	wire [8:0] log1X;
	wire [7:0] log1Y;
	wire [2:0] log1Color;
	
	wire [8:0] log2X;
	wire [7:0] log2Y;
	wire [2:0] log2Color;
	
	wire [8:0] log3X;
	wire [7:0] log3Y;
	wire [2:0] log3Color;
	
	wire [8:0] log4X;
	wire [7:0] log4Y;
	wire [2:0] log4Color;
	
	wire [8:0] log5X;
	wire [7:0] log5Y;
	wire [2:0] log5Color;
	
	wire [8:0] log6X;
	wire [7:0] log6Y;
	wire [2:0] log6Color;
	
	wire [8:0] log7X;
	wire [7:0] log7Y;
	wire [2:0] log7Color;
	
	wire [8:0] log8X;
	wire [7:0] log8Y;
	wire [2:0] log8Color;
	
	wire [8:0] log9X;
	wire [7:0] log9Y;
	wire [2:0] log9Color;
	
	wire [8:0] log10X;
	wire [7:0] log10Y;
	wire [2:0] log10Color;
	
	//inputs to Location + Movement of each coming from the movement modules
	
	wire[8:0] froggyX;
	wire[7:0] froggyY;
	
	wire[8:0] car1Xin;
	wire[7:0] car1Yin;
	
	wire[8:0] car2Xin;
	wire[7:0] car2Yin;
	
	wire[8:0] car3Xin;
	wire[7:0] car3Yin;
	
	wire[8:0] car4Xin;
	wire[7:0] car4Yin;
	
	wire[8:0] car5Xin;
	wire[7:0] car5Yin;
	
	wire[8:0] car6Xin;
	wire[7:0] car6Yin;
	
	wire[8:0] car7Xin;
	wire[7:0] car7Yin;
	
	wire[8:0] car8Xin;
	wire[7:0] car8Yin;
	
	wire[8:0] car9Xin;
	wire[7:0] car9Yin;
	
	wire[8:0] car10Xin;
	wire[7:0] car10Yin;
	
	//inputs to location + movement of logs coming as outputs of CarlocationAndMovement modules
	wire[8:0] log1Xin;
	wire[7:0] log1Yin;
	
	wire[8:0] log2Xin;
	wire[7:0] log2Yin;
	
	wire[8:0] log3Xin;
	wire[7:0] log3Yin;
	
	wire[8:0] log4Xin;
	wire[7:0] log4Yin;
	
	wire[8:0] log5Xin;
	wire[7:0] log5Yin;
	
	wire[8:0] log6Xin;
	wire[7:0] log6Yin;
	
	wire[8:0] log7Xin;
	wire[7:0] log7Yin;
	
	wire[8:0] log8Xin;
	wire[7:0] log8Yin;
	
	
	//frogLogX keeps track of how far total the frog has moved on all logs
	reg [8:0] frogLogX;
	
	//froggyXPlusLogX keeps track of the frog's x position plus the distance moved on all logs
	wire [8:0] froggyXPlusLogX;
	assign froggyXPlusLogX = (froggyX + frogLogX);
	initial frogLogX = 0; // start is as 0
	
	//the speeds of each log, coming from the CarLocationAndMovement modules
	wire [8:0] log1Speed;
	wire [8:0] log2Speed;
	wire [8:0] log3Speed;
	wire [8:0] log4Speed;
	wire [8:0] log5Speed;
	wire [8:0] log6Speed;
	wire [8:0] log7Speed;
	wire [8:0] log8Speed;
	
	//Timers tell when the logs move
	wire moveTimer;
	wire moveTimer2;

	//colors and location of the background drawn at a win
	wire[8:0] winX;
	wire[7:0] winY;
	wire[3:0] winColor;
	

	
	reg [63:0] delayCounter; // used in counting time to display win and loss screens
	reg VGA_en; // tells VGA modules when to draw something
	reg Drawrst; // reset signal sent to rectangle modules
	
vga_adapter myVGA(resetn, clock, Color, x, y, VGA_en, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_CLK);

rectangle background(clock, Drawrst, 3'b111, 9'd0, 8'd0, 9'd320, 8'd241, 1'd1, backgroundX, backgroundY, backgroundColor);
rectangle win(clock, Drawrst, 3'b010, 9'd0, 8'd0, 9'd320, 8'd241, 1'd1, winX, winY, winColor);
rectangle endGame(clock, Drawrst, 3'b100, 9'd0, 8'd0, 9'd320, 8'd241, 1'd1, endGameX, endGameY, endGameColor);


//LOOPS THROUGH X AND Y POSITIONS OF EACH CAR
rectangle car1(clock,Drawrst, 3'b100, car1Xin, car1Yin, CARLENGTH, CARHEIGHT, 1'd1, car1X, car1Y, car1Color);
rectangle car2(clock,Drawrst, 3'b100, car2Xin, car2Yin, CARLENGTH, CARHEIGHT, 1'd1, car2X, car2Y, car2Color);
rectangle car3(clock,Drawrst, 3'b100, car3Xin, car3Yin, CARLENGTH, CARHEIGHT, 1'd1, car3X, car3Y, car3Color);
rectangle car4(clock,Drawrst, 3'b100, car4Xin, car4Yin, CARLENGTH, CARHEIGHT, 1'd1, car4X, car4Y, car4Color);
rectangle car5(clock,Drawrst, 3'b100, car5Xin, car5Yin, CARLENGTH, CARHEIGHT, 1'd1, car5X, car5Y, car5Color);
rectangle car6(clock,Drawrst, 3'b100, car6Xin, car6Yin, CARLENGTH, CARHEIGHT, 1'd1, car6X, car6Y, car6Color);
rectangle car7(clock,Drawrst, 3'b100, car7Xin, car7Yin, CARLENGTH, CARHEIGHT, 1'd1, car7X, car7Y, car7Color);
rectangle car8(clock,Drawrst, 3'b100, car8Xin, car8Yin, CARLENGTH, CARHEIGHT, 1'd1, car8X, car8Y, car8Color);
rectangle car9(clock,Drawrst, 3'b100, car9Xin, car9Yin, CARLENGTH, CARHEIGHT, 1'd1, car9X, car9Y, car9Color);
rectangle car10(clock,Drawrst, 3'b100, car10Xin, car10Yin, CARLENGTH, CARHEIGHT, 1'd1, car10X, car10Y, car10Color);

//LOOPS THROUGH X AND Y POSITIONS OF EACH LOG
rectangle log1(clock,Drawrst, 3'b000, log1Xin, log1Yin, LOGLENGTH, CARHEIGHT, 1'd1, log1X, log1Y, log1Color);
rectangle log2(clock,Drawrst, 3'b000, log2Xin, log2Yin, LOGLENGTH, CARHEIGHT, 1'd1, log2X, log2Y, log2Color);
rectangle log3(clock,Drawrst, 3'b000, log3Xin, log3Yin, LOGLENGTH, CARHEIGHT, 1'd1, log3X, log3Y, log3Color);
rectangle log4(clock,Drawrst, 3'd000, log4Xin, log4Yin, LOGLENGTH, CARHEIGHT, 1'd1, log4X, log4Y, log4Color);
rectangle log5(clock,Drawrst, 3'b000, log5Xin, log5Yin, LOGLENGTH, CARHEIGHT, 1'd1, log5X, log5Y, log5Color);
rectangle log6(clock,Drawrst, 3'b000, log6Xin, log6Yin, LOGLENGTH, CARHEIGHT, 1'd1, log6X, log6Y, log6Color);
rectangle log7(clock,Drawrst, 3'b000, log7Xin, log7Yin, LOGLENGTH, CARHEIGHT, 1'd1, log7X, log7Y, log7Color);
rectangle log8(clock,Drawrst, 3'b000, log8Xin, log8Yin, LOGLENGTH, CARHEIGHT, 1'd1, log8X, log8Y, log8Color);

rectangle frog(clock, Drawrst, 3'b010,froggyXPlusLogX, froggyY, FROGLENGTH, FROGHEIGHT, 1'd1, frogX, frogY, frogColor); //sends to VGA_ADAPTER
frogMovement myFrog(clock, rst, PS2CLK, PS2DATA, frogLogX, froggyX, froggyY); //gets nums to send to rectangle frog

//OUTPUTS CARS LOCATIONS DOES MOVEMENT
CarLocationAndMovement car1Location(clock, carRst, 1, 1'b1, 8'd120, car1Xin, car1Yin);
CarLocationAndMovement car2Location(clock, carRst, 0, 1'b1, 8'd140, car2Xin, car2Yin);
CarLocationAndMovement car3Location(clock, carRst, 1, 1'b1, 8'd160, car3Xin, car3Yin);
CarLocationAndMovement car4Location(clock, carRst, 0, 1'b1, 8'd180, car4Xin, car4Yin);
CarLocationAndMovement car5Location(clock, carRst, 1, 1'b1, 8'd200, car5Xin, car5Yin);
CarLocationAndMovement car6Location(clock, carRst, 1, 1'b0, 8'd120, car6Xin, car6Yin);
CarLocationAndMovement car7Location(clock, carRst, 0, 1'b0, 8'd140, car7Xin, car7Yin);
CarLocationAndMovement car8Location(clock, carRst, 1, 1'b0, 8'd160, car8Xin, car8Yin);
CarLocationAndMovement car9Location(clock, carRst, 0, 1'b0, 8'd180, car9Xin, car9Yin);
CarLocationAndMovement car10Location(clock, carRst, 1, 1'b0, 8'd200, car10Xin, car10Yin);

//outputs and locations of logs
CarLocationAndMovement log1Location(clock, carRst, 1, 1'b1, 8'd20, log1Xin, log1Yin, log1Speed);
CarLocationAndMovement log2Location(clock, carRst, 0, 1'b1, 8'd40, log2Xin, log2Yin, log2Speed);
CarLocationAndMovement log3Location(clock, carRst, 1, 1'b1, 8'd60, log3Xin, log3Yin, log3Speed);
CarLocationAndMovement log4Location(clock, carRst, 0, 1'b1, 8'd80, log4Xin, log4Yin, log4Speed, moveTimer);
CarLocationAndMovement log5Location(clock, carRst, 1, 1'b0, 8'd20, log5Xin, log5Yin, log5Speed);
CarLocationAndMovement log6Location(clock, carRst, 0, 1'b0, 8'd40, log6Xin, log6Yin, log6Speed);
CarLocationAndMovement log7Location(clock, carRst, 1, 1'b0, 8'd60, log7Xin, log7Yin, log7Speed);
CarLocationAndMovement log8Location(clock, carRst, 0, 1'b0, 8'd80, log8Xin, log8Yin, log8Speed, moveTimer2);



//TELLS BACKGROUND WHERE NOT TO DRAW AKA AT THE CARS AND FROG
always@(*) begin
if (S == WIN || S == END || ((log1Speed == log2Speed || log2Speed == log3Speed || log3Speed == log4Speed))) // in these states, always draw the background
VGA_en = 1'b1;
//this else if tells it not to draw the background over the frog, cars, or logs
else if (backgroundX >= froggyXPlusLogX && backgroundX <=(froggyXPlusLogX + 11) && backgroundY >= froggyY && backgroundY <= (froggyY + 12) ||
backgroundX >= car1Xin && backgroundX <=(car1Xin + CARLENGTH + 1) && backgroundY >= car1Yin && backgroundY <= (car1Yin + CARHEIGHT -2) ||
backgroundX >= car2Xin && backgroundX <=(car2Xin + CARLENGTH + 1) && backgroundY >= car2Yin && backgroundY <= (car2Yin + CARHEIGHT -2) ||
backgroundX >= car3Xin && backgroundX <=(car3Xin + CARLENGTH + 1) && backgroundY >= car3Yin && backgroundY <= (car3Yin + CARHEIGHT -2) ||
backgroundX >= car4Xin && backgroundX <=(car4Xin + CARLENGTH + 1) && backgroundY >= car4Yin && backgroundY <= (car4Yin + CARHEIGHT -2) ||
backgroundX >= car5Xin && backgroundX <=(car5Xin + CARLENGTH + 1) && backgroundY >= car5Yin && backgroundY <= (car5Yin + CARHEIGHT -2) ||
backgroundX >= car6Xin && backgroundX <=(car6Xin + CARLENGTH + 1) && backgroundY >= car6Yin && backgroundY <= (car6Yin + CARHEIGHT -2) ||
backgroundX >= car7Xin && backgroundX <=(car7Xin + CARLENGTH + 1) && backgroundY >= car7Yin && backgroundY <= (car7Yin + CARHEIGHT -2) ||
backgroundX >= car8Xin && backgroundX <=(car8Xin + CARLENGTH + 1) && backgroundY >= car8Yin && backgroundY <= (car8Yin + CARHEIGHT -2) ||
backgroundX >= car9Xin && backgroundX <=(car9Xin + CARLENGTH + 1) && backgroundY >= car9Yin && backgroundY <= (car9Yin + CARHEIGHT -2) ||
backgroundX >= car10Xin && backgroundX <=(car10Xin + CARLENGTH + 1) && backgroundY >= car10Yin && backgroundY <= (car10Yin + CARHEIGHT -2)  || 
backgroundX >= log1Xin && backgroundX <=(log1Xin + LOGLENGTH + 1) && backgroundY >= log1Yin && backgroundY <= (log1Yin + CARHEIGHT -2) || 
backgroundX >= log2Xin && backgroundX <=(log2Xin + LOGLENGTH + 1) && backgroundY >= log2Yin && backgroundY <= (log2Yin + CARHEIGHT -2) || 
backgroundX >= log3Xin && backgroundX <=(log3Xin + LOGLENGTH + 1) && backgroundY >= log3Yin && backgroundY <= (log3Yin + CARHEIGHT -2) ||
backgroundX >= log4Xin && backgroundX <=(log4Xin + LOGLENGTH + 1) && backgroundY >= log4Yin && backgroundY <= (log4Yin + CARHEIGHT -2) ||
backgroundX >= log5Xin && backgroundX <=(log5Xin + LOGLENGTH + 1) && backgroundY >= log5Yin && backgroundY <= (log5Yin + CARHEIGHT -2) ||
backgroundX >= log6Xin && backgroundX <=(log6Xin + LOGLENGTH + 1) && backgroundY >= log6Yin && backgroundY <= (log6Yin + CARHEIGHT -2) ||
backgroundX >= log7Xin && backgroundX <=(log7Xin + LOGLENGTH + 1) && backgroundY >= log7Yin && backgroundY <= (log7Yin + CARHEIGHT -2) || 
backgroundX >= log8Xin && backgroundX <=(log8Xin + LOGLENGTH + 1) && backgroundY >= log8Yin && backgroundY <= (log8Yin + CARHEIGHT -2)  
)
VGA_en = 1'b0;
else 
VGA_en = 1'b1;
end

reg [8:0] S;
reg [8:0] NS;
parameter START = 9'd0,
FROG = 9'd1,
CAR1 = 9'd2,
CAR2 = 9'd3,
CAR3 = 9'd4,
CAR4 = 9'd5,
CAR5 = 9'd6,
CAR6 = 9'd7,
CAR7 = 9'd8,
CAR8 = 9'd9,
CAR9 = 9'd10,
CAR10 = 9'd11,
BUFFER1 = 9'd12,
BUFFER2 = 9'd13,
BUFFER3 = 9'd14,
BACKGROUND = 9'd15,
BUFFER0 = 9'd16,
BUFFER4 = 9'd17,
BUFFER5 = 9'd18,
BUFFER6 = 9'd19,
BUFFER7 = 9'd22,
END = 9'd20,
BUFFER8 = 9'd23,
BUFFER9 = 9'd24,
BUFFER10 = 9'd25,
BUFFER11 = 9'd26,
LOG1 = 9'd27,
LOG2 = 9'd28,
LOG3 = 9'd29,
LOG4 = 9'd30,
LOG5 = 9'd31,
LOG6 = 9'd32,
LOG7 = 9'd33,
LOG8 = 9'd34,
BUFFER12 = 9'd35,
BUFFER13 = 9'd36,
BUFFER14 = 9'd37,
BUFFER15 = 9'd38,
BUFFER16 = 9'd39,
BUFFER17 = 9'd40,
BUFFER18 = 9'd41,
BUFFER19 = 9'd42,
WIN = 9'd43,
BUFFER20 = 9'd44,
BUFFER21 = 9'd45,
SCORE = 9'd46,
CHECKSPEED = 9'd47,
BUFFER22 = 9'd48,
ERROR = 8'd99;


always @(posedge clock)
begin
		S <= NS;
end 
	
always @(*)
begin
	case (S)
		START: begin // checking collisions
		if ((froggyXPlusLogX >= car1Xin && froggyXPlusLogX <=(car1Xin + CARLENGTH -1) && froggyY >=car1Yin && froggyY <= (car1Yin + CARHEIGHT -1))
			|| (froggyXPlusLogX +FROGLENGTH >= car1Xin  && froggyXPlusLogX+FROGLENGTH <=(car1Xin + CARLENGTH -1) && froggyY >=car1Yin && froggyY <= (car1Yin + CARHEIGHT -1)) || 
			(froggyXPlusLogX >= car2Xin && froggyXPlusLogX <=(car2Xin + CARLENGTH -1) && froggyY >=car2Yin && froggyY <= (car2Yin + CARHEIGHT -1))
			|| (froggyXPlusLogX +FROGLENGTH >= car2Xin  && froggyXPlusLogX+FROGLENGTH <=(car2Xin + CARLENGTH -1) && froggyY >=car2Yin && froggyY <= (car2Yin + CARHEIGHT -1)) || 
			(froggyXPlusLogX >= car3Xin && froggyXPlusLogX <=(car3Xin + CARLENGTH -1) && froggyY >=car3Yin && froggyY <= (car3Yin + CARHEIGHT -1))
			|| (froggyXPlusLogX +FROGLENGTH >= car3Xin  && froggyXPlusLogX+FROGLENGTH <=(car3Xin + CARLENGTH -1) && froggyY >=car3Yin && froggyY <= (car3Yin + CARHEIGHT -1)) || 
			(froggyXPlusLogX >= car4Xin && froggyXPlusLogX <=(car4Xin + CARLENGTH -1) && froggyY >=car4Yin && froggyY <= (car4Yin + CARHEIGHT -1))
			|| (froggyXPlusLogX +FROGLENGTH >= car4Xin  && froggyXPlusLogX+FROGLENGTH <=(car4Xin + CARLENGTH -1) && froggyY >=car4Yin && froggyY <= (car4Yin + CARHEIGHT -1)) || 
			(froggyXPlusLogX >= car5Xin && froggyXPlusLogX <=(car5Xin + CARLENGTH -1) && froggyY >=car5Yin && froggyY <= (car5Yin + CARHEIGHT -1))
			|| (froggyXPlusLogX +FROGLENGTH >= car5Xin  && froggyXPlusLogX+FROGLENGTH <=(car5Xin + CARLENGTH -1) && froggyY >=car5Yin && froggyY <= (car5Yin + CARHEIGHT -1)) || 
			(froggyXPlusLogX >= car6Xin && froggyXPlusLogX <=(car6Xin + CARLENGTH -1) && froggyY >=car6Yin && froggyY <= (car6Yin + CARHEIGHT -1))
			|| (froggyXPlusLogX +FROGLENGTH >= car6Xin  && froggyXPlusLogX+FROGLENGTH <=(car6Xin + CARLENGTH -1) && froggyY >=car6Yin && froggyY <= (car6Yin + CARHEIGHT -1)) || 
			(froggyXPlusLogX >= car7Xin && froggyXPlusLogX <=(car7Xin + CARLENGTH -1) && froggyY >=car7Yin && froggyY <= (car7Yin + CARHEIGHT -1))
			|| (froggyXPlusLogX +FROGLENGTH >= car7Xin  && froggyXPlusLogX+FROGLENGTH <=(car7Xin + CARLENGTH -1) && froggyY >=car7Yin && froggyY <= (car7Yin + CARHEIGHT -1)) || 
			(froggyXPlusLogX >= car8Xin && froggyXPlusLogX <=(car8Xin + CARLENGTH -1) && froggyY >=car8Yin && froggyY <= (car8Yin + CARHEIGHT -1))
			|| (froggyXPlusLogX +FROGLENGTH >= car8Xin  && froggyXPlusLogX+FROGLENGTH <=(car8Xin + CARLENGTH -1) && froggyY >=car8Yin && froggyY <= (car8Yin + CARHEIGHT -1)) || 
			(froggyXPlusLogX >= car9Xin && froggyXPlusLogX <=(car9Xin + CARLENGTH -1) && froggyY >=car9Yin && froggyY <= (car9Yin + CARHEIGHT -1))
			|| (froggyXPlusLogX +FROGLENGTH >= car9Xin  && froggyXPlusLogX+FROGLENGTH <=(car9Xin + CARLENGTH -1) && froggyY >=car9Yin && froggyY <= (car9Yin + CARHEIGHT -1)) || 
			(froggyXPlusLogX >= car10Xin && froggyXPlusLogX <=(car10Xin + CARLENGTH -1) && froggyY >=car10Yin && froggyY <= (car10Yin + CARHEIGHT -1))
			|| (froggyXPlusLogX+FROGLENGTH >= car10Xin && froggyXPlusLogX+FROGLENGTH <=(car10Xin + CARLENGTH -1) && froggyY >=car10Yin && froggyY <= (car10Yin + CARHEIGHT -1)) || 
			(froggyY > 20 && froggyY <= 8'd100 && !(
				//checking that frog is not in the water
			((froggyXPlusLogX >= log1Xin && froggyXPlusLogX <=(log1Xin + LOGLENGTH -1) && froggyY >=log1Yin && froggyY <= (log1Yin + CARHEIGHT -1))
			&& (froggyXPlusLogX +FROGLENGTH >= log1Xin  && froggyXPlusLogX+FROGLENGTH <=(log1Xin + LOGLENGTH -1) && froggyY >=log1Yin && froggyY <= (log1Yin + CARHEIGHT -1)) || 
			(froggyXPlusLogX >= log2Xin && froggyXPlusLogX <=(log2Xin + LOGLENGTH -1) && froggyY >=log2Yin && froggyY <= (log2Yin + CARHEIGHT -1))
			&& (froggyXPlusLogX +FROGLENGTH >= log2Xin  && froggyXPlusLogX+FROGLENGTH <=(log2Xin + LOGLENGTH -1) && froggyY >=log2Yin && froggyY <= (log2Yin + CARHEIGHT -1)) || 
			(froggyXPlusLogX >= log3Xin && froggyXPlusLogX <=(log3Xin + LOGLENGTH -1) && froggyY >=log3Yin && froggyY <= (log3Yin + CARHEIGHT -1))
			&& (froggyXPlusLogX +FROGLENGTH >= log3Xin  && froggyXPlusLogX+FROGLENGTH <=(log3Xin + LOGLENGTH -1) && froggyY >=log3Yin && froggyY <= (log3Yin + CARHEIGHT -1)) || 
			(froggyXPlusLogX >= log4Xin && froggyXPlusLogX <=(log4Xin + LOGLENGTH -1) && froggyY >=log4Yin && froggyY <= (log4Yin + CARHEIGHT -1))
			&& (froggyXPlusLogX +FROGLENGTH >= log4Xin  && froggyXPlusLogX+FROGLENGTH <=(log4Xin + LOGLENGTH -1) && froggyY >=log4Yin && froggyY <= (log4Yin + CARHEIGHT -1)) || 
			(froggyXPlusLogX >= log5Xin && froggyXPlusLogX <=(log5Xin + LOGLENGTH -1) && froggyY >=log5Yin && froggyY <= (log5Yin + CARHEIGHT -1))
			&& (froggyXPlusLogX +FROGLENGTH >= log5Xin  && froggyXPlusLogX+FROGLENGTH <=(log5Xin + LOGLENGTH -1) && froggyY >=log5Yin && froggyY <= (log5Yin + CARHEIGHT -1)) || 
			(froggyXPlusLogX >= log6Xin && froggyXPlusLogX <=(log6Xin + LOGLENGTH -1) && froggyY >=log6Yin && froggyY <= (log6Yin + CARHEIGHT -1))
			&& (froggyXPlusLogX +FROGLENGTH >= log6Xin  && froggyXPlusLogX+FROGLENGTH <=(log6Xin + LOGLENGTH -1) && froggyY >=log6Yin && froggyY <= (log6Yin + CARHEIGHT -1)) || 
			(froggyXPlusLogX >= log7Xin && froggyXPlusLogX <=(log7Xin + LOGLENGTH -1) && froggyY >=log7Yin && froggyY <= (log7Yin + CARHEIGHT -1))
			&& (froggyXPlusLogX +FROGLENGTH >= log7Xin  && froggyXPlusLogX+FROGLENGTH <=(log7Xin + LOGLENGTH -1) && froggyY >=log7Yin && froggyY <= (log7Yin + CARHEIGHT -1)) || 
			(froggyXPlusLogX >= log8Xin && froggyXPlusLogX <=(log8Xin + LOGLENGTH -1) && froggyY >=log8Yin && froggyY <= (log8Yin + CARHEIGHT -1))
			&& (froggyXPlusLogX +FROGLENGTH >= log8Xin  && froggyXPlusLogX+FROGLENGTH <=(log8Xin + LOGLENGTH -1) && froggyY >=log8Yin && froggyY <= (log8Yin + CARHEIGHT -1))
			
			) 
			)
			)
			)
			NS <= END;
		else if (froggyY < 20)
		NS <= WIN; // win when the frog reaches the green strip at the top of the screen
		else
		NS <= CHECKSPEED; 
		end
		CHECKSPEED: //checks to see if the current level is unwinnable. Reset if it is
		if ((log1Speed == log2Speed || log2Speed == log3Speed || log3Speed == log4Speed) && log1Speed != 0 && delayCounter == 0)
		NS <= START;
		else if ((log1Speed == log2Speed || log2Speed == log3Speed || log3Speed == log4Speed) && log1Speed != 0 && delayCounter <= 1)
		NS <= CHECKSPEED;
		else
		NS <= BACKGROUND;
		
		//tells it when to keep drawing the background or to move on
		BACKGROUND: begin
		if (y < 8'd240)
		NS <= BACKGROUND;
		else
		NS <= BUFFER0;
		end
		
		//tells it when to keep drawing the frog or to move on
		FROG: begin
		if (y < froggyY + FROGHEIGHT - 1)
		NS <= FROG;
		else
		NS <= BUFFER1;
		end
		
		//CAR1 THROUGH CAR 10 tells it when to keep drawing the current car, vs when to move on
		
		CAR1: begin
		if (y < car1Yin + CARHEIGHT - 1)
		NS <= CAR1;
		else
		NS <= BUFFER2;
		end
		CAR2: begin
		if (y < car2Yin + CARHEIGHT - 1)
		NS <= CAR2;
		else
		NS <= BUFFER3;
		end
		CAR3: begin
		if (y < car3Yin + CARHEIGHT -1)
		NS <= CAR3;
		else
		NS <= BUFFER4;
		end
		CAR4: begin
		if (y < car4Yin + CARHEIGHT -1)
		NS <= CAR4;
		else
		NS <= BUFFER5;
		end
		CAR5: begin
		if (y < car5Yin + CARHEIGHT -1)
		NS <= CAR5;
		else
		NS <= BUFFER6;
		end
		CAR6: begin
		if (y < car6Yin + CARHEIGHT -1)
		NS <= CAR6;
		else
		NS <= BUFFER7;
		end
		CAR7: begin
		if (y < car7Yin + CARHEIGHT -1)
		NS <= CAR7;
		else
		NS <= BUFFER8;
		end
		CAR8: begin
		if (y < car8Yin + CARHEIGHT -1)
		NS <= CAR8;
		else
		NS <= BUFFER9;
		end
		CAR9: begin
		if (y < car9Yin + CARHEIGHT -1)
		NS <= CAR9;
		else
		NS <= BUFFER10;
		end
		
		CAR10: begin
		if (y < car10Yin + CARHEIGHT -1)
		NS <= CAR10;
		else
		NS <= BUFFER11;
		end
		
		//Eeach buffer resets the y value to zero, so that we can start counting the next thing to draw
		
		BUFFER0: if (y == 0)
		NS <= FROG;
		else 
		NS <= BUFFER0;
		
		
		BUFFER1: if (y == 0)
		NS <= CAR1;
		else 
		NS <= BUFFER1;
		
		BUFFER2: if (y == 0)
		NS <= CAR2;
		else 
		NS <= BUFFER2;
		
		BUFFER3: if (y == 0)
		NS <= CAR3;
		else 
		NS <= BUFFER3;
		
		BUFFER4: if (y == 0)
		NS <= CAR4;
		else 
		NS <= BUFFER4;
		
		BUFFER5: if (y == 0)
		NS <= CAR5;
		else 
		NS <= BUFFER5;
		
		BUFFER6: if (y == 0)
		NS <= CAR6;
		else 
		NS <= BUFFER6;
		
		BUFFER7: if (y == 0)
		NS <= CAR7;
		else 
		NS <= BUFFER7;
		
		BUFFER8: if (y == 0)
		NS <= CAR8;
		else 
		NS <= BUFFER8;
		
		BUFFER9: if (y == 0)
		NS <= CAR9;
		else 
		NS <= BUFFER9;
		
		BUFFER10: if (y == 0)
		NS <= CAR10;
		else 
		NS <= BUFFER10;
		
		BUFFER11: if (y == 0)
		NS <= LOG1;
		else 
		NS <= BUFFER11;
		
		BUFFER12: if (y == 0)
		NS <= LOG2;
		else 
		NS <= BUFFER12;
		
		BUFFER13: if (y == 0)
		NS <= LOG3;
		else 
		NS <= BUFFER13;
		
		BUFFER14: if (y == 0)
		NS <= LOG4;
		else 
		NS <= BUFFER14;
		
		BUFFER15: if (y == 0)
		NS <= LOG5;
		else 
		NS <= BUFFER15;
		
		BUFFER16: if (y == 0)
		NS <= LOG6;
		else 
		NS <= BUFFER16;
		
		BUFFER17: if (y == 0)
		NS <= LOG7;
		else 
		NS <= BUFFER17;
		
		BUFFER18: if (y == 0)
		NS <= LOG8;
		else 
		NS <= BUFFER18;
		
		BUFFER19: if (y == 0)
		NS <= START;
		else 
		NS <= BUFFER19;
		
		BUFFER20: if (y == 0)
		NS <= SCORE;
		else 
		NS <= BUFFER20;

		BUFFER21: if (y == 0)
		NS <= START;
		else 
		NS <= BUFFER21;
		
		BUFFER22: NS <= BACKGROUND;
		
		//LOG1 through LOG8 tells it when to keep drawing the log vs when to move on
		
		LOG1: begin
		if (y < log1Yin + CARHEIGHT - 1)
		NS <= LOG1;
		else
		NS <= BUFFER12;
		end
		
		LOG2: begin
		if (y < log2Yin + CARHEIGHT - 1)
		NS <= LOG2;
		else
		NS <= BUFFER13;
		end
		LOG3: begin
		if (y < log3Yin + CARHEIGHT - 1)
		NS <= LOG3;
		else
		NS <= BUFFER14;
		end
		LOG4: begin
		if (y < log4Yin + CARHEIGHT - 1)
		NS <= LOG4;
		else
		NS <= BUFFER15;
		end
		
		LOG5:begin
		if (y < log5Yin + CARHEIGHT - 1)
		NS <= LOG5;
		else
		NS <= BUFFER16;
		end
		
		LOG6: begin
		if (y < log6Yin + CARHEIGHT - 1)
		NS <= LOG6;
		else
		NS <= BUFFER17;
		end
		
		LOG7:begin
		if (y < log7Yin + CARHEIGHT - 1)
		NS <= LOG7;
		else
		NS <= BUFFER18;
		end
		LOG8: begin
		if (y < log8Yin + CARHEIGHT - 1)
		NS <= LOG8;
		else
		NS <= BUFFER19;
		end
		
		//stay on win screen for 0.5 seconds
		WIN: if (y < 8'd240 || delayCounter < 64'd25000000)
		NS <= WIN;
		else
		NS <= BUFFER20;
		
		//stay on end screen for 0.5 seconds
		END: if (y < 8'd240 || delayCounter < 64'd25000000)
		NS <= END;
		else
		NS <= BUFFER21;
		
		SCORE: NS <= START;
		
		default NS <= ERROR;
			
	endcase
		
end

always @(posedge clock)
begin
		case (S)
			SCORE: score = score + 1; //increment score by 1
			
			//If any sequential logs have the same speed, we need to reset because the level can be unwinnable
			CHECKSPEED: begin
			if ((log1Speed == log2Speed || log2Speed == log3Speed || log3Speed == log4Speed) && log1Speed != 0 && delayCounter == 0) begin
			carRst = 1'b0;
			Drawrst = 1'b1;
			delayCounter = delayCounter + 1;
			end
			else begin
			x <= backgroundX;
			y <= backgroundY;
			if (backgroundY <= 19)
			Color = 3'b010;
			else if (backgroundY < 100)
			Color = 3'b001;
			else if (backgroundY >= 100)
			Color = 3'b000;
			carRst = 1'b1;
			delayCounter = delayCounter + 1;
			end
			end
			
			//start turns resets on/off accordingly
			START:
			begin
			Drawrst =1'b1;
			rst = 1'b0;
			carRst = 1'b1;
			end
			
			//draw a red screen 
			END: begin
			x <= endGameX;
			y <= endGameY;
			Color <= endGameColor;
			delayCounter = delayCounter + 1;
			if (froggyY <= 220)
			rst <= 1'b1;
			else 
			rst <= 1'b0;
			carRst = 1'b0;
			score <= 0;
			end
			
			//draw a green screen
			WIN: begin
			delayCounter = delayCounter + 1;
			x <= winX;
			y <= winY;
			if (froggyY <= 220)
			rst <= 1'b1;
			else 
			rst <= 1'b0;
			carRst = 1'b0;
			Color <= winColor;
			end
			
			//draw the background
			BACKGROUND: begin
			delayCounter = 0;
			Drawrst = 1'b1;
			carRst = 1'b1;
			x <= backgroundX;
			y <= backgroundY;
			//draw green for the last line of the frog. There is a glitch fixed by this line
			if (backgroundX >= froggyXPlusLogX && backgroundX <= froggyXPlusLogX + FROGLENGTH && backgroundY == froggyY + 13)
			Color <= 3'b010;
			//do the same thing for each car
			else if (backgroundX >= car1Xin && backgroundX <= car1Xin + CARLENGTH && backgroundY == car1Yin + CARHEIGHT - 1 || 
					backgroundX >= car2Xin && backgroundX <= car2Xin + CARLENGTH && backgroundY == car2Yin + CARHEIGHT - 1 || 
					backgroundX >= car3Xin && backgroundX <= car3Xin + CARLENGTH && backgroundY == car3Yin + CARHEIGHT - 1 || 
					backgroundX >= car4Xin && backgroundX <= car4Xin + CARLENGTH && backgroundY == car4Yin + CARHEIGHT - 1 || 
					backgroundX >= car5Xin && backgroundX <= car5Xin + CARLENGTH && backgroundY == car5Yin + CARHEIGHT - 1 || 
					backgroundX >= car6Xin && backgroundX <= car6Xin + CARLENGTH && backgroundY == car6Yin + CARHEIGHT - 1 || 
					backgroundX >= car7Xin && backgroundX <= car7Xin + CARLENGTH && backgroundY == car7Yin + CARHEIGHT - 1 ||
					backgroundX >= car8Xin && backgroundX <= car8Xin + CARLENGTH && backgroundY == car8Yin + CARHEIGHT - 1 || 
					backgroundX >= car9Xin && backgroundX <= car9Xin + CARLENGTH && backgroundY == car9Yin + CARHEIGHT - 1 || 
					backgroundX >= car10Xin && backgroundX <= car10Xin + CARLENGTH && backgroundY == car10Yin + CARHEIGHT - 1
				)
			Color <= 3'b100;
			//same thing for each log
			else if (backgroundX >= log1Xin && backgroundX <= log1Xin + LOGLENGTH && backgroundY == log1Yin + CARHEIGHT - 1 ||
			backgroundX >= log2Xin && backgroundX <= log2Xin + LOGLENGTH && backgroundY == log2Yin + CARHEIGHT - 1 ||
			backgroundX >= log3Xin && backgroundX <= log3Xin + LOGLENGTH && backgroundY == log3Yin + CARHEIGHT - 1 ||
			backgroundX >= log4Xin && backgroundX <= log4Xin + LOGLENGTH && backgroundY == log4Yin + CARHEIGHT - 1 ||
			backgroundX >= log5Xin && backgroundX <= log5Xin + LOGLENGTH && backgroundY == log5Yin + CARHEIGHT - 1 ||
			backgroundX >= log6Xin && backgroundX <= log6Xin + LOGLENGTH && backgroundY == log6Yin + CARHEIGHT - 1 ||
			backgroundX >= log7Xin && backgroundX <= log7Xin + LOGLENGTH && backgroundY == log7Yin + CARHEIGHT - 1 ||
			backgroundX >= log8Xin && backgroundX <= log8Xin + LOGLENGTH && backgroundY == log8Yin + CARHEIGHT - 1 
			)
			Color <= 3'b000;
			//draw the road
			else if (backgroundY >= 100)
			Color <= 3'b000;
			//draw the green top area
			else if (backgroundY >=0 && backgroundY <= 19)
			Color <= 3'b010;
			else
			//draw water
			Color <= 3'b001;
			end
			
			//draw the frog
			FROG: begin
			Drawrst = 1'b1;
			x <= frogX;
			y <= frogY;
			Color <= frogColor;
			end
			
			//draw car1
			CAR1: begin
			Drawrst = 1'b1;
			x <= car1X;
			y <= car1Y;
			Color <= car1Color;
			end
			
			//draw car2
			CAR2: begin
			Drawrst = 1'b1;
			x <= car2X;
			y <= car2Y;
			Color <= car2Color;
			end
			
			//draw car3
			CAR3: begin
			Drawrst = 1'b1;
			x <= car3X;
			y <= car3Y;
			Color <= car3Color;
			end
			
			//draw car4
			CAR4: begin
			Drawrst = 1'b1;
			x <= car4X;
			y <= car4Y;
			Color <= car4Color;
			end
			
			//draw car5
			CAR5: begin
			Drawrst = 1'b1;
			x <= car5X;
			y <= car5Y;
			Color <= car5Color;
			end
			
			//draw car6
			CAR6: begin
			Drawrst = 1'b1;
			x <= car6X;
			y <= car6Y;
			Color <= car6Color;
			end
			
			//draw car7
			CAR7: begin
			Drawrst = 1'b1;
			x <= car7X;
			y <= car7Y;
			Color <= car7Color;
			end
			
			//draw car8
			CAR8: begin
			Drawrst = 1'b1;
			x <= car8X;
			y <= car8Y;
			Color <= car8Color;
			end
			
			//draw car9
			CAR9: begin
			Drawrst = 1'b1;
			x <= car9X;
			y <= car9Y;
			Color <= car9Color;
			end
			
			//draw car10
			CAR10: begin
			Drawrst = 1'b1;
			x <= car10X;
			y <= car10Y;
			Color <= car10Color;
			end
			
			//draw log1, where the frog overlaps, color it green
			LOG1: begin
			Drawrst = 1'b1;
			x <= log1X;
			y <= log1Y;
			if (log1X >= froggyXPlusLogX && log1X <=(froggyXPlusLogX + 11) && log1Y >= froggyY && log1Y <= (froggyY + 14))
			Color <= 3'b010;
			else 
			Color <= log1Color;
			end
			
			//draw log2, where the frog overlaps, color it green
			LOG2: begin
			Drawrst = 1'b1;
			x <= log2X;
			y <= log2Y;
			if (log2X >= froggyXPlusLogX && log2X <=(froggyXPlusLogX + 11) && log2Y >= froggyY && log2Y <= (froggyY + 14))
			Color <= 3'b010;
			else 
			Color <= log2Color;
			end
			
			//draw log3, where the frog overlaps, color it green
			LOG3: begin
			Drawrst = 1'b1;
			x <= log3X;
			y <= log3Y;
			if (log3X >= froggyXPlusLogX && log3X <=(froggyXPlusLogX + 11) && log3Y >= froggyY && log3Y <= (froggyY + 15))
			Color <= 3'b010;
			else 
			Color <= log3Color;
			end
			
			//draw log4, where the frog overlaps, color it green
			LOG4: begin
			Drawrst = 1'b1;
			x <= log4X;
			y <= log4Y;
			if (log4X >= froggyXPlusLogX && log4X <=(froggyXPlusLogX + 11) && log4Y >= froggyY && log4Y <= (froggyY + 14))
			Color <= 3'b010;
			else 
			Color <= log4Color;
			end
			
			//draw log5, where the frog overlaps, color it green
			LOG5: begin
			Drawrst = 1'b1;
			x <= log5X;
			y <= log5Y;
			if (log5X >= froggyXPlusLogX && log5X <=(froggyXPlusLogX + 11) && log5Y >= froggyY && log5Y <= (froggyY + 14))
			Color <= 3'b010;
			else 
			Color <= log5Color;
			end
			
			//draw log6, where the frog overlaps, color it green
			LOG6: begin
			Drawrst = 1'b1;
			x <= log6X;
			y <= log6Y;
			if (log6X >= froggyXPlusLogX && log6X <=(froggyXPlusLogX + 11) && log6Y >= froggyY && log6Y <= (froggyY + 14))
			Color <= 3'b010;
			else 
			Color <= log6Color;
			end
			
			//draw log7, where the frog overlaps, color it green
			LOG7: begin
			Drawrst = 1'b1;
			x <= log7X;
			y <= log7Y;
			if (log7X >= froggyXPlusLogX && log7X <=(froggyXPlusLogX + 11) && log7Y >= froggyY && log7Y <= (froggyY + 14))
			Color <= 3'b010;
			else 
			Color <= log7Color;
			end
			
			//draw log8, where the frog overlaps, color it green
			LOG8: begin
			Drawrst = 1'b1;
			x <= log8X;
			y <= log8Y;
			if (log8X >= froggyXPlusLogX && log8X <=(froggyXPlusLogX + 11) && log8Y >= froggyY && log8Y <= (froggyY + 14))
			Color <= 3'b010;
			else 
			Color <= log8Color;
			end
			
			//ALL BUFFERS SET Y BACK TO ZERO, AS WE DRAW EACH RECTANGLE BASED ON IT NOT HAVING REACHED ITS MAX Y VALUE
			
			BUFFER0: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			BUFFER1: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			BUFFER2: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			BUFFER3: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			BUFFER4: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			BUFFER5: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			BUFFER6: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			BUFFER7: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			
			BUFFER8: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			
			BUFFER9: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			
			BUFFER10: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			BUFFER11: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			BUFFER12: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			BUFFER13: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			BUFFER14: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			BUFFER15: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			
			BUFFER16: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			
			BUFFER17: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			BUFFER18: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			BUFFER19: begin
			y <= 0;
			Drawrst = 1'b0;
			end
			BUFFER20: begin
			delayCounter <= 0; //reset the counter
			y <= 0;
			Drawrst = 1'b0;
			end
			BUFFER21: begin
			delayCounter <= 0; //reset the counter
			y <= 0;
			Drawrst = 1'b0;
			end
			
			BUFFER22: begin
			delayCounter <= 0; //reset the counter
			y <= 0;
			Drawrst = 1'b0;
			end
		endcase
end



//tells the frog to move at the speed of the correct log, while it is on a log
//logX and log(X+4) share the same speed, as the should not overlap
always@(posedge moveTimer or posedge rst) 
begin
if (rst == 1'b1)
frogLogX = 0; //set the counter of the distance moved on logs to zero when reset
else 
begin
if (froggyXPlusLogX >= log4Xin && froggyXPlusLogX <=(log4Xin + LOGLENGTH -1) && froggyY >=log4Yin && froggyY <= (log4Yin + CARHEIGHT -1))
			frogLogX = frogLogX + log4Speed;		 
if (froggyXPlusLogX >= log8Xin && froggyXPlusLogX <=(log8Xin + LOGLENGTH -1) && froggyY >=log8Yin && froggyY <= (log8Yin + CARHEIGHT -1))
			frogLogX = frogLogX + log4Speed;		 
if (froggyXPlusLogX >= log3Xin && froggyXPlusLogX <=(log3Xin + LOGLENGTH -1) && froggyY >=log3Yin && froggyY <= (log3Yin + CARHEIGHT -1))
			frogLogX = frogLogX + log3Speed;	
if  (froggyXPlusLogX >= log7Xin && froggyXPlusLogX <=(log7Xin + LOGLENGTH -1) && froggyY >=log7Yin && froggyY <= (log7Yin + CARHEIGHT -1))
			frogLogX = frogLogX + log3Speed;	
if (froggyXPlusLogX >= log2Xin && froggyXPlusLogX <=(log2Xin + LOGLENGTH -1) && froggyY >=log2Yin && froggyY <= (log2Yin + CARHEIGHT -1)) 
			frogLogX = frogLogX + log2Speed;	
if  (froggyXPlusLogX >= log6Xin && froggyXPlusLogX <=(log6Xin + LOGLENGTH -1) && froggyY >=log6Yin && froggyY <= (log6Yin + CARHEIGHT -1))
			frogLogX = frogLogX + log2Speed;	
if (froggyXPlusLogX >= log1Xin && froggyXPlusLogX <=(log1Xin + LOGLENGTH -1) && froggyY >=log1Yin && froggyY <= (log1Yin + CARHEIGHT -1))
			frogLogX = frogLogX + log1Speed;	
if (froggyXPlusLogX >= log5Xin && froggyXPlusLogX <=(log5Xin + LOGLENGTH -1) && froggyY >=log5Yin && froggyY <= (log5Yin + CARHEIGHT -1))
			frogLogX = frogLogX + log1Speed;	
end
end

endmodule