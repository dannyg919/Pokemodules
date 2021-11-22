`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2021 02:08:46 AM
// Design Name: 
// Module Name: levelrom
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


module levelrom(
    input wire vclock,
    input wire [7:0]world_column,
    input wire [3:0]world_row,
    output logic [5:0]tile);
   
    level_rom lrom(.addra({world_column[7:4],world_row, world_column[3:0]}), .douta(tile)); 
    
endmodule
