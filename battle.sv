`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2021 03:19:36 AM
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


module battle(
input wire clk_in,
input wire [7:0] health_in,
input wire [7:0] xp_in,
input wire rst_in,         // 1 to initialize module
   input wire left_in,          // move left
   input wire right_in,         // move right
   input wire up_in,          // move up
   input wire down_in,         // move down
   input wire select,
   input wire start,
   input wire [10:0] hcount_in, // horizontal index of current pixel (0..1023)
   input wire [9:0]  vcount_in, // vertical index of current pixel (0..767)
   input wire [7:0] evol_count,
      
   output logic [11:0] pixel_out,  // game's pixel  // r=11:8, g=7:4, b=3:0

    output logic run,
    //output logic start_timer, 
    output logic [7:0] health_out,
    output logic [7:0] xp_out
    // output logic [3:0] state
    );
    logic turn;
    logic battle;
    logic [7:0] enemy_health;
    logic [11:0] player_pixel, enemy_pixel;
    logic [11:0] screen_pixel, blank_pixel;
    
    logic [10:0] enemy_health_change;
    logic [11:0] enemy_health_pixel;
    logic [7:0]enemy_sel_x,player_sel_x;
    logic enemy_sel_y,player_sel_y;
    logic [10:0] player_health_change;
    logic [11:0] player_health_pixel;
    logic [11:0] font_pixel;
    logic [9:0] arrow_x,arrow_y,font_x,font_y;
    logic [10:0] font_sel_x, font_sel_y;
    
    logic [32:0] counter;
    
    parameter PLAYER_DAMAGE=20;
    parameter ENEMY_DAMAGE=10;
    //parameter XP_GAIN=10;
    parameter RUN_X=432+72+48;
    parameter RUN_Y = 312+112+16;
    
    parameter FIGHT_X=432+72;
    parameter FIGHT_Y=312+112;
    
    logic[7:0] random_num;
    logic en;
    
    
    lfsr rng( .clk(clk_in), .rst(rst_in), .en(en), .q(random_num));
    
    logic init;
    
    //NAMES AND STATS
    logic char_count;
    
    logic [10:0] player_name_x[9:0]; //LIST OF LETTERS
    logic [10:0] player_name_y[9:0];
    poke_database player_data( .x_in(player_sel_x),
    .name_x(player_name_x),
    .name_y(player_name_y));
    
    
    
    always_ff @(posedge clk_in) begin
    if (rst_in) begin
        arrow_x<=FIGHT_X;
        arrow_y <= FIGHT_Y;
        turn<=1'b1;
        enemy_health<=7'd100;
        health_out<=health_in;
        battle<=0;
        enemy_health_change<=0;
        player_health_change<=0;
        run<= 0;
        counter <= 0;
        
        char_count <=0;
        
        enemy_sel_x <= 0;
        enemy_sel_y <= 0;
        player_sel_x <= 0;
        player_sel_y <= 0;
        en <= 1;
        init <= 1;
        xp_out<=xp_in;
    end else begin
    if (start) begin
     
     if (init) begin
        arrow_x<=FIGHT_X;
        arrow_y <= FIGHT_Y;
        turn<=1'b1;
        enemy_health<=7'd100;
        health_out<=7'd100;
        battle<=0;
        enemy_health_change<=0;
        player_health_change<=0;
        counter <= 0;
        init <= 0;
        run<= 0;  
         
     end
        
        enemy_sel_y <= 0;
        if({random_num[0],random_num[7],random_num[4],random_num[2]} <= 4'b1110) begin
            enemy_sel_x <= {random_num[0],random_num[7],random_num[4],random_num[2]};
            en <= 0;
        end
     
     
      
      if(hcount_in == 0 && vcount_in == 0) begin
        
        if (health_out>0 && enemy_health>0)begin
            if (turn) begin
                if (battle) begin
                    enemy_health<=enemy_health-PLAYER_DAMAGE;
                    enemy_health_change<=enemy_health_change+(PLAYER_DAMAGE/2);
                    
                    turn<=~turn;
                    battle<= 0;
                end else begin
                    if (left_in) begin
                            arrow_x<=FIGHT_X ;
                            
                    end
                    if (right_in)begin
                            arrow_x<= RUN_X;                          
                    end
                    if (up_in)begin
                            arrow_y<= FIGHT_Y;                          
                    end
                    if (down_in)begin
                            arrow_y<= RUN_Y;                          
                    end
                    if (select) begin
                        if (arrow_x==FIGHT_X && arrow_y == FIGHT_Y)begin
                            battle<=1;
                            
                            
                        end else if(arrow_x==RUN_X && arrow_y == RUN_Y) begin
                            battle<=0;
                            run<=1;
                            init<= 1;
                            en<=1;
                        end
                    end
                end
            end else begin
                counter <= counter +1;
                if(counter >= 32'd20) begin
                    health_out<=health_out-ENEMY_DAMAGE;
                    player_health_change<=player_health_change+(ENEMY_DAMAGE/2);
                    turn<=~turn;
                    counter <= 0;
                end
            end
       end else begin
        counter <= counter +1;
        if(counter >= 32'd15) begin
            run<=1;
            xp_out<=xp_in+50;
            counter <= 0;
            init<= 1;
            en<=1;

        end            
    
       end
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
                if (hcount_in > 432+8 && hcount_in <= 432+8+64 && vcount_in >= 312+40 && vcount_in < 312+40+64) begin

                pixel_out <= {player_pixel[11:8], player_pixel[7:4], player_pixel[3:0]};
                   
                end else if(hcount_in > 432+96 && hcount_in <= 432+96+56 && vcount_in >= 312 && vcount_in < 312+56 )begin
                
                pixel_out <= {enemy_pixel[11:8],enemy_pixel[7:4],enemy_pixel[3:0]};
                   
                end else if(hcount_in > arrow_x && hcount_in <= arrow_x+8 && vcount_in >= arrow_y && vcount_in < arrow_y+8)begin //DRAW SEL ARROW
                font_x <= arrow_x;
                font_y <= arrow_y;
                font_sel_x <= 117;
                font_sel_y <= 54;
                pixel_out <= {font_pixel[11:8],font_pixel[7:4],font_pixel[3:0]};
                
                
                end else if(hcount_in >= 432+80 && hcount_in < 432+80+8 && vcount_in >= 312+56 && vcount_in < 312+56+8)begin //PLAYER LETTER 1
                
                    font_x <= 432+80;
                    font_y <= 312+56;
                    font_sel_x <= 0;//player_name_x[0];
                    font_sel_y <= 0;//player_name_y[0];
                    pixel_out <= {font_pixel[11:8],font_pixel[7:4],font_pixel[3:0]};
                end else if(hcount_in >= 432+80+8 && hcount_in < 432+80+16 && vcount_in >= 312+56 && vcount_in < 312+56+8)begin //PLAYER LETTER 2
                
                    font_x <= 432+80+8;
                    font_y <= 312+56;
                    font_sel_x <= 1;//player_name_x[1];
                    font_sel_y <= 1;//player_name_y[1]; 
                    pixel_out <= {font_pixel[11:8],font_pixel[7:4],font_pixel[3:0]};                   
                end else if(hcount_in >= 432+80+16 && hcount_in < 432+80+24 && vcount_in >= 312+56 && vcount_in < 312+56+8)begin //PLAYER LETTER 3
                
                    font_x <= 432+80+16;
                    font_y <= 312+56;
                    font_sel_x <= 1;//player_name_x[2];
                    font_sel_y <= 1;//player_name_y[2];       
                    pixel_out <= {font_pixel[11:8],font_pixel[7:4],font_pixel[3:0]};
                end else if(hcount_in >= 432+80+24 && hcount_in < 432+80+32 && vcount_in >= 312+56 && vcount_in < 312+56+8)begin //PLAYER LETTER 4
                
                    font_x <= 432+80+24;
                    font_y <= 312+56;
                    font_sel_x <= 1;//player_name_x[3];
                    font_sel_y <= 1;//player_name_y[3];
                    pixel_out <= {font_pixel[11:8],font_pixel[7:4],font_pixel[3:0]}; 
                end else if(hcount_in >= 432+80+32 && hcount_in < 432+80+40 && vcount_in >= 312+56 && vcount_in < 312+56+8)begin //PLAYER LETTER 5
                
                    font_x <= 432+80+32;
                    font_y <= 312+56;
                    font_sel_x <= 1;//player_name_x[4];
                    font_sel_y <= 1;//player_name_y[4]; 
                    pixel_out <= {font_pixel[11:8],font_pixel[7:4],font_pixel[3:0]};  
                end else if(hcount_in >= 432+80+40 && hcount_in < 432+80+48 && vcount_in >= 312+56 && vcount_in < 312+56+8)begin //PLAYER LETTER 6
                
                    font_x <= 432+80+40;
                    font_y <= 312+56;
                    font_sel_x <= 1;//player_name_x[5];
                    font_sel_y <= 1;//player_name_y[5];                                           
                    pixel_out <= {font_pixel[11:8],font_pixel[7:4],font_pixel[3:0]};                                    

                end else if(hcount_in >= 432+80+48 && hcount_in < 432+80+56 && vcount_in >= 312+56 && vcount_in < 312+56+8)begin //PLAYER LETTER 7
                
                    font_x <= 432+80+48;
                    font_y <= 312+56;
                    font_sel_x <= 1;//player_name_x[6];
                    font_sel_y <= 1;//player_name_y[6];  
                    pixel_out <= {font_pixel[11:8],font_pixel[7:4],font_pixel[3:0]};
                end else if(hcount_in >= 432+80+56 && hcount_in < 432+80+64 && vcount_in >= 312+56 && vcount_in < 312+56+8)begin //PLAYER LETTER 8
                
                    font_x <= 432+80+56;
                    font_y <= 312+56;
                    font_sel_x <= 1;//player_name_x[7];
                    font_sel_y <= 1;//player_name_y[7];                                         
                    pixel_out <= {font_pixel[11:8],font_pixel[7:4],font_pixel[3:0]};   
                                                    
               end else if(hcount_in >= 432+80+64 && hcount_in < 432+80+72 && vcount_in >= 312+56 && vcount_in < 312+56+8)begin //PLAYER LETTER 9
                
                    font_x <= 432+80+64;
                    font_y <= 312+56;
                    font_sel_x <= 1;//player_name_x[8];
                    font_sel_y <= 1;//player_name_y[8];                           
                    pixel_out <= {font_pixel[11:8],font_pixel[7:4],font_pixel[3:0]};  
               end else if(hcount_in >= 432+80+72 && hcount_in < 432+80+80 && vcount_in >= 312+56 && vcount_in < 312+56+8)begin //PLAYER LETTER 10
                
                    font_x <= 432+80+72;
                    font_y <= 312+56;
                    font_sel_x <= 1;//player_name_x[9];
                    font_sel_y <= 1;//player_name_y[9];    
                    pixel_out <= {font_pixel[11:8],font_pixel[7:4],font_pixel[3:0]};                                      

                
                end else if( enemy_health_pixel > 0 )begin
                pixel_out <= {enemy_health_pixel[11:8],enemy_health_pixel[7:4],enemy_health_pixel[3:0]};
                
                end else if( player_health_pixel > 0 )begin
                pixel_out <= {player_health_pixel[11:8],player_health_pixel[7:4],player_health_pixel[3:0]};
                
                end else if( blank_pixel > 0 )begin
                pixel_out <= {blank_pixel[11:8],blank_pixel[7:4],blank_pixel[3:0]};
                
                end else begin                
                pixel_out <= {screen_pixel[11:8],screen_pixel[7:4],screen_pixel[3:0]};

                end

      end
    end
    
   
    

   battle_back_sprite scrn(.pixel_clk_in(clk_in),.x_in(432),.y_in(312),.hcount_in(hcount_in),.vcount_in(vcount_in), //BACKGROUND SPRITE
   .pixel_out(screen_pixel));
    

    front_sprites enemy(.pixel_clk_in(clk_in),.x_in(432+96),.y_in(312),.sprite_sel_x(56*enemy_sel_x),.sprite_sel_y(0), //ENEMY SPRITE
    .hcount_in(hcount_in),.vcount_in(vcount_in), .pixel_out(enemy_pixel));
             
    back_sprites player(.pixel_clk_in(clk_in),.x_in(432+8),.y_in(312+40),.sprite_sel_x(64*(player_sel_x+evol_count)+2*(player_sel_x+evol_count+1)),.sprite_sel_y(2), //PLAYER SPRITE
    .hcount_in(hcount_in),.vcount_in(vcount_in), .pixel_out(player_pixel));
             
    moving_blob #(.WIDTH(48),.HEIGHT(2),.COLOR(12'h0F0))   // green ENEMY HEALTH
     enemy_health_blob(.x_in(432+33),.y_in(312+19),.hcount_in(hcount_in),.vcount_in(vcount_in),
             .change_x(enemy_health_change),.pixel_out(enemy_health_pixel));
         
       moving_blob #(.WIDTH(48),.HEIGHT(2),.COLOR(12'h0F0))   // green PLAYER HEALTH
       player_health(.x_in(432+97),.y_in(312+75),.hcount_in(hcount_in),.vcount_in(vcount_in),
                  .change_x(player_health_change),.pixel_out(player_health_pixel)); 

 
     font_sprites font(.pixel_clk_in(clk_in),.x_in(font_x),.y_in(font_y),.sprite_sel_x(font_sel_x),.sprite_sel_y(font_sel_y), //SELECT ARROW
    .hcount_in(hcount_in),.vcount_in(vcount_in), .pixel_out(font_pixel));
    
    
    // ERASE BACKGROUND TEMPLATE COLORS
    blob #(.WIDTH(8),.HEIGHT(8),.COLOR(12'hFFF)) white1(.x_in(FIGHT_X), .y_in(FIGHT_Y), .hcount_in(hcount_in),
    .vcount_in(vcount_in), .pixel_out(blank_pixel));
//    blob #(.WIDTH(8),.HEIGHT(8),.COLOR(12'hFFF)) white2(.x_in(FIGHT_X), .y_in(RUN_Y), .hcount_in(hcount_in),
//    .vcount_in(vcount_in), .pixel_out(blank_pixel));
//    blob #(.WIDTH(8),.HEIGHT(8),.COLOR(12'hFFF)) white3(.x_in(RUN_X), .y_in(FIGHT_Y), .hcount_in(hcount_in),
//    .vcount_in(vcount_in), .pixel_out(blank_pixel));
//    blob #(.WIDTH(8),.HEIGHT(8),.COLOR(12'hFFF)) white4(.x_in(RUN_X), .y_in(RUN_Y), .hcount_in(hcount_in),
//    .vcount_in(vcount_in), .pixel_out(blank_pixel));  
    
    //LONGER BARS
//    blob #(.WIDTH(80),.HEIGHTl(8),.COLOR(12'hFFF)) white5(.x_in(8), .y_in(0), .hcount_in(hcount_in),
//    .vcount_in(vcount_in), .pixel_out(blank_pixel));
    
//    blob #(.WIDTH(8),.HEIGHT(8),.COLOR(12'hFFF)) white6(.x_in(RUN_X), .y_in(RUN_Y), .hcount_in(hcount_in),
//    .vcount_in(vcount_in), .pixel_out(blank_pixel));    
      
    
    
             
endmodule






