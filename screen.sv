`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2021 05:52:32 PM
// Design Name: 
// Module Name: screen
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

module window
   #(parameter WIDTH = 160,            // default width: 160 pixels
               HEIGHT = 144,           // default height: 144 pixels
               COLOR = 12'hFFF)  // default color: white
   (input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   always_comb begin
      if  ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) &&
            (vcount_in >= y_in && vcount_in < (y_in+HEIGHT)))
        pixel_out = COLOR;
      else 
        pixel_out = 0;
   end
endmodule