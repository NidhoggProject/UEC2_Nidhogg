`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2020 13:05:48
// Design Name: 
// Module Name: vga_game
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

module vga_game(
    input wire clk,
    input wire rst,
//    input wire btnU,
//    input wire btnD,
    output wire vs,
    output wire hs,
    output wire [3:0] r,
    output wire [3:0] g,
    output wire [3:0] b
);

  wire clk_in;
  wire locked;
  wire clk_fb;
  wire clk_ss;
  wire clk_out;
  wire pclk;
  (* KEEP = "TRUE" *) 
  (* ASYNC_REG = "TRUE" *)
  reg [7:0] safe_start = 0;


  ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(pclk),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
  );
  
    wire kclk, mclk;
    
    clk my_clk(
        .clk_100MHz(mclk),
        .clk_50MHz(kclk),
        .clk_65MHz(pclk),
        .reset(rst),
        .clk_in1(clk)
    );
    
    wire [11:0] hcount;
    wire [11:0] vcount;
    wire vsync, vblnk, hsync, hblnk;
    
    vga_timing my_timing (
        .vcount(vcount),
        .vsync(vsync),
        .vblnk(vblnk),
        .hcount(hcount),
        .hsync(hsync),
        .hblnk(hblnk),
        .pclk(pclk),
        .rst(rst)
    );
    
    
    wire [11:0] hcount_b;
    wire [11:0] vcount_b;
    wire vsync_b, vblnk_b, hsync_b, hblnk_b;
    wire [11:0] rgb_pixel, rgb_b;
    wire [13:0] address_pix;
    
    start my_start(
        .clk(pclk),
        .reset(rst),
//        .up_signal(btnU),
//        .down_signal(btnD),
        .vcount_in(vcount),
        .vsync_in(vsync),
        .vblnk_in(vblnk),
        .hcount_in(hcount),
        .hsync_in(hsync),
        .hblnk_in(hblnk),
        .rgb_pixel(rgb_pixel),
        .vcount_out(vcount_b),
        .vsync_out(vsync_b),
        .vblnk_out(vblnk_b),
        .hcount_out(hcount_b),
        .hsync_out(hsync_b),
        .hblnk_out(hblnk_b),
        .pixel_addr(address_pix),
        .rgb_out(rgb_b)
    );
    
    image_rom my_image_rom(
        .clk(pclk),
        .address(address_pix),
        .rgb(rgb_pixel)
    );
    
    wire [11:0] hcount_c;
    wire [11:0] vcount_c;
    wire vsync_c, vblnk_c, hsync_c, hblnk_c;
    wire [11:0] rgb_c;
    
    start_button my_start_button(
        .clk(pclk),
        .reset(rst),
//        .up_signal(btnU),
//        .down_signal(btnD),
        .vcount_in(vcount_b),
        .vsync_in(vsync_b),
        .vblnk_in(vblnk_b),
        .hcount_in(hcount_b),
        .hsync_in(hsync_b),
        .hblnk_in(hblnk_b),
        .rgb_in(rgb_b),
        .vcount_out(vcount_c),
        .vsync_out(vs),
        .vblnk_out(vblnk_c),
        .hcount_out(hcount_c),
        .hsync_out(hs),
        .hblnk_out(hblnk_c),
        .rgb_out({r, g, b})
    );

endmodule
