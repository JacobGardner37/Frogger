//Code obtained from Montvydas Klumbys	
//available at https://www.instructables.com/PS2-Keyboard-for-FPGA/
//modified by jacob gardner and lucian pfister
//uses the ps2 keyboard to move the frog using the arrow keys

module frogMovement(CLK, RST, PS2_CLK, PS2_DATA, frogLogX, outX, outY);
	input CLK, PS2_CLK, PS2_DATA, RST;
	output reg [8:0]outX;
	input [8:0] frogLogX;
	output reg [7:0]outY;
	wire [7:0] ARROW_UP = 8'h75;	//codes for arrows
	wire [7:0] ARROW_DOWN = 8'h72;
	wire [7:0] ARROW_LEFT = 8'h6B;
	wire [7:0] ARROW_RIGHT = 8'h74;

	reg read;				//this is 1 if still waits to receive more bits 
	reg [11:0] count_reading;		//this is used to detect how much time passed since it received the previous codeword
	reg PREVIOUS_STATE;			//used to check the previous state of the keyboard clock signal to know if it changed
	reg scan_err;				//this becomes one if an error was received somewhere in the packet
	reg [10:0] scan_code;			//this stores 11 received bits
	reg [7:0] CODEWORD;			//this stores only the DATA codeword
	reg TRIG_ARR;				//this is triggered when full 11 bits are received
	reg [3:0]COUNT;				//tells how many bits were received until now (from 0 to 11)
	reg TRIGGER = 0;			//This acts as a 250 times slower than the board clock. 
	reg [7:0]DOWNCOUNTER = 0;		//This is used together with TRIGGER - look the code

	reg [7:0] sameButton; //checks to see if the same button is found twice in a row, since input was read when the key is released
	//Set initial values
	initial begin
		PREVIOUS_STATE = 1;		
		scan_err = 0;		
		scan_code = 0;
		COUNT = 0;			
		CODEWORD = 0;
		read = 0;
		count_reading = 0;
		outX = 150;
		outY = 224;
		sameButton = 8'd0;
	end

	always @(posedge CLK) begin				//This reduces the frequency 250 times
		if (DOWNCOUNTER < 250) begin			//and uses variable TRIGGER as the new board clock 
			DOWNCOUNTER <= DOWNCOUNTER + 1;
			TRIGGER <= 0;
		end
		else begin
			DOWNCOUNTER <= 0;
			TRIGGER <= 1;
		end
	end
	
	always @(posedge CLK) begin	
		if (TRIGGER) begin
			if (read)				//if it still waits to read full packet of 11 bits, then (read == 1)
				count_reading <= count_reading + 1;	//and it counts up this variable
			else 						//and later if check to see how big this value is.
				count_reading <= 0;			//if it is too big, then it resets the received data
		end
	end


	always @(posedge CLK) begin		
	if (TRIGGER) begin						//If the down counter (CLK/250) is ready
		if (PS2_CLK != PREVIOUS_STATE) begin			//if the state of Clock pin changed from previous state
			if (!PS2_CLK) begin				//and if the keyboard clock is at falling edge
				read <= 1;				//mark down that it is still reading for the next bit
				scan_err <= 0;				//no errors
				scan_code[10:0] <= {PS2_DATA, scan_code[10:1]};	//add up the data received by shifting bits and adding one new bit
				COUNT <= COUNT + 1;			//
			end
		end
		else if (COUNT == 11) begin				//if it already received 11 bits
			COUNT <= 0;
			read <= 0;					//mark down that reading stopped
			TRIG_ARR <= 1;					//trigger out that the full pack of 11bits was received
			//calculate scan_err using parity bit
			if (!scan_code[10] || scan_code[0] || !(scan_code[1]^scan_code[2]^scan_code[3]^scan_code[4]
				^scan_code[5]^scan_code[6]^scan_code[7]^scan_code[8]
				^scan_code[9]))
				scan_err <= 1;
			else 
				scan_err <= 0;
		end	
		else  begin						//if it yet not received full pack of 11 bits
			TRIG_ARR <= 0;					//tell that the packet of 11bits was not received yet
			if (COUNT < 11 && count_reading >= 4000) begin	//and if after a certain time no more bits were received, then
				COUNT <= 0;				//reset the number of bits received
				read <= 0;				//and wait for the next packet
			end
		end
	PREVIOUS_STATE <= PS2_CLK;					//mark down the previous state of the keyboard clock
	end
	end


	always @(posedge CLK) begin
		if (TRIGGER) begin					//if the 250 times slower than board clock triggers
			if (TRIG_ARR) begin				//and if a full packet of 11 bits was received
				if (scan_err) begin			//BUT if the packet was NOT OK
					CODEWORD <= 8'd0;		//then reset the codeword register
				end
				else begin
					CODEWORD <= scan_code[8:1];	//else drop down the unnecessary  bits and transport the 7 DATA bits to CODEWORD reg
				end				//notice, that the codeword is also reversed! This is because the first bit to received
			end					//is supposed to be the last bit in the codeword…
			else CODEWORD <= 8'd0;				//not a full packet received, thus reset codeword
		end
		else CODEWORD <= 8'd0;					//no clock trigger, no data…
	end
	
	always @(posedge CLK) begin
	//this if statement is used to prevent inputs from being read from the release of a button
	//this was a problem we had with the original code
	if (sameButton == CODEWORD && CODEWORD != 0) sameButton <= 8'd0;
	else if (RST == 1'b1) begin
	outY <= 224;
	outX <= 150;
	end
		//the outY position is constrained so it can't go off the board
		else if (CODEWORD == ARROW_UP && outY > 9'd10)	begin			//if the CODEWORD has the same code as the ARROW_UP code
			outY <= outY - 20;
			sameButton = CODEWORD;
			end
		else if (CODEWORD == ARROW_DOWN &&  outY < 8'd220)	begin		//or if the ARROW_DOWN was pressed, then
			outY <= outY + 20;
			sameButton = CODEWORD;	
			end		
			
		//outX is constained so that the frog cannot go off the screen
		else if (CODEWORD == ARROW_LEFT && (frogLogX + outX) > 9'd15) begin
			outX <= outX - 15;
			sameButton = CODEWORD;
			end
		else if (CODEWORD == ARROW_RIGHT && (outX + frogLogX) < 9'd300) begin
			outX <= outX + 15;
			sameButton = CODEWORD;
			end

	end

endmodule
