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
   
   output logic [10:0]player_x,
   output logic [9:0]player_y
    );
    
    logic [32:0]wait_counter = 0;
    
    always_ff @(posedge vclk) begin
        if (reset) begin
            player_x <= 0;
            player_y <= 80;
            wait_counter <= 0;
        end else begin
            wait_counter <= wait_counter + 1;
            if(hcount == 0 && vcount == 0) begin
                
                      
                    if(up) begin
                       
                       player_y <= player_y - 16;
          
                    end
                    
                    if(down) begin
                        player_y <= player_y + 16;
                    end
                    
                    if(left) begin
                        player_x <= player_x -16;
                    end
                    
                    if(right) begin
                        player_x  <= player_x +16;
                    end
                
            end
                    
        end
        
     end   
    
endmodule
