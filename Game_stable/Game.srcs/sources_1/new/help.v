`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2020 20:18:49
// Design Name: 
// Module Name: help
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


module help(
    input wire clk,
    input wire reset,
    //    input wire up_signal,
    //    input wire down_signal,
    input wire [11:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [11:0] rgb_in,
    input wire [11:0] rgb_pixel_logo1,
    input wire [11:0] rgb_pixel_logo2,
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [15:0] pixel_addr_logo1,
    output reg [15:0] pixel_addr_logo2,
    output reg [11:0] rgb_out
);
    
    
    reg [11:0] rgb_out_nxt;
    
    localparam xpos_logo1 = 256;
    localparam ypos_logo1 = 350;
    localparam xpos_logo2 = 512;
    localparam ypos_logo2 = 350;
    localparam HEIGHT_logo = 256;
    localparam WIDTH_logo = 256;
    
    wire [7:0] addrx_logo1;
    wire [7:0] addry_logo1;
    wire [7:0] addrx_logo2;
    wire [7:0] addry_logo2;
    
    assign addry_logo1 = vcount_in - ypos_logo1;
    assign addrx_logo1 = hcount_in - xpos_logo1;
    assign addry_logo2 = vcount_in - ypos_logo2;
    assign addrx_logo2 = hcount_in - xpos_logo2;
    
    always@(posedge clk, posedge reset)
    if (reset)
    begin
        hsync_out <= 0;
        vsync_out <= 0;
        hblnk_out <= 0;
        vblnk_out <= 0;
        hcount_out <= 0;
        vcount_out <= 0;
    end
    else
    begin
        hsync_out <= hsync_in;
        vsync_out <= vsync_in;
        hblnk_out <= hblnk_in;
        vblnk_out <= vblnk_in;
        hcount_out <= hcount_in;
        vcount_out <= vcount_in;
        pixel_addr_logo1 <= {addry_logo1[7:0], addrx_logo1[7:0]};
        pixel_addr_logo2 <= {addry_logo2[7:0], addrx_logo2[7:0]};
    end
     
    
    always@(posedge clk, posedge reset)
    begin
    if (reset)
        rgb_out <= 0;
    else
        rgb_out <= rgb_out_nxt;
    end
    
        
    always @(*)
    begin
        if(vblnk_in || hblnk_in) rgb_out_nxt = 12'h0_0_0;
        else
        begin
            if(~vblnk_in & ~hblnk_in)
            begin
            
            // help
                if ((vcount_in <= ypos_logo1 + HEIGHT_logo - 1) && (vcount_in >= ypos_logo1) && (hcount_in <= xpos_logo1 + WIDTH_logo + 3) && (hcount_in >= xpos_logo1 + 2) && (rgb_pixel_logo1 != 12'h198)) rgb_out_nxt <= rgb_pixel_logo1;
                else if ((vcount_in <= ypos_logo2 + HEIGHT_logo) && (vcount_in >= ypos_logo2) && (hcount_in <= xpos_logo2 + WIDTH_logo) && (hcount_in >= xpos_logo2) && (rgb_pixel_logo2 != 12'h198)) rgb_out_nxt <= rgb_pixel_logo2;       
            // pomoc - literki
                else if ((vcount_in <= 110) && (vcount_in >= 100) && (((hcount_in <= 417) && (hcount_in >= 387)) || ((hcount_in <= 457) && (hcount_in >= 427)) ||
                ((hcount_in <= 537) && (hcount_in >= 507)) || ((hcount_in <= 577) && (hcount_in >= 547)))) rgb_out_nxt = 12'h999;
                else if ((vcount_in <= 160) && (vcount_in >= 110) && (((hcount_in <= 397) && (hcount_in >= 387)) || ((hcount_in <= 437) && (hcount_in >= 427)) ||
                ((hcount_in <= 457) && (hcount_in >= 447)) || ((hcount_in <= 537) && (hcount_in >= 527)) || ((hcount_in <= 517) && (hcount_in >= 507)) ||
                ((hcount_in <= 557) && (hcount_in >= 547)))) rgb_out_nxt = 12'h999;
                else if ((hcount_in >= 467) && (hcount_in <= 482) && (3*vcount_in >= 4*hcount_in - 308 - (420*3)) && (3*vcount_in <= 4*hcount_in - 248 - (420*3))) rgb_out_nxt = 12'h999;
                else if ((vcount_in <= 160) && (vcount_in >= 150) && (((hcount_in <= 457) && (hcount_in >= 427)) ||
                ((hcount_in <= 537) && (hcount_in >= 507)) || ((hcount_in <= 577) && (hcount_in >= 547)))) rgb_out_nxt = 12'h999;
                else if ((hcount_in <= 417) && (hcount_in >= 407) && (vcount_in <= 135) && (vcount_in >= 100)) rgb_out_nxt = 12'h999;
                else if ((vcount_in >= 125) && (vcount_in <= 135) && (hcount_in >= 387) && (hcount_in <= 417)) rgb_out_nxt = 12'h999;
                else if ((hcount_in >= 482) && (hcount_in <= 497) && (3*vcount_in >= (-4)*hcount_in + 3548 - (3*420)) && (3*vcount_in <= (-4)*hcount_in + 3608 - (3*420))) rgb_out_nxt = 12'h999;
                else if ((vcount_in >= 120) && (vcount_in <= 160) && (((hcount_in <= 477) && (hcount_in >= 467)) || ((hcount_in <= 497) && (hcount_in >= 487)))) rgb_out_nxt = 12'h999;
                else if ((vcount_in >= (560-100)) && (3*vcount_in <= 4*(hcount_in-400) - 748 - (100*3)) && (3*vcount_in <= (-4)*(hcount_in-400) +4228 -(100*3)) && (hcount_in > (360+400))) rgb_out_nxt = 12'h999;
//                else if ((hcount_in >= (617-100)) && (hcount_in <= (627-100)) && (vcount_in >= 100) && (vcount_in <= 150)) rgb_out_nxt = 12'h999;

    
                else rgb_out_nxt <= rgb_in;
            end
            else rgb_out_nxt = 12'h0_0_0;
        end
    end
     
endmodule