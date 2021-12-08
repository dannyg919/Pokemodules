`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2021 11:51:04 AM
// Design Name: 
// Module Name: player_controller
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


module player_controller(
   input wire vclk,
   input wire reset,
   input wire [10:0] hcount,
   input wire [9:0] vcount,
   input wire up,            // move up
   input wire down,          // move down
   input wire left,          // move left
   input wire right,         // move right
   
   input wire start,
   
   output logic [10:0]map_x,
   output logic [9:0]map_y,
   output logic battle_trigger,
   output logic [5:0] sprite_sel_x,sprite_sel_y
   
    );
    
    logic [32:0]count = 0;
    logic [32:0]walk_count = 0;
    logic [32:0]count_trans = 0;
    
    always_ff @(posedge vclk) begin
        if (reset) begin
            map_x <= 432;
            map_y <= 312;
            battle_trigger <= 0;
            count_trans <= 0;
            count <= 0;
            walk_count <= 0;
            sprite_sel_x <= 0;
            sprite_sel_y <= 0;
            
        end else begin
            if(start) begin
            
                if (battle_trigger) begin
                battle_trigger <= 0;
                end
                

                //CHECK IF IN GRASS (grass spot bottom left)
                if (map_x <= 416 && map_x > 368 && map_y <= 280 && map_y > 248 ) begin
                    count_trans <= count_trans +1;
                    if (count_trans >= 32'd65_000_000) begin
                        battle_trigger <= 1;
                        count_trans <= 0;
                    end
                end
                
                //Update per frame
                if(hcount == 0 && vcount == 0) begin
                    if (walk_count >= 32'd15) begin
                        sprite_sel_x <= 0;
                        walk_count <= 0;
                    end
                    walk_count <= walk_count + 1;
                    
                    if(up) begin
                       sprite_sel_y <= 16;
                       count<= count + 1;
                       if (count >= 32'd15) begin   
                            map_y <= map_y + 16;
                            count <= 0;
                       end
                    end
                    
                    if(down) begin
                        sprite_sel_y <= 0;
                        count<= count + 1;
                        if (count >= 32'd15) begin
                            map_y <= map_y - 16;
                            count <= 0;
                       end
                    end
                    
                    if(left) begin
                        sprite_sel_y <= 32;
                        count<= count + 1;
                        if (count >= 32'd15) begin
                            sprite_sel_x <= 16;
                            map_x <= map_x +16;
                            count <= 0;
                       end
                    end
                    
                    if(right) begin
                        sprite_sel_y <= 48;
                        count<= count + 1;
                        if (count >= 32'd15) begin
                            sprite_sel_x <= 16;
                            map_x  <= map_x -16;
                            count <= 0;
                        end
                   end 
                   
                end  
                       
            end
                      
        end
        
     end 
     
       
    
endmodule
