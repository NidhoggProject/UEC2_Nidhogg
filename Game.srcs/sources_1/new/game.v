`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.05.2020 15:32:17
// Design Name: 
// Module Name: game
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


module game(
    input wire clk,
    input wire reset,
    input wire a_signal,
    input wire d_signal,
    input wire s_signal,
    input wire w_signal,
    input wire shift_l_signal,
    input wire space_signal,
    input wire left_signal,
    input wire right_signal,
    input wire top_signal,
    input wire bottom_signal,
    input wire enter_signal,
    input wire shift_r_signal,
/*    input wire [11:0] x_LP,
    input wire [11:0] y_LP,
    input wire [11:0] x_sword_LP,
    input wire [11:0] y_sword_LP,
    input wire [11:0] x_RP,
    input wire [11:0] y_RP,
    input wire [11:0] x_sword_RP,
    input wire [11:0] y_sword_RP,*/
    output reg [11:0] x_LP,
    output reg [11:0] y_LP,
    output reg [11:0] x_sword_LP,
    output reg [11:0] y_sword_LP,
    output reg [11:0] x_RP,
    output reg [11:0] y_RP,
    output reg [11:0] x_sword_RP,
    output reg [11:0] y_sword_RP,
    output reg [2:0] LP_sword_position,
    output reg [2:0] RP_sword_position,
    output reg [2:0] board_number
    );
    
    reg [63:0] counter = 0;
    reg [11:0] x_RP_nxt, y_RP_nxt, x_LP_nxt, y_LP_nxt;

always @(*)
begin
    if (reset)
    begin
    end
    if (clk)
        begin
        board_number = 4;
        LP_sword_position = 1;
        RP_sword_position = 1;
        counter = counter + 1;
        x_RP <= (1024 - 68- 15);
        y_RP <= (768-140);
        x_LP <= 15;
        y_LP <= (768 - 140);
        if(RP_sword_position == 1)
            begin
            x_sword_RP = (x_RP - 35);
            y_sword_RP = (y_RP + 25);
            end
        if(LP_sword_position == 1)
            begin
            x_sword_LP <= (x_LP + 45);
            y_sword_LP <= (y_LP + 25);
            end
        if(RP_sword_position == 0)
            begin
            x_sword_RP <= (x_RP - 35);
            y_sword_RP <= (y_RP + 42);
            end
        if(LP_sword_position == 0)
            begin
            x_sword_LP <= (x_LP + 45);
            y_sword_LP <= (y_LP + 42);
            end
        if(RP_sword_position == 2)
            begin
            x_sword_RP <= (x_RP - 35);
            y_sword_RP <= (y_RP + 19);
            end
        if(LP_sword_position == 2)
            begin
            x_sword_LP <= (x_RP + 45);
            y_sword_LP <= (y_RP - 19);
            end
        if (counter == 10000)
            counter = 0;
            if (a_signal)
                x_LP = (x_LP - 1);
            if (left_signal)
                x_RP = (x_RP - 1);
            if (d_signal)
                x_LP= (x_LP + 1);
            if (right_signal)
                x_RP = (x_RP + 1);
            if (space_signal)
                begin
                if (y_LP < 250)
                    y_LP = (y_LP + 1);
                else
                    y_LP = (y_LP - 1);
                end
            if (enter_signal)
                begin
                if (y_RP < 250)
                    y_RP = (y_RP + 1);
                else
                    y_RP = (y_RP - 1);
                end
            if (w_signal)
                begin
                if (LP_sword_position < 2)
                    LP_sword_position = (LP_sword_position + 1);
                end
            if (top_signal)
                begin
                if (RP_sword_position < 2)
                    RP_sword_position = (RP_sword_position + 1);
                end
            if (s_signal)
                begin
                if ((LP_sword_position > 0) && (LP_sword_position < 3))
                    LP_sword_position = (LP_sword_position - 1);
                end
            if (bottom_signal)
                begin
                if ((RP_sword_position > 0) && (RP_sword_position < 3))
                    RP_sword_position = (RP_sword_position - 1);
                end
        if (x_RP < 20)
            board_number = board_number + 1;
        else if (x_LP > (768 - 20 - 46))
            board_number = board_number - 1;
    end
end

endmodule