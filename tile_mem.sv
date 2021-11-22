`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/08/2021 04:32:30 PM
// Design Name: 
// Module Name: tile_mem
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


module tile_mem( 
    input wire vclock,
    input wire rst,
    input wire tile_index,
    input wire tile_row,
    input wire tile_col,
    
    output logic tile_pixel,
    output logic tile_type,
    output logic tile_transparent
   
    );
    
    tile_rom tilemem(
    
    .clka(vclock),
    
    .addra({tile_index, tile_row, tile_col}),
    
    .douta({tile_pixel, tile_type, tile_transparent})
    
    
    );
    
endmodule
