`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2021 03:05:59 PM
// Design Name: 
// Module Name: lsfr
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


module lfsr(
input wire clk, rst, en, 
output logic [7:0] q);

  always @(posedge clk or posedge rst) begin
    if (rst)
      q <= 8'b1101_1010; // can be anything except zero
    else if (en)
      q <= {q[6:0], q[7] ^ q[5] ^ q[4] ^ q[3]}; // polynomial for maximal LFSR
  end
endmodule
