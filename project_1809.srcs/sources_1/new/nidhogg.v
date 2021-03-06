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
    input wire BTNL,
    input wire BTNR,
    input wire BTND,
    input wire BTNU,
    input wire BTNC,
    input wire sw,
    input wire PS2Data,
    input wire PS2Clk,
    output wire vs,
    output wire hs,
    output wire [3:0] r,
    output wire [3:0] g,
    output wire [3:0] b
);


        wire [1:0] key_in;      
        wire [4:0] sword_pos; 
        reg  [4:0] sword_pos_40MHz;                                
        wire change_legs_R;
        reg change_legs_R_40MHz;     
        wire [11:0] RP_x_pos;
        reg  [11:0] RP_x_pos_40MHz;        
        wire [11:0] RP_y_pos;
        reg  [11:0] RP_y_pos_40MHz;
        wire [11:0] RP_x_sword_pos;
        reg  [11:0] RP_x_sword_pos_40MHz;
        wire change_legs_L;
        reg change_legs_L_40MHz;
        wire [11:0] LP_x_pos;
        reg  [11:0] LP_x_pos_40MHz;
        wire [11:0] LP_y_pos;
        reg  [11:0] LP_y_pos_40MHz;
        wire [11:0] LP_x_sword_pos;
        reg  [11:0] LP_x_sword_pos_40MHz;
        wire [4:0] LP_sword_pos;
        reg  [4:0] LP_sword_pos_40MHz;
        wire pos_reset;
        
/*=======================================================*\     //Done
*                         CLK
\*=======================================================*/  
    
        wire locked, kclk, mclk, pclk;
//-------------------------------------------------------//    
        clk my_clk(
            .clk_50MHz(kclk),
            .clk_40MHz(pclk),
            .reset(rst),
            .clk_in1(clk),
            .locked()
        );
    
/*=======================================================*\  
*                       VGA_TIMING
\*=======================================================*/    

    wire [11:0] hcount;
    wire [11:0] vcount;
    wire vsync, vblnk, hsync, hblnk;
//-------------------------------------------------------//    
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

/*=======================================================*\ 
*                       BACKGROUND
\*=======================================================*/

    wire vsync_b, vblnk_b, hsync_b, hblnk_b;
    wire [11:0] rgb_pixel, rgb_b;        
    wire [13:0] address_pix;
    wire [11:0] vcount_b;
    wire [11:0] hcount_b;
//-------------------------------------------------------//
    wall my_wall(
        .clk(pclk),
        .reset(rst),
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

/*=======================================================*\  
*                       IMAGE_ROM
\*=======================================================*/
    
    image_rom my_image_rom(
        .clk(pclk),
        .address(address_pix),
        .rgb(rgb_pixel)
    );
//-------------------------------------------------------//    
    wire [11:0] hcount_c;
    wire [11:0] vcount_c;
    wire vsync_c, vblnk_c, hsync_c, hblnk_c;
    wire [11:0] rgb_c;
//-------------------------------------------------------//    
    wire [11:0] hcount_d;
    wire [11:0] vcount_d;
    wire vsync_d, vblnk_d, hsync_d, hblnk_d;
    wire [11:0] rgb_d;
//-------------------------------------------------------//    
    wire [11:0] hcount_e;
    wire [11:0] vcount_e;
    wire vsync_e, vblnk_e, hsync_e, hblnk_e;
    wire [11:0] rgb_e;
//-------------------------------------------------------//    
    wire [11:0] hcount_f;
    wire [11:0] vcount_f;
    wire vsync_f, vblnk_f, hsync_f, hblnk_f;
    wire [11:0] rgb_f;    

/*=======================================================*\ 
*                       BOARD_CONTROL
\*=======================================================*/    
    
    wire [11:0] rgb_pixel_up, address_pix_up, rgb_pixel_down, address_pix_down;
    wire [11:0] rgb_pixel_up_window, address_pix_up_window, rgb_pixel_down_window, address_pix_down_window;
    wire [4:0] board_out;
    wire [11:0] xpos_playerR, ypos_playerR;
    wire [11:0] xpos_playerL, ypos_playerL;
//-------------------------------------------------------//
    board_control my_board_control(
        .clk(pclk),
        .reset(rst),
        .vcount_in(vcount_b),
        .vsync_in(vsync_b),
        .vblnk_in(vblnk_b),
        .hcount_in(hcount_b),
        .hsync_in(hsync_b),
        .hblnk_in(hblnk_b),
        .rgb_in(rgb_b),
        .rgb_pixel_up(rgb_pixel_up),
        .rgb_pixel_down(rgb_pixel_down),
        .rgb_pixel_up_window(rgb_pixel_up_window),
        .rgb_pixel_down_window(rgb_pixel_down_window),
        .xpos_playerR(xpos_playerR),
        .xpos_playerL(xpos_playerL),
        .vcount_out(vcount_c),
        .vsync_out(vsync_c),
        .vblnk_out(vblnk_c),
        .hcount_out(hcount_c),
        .hsync_out(hsync_c),
        .hblnk_out(hblnk_c),
        .pixel_addr_up(address_pix_up),
        .pixel_addr_down(address_pix_down),
        .pixel_addr_up_window(address_pix_up_window),
        .pixel_addr_down_window(address_pix_down_window),
        .rgb_out(rgb_c),
        .board_out(board_out),
        .pos_reset(pos_reset)
    );
//-------------------------------------------------------//    
    image_rom_player #(.picture("../../pochodnia_gora.data")) my_image_torch_up (
        .clk(pclk),
        .address(address_pix_up),
        .rgb(rgb_pixel_up)
    );
