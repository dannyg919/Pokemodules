`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2021 03:21:15 AM
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


module evolve(input wire clk_in, input wire rst_in,
input wire [10:0] hcount_in, // horizontal index of current pixel (0..1023)
input wire [9:0]  vcount_in, // vertical index of current pixel (0..767)
input wire expired,
input wire evolve_in,
input wire [5:0] sprite_in,
output logic [5:0] sprite_out,
output logic [11:0] pixel_out

    );
    logic [11:0] evolved_pixel;
    logic [8:0] evolve_sel_x;
    
    logic [32:0] counter;
    logic [32:0] total_counter;
    always_ff @(posedge clk_in) begin
        if (rst_in) begin
            sprite_out<=sprite_in;
        end else begin
            if (evolve_in && total_counter<=50) begin
                    sprite_out<=sprite_in+1;
                    if (hcount_in > 432+52 && hcount_in <= 432+52+56 && vcount_in >= 312+20 && vcount_in < 312+20+56) begin
                        if (vcount_in >= 312+20 && vcount_in < 312+20+28) begin
                            if (counter>=32'd10)
                                counter<=0;
                                evolve_sel_x<=~evolve_sel_x;
                            end else begin
                                counter+=1;
                            end
                        end else begin
                            if (counter>=32'd7)begin
                                counter<=0;
                                evolve_sel_x<=~evolve_sel_x;
                            end else begin
                                counter+=1;
                            end
                        end
                        total_counter+=1;
                        pixel_out <= {evolved_pixel[11:8],evolved_pixel[7:4],evolved_pixel[3:0]};
                    
                    
                    end
                    
                end
        
        end

                    front_sprites original(.pixel_clk_in(clk_in),.x_in(432+52),.y_in(312+20),.sprite_sel_x(56*evolve_sel_x),.sprite_sel_y(0), //evolved SPRITE
    .hcount_in(hcount_in),.vcount_in(vcount_in), .pixel_out(evolved_pixel));
    
endmodule
