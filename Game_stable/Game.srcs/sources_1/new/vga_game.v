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
    input wire btnL,
    input wire btnR,
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
    
    wire help, menu, select_map, game_castle, game_forest, win;
    
    state_machine my_state_machine(
    .clk(pclk),
    .reset(rst),
    .help(help),
    .menu(menu),
    .select_map(select_map),
    .game_castle(game_castle),
    .game_forest(game_forest),
    .win(win)
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
    wire [11:0] rgb_pixel_playerL_head, address_pix_playerL_head, rgb_pixel_playerL_legs, address_pix_playerL_legs;
    wire [11:0] rgb_pixel_playerR_head, address_pix_playerR_head, rgb_pixel_playerR_legs, address_pix_playerR_legs;
    wire [11:0] xpos_playerL, ypos_playerL;

    background my_background(
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
    
    players my_players(
        .clk(pclk),
        .reset(rst),
        .left(btnL),
        .right(btnR),
//        .up_signal(btnU),
//        .down_signal(btnD),
        .vcount_in(vcount_b),
        .vsync_in(vsync_b),
        .vblnk_in(vblnk_b),
        .hcount_in(hcount_b),
        .hsync_in(hsync_b),
        .hblnk_in(hblnk_b),
        .rgb_in(rgb_b),
        .rgb_pixel_playerL_head(rgb_pixel_playerL_head),
        .rgb_pixel_playerL_legs(rgb_pixel_playerL_legs),
        .rgb_pixel_playerR_head(rgb_pixel_playerR_head),
        .rgb_pixel_playerR_legs(rgb_pixel_playerR_legs),
        .vcount_out(vcount_c),
        .vsync_out(vs),
        .vblnk_out(vblnk_c),
        .hcount_out(hcount_c),
        .hsync_out(hs),
        .hblnk_out(hblnk_c),
        .pixel_addr_playerL_head(address_pix_playerL_head),
        .pixel_addr_playerL_legs(address_pix_playerL_legs),
        .pixel_addr_playerR_head(address_pix_playerR_head),
        .pixel_addr_playerR_legs(address_pix_playerR_legs),
        .rgb_out({r, g, b})
 //       .xpos_playerL(xpos_playerL),
 //       .ypos_playerL(ypos_playerL)
    );
    
    image_rom_player #(.picture("../../playerL_gora1.data")) my_image_playerL_head (
        .clk(pclk),
        .address(address_pix_playerL_head),
        .rgb(rgb_pixel_playerL_head)
    );
    
    image_rom_player #(.picture("../../playerL_dol1.data")) my_image_playerL_legs(
        .clk(pclk),
        .address(address_pix_playerL_legs),
        .rgb(rgb_pixel_playerL_legs)
    );
    
    image_rom_player #(.picture("../../playerR_gora1_rev.data")) my_image_playerR_head (
        .clk(pclk),
        .address(address_pix_playerR_head),
        .rgb(rgb_pixel_playerR_head)
    );
    
    image_rom_player #(.picture("../../playerR_dol1_rev.data")) my_image_playerR_legs(
        .clk(pclk),
        .address(address_pix_playerR_legs),
        .rgb(rgb_pixel_playerR_legs)
    );
    
    wire [11:0] xpos_playerL_out, ypos_playerL_out;
    
/*    players_control my_players_control(
        .clk(pclk),
        .reset(rst),
        .left(btnL),
        .right(btnR),
        .xpos_playerL_out(xpos_playerL),
        .ypos_playerL_out(ypos_playerL)
    );*/

endmodule