//-------------------------------------------------------//    
    image_rom_player #(.picture("../../pochodnia_dol.data")) my_image_torch_down (
        .clk(pclk),
        .address(address_pix_down),
        .rgb(rgb_pixel_down)
    );
//-------------------------------------------------------//    
        image_rom_player #(.picture("../../okno_gora.data")) my_image_window_up (
            .clk(pclk),
            .address(address_pix_up_window),
            .rgb(rgb_pixel_up_window)
        );
    //-------------------------------------------------------//    
        image_rom_player #(.picture("../../okno_dol.data")) my_image_window_down (
            .clk(pclk),
            .address(address_pix_down_window),
            .rgb(rgb_pixel_down_window)
        );
        
/*=======================================================*\ 
*                       PLAYER_LEFT
\*=======================================================*/    

    wire [11:0] rgb_pixel_playerL_legs, rgb_pixel_playerL_legs2;
    wire [11:0] address_pix_playerL_h, address_pix_playerL_l, xpos_sword_L, ypos_sword_L;
    wire [11:0] rgb_pixel_playerL_h, rgb_pixel_playerL_l;
    wire [11:0] x_sword_pos_L;
    wire xpos_resetL;
    
//-------------------------------------------------------//
    
    wire [11:0] rgb_pixel_sword_L, rgb_pixel_playerL_h2;
    wire [11:0] rgb_pixel_playerL_l2;
    wire [11:0] pixel_addr_sword_L;
    wire dead_L, dead_R;
//-------------------------------------------------------//
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
        .change_legs_L(change_legs_L_40MHz),
        .LP_sword_pos(LP_sword_pos_40MHz),
        .LP_x_sword_pos(LP_x_sword_pos_40MHz),
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
        .LP_x_pos(LP_x_pos_40MHz),
        .LP_y_pos(LP_y_pos_40MHz),
        .xpos_playerL_out(xpos_playerL),
        .ypos_playerL_out(ypos_playerL),
        .xpos_sword_L(xpos_sword_L),
        .ypos_sword_L(ypos_sword_L),
        .dead_L(dead_L)
    ); 
     
//-------------------------------------------------------//
    image_rom_player #(.picture("../../playerL_gora1.data")) my_image_playerL_head (
        .clk(pclk),
        .address(address_pix_playerL_h),
        .rgb(rgb_pixel_playerL_h)
    );
//-------------------------------------------------------//
    image_rom_player #(.picture("../../playerL_gora2.data")) my_image_playerL_head2 (
        .clk(pclk),
        .address(address_pix_playerL_h),
        .rgb(rgb_pixel_playerL_h2)
    );
