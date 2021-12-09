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
input wire hcount,
input wire vcount,
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

logic signed [10:0] change_x;
logic [11:0] bar1_pixel;

  always_ff @(posedge clk_in) begin
        if(rst_in) begin
            count <= 0;
            pixel_out <= 0;
        end else begin
            if(start) begin
//                done <= 0;
                
//                count <= count + 1;
                
//                if (count>= 10'd160) begin
//                    count <= 0;
//                    done <= 1;
//                end
                
            if (hcount == 0 && vcount == 0) begin
                //case(count)
                    //0:
                    //5:
                    //10:
                    //15:
                    //20:
                    //30:
                    //default:
           //     change_x <= count;
                
                count <= count + 1;
                
                if (count>= 10'd12) begin
                    count <= 0;
                    done <= 1;
             
                end
            end
            
                
            end
            pixel_out <={bar1_pixel[11:8] , bar1_pixel[7:4] ,bar1_pixel[3:0] };
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
  
     blob #(.WIDTH(24),.HEIGHT(24),.COLOR(12'hFFF)) bar1(.x_in(432), .y_in(312), .hcount_in(hcount),
    .vcount_in(vcount),.pixel_out(bar1_pixel));
    
     //moving_blob #(.WIDTH(80),.HEIGHT(24),.COLOR(12'h000)) bar2(.x_in(change_x), .y_in(312), .hcount_in(hcount),
    //.vcount_in(vcount),.change_x(0) .pixel_out(bar2_pixel));
endmodule
//States
//001=overworld
//010=battle_transition
//100=battle
//011=evolve


