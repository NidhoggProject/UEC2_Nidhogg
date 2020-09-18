`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 01:54:20
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
    input wire clk_65MHz,
    input wire rst
    );

//-------------------------------------------------------//    
    image_rom_player #(.picture("C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/pochodnia_gora.data")) my_image_torch_up (
        .clk(clk_65MHz),
        .address(address_pix_up),
        .rgb(rgb_pixel_up)
    );
//-------------------------------------------------------//    
    image_rom_player #(.picture("C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/pochodnia_dol.data")) my_image_torch_down (
        .clk(clk_65MHz),
        .address(address_pix_down),
        .rgb(rgb_pixel_down)
    );
/*=======================================================*\     
*                       WALL
\*=======================================================*/     
    wall my_wall(
        .clk(clk_65MHz),
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
*                       BOARD_CONTROL
\*=======================================================*/     
    board_control my_board_control(
        .clk(clk_65MHz),
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
        .xpos_playerR(xpos_playerR),
        .board_controller(board),
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
    
    
endmodule
