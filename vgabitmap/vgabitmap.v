/*
 *  Show a 160 x 120  6 bit colour image
 * 
 *  Copyright(C) 2022 Robin Grosset
 *
 * 
 *  Licensed under MIT 
 *  See license file for terms of use
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

	wire clk;
	wire locked;
	reg [31:0] offset = 32'b0;

	// This PLL clock creates a 25.125 MHz output clock from 12Mhz input
	pll pixelclock(
	.clock_in(clk12MHz), 
	.clock_out(clk),
	.locked(locked)
	);

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
				// offset increments every frame
				// this allows us to add movement
				offset <= offset + 1;
			end
		end
	end

	assign vga_hsync = (hc < hpulse) ? 0:1;
	assign vga_vsync = (vc < vpulse) ? 0:1;

	reg [10:0] x;
	reg [10:0] y;
	reg [10:0] div5x;
	reg [10:0] div5y;


	reg [7:0] data;

	// Store the image in embedded RAM
	// this is an 6 bit bitmap 160 x 120 pixels
	//
	// Note this image consumes 93% of the iceFUN RAM

	reg [5:0] image [0:19200];

	initial begin
		$readmemb("image.bin", image);
	end

	always @(posedge clk)
	begin
		x <= (vc-vbp);
		y <= (hc-hbp);
		// first check if we're within vertical active video range
		if (x >= 0 && x < 480)
		begin
			// now horz video range
			if (y >= 0 && y < 640)
			begin		
				div5x <= x>>2;
				div5y <= y>>2;						
				data <= image[ ((div5x) * 160) + (div5y) ];												
				vga_r1 <= data[5];
				vga_r2 <= data[4];
				vga_g1 <= data[3];
				vga_g2 <= data[2];
				vga_b1 <= data[1];
				vga_b2 <= data[0];				
	
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

	
