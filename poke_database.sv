`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2021 03:39:15 AM
// Design Name: 
// Module Name: poke_database
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


module poke_database( input wire x_in,
    output logic [10:0] name_x[9:0],
    output logic [10:0] name_y[9:0]
    );
    
    always_comb begin
        case(x_in)
        0: begin
           name_x[0] = 11'd9; //B
           name_y[0] = 11'd0;
           
           name_x[1] = 11'd36; //U
           name_y[1] = 11'd9;
           
           name_x[2] = 11'd99; //L
           name_y[2] = 11'd0;
           
           name_x[3] = 11'd9; //B
           name_y[3] = 11'd0;
           
           name_x[4] = 11'd0; //A
           name_y[4] = 11'd0;
           
           name_x[5] = 11'd18; //S
           name_y[5] = 11'd9;
           
           name_x[6] = 11'd0; //A
           name_y[6] = 11'd0;
           
           name_x[7] = 11'd36; //U
           name_y[7] = 11'd9;
           
           name_x[8] = 11'd9; //R
           name_y[8] = 11'd9;   
           
           name_x[9] = 11'd0; //
           name_y[9] = 11'd36;          
           
            
           end 
        default: begin        
           name_x[0] = 11'd0; //
           name_y[0] = 11'd36;
           
           name_x[1] = 11'd0; //
           name_y[1] = 11'd36;
           
           name_x[2] = 11'd0; //
           name_y[2] = 11'd36;
           
           name_x[3] = 11'd0; //
           name_y[3] = 11'd36;
           
           name_x[4] = 11'd0; //
           name_y[4] = 11'd36;
           
           name_x[5] = 11'd0; //
           name_y[5] = 11'd36; 
           
           name_x[6] = 11'd0; //
           name_y[6] = 11'd36; 
           
           name_x[7] = 11'd0; //
           name_y[7] = 11'd36; 
           
           name_x[8] = 11'd0; //
           name_y[8] = 11'd36; 
           
           name_x[9] = 11'd0; //
           name_y[9] = 11'd36;              
           end
           
        endcase
    end 
endmodule
