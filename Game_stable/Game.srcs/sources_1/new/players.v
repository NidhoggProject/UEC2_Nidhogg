`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.08.2020 01:21:43
// Design Name: 
// Module Name: start_button
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


module players(
    input wire clk,
    input wire reset,
    input wire left,
    input wire right,
    //    input wire up_signal,
    //    input wire down_signal,
    input wire [11:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [11:0] rgb_in,
    input wire [11:0] rgb_pixel_playerL_head,
    input wire [11:0] rgb_pixel_playerL_legs,
    input wire [11:0] rgb_pixel_playerR_head,
    input wire [11:0] rgb_pixel_playerR_legs,
//    input wire [11:0] xpos_playerL,
//    input wire [11:0] ypos_playerL,
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] pixel_addr_playerL_head,
    output reg [11:0] pixel_addr_playerL_legs,
    output reg [11:0] pixel_addr_playerR_head,
    output reg [11:0] pixel_addr_playerR_legs,
    output reg [11:0] rgb_out
);

    localparam HEIGHT = 64;
    localparam WIDTH = 64;
    
    
    `define picture_display(xpos, ypos, height, width, rgb_pixel) (((vcount_in <= ypos + height) && (vcount_in >= ypos) && (hcount_in <= xpos + width) && (hcount_in >= xpos) && (rgb_pixel != 12'h198)));
    

    reg [65:0] counter;
    reg [11:0] left_counter, right_counter;

    reg [11:0] rgb_out_nxt;
    wire [11:0] xpos_playerL, ypos_playerL;
    wire [11:0] xpos_playerL_legs, ypos_playerL_legs;
    wire [11:0] xpos_playerR, ypos_playerR;
    wire [11:0] xpos_playerR_legs, ypos_playerR_legs;
    
    assign xpos_playerL = 75 - left_counter + right_counter;
    assign ypos_playerL = 600;
    assign xpos_playerL_legs = xpos_playerL;
    assign ypos_playerL_legs = ypos_playerL + 64;
    assign xpos_playerR = (949 - 64) - left_counter + right_counter;
    assign ypos_playerR = 600;
    assign xpos_playerR_legs = xpos_playerR;
    assign ypos_playerR_legs = ypos_playerR + 64;

    
    wire [5:0] addrx_playerL_head;
    wire [5:0] addry_playerL_head;
    wire [5:0] addrx_playerL_legs;
    wire [5:0] addry_playerL_legs;
    
    assign addry_playerL_head = vcount_in - ypos_playerL;
    assign addrx_playerL_head = hcount_in - xpos_playerL;
    assign addry_playerL_legs = vcount_in - ypos_playerL_legs;
    assign addrx_playerL_legs = hcount_in - xpos_playerL_legs;  

    
    wire [5:0] addrx_playerR_head;
    wire [5:0] addry_playerR_head;
    wire [5:0] addrx_playerR_legs;
    wire [5:0] addry_playerR_legs;
    
    assign addry_playerR_head = vcount_in - ypos_playerR;
    assign addrx_playerR_head = hcount_in - xpos_playerR;
    assign addry_playerR_legs = vcount_in - ypos_playerR_legs;
    assign addrx_playerR_legs = hcount_in - xpos_playerR_legs;  
    
    
    
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
        pixel_addr_playerL_head <= {addry_playerL_head[5:0], addrx_playerL_head[5:0]};
        pixel_addr_playerL_legs <= {addry_playerL_legs[5:0], addrx_playerL_legs[5:0]};
        pixel_addr_playerR_head <= {addry_playerR_head[5:0], addrx_playerR_head[5:0]};
        pixel_addr_playerR_legs <= {addry_playerR_legs[5:0], addrx_playerR_legs[5:0]};
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
                //if ((vcount_in <= ypos_playerL + HEIGHT) && (vcount_in >= ypos_playerL) && (hcount_in <= xpos_playerL + WIDTH) && (hcount_in >= xpos_playerL) && (rgb_pixel_playerL_head != 12'h198)) rgb_out_nxt <= rgb_pixel_playerL_head;
                if ((vcount_in <= ypos_playerL + HEIGHT - 1) && (vcount_in >= ypos_playerL ) && (hcount_in <= xpos_playerL + WIDTH + 1) && (hcount_in >= xpos_playerL + 2) && (rgb_pixel_playerL_head != 12'h198)) rgb_out_nxt <= rgb_pixel_playerL_head;         
                else if ((vcount_in <= ypos_playerL_legs + HEIGHT - 1) && (vcount_in >= ypos_playerL_legs ) && (hcount_in <= xpos_playerL_legs + WIDTH + 1) && (hcount_in >= xpos_playerL_legs + 2) && (rgb_pixel_playerL_legs != 12'h198)) rgb_out_nxt <= rgb_pixel_playerL_legs;         
                else if ((vcount_in <= ypos_playerR + HEIGHT - 1) && (vcount_in >= ypos_playerR ) && (hcount_in <= xpos_playerR + WIDTH + 1) && (hcount_in >= xpos_playerR + 2) && (rgb_pixel_playerR_head != 12'h198)) rgb_out_nxt <= rgb_pixel_playerR_head;         
                else if ((vcount_in <= ypos_playerR_legs + HEIGHT - 1) && (vcount_in >= ypos_playerR_legs ) && (hcount_in <= xpos_playerR_legs + WIDTH + 1) && (hcount_in >= xpos_playerR_legs + 2) && (rgb_pixel_playerR_legs != 12'h198)) rgb_out_nxt <= rgb_pixel_playerR_legs;
               else rgb_out_nxt <= rgb_in;
            end
            else rgb_out_nxt = 12'h0_0_0;
        end
    end
     
endmodule
