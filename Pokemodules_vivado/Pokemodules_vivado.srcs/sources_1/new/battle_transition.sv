module battle_transition(input wire clk_in, input wire expired, input wire evolve,input wire start_battle,output logic[2:0] state);
  always_ff @(posedge clk_in) begin 
   if(!expired) begin
   //Animation
   end else begin

   state<=start_battle?3'b100:evolve?3'b011:3'b001;
   end
  end
endmodule
//States
//001=overworld
//010=battle_transition
//100=battle
//011=evolve