//-------------------------------------------------------//
    image_rom_player #(.picture("../../playerL_dol1.data")) my_image_playerL_legs(
        .clk(pclk),
        .address(address_pix_playerL_l),
        .rgb(rgb_pixel_playerL_l)
    );
//-------------------------------------------------------//    
    image_rom_player #(.picture("../../playerL_dol2.data")) my_image_playerL_legs2(
        .clk(pclk),
        .address(address_pix_playerL_l),
        .rgb(rgb_pixel_playerL_l2)
    );
//-------------------------------------------------------//    
    image_rom_32x32 #(.picture("../../miecz_L.data")) my_sword_L(
        .clk(pclk),
        .address(pixel_addr_sword_L),
        .rgb(rgb_pixel_sword_L)
    );
    
/*=======================================================*\   
*                       PLAYER_RIGHT
\*=======================================================*/
    
    wire [11:0] rgb_pixel_playerR_h, address_pix_playerR_h, rgb_pixel_playerR_l, address_pix_playerR_l;
    wire [11:0] pixel_addr_playerR_legs_dead, pixel_addr_playerR_head_dead;
    wire [11:0] rgb_pixel_playerR_head_dead, rgb_pixel_playerR_legs_dead;
    wire [11:0] rgb_pixel_sword_R, rgb_pixel_playerR_h2;
    wire [11:0] xpos_sword_R, ypos_sword_R;
    wire [11:0] rgb_pixel_playerR_l2;
    wire [9:0] pixel_addr_sword_R;

//-------------------------------------------------------//    
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
    .change_legs(change_legs_R_40MHz),
    .sword_pos(sword_pos_40MHz),
    .x_sword_pos(RP_x_sword_pos_40MHz),
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
    .RP_x_pos(RP_x_pos_40MHz),
    .RP_y_pos(RP_y_pos_40MHz),
    .xpos_playerR_out(xpos_playerR),
    .ypos_playerR_out(ypos_playerR),
    .xpos_sword_R(xpos_sword_R),
    .ypos_sword_R(ypos_sword_R),
    .dead_R(dead_R)
);             
//-------------------------------------------------------//    
    image_rom_player #(.picture("../../playerR_gora1_rev.data")) my_image_playerR_head (
        .clk(pclk),
        .address(address_pix_playerR_h),
        .rgb(rgb_pixel_playerR_h)
    );
//-------------------------------------------------------//    
    image_rom_player #(.picture("../../playerR_gora2_rev.data")) my_image_playerR_head2 (
        .clk(pclk),
        .address(address_pix_playerR_h),
        .rgb(rgb_pixel_playerR_h2)
    );
//-------------------------------------------------------//    
    image_rom_player #(.picture("../../playerR_dol1_rev.data")) my_image_playerR_legs(
        .clk(pclk),
        .address(address_pix_playerR_l),
        .rgb(rgb_pixel_playerR_l)
    );
//-------------------------------------------------------//    
    image_rom_player #(.picture("../../playerR_dol2_rev.data")) my_image_playerR_legs2(
        .clk(pclk),
        .address(address_pix_playerR_l),
        .rgb(rgb_pixel_playerR_l2)
    );
//-------------------------------------------------------//    
    image_rom_32x32 #(.picture("../../miecz_R.data")) my_sword_R(
        .clk(pclk),
        .address(pixel_addr_sword_R),
        .rgb(rgb_pixel_sword_R)
    );

/*=======================================================*\     
*                       ACTION_CONTROL
\*=======================================================*/    
    
    wire dead_L_a, dead_R_a;
    wire winL, winR;
    
//-------------------------------------------------------//    
    action_control my_action_control(
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
        .dead_L(dead_L_a),
        .dead_R(dead_R_a)

    );
    
//-------------------------------------------------------//        
    
    dead_timer my_dead_timer_R(
        .clk(pclk),
        .reset(rst),
        .active(dead_R_a),
        .premature_stop(pos_reset),
        .death(dead_R)
    );
    
    dead_timer my_dead_timer_L(
        .clk(pclk),
        .reset(rst),
        .active(dead_L_a),
        .premature_stop(pos_reset),
        .death(dead_L)
    );
    
      
