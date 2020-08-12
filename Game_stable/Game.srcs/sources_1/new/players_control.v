`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.08.2020 23:58:30
// Design Name: 
// Module Name: players_control
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


module players_control(
    input wire clk,
    input wire reset,
    input wire left,
    input wire right,
    output reg [11:0] xpos_playerL_out,
    output reg [11:0] ypos_playerL_out
    );
    
    wire [11:0] xpos_playerL_in = 75;
    wire [11:0] ypos_playerL_in = 600;
    
    reg[63:0] counter = 0;
    
    always @(posedge clk, posedge reset)
    begin
        if (reset)
        begin
        end
        
        else
        begin
            if (counter == 10000)
            begin
                if (right)
                begin
                    xpos_playerL_out <= xpos_playerL_out + 1;
                end
                else if (left)
                begin
                    ypos_playerL_out <= ypos_playerL_out - 1;
                end
            counter = 0;
            end
            else
            begin
                counter = counter + 1;
                xpos_playerL_out <= 75;
                ypos_playerL_out <= 600;
            end
        end
    end
    
endmodule
