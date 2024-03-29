`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2021 05:27:37 PM
// Design Name: 
// Module Name: poke_game
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







module poke_game(
   input wire vclk_in,        // 65MHz clock
   input wire rst_in,         // 1 to initialize module
   input wire up_in,            // move up
   input wire down_in,          // move down
   input wire left_in,          // move left
   input wire right_in,         // move right
   input wire sel_in,
   
   input wire [10:0] hcount_in, // horizontal index of current pixel (0..1023)
   input wire [9:0]  vcount_in, // vertical index of current pixel (0..767)
   input wire hsync_in,         // XVGA horizontal sync signal (active low)
   input wire vsync_in,         // XVGA vertical sync signal (active low)
   input wire blank_in,         // XVGA blanking (1 means output black pixel)
      
   output logic phsync_out,       // game's horizontal sync
   output logic pvsync_out,       // game's vertical sync
   output logic pblank_out,       // game's blanking
   output logic [11:0] pixel_out  // game's pixel  // r=11:8, g=7:4, b=3:0

    );
    //OVERWORLD
    logic [11:0]screen_pixel, sheet_pixel;
    logic [11:0]char_pixel;
    //BATTLE
    logic [11:0] battle_pixel;

    
    logic [10:0] map_x;
    logic [9:0] map_y;
    logic battle_trigger;
    
    logic OVERWORLD;
    logic BATTLE;
    logic TRANSITION;
    logic EVOLUTION;
    
    logic start_over;
    logic start_battle;
    
    logic [5:0] sprite_sel_x,sprite_sel_y;
    
    player_controller contr(.vclk(vclk_in), .reset(rst_in), .hcount(hcount_in), .vcount(vcount_in), 
    .up(up_in), .down(down_in), .left(left_in), .right(right_in), .start(start_over),
    .map_x(map_x), .map_y(map_y), .battle_trigger(battle_trigger),.sprite_sel_x(sprite_sel_x),.sprite_sel_y(sprite_sel_y));
    
    //logic [7:0] health_in;
    logic overworld_trigger;
    logic [7:0] health_out;
    logic [7:0] xp_in,xp_out;
    logic [7:0] evol_count;
    battle bat(.clk_in(vclk_in),.rst_in(rst_in),.health_in(7'd100), 
    .left_in(left_in), .right_in(right_in),.up_in(up_in),.down_in(down_in), .select(sel_in), .start(start_battle),.evol_count(evol_count),
    .hcount_in(hcount_in), .vcount_in(vcount_in), .xp_in(xp_in),
      
   .pixel_out(battle_pixel),  
   .run(overworld_trigger),
    //output logic start_timer, 
   .health_out(health_out),.xp_out(xp_out));
    //output logic [7:0] xp_out,
    // output logic [3:0] state

logic [11:0] trans_pixel;
logic start_trans;
logic done_trigger;
battle_transition bat_trans(.clk_in(vclk_in), .rst_in(rst_in),.start(start_trans), .hcount(hcount_in),
 .vcount(vcount_in),.pixel_out(trans_pixel),.done(done_trigger));
logic [11:0] evolve_pixel;
logic start_ev;
logic done_ev;
logic [7:0] xp_req;
evolve ev(.clk_in(vclk_in), .rst_in(rst_in),.start(start_ev),.select(sel_in), .hcount_in(hcount_in),
 .vcount_in(vcount_in),.sprite_in(evol_count),.pixel_out(evolve_pixel),.done(done_ev));
    always_ff @(posedge vclk_in) begin
        if(rst_in) begin
            phsync_out <= hsync_in;
            pvsync_out <= vsync_in;
            pblank_out <= blank_in;
            
            pixel_out <= {screen_pixel[11:8], screen_pixel[7:4], screen_pixel[3:0]};
            
            OVERWORLD <= 1;
            TRANSITION <= 0;
            BATTLE <= 0;
            start_over <= 1;
            start_battle <= 0;
            start_trans <= 0;
            xp_in<=0;
            xp_req<=8'd49;
            
            EVOLUTION <= 0;
            start_ev <= 0;
            evol_count <=0;
            
        end else begin
              
            phsync_out <= hsync_in;
            pvsync_out <= vsync_in;
            pblank_out <= blank_in;
            
            


            
            if (battle_trigger) begin
                OVERWORLD <= 0;
                TRANSITION <= 1;
                BATTLE <= 0;
                start_trans <= 1;            
                start_battle <=0;
                start_over <= 0;
            end
            
            
//           if(xp_out>=8'd49) begin
//              OVERWORLD <= 0;
//                TRANSITION <= 0;
//                BATTLE <= 1;
//                start_battle <= 1;
//                start_trans <= 0;
//                start_over <= 0;
//           end
           if(done_trigger) begin
                OVERWORLD <= 0;
                TRANSITION <= 0;
                BATTLE <= 1;
                start_battle <= 1;
                start_trans <= 0;
                start_over <= 0;
            end
            
            if (overworld_trigger) begin
                xp_in <= xp_out;
                if(xp_out>=xp_req) begin
                    xp_req<=200;
                    xp_in<=0;
                    start_ev<=1;
                    EVOLUTION<=1;
                    OVERWORLD <= 0;
                    TRANSITION <= 0;
                    BATTLE <= 0;
                    start_battle <= 0;
                    start_trans <= 0;
                    start_over <= 0;
                    evol_count <= evol_count +1;
                end else begin
                    
                    OVERWORLD <= 1;
                    EVOLUTION<=0;
                    start_ev<=0;
                    TRANSITION <= 0;
                    BATTLE <= 0;
                    start_battle <= 0;
                    start_trans <= 0;
                    start_over <= 1;
                
                end
            end
            
            if (done_ev) begin
                    
                    OVERWORLD <= 1;
                    EVOLUTION<=0;
                    start_ev<=0;
                    TRANSITION <= 0;
                    BATTLE <= 0;
                    start_battle <= 0;
                    start_trans <= 0;
                    start_over <= 1;            
            end
            

         
//            else if (overworld_trigger) begin
//                OVERWORLD <= 1;
//                TRANSITION <= 0;
//                BATTLE <= 0;
//                start_battle <= 0;
//                start_trans <= 0;
//                start_over <= 1;
                
//            end
            
            if (TRANSITION) begin
                
                
                if(hcount_in >= 432 && hcount_in <= 592 && vcount_in >= 312 && vcount_in <= 455) begin  
                    if (trans_pixel > 0) begin
                        pixel_out <= trans_pixel;
                    end else begin
                    
                        if (sheet_pixel > 0) begin
                        
                            pixel_out <= {sheet_pixel[11:8] , sheet_pixel[7:4] ,sheet_pixel[3:0] };
                        end else begin
                            pixel_out <= {screen_pixel[11:8] , screen_pixel[7:4] , screen_pixel[3:0] }; 
                         
                        end
                    end
                   
                end else begin
                      pixel_out <= blank_in;
                end
            end
            
            
            if (OVERWORLD) begin  //OVERWORLD PIXEL OUTPUT
                if(hcount_in >= 432 && hcount_in <= 592 && vcount_in >= 312 && vcount_in <= 455) begin  //Show in gameboy window
                
                    if (sheet_pixel > 0) begin
                        
                        pixel_out <= {sheet_pixel[11:8] , sheet_pixel[7:4] ,sheet_pixel[3:0] };
                    end else begin
                        pixel_out <= {screen_pixel[11:8] , screen_pixel[7:4] , screen_pixel[3:0] }; 
                         
                    end
                   
                end else begin
                        pixel_out <= blank_in;
                end
            end
            
            if (BATTLE)  begin //BATTLE PIXEL OUTPUT

               
               pixel_out <= battle_pixel;
               
            end
            if (EVOLUTION) begin
            if(hcount_in >= 432 && hcount_in <= 592 && vcount_in >= 312 && vcount_in <= 455) begin  
                    
               pixel_out <= evolve_pixel;

            end else begin
               pixel_out <= blank_in;
            end
            end
             
        
        end
    end
    
    


    //OVERWORLD BLOBS
    
    picture_blob2 sheet(.pixel_clk_in(vclk_in),.x_in(496),.y_in(376),.sprite_sel_x(sprite_sel_x),.sprite_sel_y(sprite_sel_y),.hcount_in(hcount_in),.vcount_in(vcount_in), .pixel_out(sheet_pixel));
    
    picture_blob level(.pixel_clk_in(vclk_in),.x_in(map_x),.y_in(map_y),.hcount_in(hcount_in),.vcount_in(vcount_in), .pixel_out(screen_pixel));

    //blob #(.WIDTH(16),.HEIGHT(16),.COLOR(12'hF00)) ch(.x_in(500), .y_in(376), .hcount_in(hcount_in),
    //.vcount_in(vcount_in), .pixel_out(char_pixel));
    

 
endmodule



