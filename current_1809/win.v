`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.08.2020 17:06:30
// Design Name: 
// Module Name: win
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


module win(
    input wire clk,
    input wire reset,
    input wire [2:0] board_in,
    input wire [11:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [11:0] rgb_in,
    input wire [11:0] rgb_pixel_sign_left,
    input wire [11:0] rgb_pixel_sign_right,
    input wire [11:0] rgb_pixel_crown,
    //    input wire [11:0] xpos_L,
    //    input wire [11:0] ypos_L,
    input wire [11:0] xpos_R,
    //input wire [11:0] ypos_R;
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [13:0] pixel_addr_sign_left,
    output reg [13:0] pixel_addr_sign_right,
    output reg [9:0] pixel_addr_crown,
    output reg [11:0] rgb_out,
    output reg winL,
    output reg winR
    );
    
    
    localparam SIZE = 128;
    localparam SIZE_CROWN = 32;
    
//    localparam board_in = 3;
//    localparam xpos_R = (949 - 64);
    localparam ypos_R = 600;
    localparam xpos_L = 75;
    localparam ypos_L = 600;
    
        
    reg [11:0] rgb_out_nxt;
    
    wire [11:0] xpos_sign_left, ypos_sign_left, xpos_sign_right, ypos_sign_right;
    wire [11:0] xpos_crown, ypos_crown, xpos_crownL, ypos_crownL;
    
    wire [2:0] board;
        
    assign ypos_sign_left = 384;
    assign xpos_sign_left = 384;
    assign ypos_sign_right = ypos_sign_left;
    assign xpos_sign_right = xpos_sign_left + 128;
    assign xpos_crown = xpos_R + 16;
    assign ypos_crown = ypos_R - 19;
    assign xpos_crownL = xpos_L + 16;
    assign ypos_crownL = ypos_L - 19;

    wire [6:0] addrx_sign_left;
    wire [6:0] addry_sign_left;
    wire [6:0] addrx_sign_right;
    wire [6:0] addry_sign_right;
    reg [4:0] addrx_crown;
    reg [4:0] addry_crown;
    
    assign addry_sign_left = vcount_in - ypos_sign_left;
    assign addrx_sign_left = hcount_in - xpos_sign_left;
    assign addry_sign_right = vcount_in - ypos_sign_right;
    assign addrx_sign_right = hcount_in - xpos_sign_right;  
    
    always @(*)
    begin
    if (board == 1)
        begin
            addry_crown <= vcount_in - ypos_crown;
            addrx_crown <= hcount_in - xpos_crown;
        end
    else
        begin
            addry_crown <= vcount_in - ypos_crownL;
            addrx_crown <= hcount_in - xpos_crownL;
        end    
    end
    
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
        pixel_addr_sign_left <= {addry_sign_left[6:0], addrx_sign_left[6:0]};
        pixel_addr_sign_right <= {addry_sign_right[6:0], addrx_sign_right[6:0]};
        pixel_addr_crown <= {addry_crown[4:0], addrx_crown[4:0]};
    end
    
     

    always@(posedge clk)
    begin
    if (reset)
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
                if ((board == 1) && (xpos_R < 200))
                begin
                    winR <= 1;
                    if ((vcount_in <= ypos_crown + SIZE_CROWN - 1) && (vcount_in >= ypos_crown) && (hcount_in <= xpos_crown + SIZE_CROWN + 1) && (hcount_in >= xpos_crown + 2) && (rgb_pixel_crown != 12'h198)) rgb_out_nxt <= rgb_pixel_crown;         
                    else if ((vcount_in <= ypos_sign_left + SIZE - 1) && (vcount_in >= ypos_sign_left) && (hcount_in <= xpos_sign_left + SIZE + 1) && (hcount_in >= xpos_sign_left + 2) && (rgb_pixel_sign_left == 12'hB0F)) rgb_out_nxt <= 12'hCF0;         
                    else if ((vcount_in <= ypos_sign_right + SIZE - 1) && (vcount_in >= ypos_sign_right) && (hcount_in <= xpos_sign_right + SIZE + 1) && (hcount_in >= xpos_sign_right + 2) && (rgb_pixel_sign_right == 12'hB0F)) rgb_out_nxt <= 12'hCF0;
                    else if ((vcount_in <= ypos_sign_left + SIZE - 1) && (vcount_in >= ypos_sign_left) && (hcount_in <= xpos_sign_left + SIZE + 1) && (hcount_in >= xpos_sign_left + 2) && (rgb_pixel_sign_left == 12'h305)) rgb_out_nxt <= 12'h774;         
                    else if ((vcount_in <= ypos_sign_right + SIZE - 1) && (vcount_in >= ypos_sign_right) && (hcount_in <= xpos_sign_right + SIZE + 1) && (hcount_in >= xpos_sign_right + 2) && (rgb_pixel_sign_right == 12'h305)) rgb_out_nxt <= 12'h774;
                    else rgb_out_nxt <= rgb_in;
                end
                else if ((board == 5) && (xpos_L > (1024 - 64 - 200)))
                begin
                    winL <= 1;
                    if ((vcount_in <= ypos_crownL + SIZE_CROWN - 1) && (vcount_in >= ypos_crownL) && (hcount_in <= xpos_crownL + SIZE_CROWN + 1) && (hcount_in >= xpos_crownL + 2) && (rgb_pixel_crown != 12'h198)) rgb_out_nxt <= rgb_pixel_crown;         
                    else if ((vcount_in <= ypos_sign_left + SIZE - 1) && (vcount_in >= ypos_sign_left) && (hcount_in <= xpos_sign_left + SIZE + 1) && (hcount_in >= xpos_sign_left + 2) && (rgb_pixel_sign_left != 12'h198)) rgb_out_nxt <= rgb_pixel_sign_left;         
                    else if ((vcount_in <= ypos_sign_right + SIZE - 1) && (vcount_in >= ypos_sign_right) && (hcount_in <= xpos_sign_right + SIZE + 1) && (hcount_in >= xpos_sign_right + 2) && (rgb_pixel_sign_right != 12'h198)) rgb_out_nxt <= rgb_pixel_sign_right;
                    else rgb_out_nxt <= rgb_in;
                end
                else rgb_out_nxt <= rgb_in;
            end
            else rgb_out_nxt = 12'h0_0_0;
        end
    end
     
endmodule
