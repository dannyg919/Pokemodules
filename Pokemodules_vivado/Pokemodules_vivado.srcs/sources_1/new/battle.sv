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
   (input wire [10:0] x_in,hcount_in,change_x,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   always_comb begin
      if  ((hcount_in >= x_in && hcount_in < (x_in+WIDTH-change_x)) &&
            (vcount_in >= y_in && vcount_in < (y_in+HEIGHT)))
        pixel_out = COLOR;
      else 
        pixel_out = 0;
   end
endmodule

module battle(
input wire clk_in,
input wire [7:0] health_in,
//input wire [7:0] xp_in,
input wire rst_in,         // 1 to initialize module
   input wire left_in,          // move left
   input wire right_in,         // move right
   input wire select,
   input wire [10:0] hcount_in, // horizontal index of current pixel (0..1023)
   input wire [9:0]  vcount_in, // vertical index of current pixel (0..767)
   input wire hsync_in,         // XVGA horizontal sync signal (active low)
   input wire vsync_in,         // XVGA vertical sync signal (active low)
   input wire blank_in,         // XVGA blanking (1 means output black pixel)
      
   output logic phsync_out,       // game's horizontal sync
   output logic pvsync_out,       // game's vertical sync
   output logic pblank_out,       // game's blanking
   output logic [11:0] pixel_out,  // game's pixel  // r=11:8, g=7:4, b=3:0

    output logic run,
    //output logic start_timer, 
    output logic [7:0] health_out
    //output logic [7:0] xp_out,
    // output logic [3:0] state
    );
    logic turn;
    logic battle;
    logic [7:0] enemy_health;
    logic [11:0] player_pixel;
    logic [11:0] enemy_pixel;
    
    logic [10:0] enemy_health_change;
    logic [11:0] enemy_health_pixel;
    logic [10:0] player_health_change;
    logic [11:0] player_health_pixel;
    logic [11:0] run_pixel,fight_pixel,menu_pixel,arrow_pixel;
    logic [9:0] arrow_x;
    parameter PLAYER_DAMAGE=20;
    parameter ENEMY_DAMAGE=10;
    //parameter XP_GAIN=10;
    parameter RUN_POS=432+16+40+8;
    parameter FIGHT_POS=432+8;
    
    always_ff @(posedge clk_in) begin
    if (rst_in) begin
        arrow_x<=FIGHT_POS;
        turn<=1'b1;
        enemy_health=7'd100;
        health_out<=health_in;
        battle<=0;
        enemy_health_change<=50;
        player_health_change<=50;
    end else begin
    if (health_out>0 && enemy_health>0)begin
        if (turn) begin
            if (battle) begin
                enemy_health<=enemy_health-PLAYER_DAMAGE;
                enemy_health_change<=enemy_health_change-(PLAYER_DAMAGE/2);
                turn<=~turn;
            end else begin
                if (left_in) begin
                        arrow_x<=FIGHT_POS;
                end
                if (right_in)begin
                        arrow_x<=RUN_POS;
                end
                if (select) begin
                    if (arrow_x==FIGHT_POS)begin
                        battle<=1;
                    end else begin
                        battle<=0;
                        run<=1;
                    end
                end
            end
        end else begin
            health_out<=health_out-ENEMY_DAMAGE;
            player_health_change<=player_health_change-(ENEMY_DAMAGE/2);
            turn<=~turn;
        end
   end else begin
    run<=1;
   end
//    if (!battle_start) begin
//        turn<=1'b1;
//        enemy_health=7'd100;
//        health_out<=health_in;
//        battle_start<=1;
        
//    end
//    if (health_out>0 && enemy_health>0)begin 
//        if (battle) begin
//            if (turn) begin
//                health_out<=health_out-ENEMY_DAMAGE;
//            end else begin
//                enemy_health<=enemy_health-PLAYER_DAMAGE;
//            end
//            turn<=~turn;
//            end
//    end else begin
//        battle<=0;
//        start_timer<=1;
//        state<=4'b010;
//        xp_out<=xp_in+XP_GAIN;
//    end
//    if (start_timer) begin
//         start_timer<=0; //make sure this is 0 if it is 1 after every clock cycle so that it doesnt keep restarting clock
//    end
    end
     pixel_out <= {player_pixel[11:8] + enemy_pixel[11:8]+ player_health_pixel[11:8]+enemy_health_pixel[11:8]+run_pixel[11:8]+fight_pixel[11:8]+menu_pixel[11:8]+arrow_pixel[11:8],
                        player_pixel[7:4] + enemy_pixel[7:4] + player_health_pixel[7:4]+enemy_health_pixel[7:4]+run_pixel[7:4]+fight_pixel[7:4]+menu_pixel[7:4]+arrow_pixel[7:4],
                        player_pixel[3:0] + enemy_pixel[3:0] + player_health_pixel[3:0]+enemy_health_pixel[3:0]+run_pixel[3:0]+fight_pixel[3:0]+menu_pixel[3:0]+arrow_pixel[3:0]};
    end
   
    
    blob #(.WIDTH(32),.HEIGHT(32),.COLOR(12'h00F))   // blue!
     player(.x_in(432+14),.y_in(312+144-40-14-32),.hcount_in(hcount_in),.vcount_in(vcount_in),
             .pixel_out(player_pixel));
    
    blob #(.WIDTH(56),.HEIGHT(56),.COLOR(12'hF00))   // red!
     enemy(.x_in(432+160-14-56),.y_in(312+10),.hcount_in(hcount_in),.vcount_in(vcount_in),
             .pixel_out(enemy_pixel));
             
    blob #(.WIDTH(50),.HEIGHT(10),.COLOR(12'h0F0))   // green
     player_health(.x_in(432+14),.y_in(312+10),.hcount_in(hcount_in),.vcount_in(vcount_in),
             .change_x(player_health_change),.pixel_out(player_health_pixel));
             
        
       blob #(.WIDTH(50),.HEIGHT(10),.COLOR(12'h0F0))   // green
     enemy_health_blob(.x_in(432+160-14-50),.y_in(312+144-40-14-10),.hcount_in(hcount_in),.vcount_in(vcount_in),
             .change_x(enemy_health_change),.pixel_out(enemy_health_pixel)); 
        blob #(.WIDTH(40),.HEIGHT(8),.COLOR(12'hFF0))   // yellow
     fight(.x_in(432+16),.y_in(312+144-16-8),.hcount_in(hcount_in),.vcount_in(vcount_in),
             .pixel_out(fight_pixel));   
        blob #(.WIDTH(24),.HEIGHT(8),.COLOR(12'hF00))   // red
     run_blob(.x_in(432+16+40+16),.y_in(312+144-16-8),.hcount_in(hcount_in),.vcount_in(vcount_in),
             .pixel_out(run_pixel)); 
      blob #(.WIDTH(160),.HEIGHT(40),.COLOR(12'hFFF))   // green
     menu(.x_in(432),.y_in(312+144-40),.hcount_in(hcount_in),.vcount_in(vcount_in),
             .pixel_out(menu_pixel));   
      blob #(.WIDTH(8),.HEIGHT(8),.COLOR(12'h000))   // black
     arrow(.x_in(432+8),.y_in(312+144-16-8),.hcount_in(hcount_in),.vcount_in(vcount_in),
             .pixel_out(arrow_pixel));   
endmodule


