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

module nidhogg(
    input wire clk,
    input wire rst,
    input wire btnL,
    input wire btnR,
    input wire PS2Data,
    input wire PS2Clk,
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
    wire [11:0] rgb_pixel, rgb_b, rgb_x;        //rgb_x - test value to keyboard
    wire [13:0] address_pix;
    wire [11:0] rgb_pixel_playerL_head, address_pix_playerL_head, rgb_pixel_playerL_legs, address_pix_playerL_legs,
                rgb_pixel_playerL_legs2;
    wire [11:0] rgb_pixel_playerR_h, address_pix_playerR_h, rgb_pixel_playerR_l, address_pix_playerR_l;
    wire [11:0] xpos_playerL, ypos_playerL;
    wire L_dead, R_dead, L_dead_out, R_dead_out;

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
    
    wire [11:0] hcount_d;
    wire [11:0] vcount_d;
    wire vsync_d, vblnk_d, hsync_d, hblnk_d;
    wire [11:0] rgb_d;
    
    wire [11:0] hcount_e;
    wire [11:0] vcount_e;
    wire vsync_e, vblnk_e, hsync_e, hblnk_e;
    wire [11:0] rgb_e;
    
    wire [11:0] hcount_f;
    wire [11:0] vcount_f;
    wire vsync_f, vblnk_f, hsync_f, hblnk_f;
    wire [11:0] rgb_f;    
    
    wire [11:0] rgb_pixel_up, address_pix_up, rgb_pixel_down, address_pix_down;
    wire [11:0] xpos_playerR;
    wire [2:0] board;
    
    wire [1:0] board_change;
    
    wire xpos_resetR;
    
    board_control my_board_control(
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
        .rgb_pixel_up(rgb_pixel_up),
        .rgb_pixel_down(rgb_pixel_down),
        .xpos_playerR(xpos_playerR),
        .board_in(board),
        .vcount_out(vcount_c),
        .vsync_out(vsync_c),
        .vblnk_out(vblnk_c),
        .hcount_out(hcount_c),
        .hsync_out(hsync_c),
        .hblnk_out(hblnk_c),
        .pixel_addr_up(address_pix_up),
        .pixel_addr_down(address_pix_down),
        .rgb_out(rgb_c),
        .winR(),
        .winL()
    );
    
    image_rom_player #(.picture("../../pochodnia_gora.data")) my_image_torch_up (
        .clk(pclk),
        .address(address_pix_up),
        .rgb(rgb_pixel_up)
    );
    
    image_rom_player #(.picture("../../pochodnia_dol.data")) my_image_torch_down (
        .clk(pclk),
        .address(address_pix_down),
        .rgb(rgb_pixel_down)
    );
        
    
