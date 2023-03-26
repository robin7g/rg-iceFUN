/*
 *  VGA this has 2 bits per RGB colour line
 *  6 bits of colour overall = 64 colours
 * 
 *  Copyright(C) 2022 Robin Grosset
 *  
 * 
 */
 
`include "pll.v" 
`include "ledscan.v"

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
	always @ (posedge clk) begin
        counter <= counter + 1;
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

	reg [119:0] colors = { // each bar is 36-ish pixels each
		6'b001100, // 0  - Green
		6'b011100, // 1
		6'b101100, // 2
		6'b111100, // 3  - Yellow
		6'b111000, // 4
		6'b110100, // 5
		6'b110000, // 6 - Red
		6'b110001, // 7
		6'b110010, // 8
		6'b110011, // 9 - Purple
		6'b100011, // 10
		6'b010011, // 11
		6'b000011, // 12 - Blue
		6'b000111, // 13 
		6'b001011, // 14
		6'b001111, // 15 - Cyan
		6'b001110, // 16
		6'b001101, // 17
		6'b111111, // White
		6'b000000 // Black
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
	reg [10:0] x;
	reg [10:0] y;
	reg [3:0] x_mod_16;
	reg [0:0] x_mod_2;

	always @(posedge clk)
	begin
		x <= (vc-vbp);
		y <= (hc-hbp);
		// first check if we're within vertical active video range
		if (x >= 0 && x < 480)
		begin
			// hbp = 144
			if (y >= 0 && y < 640)
			begin
				// within 640 pixels we can fit nearly 18 colours 36 pixels wide
				// the following calculation selects the idx of the colour
				// in the array of colours to rednder a rainbow pattern as
				// the scan lines are egnerated 
				// offset variable is updated 25 times a second
				// and allows the bars to scroll.. 
				idx = (y+offset)>>5;
				x_mod_16 = idx[3:0]; // x % 16
    				x_mod_2 = idx[0];    // x % 2
				idx <= (x_mod_16+x_mod_2) * 6; // x % 18 * 6
				vga_r1 <= colors[idx];
				vga_r2 <= colors[idx-1];
				vga_g1 <= colors[idx-2];
				vga_g2 <= colors[idx-3];
				vga_b1 <= colors[idx-4];
				vga_b2 <= colors[idx-5];
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
