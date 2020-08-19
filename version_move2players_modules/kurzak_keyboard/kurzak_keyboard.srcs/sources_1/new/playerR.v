`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2020 19:45:48
// Design Name: 
// Module Name: playerR
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


module k_playerR(
    input wire clk_50MHz,
    input wire rst,
    input wire RP_left,
    input wire RP_right,
    output reg [11:0] RP_x_pos 
    );
    
    reg [11:0] RP_x_pos_nxt;
    reg [63:0] counter = 0; 
    
  always@(posedge clk_50MHz, posedge rst)
      begin
      if (rst) begin
          RP_x_pos <= 0;
      end else begin
          RP_x_pos <= RP_x_pos_nxt;
          if (counter == 100000)
            begin 
              if (RP_left == 1'b1) begin
                RP_x_pos_nxt = RP_x_pos + 1;
                counter = 0;
              end else if (RP_right == 1'b1) begin
                RP_x_pos_nxt = RP_x_pos - 1;
                counter = 0;
              end
            end
          else
           counter = counter + 1;
      end end
    
endmodule
