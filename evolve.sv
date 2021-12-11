`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2021 09:55:56 AM
// Design Name: 
// Module Name: evolve
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


module evolve(input wire clk_in, input wire rst_in,input wire select,
input wire [10:0] hcount_in, // horizontal index of current pixel (0..1023)
input wire [9:0]  vcount_in, // vertical index of current pixel (0..767)
//input wire expired,
input wire start,
input wire [7:0] sprite_in,

output logic [11:0] pixel_out,
output logic done
    );
    logic [11:0] evolved_pixel;
    logic [7:0] evolve_sel_x;
    
    logic [32:0] counter;
    logic [32:0] count;
    logic [32:0] total_counter;
    
    logic init;
    logic val;
    logic temp;
    always_ff @(posedge clk_in) begin
        if (rst_in) begin
            //sprite_out<=sprite_in;
            done<=0;
            evolve_sel_x <= 0;
            pixel_out <=0;
            init <= 1;
            val <= 0;
            temp <= sprite_in;
        end else begin
           //
           
            if (start) begin
                if (done) begin
                done <= 0;
                end
                
                if(init) begin
                    count <= 0;
                    init <= 0;
                end
                
                if(hcount_in == 0 && vcount_in == 0) begin
                
                if (count>= 10'd100) begin
                    if(select)begin
                    done <= 1;
                    count <= 0;
                    end
                    //sprite_out <= sprite_in +1;
                end else begin
                    count <= count + 1;
                    
                    if (count % 10 == 0) begin
                    val <= ~val;
                    
                    evolve_sel_x <= temp+val;
                    end
                    
                end
            
                
                end
                
                    //sprite_out<=sprite_in+1;
                if (hcount_in > 432+52 && hcount_in <= 432+52+56 && vcount_in >= 312+20 && vcount_in < 312+20+56) begin
                    if(evolve_sel_x) begin
                        pixel_out <= {evolved_pixel[11:8],evolved_pixel[7:4],evolved_pixel[3:0]};
                    end else begin 
                        pixel_out <= {evolved_pixel[11:8],evolved_pixel[7:4],evolved_pixel[3:0]};
                    end
                end  
             end     
                   
        end
            
     end   
      
                    front_sprites original(.pixel_clk_in(clk_in),.x_in(432+52),.y_in(312+20),.sprite_sel_x(56*(evolve_sel_x+sprite_in-1)),.sprite_sel_y(0), //evolved SPRITE
    .hcount_in(hcount_in),.vcount_in(vcount_in), .pixel_out(evolved_pixel));
    
endmodule
