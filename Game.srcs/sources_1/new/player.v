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
    input wire reset,
    input wire clk,
    input wire [11:0] x_LP,
    input wire [11:0] y_LP,
    input wire [11:0] x_sword_LP,
    input wire [11:0] y_sword_LP,
    input wire [11:0] x_RP,
    input wire [11:0] y_RP,
    input wire [11:0] x_sword_RP,
    input wire [11:0] y_sword_RP,
    input wire [2:0] LP_sword_position,
    input wire [2:0] RP_sword_position,
    input wire [2:0] board_number,
    input wire [11:0] rgb_in,
    input wire [11:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [10:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [10:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] rgb_out
    );
    
    reg [11:0] rgb_out_next;
    
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
        end
    end
    
    always @(posedge clk, posedge reset)
    begin
        if (reset)
           rgb_out <= 0;
        else
           rgb_out <= rgb_out_next;
    end
    
    always @(*)
    begin
        if (vblnk_in || hblnk_in)
            rgb_out_next = 12'h0_0_0;
        else
            if ((hcount_in > x_LP) && (hcount_in < (x_LP + 46)) && (vcount_in > y_LP) && (vcount_in < (y_LP + 83)))
                rgb_out_next <= 12'h9C6;
            else if ((hcount_in > x_RP) && (hcount_in < (x_RP + 46)) && (vcount_in > y_RP) && (vcount_in < (y_RP + 83)))
                rgb_out_next <= 12'ha9c;
            else if ((hcount_in > x_sword_LP) && (hcount_in < (x_sword_LP + 35)) && (vcount_in > y_sword_LP) && (vcount_in < (y_sword_LP + 5)))
                rgb_out_next <= 12'h563;
            else if ((hcount_in > x_sword_RP) && (hcount_in < (x_sword_RP + 35)) && (vcount_in > y_sword_RP) && (vcount_in < (y_sword_RP + 5)))
                    rgb_out_next <= 12'h435;
            else
                rgb_out_next <= rgb_in;
    end
    
endmodule
