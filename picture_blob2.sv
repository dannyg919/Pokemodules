`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2021 03:09:18 AM
// Design Name: 
// Module Name: picture_blob2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module picture_blob2
   #(parameter WIDTH = 48,     // default picture width
               HEIGHT = 64)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    
    input wire [5:0] sprite_sel_x,
    input wire [5:0] sprite_sel_y,
    
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in+sprite_sel_x+2) + (vcount_in-y_in+sprite_sel_y) * WIDTH;
   char_rom  rm(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

   // use color map to create 4 bits R, 4 bits G, 4 bits B
   // since the image is greyscale, just replicate the red pixels
   // and not bother with the other two color maps.
    rcm2 rcmc(.clka(pixel_clk_in), .addra(image_bits), .douta(red_mapped));
   //green_coe gcm(.clka(pixel_clk_in), .addra(image_bits), .douta(green_mapped));
   //blue_coe bcm (.clka(pixel_clk_in), .addra(image_bits), .douta(blue_mapped));
   // note the one clock cycle delay in pixel!
   always_ff @ (posedge pixel_clk_in) begin
     if ((hcount_in >= x_in && hcount_in < (x_in+16)) &&
          (vcount_in >= y_in && vcount_in < (y_in+16)))
        // use MSB 4 bits
        pixel_out <= {red_mapped[7:4],red_mapped[7:4],red_mapped[7:4]}; // greyscale
        //pixel_out <= {red_mapped[7:4], 8h'0}; // only red hues
        else pixel_out <= 0;
   end
endmodule