`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 18:48:03
// Design Name: 
// Module Name: action_control
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


module action_control(
    input wire clk,
    input wire reset,
    input wire [11:0] xpos_playerR,
    input wire [11:0] ypos_playerR,
    input wire [11:0] xpos_sword_R,
    input wire [11:0] ypos_sword_R,
    input wire [11:0] xpos_playerL,
    input wire [11:0] ypos_playerL,
    input wire [11:0] xpos_sword_L,
    input wire [11:0] ypos_sword_L,
    output reg dead_L,
    output reg dead_R
    );


    
    always @(posedge clk)
    if (reset)
        begin
            dead_L <= 0;
            dead_R <= 0;
        end
    else
        begin
            if (ypos_sword_L != ypos_sword_R)
                begin
                    if ((xpos_sword_R <= (xpos_playerL + 64 - 18)) && (xpos_sword_R > (xpos_playerL + 64 - 18 - 40)) && (ypos_sword_R > ypos_playerL) && (ypos_sword_R < (ypos_playerL + 128)) && (dead_L < 1) && (dead_R < 1)) dead_L <= 1; //= dead_L + 1;
//                    else if ((xpos_sword_R <= (xpos_playerL + 64 - 24)) && (ypos_sword_R > ypos_playerL) && (ypos_sword_R < (ypos_playerL + 128)) && (dead_L >= 1)) dead_L <= 1;
                    else if ((xpos_sword_L >= (xpos_playerR - 18)) && (xpos_sword_L < (xpos_playerR - 18 + 40)) && (ypos_sword_L > ypos_playerR) && (ypos_sword_L < (ypos_playerR + 128)) && (dead_R < 1) && (dead_L < 1)) dead_R <= 1;//dead_R + 1;
//                    else if ((xpos_sword_L >= (xpos_playerR - 24)) && (ypos_sword_L > ypos_playerR) && (ypos_sword_L < (ypos_playerR + 128)) && (dead_R >= 1)) dead_R <= 1;
                    else
                    begin
                        dead_L <= 0;
                        dead_R <= 0;
                    end
                end
            else
                begin
                    dead_L <= 0;
                    dead_R <= 0;
                end
        end
    
endmodule
