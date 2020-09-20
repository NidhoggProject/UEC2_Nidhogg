`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 18:35:08
// Design Name: 
// Module Name: wall
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


module wall(
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
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] pixel_addr,
    output reg [11:0] rgb_out
    );

    localparam HEIGHT = 128;
    localparam WIDTH = 128;
    localparam xpos = 0;
    localparam ypos = 0;
        
    wire [5:0] addrx;
    wire [5:0] addry;
    
    assign addry = vcount_in - ypos;
    assign addrx = hcount_in - xpos;
    
    reg [11:0] rgb_out_nxt;

    always@(posedge clk)
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
        pixel_addr <= {addry[5:0], addrx[5:0]};
    end
     

    always@(posedge clk)
    begin
    if (reset)
        rgb_out <= 0;
    else
        rgb_out <= rgb_out_nxt;
    end
        
    integer i, j;
        
    always @(*)
    begin
        if(vblnk_in || hblnk_in) rgb_out_nxt = 12'h0_0_0;
        else
        begin
            if(~vblnk_in & ~hblnk_in)
            begin
                for (i = 0; i < 20; i=i+1)
                begin
                    for (j = 0; j < 20; j=j+1)
                    begin
                        if ((vcount_in <= ypos + (i+1)*HEIGHT - 1) && (vcount_in >= ypos + i*HEIGHT) && (hcount_in <= xpos + (j+1)*WIDTH) && (hcount_in >= xpos + j*WIDTH)) rgb_out_nxt <= rgb_pixel;
                        //else rgb_out_nxt <= 12'h725;
                    end
                end        
                if (vcount_in > 550) rgb_out_nxt <= 12'h300;   // 700
                else if (vcount_in > 555) rgb_out_nxt <= 12'h200;    //695
                else if (vcount_in > 520) rgb_out_nxt <= 12'h333;   //640
            end
            else rgb_out_nxt = 12'h0_0_0;
        end
    end
         
endmodule