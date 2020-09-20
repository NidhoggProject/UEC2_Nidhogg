`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 18:46:11
// Design Name: 
// Module Name: dead_timer
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


module dead_timer(
    input wire clk,
    input wire reset,
    input wire active,
    input wire premature_stop,
    output reg death
    );
    
    reg [26:0] counter = 0;
    
    always @(posedge clk)
        if (reset || premature_stop)
            begin
                death <= 0;
                counter <= 0;
            end
        else if (active == 1)
            begin
                counter <= counter + 1;
                death <= 1;
            end
        else if ((counter < 134217700) && (counter > 0))
            begin
                death <= 1;
                counter <= counter + 1;
            end
        else
            begin
                death <= 0;
                counter <= 0;
            end
    
endmodule
