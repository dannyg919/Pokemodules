module battle_transition(input wire clk_in,
input wire rst_in,
input wire expired,input wire start_battle,
input wire [7:0] level_in,
input wire [7:0] xp_in,
output logic[2:0] state,
output logic[7:0] xp_out,
output logic[7:0] level_out,
output logic evolve,
output logic start_timer);
logic [7:0] level_evolve;
logic [7:0] xp_req;
  always_ff @(posedge clk_in) begin
   
  if(xp_in>=xp_req)begin
    level_out<=level_in+1;
    xp_req<=xp_req+10;
    if (level_in+1>=level_evolve)begin
        evolve<=1;
        level_evolve<=level_evolve+20;
        start_timer<=1;
    end
  end else begin
       if(!expired) begin //need to fix to make more specific 
       //Animation
       end else begin
    
        state<=start_battle?3'b100:evolve?3'b011:3'b001;
   end
   end
  end
endmodule
//States
//001=overworld
//010=battle_transition
//100=battle
//011=evolve