/*    playerL my_playerL(
        .clk(pclk),
        .reset(rst),
        .left(btnL),
        .right(btnR),
//        .up_signal(btnU),
//        .down_signal(btnD),
        .vcount_in(vcount_c),
        .vsync_in(vsync_c),
        .vblnk_in(vblnk_c),
        .hcount_in(hcount_c),
        .hsync_in(hsync_c),
        .hblnk_in(hblnk_c),
        .rgb_in(rgb_c),
        .rgb_pixel_playerL_head(rgb_pixel_playerL_head),
        .rgb_pixel_playerL_legs(rgb_pixel_playerL_legs),
        .rgb_pixel_playerL_legs2(rgb_pixel_playerL_legs2),
        .vcount_out(vcount_d),
        .vsync_out(vsync_d),
        .vblnk_out(vblnk_d),
        .hcount_out(hcount_d),
        .hsync_out(hsync_d),
        .hblnk_out(hblnk_d),
        .pixel_addr_playerL_head(address_pix_playerL_head),
        .pixel_addr_playerL_legs(address_pix_playerL_legs),
        .rgb_out(rgb_d)
 //       .xpos_playerL(xpos_playerL),
 //       .ypos_playerL(ypos_playerL)
    );*/
    
    wire [11:0] rgb_pixel_sword_L, rgb_pixel_playerL_h, rgb_pixel_playerL_h2, rgb_pixel_playerL_l, rgb_pixel_playerL_l2;
    wire change_legs_L;
    wire [4:0] sword_pos_L;
    wire [11:0] x_sword_pos_L;
    wire [11:0] address_pix_playerL_h, address_pix_playerL_l, LP_x_pos, LP_y_pos, xpos_sword_L, ypos_sword_L, ypos_playerR;
    wire [11:0] xpos_sword_R, ypos_sword_R;
    wire [4:0] board_change_L;
    wire [11:0] pixel_addr_sword_L;
    wire xpos_resetL;
    
    playerL my_playerL (
        .clk(pclk),
        .reset(rst),
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
//        .rgb_pixel_playerL_head_dead(rgb_pixel_playerL_head_dead),
//        .rgb_pixel_playerL_legs_dead(rgb_pixel_playerL_legs_dead),
        .change_legs_L(change_legs_L),
        .sword_pos(sword_pos_L),
        .x_sword_pos(x_sword_pos_L),
        .vcount_out(vcount_d),
        .vsync_out(vsync_d),
        .vblnk_out(vblnk_d),
        .hcount_out(hcount_d),
        .hsync_out(hsync_d),
        .hblnk_out(hblnk_d),
        .pixel_addr_playerL_head(address_pix_playerL_h),
        .pixel_addr_playerL_legs(address_pix_playerL_l),
        .pixel_addr_sword_L(pixel_addr_sword_L),
//        .pixel_addr_playerL_head_dead(pixel_addr_playerL_head_dead),
//        .pixel_addr_playerL_legs_dead(pixel_addr_playerL_legs_dead),
        .rgb_out(rgb_d),
        .LP_x_pos(LP_x_pos),
        .LP_y_pos(LP_y_pos),
        .xpos_playerL_out(xpos_playerL),
        .ypos_playerL_out(ypos_playerL),
        .xpos_sword_L(xpos_sword_L),
        .ypos_sword_L(ypos_sword_L)
/*        .L_dead_in(L_dead),
        .L_dead_in(L_dead),*/
    );       
    
    image_rom_player #(.picture("../../playerL_gora1.data")) my_image_playerL_head (
        .clk(pclk),
        .address(address_pix_playerL_h),
        .rgb(rgb_pixel_playerL_h)
    );
    
    image_rom_player #(.picture("../../playerL_gora2.data")) my_image_playerL_head2 (
        .clk(pclk),
        .address(address_pix_playerL_h),
        .rgb(rgb_pixel_playerL_h2)
    );
    
    image_rom_player #(.picture("../../playerL_dol1.data")) my_image_playerL_legs(
        .clk(pclk),
        .address(address_pix_playerL_l),
        .rgb(rgb_pixel_playerL_l)
    );
    
    image_rom_player #(.picture("../../playerL_dol2.data")) my_image_playerL_legs2(
        .clk(pclk),
        .address(address_pix_playerL_l),
        .rgb(rgb_pixel_playerL_l2)
    );
    
    
    image_rom_32x32 #(.picture("../../miecz_L.data")) my_sword_L(
        .clk(pclk),
        .address(pixel_addr_sword_L),
        .rgb(rgb_pixel_sword_L)
    );
    
    wire [11:0] RP_x_pos, RP_y_pos;
    wire [11:0] rgb_pixel_sword_R, rgb_pixel_playerR_h2;
    wire [9:0] pixel_addr_sword_R;
    wire [11:0] rgb_pixel_playerR_l2;
    wire change_legs_R;
    wire [4:0] sword_pos;
    wire [11:0] x_sword_pos;
    wire [11:0] pixel_addr_playerR_legs_dead, pixel_addr_playerR_head_dead;
    wire [11:0] rgb_pixel_playerR_head_dead, rgb_pixel_playerR_legs_dead;

    
    playerR my_playerR (
        .clk(pclk),
        .reset(rst),
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
//        .rgb_pixel_playerR_head_dead(rgb_pixel_playerR_head_dead),
//        .rgb_pixel_playerR_legs_dead(rgb_pixel_playerR_legs_dead),
        .change_legs(change_legs_R),
        .sword_pos(sword_pos),
        .x_sword_pos(x_sword_pos),
        .vcount_out(vcount_e),
        .vsync_out(vsync_e),
        .vblnk_out(vblnk_e),
        .hcount_out(hcount_e),
        .hsync_out(hsync_e),
        .hblnk_out(hblnk_e),
        .pixel_addr_playerR_head(address_pix_playerR_h),
        .pixel_addr_playerR_legs(address_pix_playerR_l),
        .pixel_addr_sword_R(pixel_addr_sword_R),
//        .pixel_addr_playerR_head_dead(pixel_addr_playerR_head_dead),
//        .pixel_addr_playerR_legs_dead(pixel_addr_playerR_legs_dead),
        .rgb_out(rgb_e),
        .RP_x_pos(RP_x_pos),
        .RP_y_pos(RP_y_pos),
        .xpos_playerR_out(xpos_playerR),
        .ypos_playerR_out(ypos_playerR),
        .xpos_sword_R(xpos_sword_R),
        .ypos_sword_R(ypos_sword_R)
/*        .L_dead_in(L_dead),
        .R_dead_in(R_dead),*/
    );       
    
    /*
    dead_timer my_dead_timer_R(
        .clk(pclk),
        .reset(rst),
        .active(R_dead_out),
        .premature_stop(xpos_resetR),
        .death(R_dead)
    );
    */
    
    wire [11:0] rgb_sign_left, rgb_sign_right, rgb_crown;
    wire [13:0] addr_sign_l, addr_sign_r;
    wire [9:0] addr_crown;
    
    image_rom_player #(.picture("../../playerR_gora1_rev.data")) my_image_playerR_head (
        .clk(pclk),
        .address(address_pix_playerR_h),
        .rgb(rgb_pixel_playerR_h)
    );
    
    image_rom_player #(.picture("../../playerR_gora2_rev.data")) my_image_playerR_head2 (
        .clk(pclk),
        .address(address_pix_playerR_h),
        .rgb(rgb_pixel_playerR_h2)
    );
    
    image_rom_player #(.picture("../../playerR_dol1_rev.data")) my_image_playerR_legs(
        .clk(pclk),
        .address(address_pix_playerR_l),
        .rgb(rgb_pixel_playerR_l)
    );
    
    image_rom_player #(.picture("../../playerR_dol2_rev.data")) my_image_playerR_legs2(
        .clk(pclk),
        .address(address_pix_playerR_l),
        .rgb(rgb_pixel_playerR_l2)
    );
    
