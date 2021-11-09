`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2021 03:16:04 AM
// Design Name: 
// Module Name: battle
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

module battle(input wire clk_in,input wire run,input wire [7:0] health_in,input wire [7:0] xp_in,

    output logic battle, output logic start_timer, output logic [7:0] health_out, output logic [7:0] xp_out, output logic [3:0] state);
    logic turn;
    logic [7:0] enemy_health;
    logic battle_start=1'b0;
    parameter PLAYER_DAMAGE=15;
    parameter ENEMY_DAMAGE=5;
    parameter XP_GAIN=10;
    always_ff @(posedge clk_in) begin
    battle<=run?0:1;
    if (!battle_start) begin
        turn<=1'b1;
        enemy_health=7'd100;
        health_out<=health_in;
        battle_start<=1;
        
    end
    if (health_out>0 && enemy_health>0)begin 
        if (battle) begin
            if (turn) begin
                health_out<=health_out-ENEMY_DAMAGE;
            end else begin
                enemy_health<=enemy_health-PLAYER_DAMAGE;
            end
            turn<=~turn;
    end else begin
        battle<=0;
        start_timer<=1;
        state<=4'b010;
        xp_out<=xp_in+XP_GAIN;
    end
    if (start_timer) begin
         start_timer<=0; //make sure this is 0 if it is 1 after every clock cycle so that it doesnt keep restarting clock
    end
    end
    end
endmodule
