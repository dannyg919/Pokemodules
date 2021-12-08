`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2021 03:21:15 AM
// Design Name: 
// Module Name: evolve
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


module evolve(input wire clk_in, input wire rst_in,
input wire expired,
input wire evolve,
input wire [5:0] sprite_in,
output logic [5:0] sprite_out

    );
    always_ff @(posedge clk_in) begin
        if (rst_in) begin
            sprite_out<=sprite_in;
        end else begin
            if (evolve) begin
                sprite_out<=sprite_in+1;
                if (!expired) begin
                    //animation
                end
            end
        
        end
   end
endmodule
