`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2021 07:44:52 PM
// Design Name: 
// Module Name: battle_transition
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


module battle_transition(input wire clk_in,
input wire rst_in,
input wire [10:0] hcount,
input wire [9:0] vcount,
input wire start,
//input wire expired,input wire start_battle,
//input wire [7:0] level_in,
//input wire [7:0] xp_in,
//output logic[2:0] state,
//output logic[7:0] xp_out,
//output logic[7:0] level_out,
//output logic evolve,
//output logic start_timer
output logic done,
output logic [11:0] pixel_out);

logic [7:0] level_evolve;
logic [7:0] xp_req;
logic [32:0] count = 0;

logic [10:0] change_x;
logic [11:0] bar1_pixel,bar3_pixel,bar5_pixel,bar2_pixel,bar4_pixel,bar6_pixel;

logic init;

  always_ff @(posedge clk_in) begin
        if(rst_in) begin
            count <= 0;
            pixel_out <= 0;
            done <= 0;
            init <= 1;
        end else begin

            if(start) begin
                if (done) begin
                done <= 0;
                end
                
                if(init) begin
                    count <= 0;
                    init <= 0;
                end
                
            
           if(hcount == 0 && vcount == 0) begin
                
                if (count>= 10'd164) begin
                    done <= 1;
                    init <= 1;
                end else begin
                    count <= count + 4;
                end
            
                
            end
            pixel_out <= {bar1_pixel[11:8] + bar3_pixel[11:8]+ bar5_pixel[11:8]+bar2_pixel[11:8] + bar4_pixel[11:8]+ bar6_pixel[11:8] , 
            bar1_pixel[7:4] + bar3_pixel[7:4]+ bar5_pixel[7:4]+ bar2_pixel[7:4] + bar4_pixel[7:4]+ bar6_pixel[7:4], 
            bar1_pixel[3:0] + bar3_pixel[3:0]+ bar5_pixel[3:0]+ bar2_pixel[3:0] + bar4_pixel[3:0]+ bar6_pixel[3:0]};
            end
           
        end
//  if(xp_in>=xp_req)begin
//    level_out<=level_in+1;
//    xp_req<=xp_req+10;
//    if (level_in+1>=level_evolve)begin
//        evolve<=1;
//        level_evolve<=level_evolve+20;
//        start_timer<=1;
//    end
//  end else begin
//       if(!expired) begin //need to fix to make more specific 
//       //Animation
//       end else begin
    
//        state<=start_battle?3'b100:evolve?3'b011:3'b001;
//   end
//   end

  end
  
     moving_blob_pos #(.WIDTH(0),.HEIGHT(24),.COLOR(12'h111)) bar1(.x_in(431), .y_in(312), .hcount_in(hcount),
    .vcount_in(vcount),.change_x(count),.pixel_out(bar1_pixel));
    
    moving_blob_pos #(.WIDTH(0),.HEIGHT(24),.COLOR(12'h111)) bar3(.x_in(431), .y_in(312+48), .hcount_in(hcount),
    .vcount_in(vcount),.change_x(count),.pixel_out(bar3_pixel));
    
    moving_blob_pos #(.WIDTH(0),.HEIGHT(24),.COLOR(12'h111)) bar5(.x_in(431), .y_in(312+96), .hcount_in(hcount),
    .vcount_in(vcount),.change_x(count),.pixel_out(bar5_pixel));
    
    moving_blob_pos #(.WIDTH(165),.HEIGHT(24),.COLOR(12'h111)) bar2(.x_in(592-count), .y_in(312+24), .hcount_in(hcount),
    .vcount_in(vcount),.change_x(0),.pixel_out(bar2_pixel));
    
    moving_blob_pos #(.WIDTH(165),.HEIGHT(24),.COLOR(12'h111)) bar4(.x_in(592-count), .y_in(312+72), .hcount_in(hcount),
    .vcount_in(vcount),.change_x(0),.pixel_out(bar4_pixel));
    
    moving_blob_pos #(.WIDTH(165),.HEIGHT(24),.COLOR(12'h111)) bar6(.x_in(592-count), .y_in(312+120), .hcount_in(hcount),
    .vcount_in(vcount),.change_x(0),.pixel_out(bar6_pixel));
    

endmodule
//States
//001=overworld
//010=battle_transition
//100=battle
//011=evolve


