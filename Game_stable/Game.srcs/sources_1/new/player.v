`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.05.2020 17:23:02
// Design Name: 
// Module Name: player
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


module player(
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
    input wire [11:0] rgb_pixel,
    input wire [11:0] rgb_in,
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [13:0] pixel_addr,
    output reg [11:0] rgb_out
    );
    
    localparam HEIGHT = 83;
    localparam WIDTH = 46;
    localparam xpos = 561;
    localparam ypos = 320;
    
    wire [6:0] addrx;
    wire [6:0] addry;
    
    assign addry = vcount_in - ypos;
    assign addrx = hcount_in - xpos;
    
    reg [11:0] rgb_out_nxt;
    
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
        pixel_addr <= {addry[6:0], addrx[6:0]};
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
               if (((vcount_in <= ypos + HEIGHT - 1) && (vcount_in >= ypos) && (hcount_in <= xpos + WIDTH + 1) && (hcount_in >= xpos))
               && (rgb_pixel != 12'h000) && ((rgb_pixel != 12'hfff))) rgb_out_nxt <= rgb_pixel;
               else rgb_out_nxt <= rgb_in;
            end
            else rgb_out_nxt = 12'h0_0_0;
        end
    end
         
endmodule
