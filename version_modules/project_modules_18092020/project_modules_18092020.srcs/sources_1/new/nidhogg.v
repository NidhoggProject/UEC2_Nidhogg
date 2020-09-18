`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 01:40:53
// Design Name: 
// Module Name: nidhogg
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
    
//-------------------------------------------------------//    
    
    wire locked, clk_100MHz, clk_65MHz, clk_50MHz;      
/*=======================================================*\     
*                       CLK
\*=======================================================*/
    clk my_clk(
        .clk_100MHz(clk_100MHz),
        .clk_50MHz(clk_50MHz),
        .clk_65MHz(clk_65MHz),
        .reset(rst),
        .clk_in1(clk),
        .locked()
    );
/*=======================================================*\     
*                       ODDR_pclk
\*=======================================================*/    
    ODDR pclk_oddr (
        .Q(pclk_mirror),
        .C(clk_65MHz),
        .CE(1'b1),
        .D1(1'b1),
        .D2(1'b0),
        .R(1'b0),
        .S(1'b0)
    );    
    
/*=======================================================*\     //Done
*                       IMAGE_ROM
\*=======================================================*/
        
    image_rom my_image_rom(
        .clk(clk_65MHz),
        .address(address_pix),
        .rgb(rgb_pixel)
    );
/*=======================================================*\     
*                       VGA_TIMING
\*=======================================================*/
    
    wire [11:0] hcount;
    wire [11:0] vcount;
    wire vsync, vblnk, hsync, hblnk;
//-------------------------------------------------------//         
    vga_timing my_vga_timing (
        .vcount(vcount),
        .vsync(vsync),
        .vblnk(vblnk),
        .hcount(hcount),
        .hsync(hsync),
        .hblnk(hblnk),
        .clk_65MHz(clk_65MHz),
        .rst(rst)
    );
/*=======================================================*\     
*                       BACKGROUND
\*=======================================================*/      
    background my_background(
    
    );
/*=======================================================*\     
*                       GAME_CONTROL
\*=======================================================*/     
    game_control my_game_control(
    
    );
/*=======================================================*\     
*                       PLAYERS
\*=======================================================*/      
    players my_players(
        
    );
        
endmodule