/*=======================================================*\ 
*                       WIN
\*=======================================================*/      

    wire [11:0] rgb_sign_left, rgb_sign_right, rgb_crown, rgb_crownL;
wire [13:0] addr_sign_l, addr_sign_r;
wire [9:0] addr_crown, addr_crownL;
//-------------------------------------------------------//        
    win my_win(
        .clk(pclk),
        .reset(rst),
        .board_in(board_out),
        .vcount_in(vcount_e),
        .vsync_in(vsync_e),
        .vblnk_in(vblnk_e),
        .hcount_in(hcount_e),
        .hsync_in(hsync_e),
        .hblnk_in(hblnk_e),
        .rgb_in(rgb_e),
        .xpos_R(xpos_playerR),
        .xpos_L(xpos_playerL),
        .ypos_R(ypos_playerR),
        .ypos_L(ypos_playerL),
        .rgb_pixel_sign_left(rgb_sign_left),
        .rgb_pixel_sign_right(rgb_sign_right),
        .rgb_pixel_crown(rgb_crown),
        .rgb_pixel_crownL(rgb_crownL),
        .vcount_out(vcount_f),
        .vsync_out(vs),
        .vblnk_out(vblnk_f),
        .hcount_out(hcount_f),
        .hsync_out(hs),
        .hblnk_out(hblnk_f),
        .pixel_addr_sign_left(addr_sign_l),
        .pixel_addr_sign_right(addr_sign_r),
        .pixel_addr_crown(addr_crown),
        .pixel_addr_crownL(addr_crownL),
        .rgb_out({r, g, b}),
        .winL(winL),
        .winR(winR)
    );        
    //-------------------------------------------------------//    
    image_rom_128x128 #(.picture("../../wygranalewo.data")) my_image_sign_left(
        .clk(pclk),
        .address(addr_sign_l),
        .rgb(rgb_sign_left)
    );
    //-------------------------------------------------------//    
    image_rom_128x128 #(.picture("../../wygranaprawo.data")) my_image_sign_right(
            .clk(pclk),
            .address(addr_sign_r),
            .rgb(rgb_sign_right)
        );
    //-------------------------------------------------------//    
    image_rom_32x32 #(.picture("../../korona.data")) my_image_crown(
        .clk(pclk),
        .address(addr_crown),
        .rgb(rgb_crown)
    );
    //-------------------------------------------------------//    
        image_rom_32x32 #(.picture("../../korona.data")) my_image_crownL(
            .clk(pclk),
            .address(addr_crownL),
            .rgb(rgb_crownL)
        );        
        
/*=======================================================*\ 
*                       KEYBOARD
\*=======================================================*/    
    
//-------------------------------------------------------//    
    keyboard my_keyboard(
      .clk_50MHz(kclk),
      .rst(rst),
      .PS2Data(PS2Data),
      .PS2Clk(PS2Clk),
      .BTNL(BTNL),
      .BTNR(BTNR),
      .BTND(BTND),
      .BTNU(BTNU),
      .BTNC(BTNC),
      .sw(sw),
      .dead_R(dead_R || winR || winL),
      .dead_L(dead_L || winL || winR),
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
      .LP_sword_pos(LP_sword_pos),
      .pos_reset(pos_reset)

    );
    
/*=======================================================*\ 
*                    CLK_Convert_signal
\*=======================================================*/  
    
        always@(posedge pclk)
            begin
                sword_pos_40MHz <= sword_pos;
                change_legs_R_40MHz <= change_legs_R;
                RP_x_pos_40MHz <= RP_x_pos;
                RP_y_pos_40MHz <= RP_y_pos;
                RP_x_sword_pos_40MHz <= RP_x_sword_pos;
                change_legs_L_40MHz <= change_legs_L;
                LP_x_pos_40MHz <= LP_x_pos;
                LP_y_pos_40MHz <= LP_y_pos;
                LP_x_sword_pos_40MHz <= LP_x_sword_pos;
                LP_sword_pos_40MHz <= LP_sword_pos;
            end  

    endmodule
