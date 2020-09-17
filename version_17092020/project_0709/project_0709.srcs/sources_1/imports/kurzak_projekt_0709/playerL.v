`timescale 1ns / 1ps


module playerL(
    input wire clk,
    input wire reset,
    input wire [11:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [11:0] rgb_in,
    input wire [11:0] rgb_pixel_sword_L,
    input wire [11:0] rgb_pixel_playerL_head,
    input wire [11:0] rgb_pixel_playerL_head2,
    input wire [11:0] rgb_pixel_playerL_legs,
    input wire [11:0] rgb_pixel_playerL_legs2,
    input wire [11:0] LP_x_pos,
    input wire [11:0] LP_y_pos,
    input wire change_legs_L,
    input wire [4:0] LP_sword_pos,
    input wire [11:0] LP_x_sword_pos,
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] pixel_addr_playerL_head,
    output reg [11:0] pixel_addr_playerL_legs,
    output reg [9:0] pixel_addr_sword_L,
    output reg [11:0] rgb_out,
    output reg [11:0] xpos_playerL_out,
    output reg [11:0] ypos_playerL_out,
    output reg [11:0] xpos_sword_L,
    output reg [11:0] ypos_sword_L
);

    localparam HEIGHT = 64;
    localparam WIDTH = 64;
    localparam SWORD_SIZE = 32;

    reg [11:0] rgb_out_nxt;
    wire [11:0] xpos_playerL_nxt, ypos_playerL_nxt;
    wire [11:0] xpos_playerL_legs, ypos_playerL_legs;
    wire [11:0] xpos_playerL_head_dead, ypos_playerL_head_dead;
    wire [11:0] xpos_playerL_legs_dead, ypos_playerL_legs_dead;
    wire [11:0] LP_x_pos_nxt, LP_y_pos_nxt;
    wire [11:0] xpos_sword_L_nxt, ypos_sword_L_nxt;
    
    assign LP_x_pos_nxt = LP_x_pos;
    assign LP_y_pos_nxt = LP_y_pos;
    
    assign xpos_playerL_nxt = 75 + LP_x_pos_nxt;
    assign ypos_playerL_nxt = 600 - LP_y_pos_nxt;
    assign xpos_playerL_legs = xpos_playerL_nxt;
    assign ypos_playerL_legs = ypos_playerL_nxt + 64;
    
/*    assign xpos_playerL_head_dead = (949 - 64) - LP_x_pos_nxt + 64;
    assign ypos_playerL_head_dead = 600 - LP_y_pos_nxt + 64;
    assign xpos_playerL_legs_dead = xpos_playerL_nxt;
    assign ypos_playerL_legs_dead = ypos_playerL_nxt + 64;*/

    assign xpos_sword_L_nxt = (xpos_playerL_nxt + 64 + LP_x_sword_pos);
    assign ypos_sword_L_nxt = (ypos_playerL_nxt + 55 - LP_sword_pos);
        
    wire [5:0] addrx_playerL_head;
    wire [5:0] addry_playerL_head;
    wire [5:0] addrx_playerL_legs;
    wire [5:0] addry_playerL_legs;
    wire [5:0] addrx_sword_L, addry_sword_L;
//    wire [5:0] addry_playerL_head_dead, addrx_playerL_head_dead, addrx_playerL_legs_dead, addry_playerL_legs_dead;
    
    assign addry_playerL_head = vcount_in - ypos_playerL_nxt;
    assign addrx_playerL_head = hcount_in - xpos_playerL_nxt;
    assign addry_playerL_legs = vcount_in - ypos_playerL_legs;
    assign addrx_playerL_legs = hcount_in - xpos_playerL_legs;  

/*    assign addry_playerL_head_dead = vcount_in - ypos_playerL_head_dead;
    assign addrx_playerL_head_dead = hcount_in - xpos_playerL_head_dead;
    assign addry_playerL_legs_dead = vcount_in - ypos_playerL_legs_dead;
    assign addrx_playerL_legs_dead = hcount_in - xpos_playerL_legs_dead;*/
 
    assign addrx_sword_L = hcount_in - xpos_sword_L_nxt;
    assign addry_sword_L = vcount_in - ypos_sword_L_nxt;
        
    
    always@(posedge clk)
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
        xpos_playerL_out <= xpos_playerL_nxt;
        ypos_playerL_out <= ypos_playerL_nxt;
        xpos_sword_L <= xpos_sword_L_nxt;
        ypos_sword_L <= ypos_sword_L_nxt;
        pixel_addr_playerL_head <= {addry_playerL_head[5:0], addrx_playerL_head[5:0]};
        pixel_addr_playerL_legs <= {addry_playerL_legs[5:0], addrx_playerL_legs[5:0]};
        pixel_addr_sword_L <= {addry_sword_L[4:0], addrx_sword_L[4:0]};
//        pixel_addr_playerL_head_dead <= {addry_playerL_head_dead[5:0], addrx_playerL_head_dead[5:0]};
//        pixel_addr_playerL_legs_dead <= {addry_playerL_legs_dead[5:0], addrx_playerL_legs_dead[5:0]};
    end
    
     

    always@(posedge clk)
    begin
    if (reset)
        rgb_out <= 0;
    else
        rgb_out <= rgb_out_nxt;
    end
    
    
 /*   always @*
    begin
        if ((rgb_in == 12'hfff) && (rgb_out_nxt == 12'hcf0) && (L_dead == 0)) L_dead <= L_dead + 1;
        else if ((rgb_in == 12'hfff) && (rgb_out_nxt == 12'hcf0) && (L_dead >= 1)) L_dead <= 1;
        else L_dead <= 0;
    end*/
    
        
    always @(*)
    begin
        if(vblnk_in || hblnk_in) rgb_out_nxt = 12'h0_0_0;
        else
        begin
            if(~vblnk_in & ~hblnk_in)
            begin                
                if (change_legs_L == 1)
                begin
                    if (LP_sword_pos == 0)
                    begin
                        if ((vcount_in <= ypos_playerL_nxt + HEIGHT - 1) && (vcount_in >= ypos_playerL_nxt ) && (hcount_in <= xpos_playerL_nxt + WIDTH + 1) && (hcount_in >= xpos_playerL_nxt + 2) && (rgb_pixel_playerL_head != 12'h198)) rgb_out_nxt <= rgb_pixel_playerL_head;
                        else if ((vcount_in <= ypos_playerL_legs + HEIGHT - 1) && (vcount_in >= ypos_playerL_legs ) && (hcount_in <= xpos_playerL_legs + WIDTH + 1) && (hcount_in >= xpos_playerL_legs + 2) && (rgb_pixel_playerL_legs2 != 12'h198)) rgb_out_nxt <= rgb_pixel_playerL_legs2;
                        else if ((vcount_in <= ypos_sword_L_nxt + SWORD_SIZE - 1) && (vcount_in >= ypos_sword_L_nxt) && (hcount_in <= xpos_sword_L_nxt + SWORD_SIZE + 1) && (hcount_in >= xpos_sword_L_nxt + 2) && (rgb_pixel_sword_L != 12'h198)) rgb_out_nxt <= 12'h000;
                        else rgb_out_nxt <= rgb_in;
                    end
                    else if (LP_sword_pos != 0)
                    begin
                        if ((vcount_in <= ypos_playerL_nxt + HEIGHT - 1) && (vcount_in >= ypos_playerL_nxt ) && (hcount_in <= xpos_playerL_nxt + WIDTH + 1) && (hcount_in >= xpos_playerL_nxt + 2) && (rgb_pixel_playerL_head2 != 12'h198)) rgb_out_nxt <= rgb_pixel_playerL_head2;
                        else if ((vcount_in <= ypos_playerL_legs + HEIGHT - 1) && (vcount_in >= ypos_playerL_legs ) && (hcount_in <= xpos_playerL_legs + WIDTH + 1) && (hcount_in >= xpos_playerL_legs + 2) && (rgb_pixel_playerL_legs2 != 12'h198)) rgb_out_nxt <= rgb_pixel_playerL_legs2;
                        else if ((vcount_in <= ypos_sword_L_nxt + SWORD_SIZE - 1) && (vcount_in >= ypos_sword_L_nxt) && (hcount_in <= xpos_sword_L_nxt + SWORD_SIZE + 1) && (hcount_in >= xpos_sword_L_nxt + 2) && (rgb_pixel_sword_L != 12'h198)) rgb_out_nxt <= 12'h000;
                        else rgb_out_nxt <= rgb_in;
                    end
                end
                else if (change_legs_L != 1)
                begin
                    if (LP_sword_pos == 0)
                    begin
                        if ((vcount_in <= ypos_playerL_nxt + HEIGHT - 1) && (vcount_in >= ypos_playerL_nxt ) && (hcount_in <= xpos_playerL_nxt + WIDTH + 1) && (hcount_in >= xpos_playerL_nxt + 2) && (rgb_pixel_playerL_head != 12'h198)) rgb_out_nxt <= rgb_pixel_playerL_head;
                        else if ((vcount_in <= ypos_playerL_legs + HEIGHT - 1) && (vcount_in >= ypos_playerL_legs ) && (hcount_in <= xpos_playerL_legs + WIDTH + 1) && (hcount_in >= xpos_playerL_legs + 2) && (rgb_pixel_playerL_legs != 12'h198)) rgb_out_nxt <= rgb_pixel_playerL_legs;
                        else if ((vcount_in <= ypos_sword_L_nxt + SWORD_SIZE - 1) && (vcount_in >= ypos_sword_L_nxt) && (hcount_in <= xpos_sword_L_nxt + SWORD_SIZE + 1) && (hcount_in >= xpos_sword_L_nxt + 2) && (rgb_pixel_sword_L != 12'h198)) rgb_out_nxt <= 12'h000;
                        else rgb_out_nxt <= rgb_in;
                    end
                    else if (LP_sword_pos != 0)
                    begin
                        if ((vcount_in <= ypos_playerL_nxt + HEIGHT - 1) && (vcount_in >= ypos_playerL_nxt ) && (hcount_in <= xpos_playerL_nxt + WIDTH + 1) && (hcount_in >= xpos_playerL_nxt + 2) && (rgb_pixel_playerL_head2 != 12'h198)) rgb_out_nxt <= rgb_pixel_playerL_head2;
                        else if ((vcount_in <= ypos_playerL_legs + HEIGHT - 1) && (vcount_in >= ypos_playerL_legs ) && (hcount_in <= xpos_playerL_legs + WIDTH + 1) && (hcount_in >= xpos_playerL_legs + 2) && (rgb_pixel_playerL_legs != 12'h198)) rgb_out_nxt <= rgb_pixel_playerL_legs;
                        else if ((vcount_in <= ypos_sword_L_nxt + SWORD_SIZE - 1) && (vcount_in >= ypos_sword_L_nxt) && (hcount_in <= xpos_sword_L_nxt + SWORD_SIZE + 1) && (hcount_in >= xpos_sword_L_nxt + 2) && (rgb_pixel_sword_L != 12'h198)) rgb_out_nxt <= 12'h000;
                        else rgb_out_nxt <= rgb_in;
                    end
                end
            end
            else rgb_out_nxt = 12'h0_0_0;
        end
    end
    

     
endmodule
