`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2021 03:48:20 AM
// Design Name: 
// Module Name: level_up
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


module level_up(input wire clk_in, input wire xp_in, input wire hp_in, input wire level_in,
output logic [7:0] xp_out, output logic [7:0]hp_out, output logic level_out, output logic evolve

    );
logic [7:0]max_xp=30;
logic [7:0]max_hp=30;
logic [7:0]evolve_level=20;
logic [7:0]increase_hp=2;
logic [7:0] increase_xp=5;
always_ff @(posedge clk_in) begin
    if (xp_in>=max_xp)begin
        level_out<=level_in+1;
        xp_out<=0;
        max_hp<=max_hp+increase_hp;
        hp_out<=max_hp+increase_hp;
        max_xp<=max_hp+increase_xp;
        increase_xp<=increase_xp+10;
    end
    evolve<=(level_out==evolve_level)?1:0;
end
endmodule
