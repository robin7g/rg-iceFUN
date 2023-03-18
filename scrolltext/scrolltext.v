/*
 *  Scroll Text Display using a 4x8 Font.  
 * 
 *  Copyright(C) 2023 Robin Grosset
 *  
 *  This file and the entire 4x8 font data created for this project 
 *  is shared under the MIT license 
 *  
 *  Led scan code is reused from an example by Gerald Coe, Devantech Ltd
 *  his copyright and permissive license inclued in ledscan.v
 * 
 */
 
`include "ledscan.v"
`include "4x8font.v" 

module top (
	input clk12MHz, 
	output led1, 
	output led2, 
	output led3, 
	output led4, 
	output led5, 
	output led6, 
	output led7, 
	output led8, 
	output lcol1, 
	output lcol2, 
	output lcol3, 
	output lcol4
	);

	// Led pixel registers, ledscan.v ensures these are flashed to the display one by one
	reg [7:0] leds1;
	reg [7:0] leds2;
	reg [7:0] leds3;
	reg [7:0] leds4;
	


	// Interface code to ledscan.v module. 
	wire [7:0] leds;
	wire [3:0] lcol;

	// all the stuff wired up. 
	assign { led8, led7, led6, led5, led4, led3, led2, led1 } = leds[7:0];
	assign { lcol4, lcol3, lcol2, lcol1 } = lcol[3:0];
	
	// a 32 bit counter used to scroll the text
        reg [31:0] counter = 32'b0;

	// Gerald's led scan module this manages the display logic to mutiplex the 
	// led control lines. Like a matrix keyboard but in reverse. 
 	LedScan scan (
		.clk12MHz(clk12MHz), 
		.leds1(leds1),		
		.leds2(leds2),
		.leds3(leds3),
		.leds4(leds4),
		.leds(leds), 
		.lcol(lcol)
	);


        // This is count of vertial lines in the entire set of characters. 
	// we are going to scroll the lines across the screen 
	localparam lines = 65;
	reg [7:0] line_count = 65;
	
	// _ H E L L O _ W O R L D ! _ 
	// Chars = 4 wide.. Single Line Space = 1 wide
	// 4, 4, 1, 4, 1, 4, 1, 4, 1, 4, 4, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 4
	// Sum = 65 lines = 520 bits

	reg [520:0] hex = {_cSP,_cH,_s,_cE,_s, _cL,_s, _cL,_s, _cO, _cSP,
			_cW,_s,  _cO,_s,  _cR, _s, _cL, _s, _cD, _s, _cEX, _cSP};

	
   
	// Here we select data to display on the 'screen' of leds
	// each 8 leds is a line. 
    always @ (*) begin
		leds1[7:0] = ~ hex[line_count*8    : line_count*8-8]; 
		leds2[7:0] = ~ hex[line_count*8-9  : line_count*8-16]; 
		leds3[7:0] = ~ hex[line_count*8-17 : line_count*8-24]; 
		leds4[7:0] = ~ hex[line_count*8-25  : line_count*8-32]; 
    end

	// increment the counter every clock and after a certain number of clocks
	// we shift the pixel lines along. 	
    always @ (posedge clk12MHz) begin
        counter <= counter + 1;
		if (counter > 'h18FFFF) begin
			// This condition should be reached after ~100 ms. 
			// so one character of 5 pixels wide  (includes the blank spacer) 
			// moves across the pixel grid in ~ 1/2 a second
			line_count <= line_count - 1;
			if (line_count == 4 ) begin
				line_count <= lines;
			end	
			counter <= 0;
		end 
    end

endmodule
