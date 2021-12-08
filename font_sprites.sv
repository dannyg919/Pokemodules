`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2021 08:31:28 AM
// Design Name: 
// Module Name: font_sprites
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


module font_sprites
   #(parameter WIDTH = 143 ,     // default picture width
               HEIGHT = 89)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    
    input wire [9:0] sprite_sel_x,
    input wire [8:0] sprite_sel_y,
    
    output logic [11:0] pixel_out);

   logic [20:0] image_addr;   // num of bits for 256*240 ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in+sprite_sel_x+2) + (vcount_in-y_in+sprite_sel_y) * WIDTH;
   font_rom  font_rm(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

   // use color map to create 4 bits R, 4 bits G, 4 bits B
   // since the image is greyscale, just replicate the red pixels
   // and not bother with the other two color maps.
    font_rcm fnt_rcm(.clka(pixel_clk_in), .addra(image_bits), .douta(red_mapped));
   //green_coe gcm(.clka(pixel_clk_in), .addra(image_bits), .douta(green_mapped));
   //blue_coe bcm (.clka(pixel_clk_in), .addra(image_bits), .douta(blue_mapped));
   // note the one clock cycle delay in pixel!
   always_ff @ (posedge pixel_clk_in) begin
     if ((hcount_in >= x_in && hcount_in < (x_in+8)) &&
          (vcount_in >= y_in && vcount_in < (y_in+8)))
        // use MSB 4 bits
        pixel_out <= {red_mapped[7:4],red_mapped[7:4],red_mapped[7:4]}; // greyscale
        //pixel_out <= {red_mapped[7:4], 8h'0}; // only red hues
        else pixel_out <= 0;
   end
endmodule
