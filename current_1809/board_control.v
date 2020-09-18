`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.08.2020 22:32:04
// Design Name: 
// Module Name: board_control
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


module board_control(
    input wire clk,
    input wire reset,
    input wire [11:0] vcount_in,
    input wire vsync_in,
    input wire vblnk_in,
    input wire [11:0] hcount_in,
    input wire hsync_in,
    input wire hblnk_in,
    input wire [11:0] rgb_in,
    input wire [11:0] rgb_pixel_up,
    input wire [11:0] rgb_pixel_down,
    input wire [4:0] board_controller,
    input wire [4:0] board_controller_L,
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] pixel_addr_up,
    output reg [11:0] pixel_addr_down,
    output reg [11:0] rgb_out,
    output reg [2:0] board_out
    );
        
        
/*    always@(*)
    begin
        if (board_change) board_out <= board_in - 1;
        else board_out <= board_in;
        if (board_out == 1) board_out = 1;
        else if (board_out == 2) board_out = 1;
        else if (board_out == 3) board_out = 2;
        else if (board_out == 4) board_out = 3;
        else if (board_out == 5) board_out = 4;
        else board_out = 3;
        if ((board_out != 5) && (board_out != 1))
            board_out <= 3 - board_change;
    end*/
    
    reg [11:0] rgb_out_nxt;    
    localparam HEIGHT = 64;
    localparam WIDTH = 64;
    localparam xpos_up = 732;
    localparam ypos_up = 160;
    localparam xpos_down = xpos_up;
    localparam ypos_down = ypos_up + 64;
    localparam xpos_up2 = 228;
    localparam ypos_up2 = 160;
    localparam xpos_down2 = xpos_up2;
    localparam ypos_down2 = ypos_up2 + 64;
    
    wire [5:0] addrx_up;
    wire [5:0] addry_up;
    wire [5:0] addrx_down;
    wire [5:0] addry_down;
    
    
    assign addry_up = vcount_in - ypos_up;
    assign addrx_up = hcount_in - xpos_up;
    assign addry_down = vcount_in - ypos_down;
    assign addrx_down = hcount_in - xpos_down;  
    

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
        pixel_addr_up <= {addry_up[5:0], addrx_up[5:0]};
        pixel_addr_down <= {addry_down[5:0], addrx_down[5:0]};
        board_out <= (3 - board_controller + board_controller_L);
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
                case(board_out)
                1:
                    begin
                    // pochodnia prawo
                    if ((vcount_in <= ypos_down + HEIGHT - 1) && (vcount_in >= ypos_down) && (hcount_in <= xpos_down + WIDTH + 1) && (hcount_in >= xpos_down + 2) && (rgb_pixel_down != 12'h198)) rgb_out_nxt <= rgb_pixel_down;         
                    else if ((vcount_in <= ypos_up + HEIGHT - 1) && (vcount_in >= ypos_up ) && (hcount_in <= xpos_up + WIDTH + 1) && (hcount_in >= xpos_up + 2) && (rgb_pixel_up != 12'h198)) rgb_out_nxt <= rgb_pixel_up;  
                    // pochodnia lewo
                    else if ((vcount_in <= ypos_down2 + HEIGHT - 1) && (vcount_in >= ypos_down2) && (hcount_in <= xpos_down2 + WIDTH + 1) && (hcount_in >= xpos_down2 + 2) && (rgb_pixel_down != 12'h198)) rgb_out_nxt <= rgb_pixel_down;         
                    else if ((vcount_in <= ypos_up2 + HEIGHT - 1) && (vcount_in >= ypos_up2 ) && (hcount_in <= xpos_up2 + WIDTH + 1) && (hcount_in >= xpos_up2 + 2) && (rgb_pixel_up != 12'h198)) rgb_out_nxt <= rgb_pixel_up;  
                    else rgb_out_nxt = rgb_in;    
                    end
                2:
                    begin
                    // lewe okno
                    if ((hcount_in <= 265) && (hcount_in >= 255) && (vcount_in <= 300) && (vcount_in >= 150)) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in <= 320) && (hcount_in >= 200) && (((vcount_in <= 205) && (vcount_in >= 195)) || ((vcount_in <= 255) && (vcount_in >= 245)) || ((vcount_in <= 305) && (vcount_in >= 295)))) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in >= 210) && (hcount_in <= 310) && (vcount_in <= 300) && (vcount_in >= 200)) rgb_out_nxt <= 12'h113;
                    else if ((hcount_in - 260)*(hcount_in - 260) + (vcount_in - 200)*(vcount_in - 200) <= 50*50) rgb_out_nxt <= 12'h113;
                    else if ((hcount_in >= 200) && (hcount_in <= 320) && (vcount_in <= 310) && (vcount_in >= 200)) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in - 260)*(hcount_in - 260) + (vcount_in - 200)*(vcount_in - 200) <= 60*60) rgb_out_nxt <= 12'h222;

                    // pochodnia prawo
                    else if ((vcount_in <= ypos_down + HEIGHT - 1) && (vcount_in >= ypos_down) && (hcount_in <= xpos_down + WIDTH + 1) && (hcount_in >= xpos_down + 2) && (rgb_pixel_down != 12'h198)) rgb_out_nxt <= rgb_pixel_down;         
                    else if ((vcount_in <= ypos_up + HEIGHT - 1) && (vcount_in >= ypos_up ) && (hcount_in <= xpos_up + WIDTH + 1) && (hcount_in >= xpos_up + 2) && (rgb_pixel_up != 12'h198)) rgb_out_nxt <= rgb_pixel_up;  
                    else rgb_out_nxt = rgb_in;                    
                    end
                3:
                    begin
                    //lewe okno
                    if ((hcount_in <= 265) && (hcount_in >= 255) && (vcount_in <= 300) && (vcount_in >= 150)) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in <= 320) && (hcount_in >= 200) && (((vcount_in <= 205) && (vcount_in >= 195)) || ((vcount_in <= 255) && (vcount_in >= 245)) || ((vcount_in <= 305) && (vcount_in >= 295)))) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in >= 210) && (hcount_in <= 310) && (vcount_in <= 300) && (vcount_in >= 200)) rgb_out_nxt <= 12'h113;
                    else if ((hcount_in - 260)*(hcount_in - 260) + (vcount_in - 200)*(vcount_in - 200) <= 50*50) rgb_out_nxt <= 12'h113;
                    else if ((hcount_in >= 200) && (hcount_in <= 320) && (vcount_in <= 310) && (vcount_in >= 200)) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in - 260)*(hcount_in - 260) + (vcount_in - 200)*(vcount_in - 200) <= 60*60) rgb_out_nxt <= 12'h222;
                    
                    //prawe okno
                    else if ((hcount_in <= 769) && (hcount_in >= 759) && (vcount_in <= 300) && (vcount_in >= 150)) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in <= 824) && (hcount_in >= 704) && (((vcount_in <= 205) && (vcount_in >= 195)) || ((vcount_in <= 255) && (vcount_in >= 245)) || ((vcount_in <= 305) && (vcount_in >= 295)))) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in >= 714) && (hcount_in <= 814) && (vcount_in <= 300) && (vcount_in >= 200)) rgb_out_nxt <= 12'h113;
                    else if ((hcount_in - 764)*(hcount_in - 764) + (vcount_in - 200)*(vcount_in - 200) <= 50*50) rgb_out_nxt <= 12'h113;
                    else if ((hcount_in >= 704) && (hcount_in <= 824) && (vcount_in <= 310) && (vcount_in >= 200)) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in - 764)*(hcount_in - 764) + (vcount_in - 200)*(vcount_in - 200) <= 60*60) rgb_out_nxt <= 12'h222;
                    else rgb_out_nxt = rgb_in;
                    end
                4:
                    begin
                    //pochodnia
                    if ((vcount_in <= ypos_down2 + HEIGHT - 1) && (vcount_in >= ypos_down2) && (hcount_in <= xpos_down2 + WIDTH + 1) && (hcount_in >= xpos_down2 + 2) && (rgb_pixel_down != 12'h198)) rgb_out_nxt <= rgb_pixel_down;         
                    else if ((vcount_in <= ypos_up2 + HEIGHT - 1) && (vcount_in >= ypos_up2 ) && (hcount_in <= xpos_up2 + WIDTH + 1) && (hcount_in >= xpos_up2 + 2) && (rgb_pixel_up != 12'h198)) rgb_out_nxt <= rgb_pixel_up;  
                    //okno prawo
                    else if ((hcount_in <= 769) && (hcount_in >= 759) && (vcount_in <= 300) && (vcount_in >= 150)) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in <= 824) && (hcount_in >= 704) && (((vcount_in <= 205) && (vcount_in >= 195)) || ((vcount_in <= 255) && (vcount_in >= 245)) || ((vcount_in <= 305) && (vcount_in >= 295)))) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in >= 714) && (hcount_in <= 814) && (vcount_in <= 300) && (vcount_in >= 200)) rgb_out_nxt <= 12'h113;
                    else if ((hcount_in - 764)*(hcount_in - 764) + (vcount_in - 200)*(vcount_in - 200) <= 50*50) rgb_out_nxt <= 12'h113;
                    else if ((hcount_in >= 704) && (hcount_in <= 824) && (vcount_in <= 310) && (vcount_in >= 200)) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in - 764)*(hcount_in - 764) + (vcount_in - 200)*(vcount_in - 200) <= 60*60) rgb_out_nxt <= 12'h222;
                    else rgb_out_nxt = rgb_in;
                    end
                5:
                    begin
                    // pochodnia prawo
                    if ((vcount_in <= ypos_down + HEIGHT - 1) && (vcount_in >= ypos_down) && (hcount_in <= xpos_down + WIDTH + 1) && (hcount_in >= xpos_down + 2) && (rgb_pixel_down != 12'h198)) rgb_out_nxt <= rgb_pixel_down;         
                    else if ((vcount_in <= ypos_up + HEIGHT - 1) && (vcount_in >= ypos_up ) && (hcount_in <= xpos_up + WIDTH + 1) && (hcount_in >= xpos_up + 2) && (rgb_pixel_up != 12'h198)) rgb_out_nxt <= rgb_pixel_up;  
                    //pochodnia lewo
                    else if ((vcount_in <= ypos_down2 + HEIGHT - 1) && (vcount_in >= ypos_down2) && (hcount_in <= xpos_down2 + WIDTH + 1) && (hcount_in >= xpos_down2 + 2) && (rgb_pixel_down != 12'h198)) rgb_out_nxt <= rgb_pixel_down;         
                    else if ((vcount_in <= ypos_up2 + HEIGHT - 1) && (vcount_in >= ypos_up2 ) && (hcount_in <= xpos_up2 + WIDTH + 1) && (hcount_in >= xpos_up2 + 2) && (rgb_pixel_up != 12'h198)) rgb_out_nxt <= rgb_pixel_up;  
                    else rgb_out_nxt = rgb_in;    
                    end
                default:
                    begin
                    //lewe okno
                    if ((hcount_in <= 265) && (hcount_in >= 255) && (vcount_in <= 300) && (vcount_in >= 150)) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in <= 320) && (hcount_in >= 200) && (((vcount_in <= 205) && (vcount_in >= 195)) || ((vcount_in <= 255) && (vcount_in >= 245)) || ((vcount_in <= 305) && (vcount_in >= 295)))) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in >= 210) && (hcount_in <= 310) && (vcount_in <= 300) && (vcount_in >= 200)) rgb_out_nxt <= 12'h113;
                    else if ((hcount_in - 260)*(hcount_in - 260) + (vcount_in - 200)*(vcount_in - 200) <= 50*50) rgb_out_nxt <= 12'h113;
                    else if ((hcount_in >= 200) && (hcount_in <= 320) && (vcount_in <= 310) && (vcount_in >= 200)) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in - 260)*(hcount_in - 260) + (vcount_in - 200)*(vcount_in - 200) <= 60*60) rgb_out_nxt <= 12'h222;
                    
                    //prawe okno
                    else if ((hcount_in <= 769) && (hcount_in >= 759) && (vcount_in <= 300) && (vcount_in >= 150)) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in <= 824) && (hcount_in >= 704) && (((vcount_in <= 205) && (vcount_in >= 195)) || ((vcount_in <= 255) && (vcount_in >= 245)) || ((vcount_in <= 305) && (vcount_in >= 295)))) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in >= 714) && (hcount_in <= 814) && (vcount_in <= 300) && (vcount_in >= 200)) rgb_out_nxt <= 12'h113;
                    else if ((hcount_in - 764)*(hcount_in - 764) + (vcount_in - 200)*(vcount_in - 200) <= 50*50) rgb_out_nxt <= 12'h113;
                    else if ((hcount_in >= 704) && (hcount_in <= 824) && (vcount_in <= 310) && (vcount_in >= 200)) rgb_out_nxt <= 12'h222;
                    else if ((hcount_in - 764)*(hcount_in - 764) + (vcount_in - 200)*(vcount_in - 200) <= 60*60) rgb_out_nxt <= 12'h222;
                    else rgb_out_nxt = rgb_in;                   
                    end                
                endcase
            end
            else rgb_out_nxt = 12'h000;
        end
    end
    
endmodule
