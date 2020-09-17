`timescale 1ns / 1ps


module dead_timer(
    input wire clk,
    input wire reset,
    input wire active,
    input wire premature_stop,
    output reg death
    );
    
    reg [25:0] counter = 0;
    
    always @(posedge clk)
        if (reset || (!active) || premature_stop)
            begin
                death <= 0;
                counter <= 0;
            end
        else if (active == 1)
        begin
            if (counter < 67108860)
            begin
                death <= 1;
                counter <= counter + 1;
            end
            else
            begin
                death <= 0;
                counter <= 0;
            end
        end
    
endmodule
