`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 18:47:03
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
    input wire [11:0] rgb_pixel_up_window,
    input wire [11:0] rgb_pixel_down_window,
    input wire [11:0] xpos_playerR,
    input wire [11:0] xpos_playerL,
    output reg [11:0] vcount_out,
    output reg vsync_out,
    output reg vblnk_out,
    output reg [11:0] hcount_out,
    output reg hsync_out,
    output reg hblnk_out,
    output reg [11:0] pixel_addr_up,
    output reg [11:0] pixel_addr_down,
    output reg [11:0] pixel_addr_up_window,
    output reg [11:0] pixel_addr_down_window,
    output reg [11:0] rgb_out,
    output reg [4:0] board_out,
    output reg pos_reset
        );
        
    
    reg [11:0] rgb_out_nxt, rgb_out_reg;    
    localparam HEIGHT = 64;
    localparam WIDTH = 64;
    
    localparam xpos_up = 586;
    localparam ypos_up = 100;
    localparam xpos_down = xpos_up;
    localparam ypos_down = ypos_up + 64;
    localparam xpos_up2 = 150;
    localparam ypos_up2 = 100;
    localparam xpos_down2 = xpos_up2;
    localparam ypos_down2 = ypos_up2 + 64;
    localparam xpos_up_window = xpos_up;
    localparam ypos_up_window = ypos_up;
    localparam xpos_down_window = xpos_up;
    localparam ypos_down_window = ypos_up + 64;
    localparam xpos_up2_window = xpos_up2;
    localparam ypos_up2_window = ypos_up2;
    localparam xpos_down2_window = xpos_up2;
    localparam ypos_down2_window = ypos_up2 + 64;
    
    wire [5:0] addrx_up;
    wire [5:0] addry_up;
    wire [5:0] addrx_down;
    wire [5:0] addry_down;
    wire [5:0] addrx_up_window;
    wire [5:0] addry_up_window;
    wire [5:0] addrx_down_window;
    wire [5:0] addry_down_window;
    
    
    assign addry_up = vcount_in - ypos_up;
    assign addrx_up = hcount_in - xpos_up;
    assign addry_down = vcount_in - ypos_down;
    assign addrx_down = hcount_in - xpos_down;  
    assign addry_up_window = vcount_in - ypos_up_window;
    assign addrx_up_window = hcount_in - xpos_up_window;
    assign addry_down_window = vcount_in - ypos_down_window;
    assign addrx_down_window = hcount_in - xpos_down_window;  
    
    reg [4:0] counterL_nxt = 0, counterR_nxt = 0;
    reg [4:0] counterL, counterR;
    
    
    always @(posedge clk)
        begin
            board_out <= (5 - counterR + counterL);
            counterR <= counterR_nxt;
            counterL <= counterL_nxt;
            if ((xpos_playerR == 40) && (pos_reset != 1))
                begin
                    pos_reset <= 1;
                    counterR_nxt <= counterR + 1;
                end
            else if ((xpos_playerL == (800 - 40 - 64)) && (pos_reset != 1))
                begin
                    counterL_nxt <= counterL + 1;
                    pos_reset <= 1;
                end
            else pos_reset <= 0;
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
        pixel_addr_up <= {addry_up[5:0], addrx_up[5:0]};
        pixel_addr_down <= {addry_down[5:0], addrx_down[5:0]};
        pixel_addr_up_window <= {addry_up_window[5:0], addrx_up_window[5:0]};
        pixel_addr_down_window <= {addry_down_window[5:0], addrx_down_window[5:0]};
//        board_out <= (3 - board_controller + board_controller_L);

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
                3:
                    begin
                    // lewe okno
                    if ((vcount_in <= ypos_down2_window + HEIGHT - 1) && (vcount_in >= ypos_down2_window) && (hcount_in <= xpos_down2_window + WIDTH -11) && (hcount_in >= xpos_down2_window -10) && (rgb_pixel_down_window != 12'h198)) rgb_out_nxt <= rgb_pixel_down_window;         
                    else if ((vcount_in <= ypos_up2_window + HEIGHT - 1) && (vcount_in >= ypos_up2_window ) && (hcount_in <= xpos_up2_window + WIDTH -11) && (hcount_in >= xpos_up2_window -10) && (rgb_pixel_up_window != 12'h198)) rgb_out_nxt <= rgb_pixel_up_window;  
                                        
                    // pochodnia prawo
                    else if ((vcount_in <= ypos_down + HEIGHT - 1) && (vcount_in >= ypos_down) && (hcount_in <= xpos_down + WIDTH + 1) && (hcount_in >= xpos_down + 2) && (rgb_pixel_down != 12'h198)) rgb_out_nxt <= rgb_pixel_down;         
                    else if ((vcount_in <= ypos_up + HEIGHT - 1) && (vcount_in >= ypos_up ) && (hcount_in <= xpos_up + WIDTH + 1) && (hcount_in >= xpos_up + 2) && (rgb_pixel_up != 12'h198)) rgb_out_nxt <= rgb_pixel_up;  
                    else rgb_out_nxt = rgb_in;                    
                    end
                5:
                    begin
                    // prawe okno
                    if ((vcount_in <= ypos_down2_window + HEIGHT - 1) && (vcount_in >= ypos_down2_window) && (hcount_in <= xpos_down2_window + WIDTH -11) && (hcount_in >= xpos_down2_window -10) && (rgb_pixel_down_window != 12'h198)) rgb_out_nxt <= rgb_pixel_down_window;         
                    else if ((vcount_in <= ypos_up2_window + HEIGHT - 1) && (vcount_in >= ypos_up2_window ) && (hcount_in <= xpos_up2_window + WIDTH -11) && (hcount_in >= xpos_up2_window -10) && (rgb_pixel_up_window != 12'h198)) rgb_out_nxt <= rgb_pixel_up_window;  
                    // okno lewo
                    else if ((vcount_in <= ypos_down_window + HEIGHT - 1) && (vcount_in >= ypos_down_window) && (hcount_in <= xpos_down_window + WIDTH + 1) && (hcount_in >= xpos_down_window + 2) && (rgb_pixel_down_window != 12'h198)) rgb_out_nxt <= rgb_pixel_down_window;         
                    else if ((vcount_in <= ypos_up_window + HEIGHT - 1) && (vcount_in >= ypos_up_window ) && (hcount_in <= xpos_up_window + WIDTH + 1) && (hcount_in >= xpos_up_window + 2) && (rgb_pixel_up_window != 12'h198)) rgb_out_nxt <= rgb_pixel_up_window;  
                    else rgb_out_nxt = rgb_in;    
                    end
                7:
                    begin
                    //pochodnia
                    if ((vcount_in <= ypos_down2 + HEIGHT - 1) && (vcount_in >= ypos_down2) && (hcount_in <= xpos_down2 + WIDTH + 1) && (hcount_in >= xpos_down2 + 2) && (rgb_pixel_down != 12'h198)) rgb_out_nxt <= rgb_pixel_down;         
                    else if ((vcount_in <= ypos_up2 + HEIGHT - 1) && (vcount_in >= ypos_up2 ) && (hcount_in <= xpos_up2 + WIDTH + 1) && (hcount_in >= xpos_up2 + 2) && (rgb_pixel_up != 12'h198)) rgb_out_nxt <= rgb_pixel_up;  
                    //okno prawo
                    else if ((vcount_in <= ypos_down_window + HEIGHT - 1) && (vcount_in >= ypos_down_window) && (hcount_in <= xpos_down_window + WIDTH + 1) && (hcount_in >= xpos_down_window + 2) && (rgb_pixel_down_window != 12'h198)) rgb_out_nxt <= rgb_pixel_down_window;         
                    else if ((vcount_in <= ypos_up_window + HEIGHT - 1) && (vcount_in >= ypos_up_window ) && (hcount_in <= xpos_up_window + WIDTH + 1) && (hcount_in >= xpos_up_window + 2) && (rgb_pixel_up_window != 12'h198)) rgb_out_nxt <= rgb_pixel_up_window;  
                    else rgb_out_nxt = rgb_in;
                    end
                9:
                    begin
                    // pochodnia prawo
                    if ((vcount_in <= ypos_down + HEIGHT - 1) && (vcount_in >= ypos_down) && (hcount_in <= xpos_down + WIDTH + 1) && (hcount_in >= xpos_down + 2) && (rgb_pixel_down != 12'h198)) rgb_out_nxt <= rgb_pixel_down;         
                    else if ((vcount_in <= ypos_up + HEIGHT - 1) && (vcount_in >= ypos_up ) && (hcount_in <= xpos_up + WIDTH + 1) && (hcount_in >= xpos_up + 2) && (rgb_pixel_up != 12'h198)) rgb_out_nxt <= rgb_pixel_up;  
                    // pochodnia lewo
                    else if ((vcount_in <= ypos_down2 + HEIGHT - 1) && (vcount_in >= ypos_down2) && (hcount_in <= xpos_down2 + WIDTH + 1) && (hcount_in >= xpos_down2 + 2) && (rgb_pixel_down != 12'h198)) rgb_out_nxt <= rgb_pixel_down;         
                    else if ((vcount_in <= ypos_up2 + HEIGHT - 1) && (vcount_in >= ypos_up2 ) && (hcount_in <= xpos_up2 + WIDTH + 1) && (hcount_in >= xpos_up2 + 2) && (rgb_pixel_up != 12'h198)) rgb_out_nxt <= rgb_pixel_up;  
                    else rgb_out_nxt = rgb_in;    
                end
                default:
                    begin
                // prawe okno
                if ((vcount_in <= ypos_down2_window + HEIGHT - 1) && (vcount_in >= ypos_down2_window) && (hcount_in <= xpos_down2_window + WIDTH -11) && (hcount_in >= xpos_down2_window -10) && (rgb_pixel_down_window != 12'h198)) rgb_out_nxt <= rgb_pixel_down_window;         
                else if ((vcount_in <= ypos_up2_window + HEIGHT - 1) && (vcount_in >= ypos_up2_window ) && (hcount_in <= xpos_up2_window + WIDTH -11) && (hcount_in >= xpos_up2_window -10) && (rgb_pixel_up_window != 12'h198)) rgb_out_nxt <= rgb_pixel_up_window;  
                // okno lewo
                else if ((vcount_in <= ypos_down_window + HEIGHT - 1) && (vcount_in >= ypos_down_window) && (hcount_in <= xpos_down_window + WIDTH + 1) && (hcount_in >= xpos_down_window + 2) && (rgb_pixel_down_window != 12'h198)) rgb_out_nxt <= rgb_pixel_down_window;         
                else if ((vcount_in <= ypos_up_window + HEIGHT - 1) && (vcount_in >= ypos_up_window ) && (hcount_in <= xpos_up_window + WIDTH + 1) && (hcount_in >= xpos_up_window + 2) && (rgb_pixel_up_window != 12'h198)) rgb_out_nxt <= rgb_pixel_up_window;  
                else rgb_out_nxt = rgb_in;    
                end        
                endcase
            end
            else rgb_out_nxt = 12'h000;
        end
    end
    
endmodule
