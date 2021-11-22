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
    
    logic [11:0]screen_pixel;
    logic [11:0]char_pixel;
    
    logic [10:0] player_x;
    logic [9:0] player_y;
    
    
    player_controller contr(.vclk(vclk_in), .reset(rst_in), .hcount(hcount_in), .vcount(vcount_in), 
    .up(up_in), .down(down_in), .left(left_in), .right(right_in),
    .player_x(player_x), .player_y(player_y));
    
    
    always_ff @(posedge vclk_in) begin
        if(rst_in) begin
            phsync_out <= hsync_in;
            pvsync_out <= vsync_in;
            pblank_out <= blank_in;
            
            pixel_out <= {screen_pixel[11:8], screen_pixel[7:4], screen_pixel[3:0]};
        end else begin
              
            phsync_out <= hsync_in;
            pvsync_out <= vsync_in;
            pblank_out <= blank_in;
            
            if(hcount_in == 0 && vcount_in == 0) begin //Update per frame
            end
            
            if(char_pixel > 0) begin
                pixel_out <= {char_pixel[11:8], char_pixel[7:4], char_pixel[3:0]};
            end else begin
                  pixel_out <= {screen_pixel[11:8], screen_pixel[7:4] , screen_pixel[3:0]};  
            end
                
            
             
        
        end
    end
    
    logic [5:0] tile;

    
    picture_blob level(.pixel_clk_in(vclk_in),.x_in(0),.y_in(0),.hcount_in(hcount_in),.vcount_in(vcount_in), .pixel_out(screen_pixel));
    
    
    blob #(.WIDTH(16),.HEIGHT(16),.COLOR(12'hF00)) ch(.x_in(player_x), .y_in(player_y), .hcount_in(hcount_in),
    .vcount_in(vcount_in), .pixel_out(char_pixel));
    
    //window win(.x_in(0),.y_in(0),.hcount_in(hcount_in),.vcount_in(vcount_in),
            //.pixel_out(screen_pixel));
    




    
endmodule



