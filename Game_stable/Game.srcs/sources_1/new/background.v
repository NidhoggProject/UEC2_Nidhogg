`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2020 13:15:41
// Design Name: 
// Module Name: background
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


module background(
    input wire reset,
    input wire clk,
    input wire [11:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
//    input wire rgb_pixel,
    input wire [2:0] board_number,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out
//    output reg [19:0] pixel_addr
    );
    
    reg [11:0] rgb_out_nxt;
    
    wire [9:0] addrx, addry;
    
    assign addry = vcount_in;
    assign addrx = hcount_in;
    
    always@(posedge clk, posedge reset)
    begin
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
//            pixel_addr <= {addry[9:0], addrx[9:0]};
        end
    end
        
    always @(posedge clk, posedge reset)
    begin
        if (reset)
           rgb_out <= 0;
        else
           rgb_out <= rgb_out_nxt;
    end
        
    always @(*)
    begin
        if (vblnk_in || hblnk_in)
            rgb_out_nxt = 12'h0_0_0;
        else
            case(board_number)
                1: rgb_out_nxt <= 12'hF40;//rgb_pixel;
                2: rgb_out_nxt <= 12'hFB0;
                3: rgb_out_nxt <= 12'h1F0;
                4: rgb_out_nxt <= 12'h0FF;
                5: rgb_out_nxt <= 12'h20F;
                6: rgb_out_nxt <= 12'h90F;
                7: rgb_out_nxt <= 12'hF06;
                default: rgb_out_nxt <= 12'hFFF;
            endcase
    end
    
endmodule
