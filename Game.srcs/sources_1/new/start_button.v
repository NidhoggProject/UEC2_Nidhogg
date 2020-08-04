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


module start_button(
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
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] rgb_out
);


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
            if ((hcount_in < 662) && (hcount_in > 657) && (vcount_in < 480) && (vcount_in > 380)) rgb_out_nxt = 12'h999;
            else if ((hcount_in < 367) && (hcount_in > 362) && (vcount_in < 480) && (vcount_in > 380)) rgb_out_nxt = 12'h999;
            else if ((hcount_in < 662) && (hcount_in > 362) && (vcount_in < 480) && (vcount_in > 475)) rgb_out_nxt = 12'h999;
            else if ((hcount_in < 662) && (hcount_in > 362) && (vcount_in < 385) && (vcount_in > 380)) rgb_out_nxt = 12'h999;
            else if ((hcount_in <= 657) && (hcount_in >= 367) && (vcount_in <= 475) && (vcount_in >= 385)) rgb_out_nxt = 12'h455;
            else if ((hcount_in < 662) && (hcount_in > 657) && (vcount_in < 600) && (vcount_in > 500)) rgb_out_nxt = 12'h999;
            else if ((hcount_in < 367) && (hcount_in > 362) && (vcount_in < 600) && (vcount_in > 500)) rgb_out_nxt = 12'h999;
            else if ((hcount_in < 662) && (hcount_in > 362) && (vcount_in < 600) && (vcount_in > 595)) rgb_out_nxt = 12'h999;
            else if ((hcount_in < 662) && (hcount_in > 362) && (vcount_in < 505) && (vcount_in > 500)) rgb_out_nxt = 12'h999;
            else if ((hcount_in <= 657) && (hcount_in >= 367) && (vcount_in <= 595) && (vcount_in >= 505)) rgb_out_nxt = 12'h455;
            else rgb_out_nxt <= rgb_in;
        end
        else rgb_out_nxt = 12'h0_0_0;
    end
end
     
endmodule
