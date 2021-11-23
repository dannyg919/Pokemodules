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

module blob
   #(parameter WIDTH = 64,            // default width: 64 pixels
               HEIGHT = 64,           // default height: 64 pixels
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

module battle(input wire clk_in,input wire run,input wire [7:0] health_in,input wire [7:0] xp_in,
input wire rst_in,         // 1 to initialize module
   input wire left_in,          // move left
   input wire right_in,         // move right
   
   input wire [10:0] hcount_in, // horizontal index of current pixel (0..1023)
   input wire [9:0]  vcount_in, // vertical index of current pixel (0..767)
   input wire hsync_in,         // XVGA horizontal sync signal (active low)
   input wire vsync_in,         // XVGA vertical sync signal (active low)
   input wire blank_in,         // XVGA blanking (1 means output black pixel)
      
   output logic phsync_out,       // game's horizontal sync
   output logic pvsync_out,       // game's vertical sync
   output logic pblank_out,       // game's blanking
   output logic [11:0] pixel_out,  // game's pixel  // r=11:8, g=7:4, b=3:0

    output logic battle, output logic start_timer, output logic [7:0] health_out, output logic [7:0] xp_out, output logic [3:0] state);
    logic turn;
    logic [7:0] enemy_health;
    logic battle_start=1'b0;
    //logic [9:0] player_y;
    logic [11:0] player_pixel;
    //logic [10:0] player_x;
    
    logic [9:0] enemy_y;
    logic [11:0] enemy_pixel;
    logic [10:0] enemy_x;
    
    logic [10:0] enemy_health_x;
    logic [9:0] enemy_health_y;
    logic [11:0] enemy_health_pixel;
    logic [10:0] player_health_x;
    logic [9:0] player_health_y;
    logic [11:0] player_health_pixel;
    parameter PLAYER_DAMAGE=10;
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
            end
    end else begin
        battle<=0;
        start_timer<=1;
        state<=4'b010;
        xp_out<=xp_in+XP_GAIN;
    end
    if (start_timer) begin
         start_timer<=0; //make sure this is 0 if it is 1 after every clock cycle so that it doesnt keep restarting clock
    end
     pixel_out <= {player_pixel[11:8] + enemy_pixel[11:8]+ player_health_pixel[11:8]+enemy_health_pixel[11:8],
                        player_pixel[7:4] + enemy_pixel[7:4] + player_health_pixel[7:4]+enemy_health_pixel[7:4],
                        player_pixel[3:0] + enemy_pixel[3:0] + player_health_pixel[3:0]+enemy_health_pixel[3:0]};
    end
   
    
    blob #(.WIDTH(56),.HEIGHT(56),.COLOR(12'h00F))   // blue!
     player(.x_in(432+14),.y_in(312+144-40-14-56),.hcount_in(hcount_in),.vcount_in(vcount_in),
             .pixel_out(player_pixel));
    
    blob #(.WIDTH(56),.HEIGHT(56),.COLOR(12'hF00))   // red!
     enemy(.x_in(432+160-14-56),.y_in(312+10),.hcount_in(hcount_in),.vcount_in(vcount_in),
             .pixel_out(enemy_pixel));
             
    blob #(.WIDTH(50),.HEIGHT(10),.COLOR(12'h0F0))   // green
     player_health(.x_in(432+14),.y_in(312+10),.hcount_in(hcount_in),.vcount_in(vcount_in),
             .pixel_out(player_health_pixel));
             
        
       blob #(.WIDTH(50),.HEIGHT(10),.COLOR(12'h0F0))   // green
     enemy_health_blob(.x_in(432+160-14-50),.y_in(312+144-40-14-10),.hcount_in(hcount_in),.vcount_in(vcount_in),
             .pixel_out(enemy_health_pixel));     
endmodule


