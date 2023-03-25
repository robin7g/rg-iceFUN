/*
 *  VGA this has 2 bits per RGB colour line
 *  6 bits of colour overall = 64 colours
 * 
 *  Copyright(C) 2022 Robin Grosset
 *  
 * 
 */
 
`include "pll.v" 

module top (
	input clk12MHz, 
	output vga_r1,
	output vga_r2, 
	output vga_g1,
	output vga_g2,
	output vga_b1,
	output vga_b2,
	output vga_hsync,
	output vga_vsync
	);

	// a 32 bit counter used to scroll the text
    reg [31:0] counter = 32'b0;
	reg [31:0] counter21 = 32'b0;
	reg [31:0] offset = 32'b0;

	wire clk;
	wire locked;

	// This PLL clock creates a 25.125 MHz output clock from 12Mhz input
	pll pixelclock(
	.clock_in(clk12MHz), 
	.clock_out(clk),
	.locked(locked)
	);


	// increment the counter every clock and after a certain number of clocks
	// we shift the pixel lines along. 	
    always @ (posedge clk12MHz) begin
        counter <= counter + 1;
    end

	always @ (posedge clk) begin
        counter21 <= counter21 + 1;
    end


	// video structure constants
	parameter hpixels = 800; // horizontal pixels per line
	parameter vlines = 521;  // vertical lines per frame
	parameter hpulse = 96; 	 // hsync pulse length
	parameter vpulse = 2; 	 // vsync pulse length
	parameter hbp = 144; 	 // end of horizontal back porch
	parameter hfp = 784; 	 // beginning of horizontal front porch
	parameter vbp = 31; 	 // end of vertical back porch
	parameter vfp = 511; 	 // beginning of vertical front porch
	// active horizontal video is therefore: 784 - 144 = 640
	// active vertical video is therefore: 511 - 31 = 480

	// registers for storing the horizontal & vertical counters
	reg [9:0] hc;
	reg [9:0] vc;

	parameter  _cBK = 6'b000000; // Black
	parameter  _cWT = 6'b111111; // White

	parameter  _cG0 = 6'b001100; // Green
	parameter  _cG1 = 6'b011100;
	parameter  _cG2 = 6'b101100;
	parameter  _cY0 = 6'b111100; // Yellow
	parameter  _cY1 = 6'b111000;
	parameter  _cY2 = 6'b110100;
	parameter  _cR0 = 6'b110000; // Red
	parameter  _cR1 = 6'b110001; 
	parameter  _cR2 = 6'b110010; 
	parameter  _cP0 = 6'b110011; // Purple
	parameter  _cP1 = 6'b100011; 
	parameter  _cP2 = 6'b010011; 
	parameter  _cB0 = 6'b000011; // Blue
	parameter  _cB1 = 6'b000111; 
	parameter  _cB2 = 6'b001011; 
	parameter  _cC0 = 6'b001111; // Cyan
	parameter  _cC1 = 6'b001110; 
	parameter  _cC2 = 6'b001101; 
	// go back to green _cG0

	reg [107:0] colors = { // each bar is 36-ish pixels each
		_cG0, // 0  - Green
		_cG1, // 1
		_cG2, // 2
		_cY0, // 3  - Yellow
		_cY1, // 4
		_cY2, // 5
		_cR0, // 6 - Red
		_cR1, // 7
		_cR2, // 8
		_cP0, // 9 - Purple
		_cP1, // 10
		_cP2, // 11
		_cB0, // 12 - Blue
		_cB1, // 13 
		_cB2, // 14
		_cC0, // 15 - Cyan
		_cC1, // 16
		_cC2 // 17
	}; // this colour bar car cycle as got back to green .. 

	always @(posedge clk)
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1) begin
				vc <= vc + 1;
			end 
			else
			begin
				vc <= 0;
				// offset allows the colour bars to move
				offset <= offset + 1;
			end
		end
	end

	assign vga_hsync = (hc < hpulse) ? 0:1;
	assign vga_vsync = (vc < vpulse) ? 0:1;

	reg [9:0] idx;
	
	
	always @(hc,vc)
	begin
		// first check if we're within vertical active video range
		if (vc >= vbp && vc < vfp)
		begin
			// hbp = 144
			if (hc >= hbp && hc < (hbp+640))
			begin
				// within 640 pixels we can fit nearly 18 colours 36 pixels wide
				// the following calculation selects the idx of the colour
				// in the array of colours to rednder a rainbow pattern as
				// the scan lines are egnerated 
				// offset variable is updated 25 times a second
				// and allows the bars to scroll.. 
				idx = (107-(6*(((hc-hbp + offset)/35)%18)));
				vga_r1 = colors[ idx - 0];
				vga_r2 = colors[ idx - 1];
				vga_g1 = colors[ idx - 2];
				vga_g2 = colors[ idx - 3];
				vga_b1 = colors[ idx - 4];
				vga_b2 = colors[ idx - 5];
			end
			else
			// we're outside active horizontal range so display black
			begin
				vga_r1 = 0;
				vga_r2 = 0;
				vga_g1 = 0;
				vga_g2 = 0;
				vga_b1 = 0;
				vga_b2 = 0;
			end
		end
		// we're outside active vertical range so display black
		else
		begin
				vga_r1 = 0;
				vga_r2 = 0;
				vga_g1 = 0;
				vga_g2 = 0;
				vga_b1 = 0;
				vga_b2 = 0;
		end
	end


endmodule
