`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 01:51:35
// Design Name: 
// Module Name: playerR
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


module playerR(
    input wire clk_65MHz,
    input wire rst,
    input wire [11:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [11:0] rgb_in,
    input wire [11:0] rgb_pixel_sword_R,
    input wire [11:0] rgb_pixel_playerR_head,
    input wire [11:0] rgb_pixel_playerR_head2,
    input wire [11:0] rgb_pixel_playerR_legs,
    input wire [11:0] rgb_pixel_playerR_legs2, //!!!    
    input wire [11:0] RP_x_pos,
    input wire [11:0] RP_y_pos,
    input wire change_legs,
    input wire [4:0] sword_pos,
    input wire [11:0] x_sword_pos,
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] pixel_addr_playerR_head,
    output reg [11:0] pixel_addr_playerR_legs,
    output reg [9:0] pixel_addr_sword_R,
    output reg [11:0] rgb_out,
    output reg [11:0] xpos_playerR_out,
    output reg [11:0] ypos_playerR_out,
    output reg [11:0] xpos_sword_R,
    output reg [11:0] ypos_sword_R
);

    localparam HEIGHT = 64;
    localparam WIDTH = 64;
    localparam SWORD_SIZE = 32;

    reg [11:0] rgb_out_nxt;
    wire [11:0] xpos_playerR_nxt, ypos_playerR_nxt;
    wire [11:0] xpos_playerR_legs, ypos_playerR_legs;
    wire [11:0] xpos_playerR_head_dead, ypos_playerR_head_dead;
    wire [11:0] xpos_playerR_legs_dead, ypos_playerR_legs_dead;
    wire [11:0] LP_x_pos_nxt, RP_x_pos_nxt, RP_y_pos_nxt;
    wire [11:0] xpos_sword_R_nxt, ypos_sword_R_nxt;
    
    assign RP_x_pos_nxt = RP_x_pos;
    assign RP_y_pos_nxt = RP_y_pos;
    
    assign xpos_playerR_nxt = (949 - 64) - RP_x_pos_nxt;
    assign ypos_playerR_nxt = 600 - RP_y_pos_nxt;
    assign xpos_playerR_legs = xpos_playerR_nxt;
    assign ypos_playerR_legs = ypos_playerR_nxt + 64;

    assign xpos_sword_R_nxt = (xpos_playerR_nxt - 32 - x_sword_pos);
    assign ypos_sword_R_nxt = (ypos_playerR_nxt + 55 - sword_pos);

    wire [5:0] addrx_playerR_head;
    wire [5:0] addry_playerR_head;
    wire [5:0] addrx_playerR_legs;
    wire [5:0] addry_playerR_legs;
    wire [5:0] addrx_sword_R, addry_sword_R;
    
    assign addry_playerR_head = vcount_in - ypos_playerR_nxt;
    assign addrx_playerR_head = hcount_in - xpos_playerR_nxt;
    assign addry_playerR_legs = vcount_in - ypos_playerR_legs;
    assign addrx_playerR_legs = hcount_in - xpos_playerR_legs;  
 
    assign addrx_sword_R = hcount_in - xpos_sword_R_nxt;
    assign addry_sword_R = vcount_in - ypos_sword_R_nxt;
        
    always@(posedge clk_65MHz)
    if (rst)
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
        xpos_playerR_out <= xpos_playerR_nxt;
        ypos_playerR_out <= ypos_playerR_nxt;
        xpos_sword_R <= xpos_sword_R_nxt;
        ypos_sword_R <= ypos_sword_R_nxt;
        pixel_addr_playerR_head <= {addry_playerR_head[5:0], addrx_playerR_head[5:0]};
        pixel_addr_playerR_legs <= {addry_playerR_legs[5:0], addrx_playerR_legs[5:0]};
        pixel_addr_sword_R <= {addry_sword_R[4:0], addrx_sword_R[4:0]};
    end

    always@(posedge clk_65MHz)
    begin
    if (rst)
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
                if (change_legs == 1)
                begin
                    if (sword_pos == 0)
                    begin
                        if ((vcount_in <= ypos_playerR_nxt + HEIGHT - 1) && (vcount_in >= ypos_playerR_nxt ) && (hcount_in <= xpos_playerR_nxt + WIDTH + 1) && (hcount_in >= xpos_playerR_nxt + 2) && (rgb_pixel_playerR_head != 12'h198)) rgb_out_nxt <= rgb_pixel_playerR_head;
                        else if ((vcount_in <= ypos_playerR_legs + HEIGHT - 1) && (vcount_in >= ypos_playerR_legs ) && (hcount_in <= xpos_playerR_legs + WIDTH + 1) && (hcount_in >= xpos_playerR_legs + 2) && (rgb_pixel_playerR_legs2 != 12'h198)) rgb_out_nxt <= rgb_pixel_playerR_legs2;
                        else if ((vcount_in <= ypos_sword_R_nxt + SWORD_SIZE - 1) && (vcount_in >= ypos_sword_R_nxt) && (hcount_in <= xpos_sword_R_nxt + SWORD_SIZE + 1) && (hcount_in >= xpos_sword_R_nxt + 2) && (rgb_pixel_sword_R != 12'h198)) rgb_out_nxt <= 12'h000;
                        else rgb_out_nxt <= rgb_in;
                    end
                    else if (sword_pos != 0)
                    begin
                        if ((vcount_in <= ypos_playerR_nxt + HEIGHT - 1) && (vcount_in >= ypos_playerR_nxt ) && (hcount_in <= xpos_playerR_nxt + WIDTH + 1) && (hcount_in >= xpos_playerR_nxt + 2) && (rgb_pixel_playerR_head2 != 12'h198)) rgb_out_nxt <= rgb_pixel_playerR_head2;
                        else if ((vcount_in <= ypos_playerR_legs + HEIGHT - 1) && (vcount_in >= ypos_playerR_legs ) && (hcount_in <= xpos_playerR_legs + WIDTH + 1) && (hcount_in >= xpos_playerR_legs + 2) && (rgb_pixel_playerR_legs2 != 12'h198)) rgb_out_nxt <= rgb_pixel_playerR_legs2;
                        else if ((vcount_in <= ypos_sword_R_nxt + SWORD_SIZE - 1) && (vcount_in >= ypos_sword_R_nxt) && (hcount_in <= xpos_sword_R_nxt + SWORD_SIZE + 1) && (hcount_in >= xpos_sword_R_nxt + 2) && (rgb_pixel_sword_R != 12'h198)) rgb_out_nxt <= 12'h000;
                        else rgb_out_nxt <= rgb_in;
                    end
                end
                else if (change_legs != 1)
                begin
                    if (sword_pos == 0)
                    begin
                        if ((vcount_in <= ypos_playerR_nxt + HEIGHT - 1) && (vcount_in >= ypos_playerR_nxt ) && (hcount_in <= xpos_playerR_nxt + WIDTH + 1) && (hcount_in >= xpos_playerR_nxt + 2) && (rgb_pixel_playerR_head != 12'h198)) rgb_out_nxt <= rgb_pixel_playerR_head;
                        else if ((vcount_in <= ypos_playerR_legs + HEIGHT - 1) && (vcount_in >= ypos_playerR_legs ) && (hcount_in <= xpos_playerR_legs + WIDTH + 1) && (hcount_in >= xpos_playerR_legs + 2) && (rgb_pixel_playerR_legs != 12'h198)) rgb_out_nxt <= rgb_pixel_playerR_legs;
                        else if ((vcount_in <= ypos_sword_R_nxt + SWORD_SIZE - 1) && (vcount_in >= ypos_sword_R_nxt) && (hcount_in <= xpos_sword_R_nxt + SWORD_SIZE + 1) && (hcount_in >= xpos_sword_R_nxt + 2) && (rgb_pixel_sword_R != 12'h198)) rgb_out_nxt <= 12'h000;
                        else rgb_out_nxt <= rgb_in;
                    end
                    else if (sword_pos != 0)
                    begin
                        if ((vcount_in <= ypos_playerR_nxt + HEIGHT - 1) && (vcount_in >= ypos_playerR_nxt ) && (hcount_in <= xpos_playerR_nxt + WIDTH + 1) && (hcount_in >= xpos_playerR_nxt + 2) && (rgb_pixel_playerR_head2 != 12'h198)) rgb_out_nxt <= rgb_pixel_playerR_head2;
                        else if ((vcount_in <= ypos_playerR_legs + HEIGHT - 1) && (vcount_in >= ypos_playerR_legs ) && (hcount_in <= xpos_playerR_legs + WIDTH + 1) && (hcount_in >= xpos_playerR_legs + 2) && (rgb_pixel_playerR_legs != 12'h198)) rgb_out_nxt <= rgb_pixel_playerR_legs;
                        else if ((vcount_in <= ypos_sword_R_nxt + SWORD_SIZE - 1) && (vcount_in >= ypos_sword_R_nxt) && (hcount_in <= xpos_sword_R_nxt + SWORD_SIZE + 1) && (hcount_in >= xpos_sword_R_nxt + 2) && (rgb_pixel_sword_R != 12'h198)) rgb_out_nxt <= 12'h000;
                        else rgb_out_nxt <= rgb_in;
                    end
                end
            end
            else rgb_out_nxt = 12'h0_0_0;
        end
    end
     
endmodule
