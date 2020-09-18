`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 01:57:07
// Design Name: 
// Module Name: game_control
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


module game_control(
    input wire clk_65MHz,
    input wire rst
    );

//-------------------------------------------------------//    
    image_rom_128x128 #(.picture("C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/wygranalewo.data")) my_image_sign_left(
        .clk(clk_65MHz),
        .address(addr_sign_l),
        .rgb(rgb_sign_left)
    );
//-------------------------------------------------------//    
    image_rom_128x128 #(.picture("C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/wygranaprawo.data")) my_image_sign_right(
        .clk(clk_65MHz),
        .address(addr_sign_r),
        .rgb(rgb_sign_right)
    );
//-------------------------------------------------------//    
    image_rom_32x32 #(.picture("C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/korona.data")) my_image_crown(
        .clk(clk_65MHz),
        .address(addr_crown),
        .rgb(rgb_crown)
    );        
/*=======================================================*\     
*                       ACTION
\*=======================================================*/    
    action my_action(
    
    );
/*=======================================================*\     
*                       DEAD_TIMER
\*=======================================================*/    
    dead_timer my_dead_timer(
        .clk(clk_65MHz),
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
/*=======================================================*\     
*                       WIN
\*=======================================================*/    
    win my_win(
        .clk(clk_65MHz),
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
    );
    
    
endmodule
