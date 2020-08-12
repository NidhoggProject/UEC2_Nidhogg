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
    output reg [11:0] rgb_out
);


    reg [65:0] counter;
    reg [11:0] left_counter, right_counter;

    
    always @(posedge right)
    begin
        right_counter = right_counter + 1/4;
    end

    reg [11:0] rgb_out_nxt;
    
    wire [11:0] xpos_playerL, ypos_playerL;
    
    assign xpos_playerL = 75 - left_counter + right_counter;
    assign ypos_playerL = 600;
    
    wire [11:0] xpos_playerL_legs, ypos_playerL_legs;
    
    assign xpos_playerL_legs = xpos_playerL;
    assign ypos_playerL_legs = ypos_playerL + 64;
    
    localparam HEIGHT = 64;
    localparam WIDTH = 64;
    
    wire [5:0] addrx_playerL_head;
    wire [5:0] addry_playerL_head;
    wire [5:0] addrx_playerL_legs;
    wire [5:0] addry_playerL_legs;
    
    assign addry_playerL_head = vcount_in - ypos_playerL;
    assign addrx_playerL_head = hcount_in - xpos_playerL;
    assign addry_playerL_legs = vcount_in - ypos_playerL_legs;
    assign addrx_playerL_legs = hcount_in - xpos_playerL_legs;  

    
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
    end
    
    
    always @(posedge left)
    begin
        left_counter <= left_counter + 1/4;
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
                if ((vcount_in <= ypos_playerL + HEIGHT) && (vcount_in >= ypos_playerL) && (hcount_in <= xpos_playerL + WIDTH) && (hcount_in >= xpos_playerL) && (rgb_pixel_playerL_head != 12'h198)) rgb_out_nxt <= rgb_pixel_playerL_head;
                else if ((vcount_in <= ypos_playerL_legs + HEIGHT) && (vcount_in >= ypos_playerL_legs ) && (hcount_in <= xpos_playerL_legs + WIDTH) && (hcount_in >= xpos_playerL_legs) && (rgb_pixel_playerL_legs != 12'h198)) rgb_out_nxt <= rgb_pixel_playerL_legs;                                       
                else rgb_out_nxt <= rgb_in;
            end
            else rgb_out_nxt = 12'h0_0_0;
        end
    end
     
endmodule