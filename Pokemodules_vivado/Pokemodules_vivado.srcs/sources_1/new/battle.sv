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

module battle(input wire clk_in,input wire run,input wire [7:0] health_in,

    output logic battle, output logic [7:0] health_out);
    logic turn;
    logic [7:0] enemy_health;
    logic battle_start=1'b0;
    parameter PLAYER_DAMAGE=30;
    parameter ENEMY_DAMAGE=20;
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
    end
    
    end
    end
endmodule
