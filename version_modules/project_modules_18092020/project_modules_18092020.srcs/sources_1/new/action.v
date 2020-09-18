`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 01:58:00
// Design Name: 
// Module Name: action
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


module action(
    input wire clk_65MHz,
    input wire rst,
    input wire [11:0] xpos_playerR,
    input wire [11:0] ypos_playerR,
    input wire [11:0] xpos_sword_R,
    input wire [11:0] ypos_sword_R,
    input wire [11:0] xpos_playerL,
    input wire [11:0] ypos_playerL,
    input wire [11:0] xpos_sword_L,
    input wire [11:0] ypos_sword_L,
    output reg dead_L,
    output reg dead_R,
    output reg collision,
    output reg pos_reset,
    output reg [2:0] board_controller
    );
    
    reg [2:0] board_controller_nxt = 0;
       
    always @(posedge clk_65MHz)
    if (rst)
        begin
            dead_L <= 0;
            dead_R <= 0;
            collision <= 0;
            pos_reset <= 1'b0;
            board_controller <= 0;
        end
    else
           begin
           board_controller <= board_controller_nxt;
               if (xpos_playerR <= 40)
                   begin
                       board_controller_nxt <= board_controller_nxt - 1;
                       pos_reset <= 1'b1;
                   end  
               else if (xpos_playerL >= (1024 - 40 - 64)) 
                    begin
                       board_controller_nxt <= board_controller_nxt + 1;
                       pos_reset <= 1'b1;
                    end   
               else if ((ypos_sword_L == ypos_sword_R) && ((xpos_sword_L + 32) == xpos_sword_R)) collision <= 1;
               else if (ypos_sword_L != ypos_sword_R)
                   begin
                       if ((xpos_sword_R <= (xpos_playerL + 64 - 24)) && (ypos_sword_R > ypos_playerL) && (ypos_sword_R < (ypos_playerL + 128)) && (dead_L < 1)) dead_L <= dead_L + 1;
                       else if ((xpos_sword_R <= (xpos_playerL + 64 - 24)) && (ypos_sword_R > ypos_playerL) && (ypos_sword_R < (ypos_playerL + 128)) && (dead_L >= 1)) dead_L <= 1;
                       else if ((xpos_sword_L >= (xpos_playerR - 24)) && (ypos_sword_L > ypos_playerR) && (ypos_sword_L < (ypos_playerR + 128)) && (dead_R < 1)) dead_R <= dead_R + 1;
                       else if ((xpos_sword_L >= (xpos_playerR - 24)) && (ypos_sword_L > ypos_playerR) && (ypos_sword_L < (ypos_playerR + 128)) && (dead_R >= 1)) dead_R <= 1;
                   end
               else
                   begin
                       pos_reset <= 1'b0;
                       dead_L <= 0;
                       dead_R <= 0;
                       collision <= 0;
                   end
           end    
    
endmodule
