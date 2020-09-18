`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 01:50:08
// Design Name: 
// Module Name: players
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
    input wire clk_65MHz,
    input wire clk_50MHz,
    input wire rst,
    input wire PS2Data,
    input wire PS2Clk,
    input wire BTNL,
    input wire BTNR,
    input wire BTND,
    input wire BTNU,
    input wire BTNC,
    input wire sw,
    input wire [11:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [11:0] rgb_in,
    input wire xpos_reset,
    input wire dead_L,
    input wire dead_R,
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] rgb_out,
    output reg [11:0] xpos_playerR_out,
    output reg [11:0] ypos_playerR_out,
    output reg [11:0] xpos_sword_R,
    output reg [11:0] ypos_sword_R,
    output reg [11:0] xpos_playerL_out,
    output reg [11:0] ypos_playerL_out,
    output reg [11:0] xpos_sword_L,
    output reg [11:0] ypos_sword_L
    );
    
//-------------------------------------------------------//



//-------------------------------------------------------//
    wire [11:0] rgb_pixel_playerR_h, address_pix_playerR_h, rgb_pixel_playerR_l, address_pix_playerR_l;
    wire [11:0] pixel_addr_playerR_legs_dead, pixel_addr_playerR_head_dead;
    wire [11:0] rgb_pixel_playerR_head_dead, rgb_pixel_playerR_legs_dead;
    wire [11:0] rgb_pixel_sword_R, rgb_pixel_playerR_h2;
    wire [11:0] xpos_sword_R, ypos_sword_R;
    wire [11:0] rgb_pixel_playerR_l2;
    
    
    wire [9:0] pixel_addr_sword_R;
//-------------------------------------------------------//
    wire [11:0] rgb_pixel_playerL_legs, rgb_pixel_playerL_legs2;
    wire [11:0] address_pix_playerL_h, address_pix_playerL_l, xpos_sword_L, ypos_sword_L;
    wire [11:0] rgb_pixel_playerL_h, rgb_pixel_playerL_l;
    wire [11:0] x_sword_pos_L;
    wire xpos_resetL;
    
    wire [11:0] rgb_pixel_sword_L, rgb_pixel_playerL_h2;
    
    wire [11:0] rgb_pixel_playerL_l2;
   
    wire [11:0] pixel_addr_sword_L;
/*=======================================================*\     
*                       PLAYER_RIGHT
\*=======================================================*/    
    playerR my_playerR (
        .clk_65MHz(clk_65MHz),
        .rst(rst),
        .vcount_in(vcount_d),
        .vsync_in(vsync_d),
        .vblnk_in(vblnk_d),
        .hcount_in(hcount_d),
        .hsync_in(hsync_d),
        .hblnk_in(hblnk_d),
        .rgb_in(rgb_d),
        .rgb_pixel_sword_R(rgb_pixel_sword_R),
        .rgb_pixel_playerR_head(rgb_pixel_playerR_h),
        .rgb_pixel_playerR_head2(rgb_pixel_playerR_h2),
        .rgb_pixel_playerR_legs(rgb_pixel_playerR_l),
        .rgb_pixel_playerR_legs2(rgb_pixel_playerR_l2),
        .change_legs(change_legs_R),
        .sword_pos(sword_pos),
        .x_sword_pos(RP_x_sword_pos),
        .vcount_out(vcount_e),
        .vsync_out(vsync_e),
        .vblnk_out(vblnk_e),
        .hcount_out(hcount_e),
        .hsync_out(hsync_e),
        .hblnk_out(hblnk_e),
        .pixel_addr_playerR_head(address_pix_playerR_h),
        .pixel_addr_playerR_legs(address_pix_playerR_l),
        .pixel_addr_sword_R(pixel_addr_sword_R),
        .rgb_out(rgb_e),
        .RP_x_pos(RP_x_pos),
        .RP_y_pos(RP_y_pos),
        .xpos_playerR_out(xpos_playerR),
        .ypos_playerR_out(ypos_playerR),
        .xpos_sword_R(xpos_sword_R),
        .ypos_sword_R(ypos_sword_R)
    );         
/*=======================================================*\     
*                       ROM_PLAYER_RIGHT
\*=======================================================*/  
    image_rom_player #(.picture("C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/playerR_gora1_rev.data")) my_image_playerR_head (
        .clk(clk_65MHz),
        .address(address_pix_playerR_h),
        .rgb(rgb_pixel_playerR_h)
    );
//-------------------------------------------------------//    
    image_rom_player #(.picture("C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/playerR_gora2_rev.data")) my_image_playerR_head2 (
        .clk(clk_65MHz),
        .address(address_pix_playerR_h),
        .rgb(rgb_pixel_playerR_h2)
    );
//-------------------------------------------------------//    
    image_rom_player #(.picture("C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/playerR_dol1_rev.data")) my_image_playerR_legs(
        .clk(clk_65MHz),
        .address(address_pix_playerR_l),
        .rgb(rgb_pixel_playerR_l)
    );
//-------------------------------------------------------//    
    image_rom_player #(.picture("C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/playerR_dol2_rev.data")) my_image_playerR_legs2(
        .clk(clk_65MHz),
        .address(address_pix_playerR_l),
        .rgb(rgb_pixel_playerR_l2)
    );
//-------------------------------------------------------//    
    image_rom_32x32 #(.picture("C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/miecz_R.data")) my_sword_R(
        .clk(clk_65MHz),
        .address(pixel_addr_sword_R),
        .rgb(rgb_pixel_sword_R)
    );
/*=======================================================*\     
*                       PLAYER_LEFT
\*=======================================================*/
    playerL my_playerL (
        .clk_65MHz(clk_65MHz),
        .rst(rst),
        .vcount_in(vcount_c),
        .vsync_in(vsync_c),
        .vblnk_in(vblnk_c),
        .hcount_in(hcount_c),
        .hsync_in(hsync_c),
        .hblnk_in(hblnk_c),
        .rgb_in(rgb_c),
        .rgb_pixel_sword_L(rgb_pixel_sword_L),
        .rgb_pixel_playerL_head(rgb_pixel_playerL_h),
        .rgb_pixel_playerL_head2(rgb_pixel_playerL_h2),
        .rgb_pixel_playerL_legs(rgb_pixel_playerL_l),
        .rgb_pixel_playerL_legs2(rgb_pixel_playerL_l2),
        .change_legs_L(change_legs_L),
        .LP_sword_pos(LP_sword_pos),
        .LP_x_sword_pos(LP_x_sword_pos),
        .vcount_out(vcount_d),
        .vsync_out(vsync_d),
        .vblnk_out(vblnk_d),
        .hcount_out(hcount_d),
        .hsync_out(hsync_d),
        .hblnk_out(hblnk_d),
        .pixel_addr_playerL_head(address_pix_playerL_h),
        .pixel_addr_playerL_legs(address_pix_playerL_l),
        .pixel_addr_sword_L(pixel_addr_sword_L),
        .rgb_out(rgb_d),
        .LP_x_pos(LP_x_pos),
        .LP_y_pos(LP_y_pos),
        .xpos_playerL_out(xpos_playerL),
        .ypos_playerL_out(ypos_playerL),
        .xpos_sword_L(xpos_sword_L),
        .ypos_sword_L(ypos_sword_L)
    );       
/*=======================================================*\     
*                       ROM_PLAYER_LEFT
\*=======================================================*/ 
    image_rom_player #(.picture("C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/playerL_gora1.data")) my_image_playerL_head (
        .clk(clk_65MHz),
        .address(address_pix_playerL_h),
        .rgb(rgb_pixel_playerL_h)
    );
//-------------------------------------------------------//
    image_rom_player #(.picture("C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/playerL_gora2.data")) my_image_playerL_head2 (
        .clk(clk_65MHz),
        .address(address_pix_playerL_h),
        .rgb(rgb_pixel_playerL_h2)
    );
//-------------------------------------------------------//
    image_rom_player #(.picture("C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/playerL_dol1.data")) my_image_playerL_legs(
        .clk(clk_65MHz),
        .address(address_pix_playerL_l),
        .rgb(rgb_pixel_playerL_l)
    );
//-------------------------------------------------------//    
    image_rom_player #(.picture("C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/playerL_dol2.data")) my_image_playerL_legs2(
        .clk(clk_65MHz),
        .address(address_pix_playerL_l),
        .rgb(rgb_pixel_playerL_l2)
    );
//-------------------------------------------------------//    
    image_rom_32x32 #(.picture("C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/miecz_L.data")) my_sword_L(
        .clk(clk_65MHz),
        .address(pixel_addr_sword_L),
        .rgb(rgb_pixel_sword_L)
    );
/*=======================================================*\     
*                       KEYBOARD
\*=======================================================*/       
    keyboard my_keyboard(
      .clk_50MHz(clk_50MHz),
      .rst(rst),
      .PS2Data(PS2Data),
      .PS2Clk(PS2Clk),
      .xpos_reset(pos_reset),
      .BTNL(BTNL),
      .BTNR(BTNR),
      .BTND(BTND),
      .BTNU(BTNU),
      .BTNC(BTNC),
      .sw(sw),
      .key(key_in),
      .sword_pos(sword_pos),
      .RP_change_legs(change_legs_R),
      .RP_x_pos(RP_x_pos),
      .RP_y_pos(RP_y_pos),
      .RP_x_sword_pos(RP_x_sword_pos),
      .LP_change_legs(change_legs_L),
      .LP_x_pos(LP_x_pos),
      .LP_y_pos(LP_y_pos),
      .LP_x_sword_pos(LP_x_sword_pos),
      .LP_sword_pos(LP_sword_pos)
    );
    
endmodule
