`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2021 03:22:46 AM
// Design Name: 
// Module Name: timer
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


module timer(   input wire rst_in, clock, start_timer,
                input wire [3:0] value,
                output logic counting,
                output logic expired_pulse,
                output logic one_hz,
                output logic [3:0] count_out);

	//use parameter below for generating one_hz_enable signal
	parameter ONE_HZ_PERIOD = 25_000_000;
    logic [31:0] counter;
    logic  clock_cycle;
    // Verilog
    always_ff @(posedge clock) begin
        if (rst_in) begin
            counting<=0;
            expired_pulse<=0;
            one_hz<=0;
            count_out<=0;
            counter<=32'b0;
        end else begin
            if (start_timer) begin
                count_out<=value;
                counting<=1;
                expired_pulse<=0;
                one_hz<=0;
                counter<=32'b0;
                clock_cycle<=1;
            end else begin
                if (counter>=ONE_HZ_PERIOD-2) begin         //once counter hits one hz it sends one hz out
                    one_hz<=1;
                    counter<=32'b0;
                end else begin
                    one_hz<=0;
                    counter<=counter+1;
                
                
                end
            end
            if(counting)begin
                if (clock_cycle)begin
                    count_out<=value;       //sets value after a clock cycle to make sure the timer is reading the right values per state
                    clock_cycle<=0;
                end
                if(one_hz)begin
                    count_out<=count_out-1; //subtracts one from the timer after one hz passes
                    counter<=32'b0;
                end
                
                if (count_out<=0) begin
                    expired_pulse<=1;  //once we reach 0 we send out expired and we stop counting
                    counting<=0;
                end
            end else begin
                expired_pulse<=0;
            end
        end
    end
endmodule

`default_nettype wire