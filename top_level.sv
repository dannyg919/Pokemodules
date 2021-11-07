`timescale 1ns / 1ps

`default_nettype none



module top_level(
   input wire clk_100mhz,
   input wire btnc, btnu, btnl, btnr, btnd,
   output logic[3:0] vga_r,
   output logic[3:0] vga_b,
   output logic[3:0] vga_g,
   output logic vga_hs,
   output logic vga_vs
   );
   
   //CLOCK LOGIC
   logic clk_65mhz;
   clk_wiz_65mhz clk_wizard(.clk_in1(clk_100mhz), .clk_out1(clk_65mhz));
   
    //XVGA LOGIC
    logic [10:0] hcount;    // pixel on current line
    logic [9:0] vcount;     // line number
    logic hsync, vsync, blank; //control signals for vga
    logic [11:0] pixel;
    logic [11:0] rgb;
     xvga xvga1(.vclock_in(clk_65mhz),.hcount_out(hcount),.vcount_out(vcount),
          .hsync_out(hsync),.vsync_out(vsync),.blank_out(blank));
    
    //BUTTON LOGIC (TODO: REPLACE WITH NES CONTROLS)    
    logic reset;
    debounce db1(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnc),.clean_out(reset));
   
    
    logic up,down,left,right;
    debounce db2(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnu),.clean_out(up));
    debounce db3(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnd),.clean_out(down));
    debounce db4(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnl),.clean_out(left));
    debounce db5(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnr),.clean_out(right));

    //GAME LOGIC
    logic phsync,pvsync,pblank;
    poke_game pg(.vclk_in(clk_65mhz),.rst_in(reset),
                .up_in(up),.down_in(down),.left_in(left),.right_in(right),
                .hcount_in(hcount),.vcount_in(vcount),
                .hsync_in(hsync),.vsync_in(vsync),.blank_in(blank),
                .phsync_out(phsync),.pvsync_out(pvsync),.pblank_out(pblank),.pixel_out(pixel));
             
               
    logic b,hs,vs;
    logic border = (hcount==0 | hcount==1023 | vcount==0 | vcount==767 |
                  hcount == 512 | vcount == 384);

    always_ff @(posedge clk_65mhz) begin
        hs <= phsync;
        vs <= pvsync;
        b <= pblank;
        rgb <= pixel;
    end
               
               
               
    // the following lines are required for the Nexys4 VGA circuit - do not change
    assign vga_r = ~b ? rgb[11:8]: 0;
    assign vga_g = ~b ? rgb[7:4] : 0;
    assign vga_b = ~b ? rgb[3:0] : 0;

    assign vga_hs = ~hs;
    assign vga_vs = ~vs;      
    
         
endmodule

   
   