/*    image_rom_player #(.picture("../../playerR_dead_legs.data")) my_image_playerR_legs_dead(
        .clk(pclk),
        .address(pixel_addr_playerR_legs_dead),
        .rgb(rgb_pixel_playerR_legs_dead)
    );
    
    image_rom_player #(.picture("../../playerR_dead_head.data")) my_image_playerR_head_dead(
        .clk(pclk),
        .address(pixel_addr_playerR_head_dead),
        .rgb(rgb_pixel_playerR_head_dead)
    );*/
    
    image_rom_32x32 #(.picture("../../miecz_R.data")) my_sword_R(
        .clk(pclk),
        .address(pixel_addr_sword_R),
        .rgb(rgb_pixel_sword_R)
    );
    
    wire pos_reset;
    
    death_control my_death_control(
        .clk(pclk),
        .reset(rst),
        .xpos_playerR(xpos_playerR),
        .ypos_playerR(ypos_playerR),
        .xpos_sword_R(xpos_sword_R),
        .ypos_sword_R(ypos_sword_R),
        .xpos_playerL(xpos_playerL),
        .ypos_playerL(ypos_playerL),
        .xpos_sword_L(xpos_sword_L),
        .ypos_sword_L(ypos_sword_L),
        .dead_L(),
        .dead_R(),
        .collision(),
        .pos_reset(pos_reset),
        .board_controller(board)
    );
    
    
    win my_win(
        .clk(pclk),
        .reset(rst),
        .board_in(board),
        .vcount_in(vcount_e),
        .vsync_in(vsync_e),
        .vblnk_in(vblnk_e),
        .hcount_in(hcount_e),
        .hsync_in(hsync_e),
        .hblnk_in(hblnk_e),
        .rgb_in(rgb_e),
        .xpos_R(xpos_playerR),
        .rgb_pixel_sign_left(rgb_sign_left),
        .rgb_pixel_sign_right(rgb_sign_right),
        .rgb_pixel_crown(rgb_crown),
        .vcount_out(vcount_f),
        .vsync_out(vs),
        .vblnk_out(vblnk_f),
        .hcount_out(hcount_f),
        .hsync_out(hs),
        .hblnk_out(hblnk_f),
        .pixel_addr_sign_left(addr_sign_l),
        .pixel_addr_sign_right(addr_sign_r),
        .pixel_addr_crown(addr_crown),
        .rgb_out({r, g, b})
 //       .xpos_playerL(xpos_playerL),
 //       .ypos_playerL(ypos_playerL)
    );    
    
    /*death_control my_death_control(
        .clk(pclk),
        .reset(rst),
        .R_dead(R_dead),
        .L_dead(),
        .rgb_in(rgb_f),
        .rgb_out({r, g, b})
    );*/
    
    
    image_rom_128x128 #(.picture("../../wygranalewo.data")) my_image_sign_left(
        .clk(pclk),
        .address(addr_sign_l),
        .rgb(rgb_sign_left)
    );
    
    image_rom_128x128 #(.picture("../../wygranaprawo.data")) my_image_sign_right(
            .clk(pclk),
            .address(addr_sign_r),
            .rgb(rgb_sign_right)
        );
    
    image_rom_32x32 #(.picture("../../korona.data")) my_image_crown(
        .clk(pclk),
        .address(addr_crown),
        .rgb(rgb_crown)
    );
    
    wire [11:0] xpos_playerL_out, ypos_playerL_out;

    wire [1:0] key_in;
    wire change_legs_R_in;
    wire [11:0] RP_x_pos_in;
    
    keyboard my_keyboard(
      .clk_50MHz(kclk),
      .rst(rst),
      .PS2Data(PS2Data),
      .PS2Clk(PS2Clk),
      .xpos_reset(pos_reset),
      .key(key_in),
//      .LP_x_pos(LP_x_pos),
      .RP_x_pos(RP_x_pos),
      .RP_y_pos(RP_y_pos),
      .change_legs_R(change_legs_R),
      .sword_pos(sword_pos),
      .x_sword_pos(x_sword_pos)
    );
    
    /*delay my_delay(
    .clk(pclk),
    .reset(rst),
    .RP_x_pos(RP_x_pos_in),
    .change_legs_R(change_legs_R_in),
    .RP_x_pos_out(RP_x_pos),
    .change_legs_R_out(change_legs_R)
    );*/
    
endmodule
