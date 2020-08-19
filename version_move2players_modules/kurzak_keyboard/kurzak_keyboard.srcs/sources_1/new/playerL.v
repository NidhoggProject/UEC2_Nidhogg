`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2020 19:42:05
// Design Name: 
// Module Name: playerL
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


module k_playerL(
    input wire clk_50MHz,
    input wire rst,
    input wire LP_left,
    input wire LP_right,
    output reg [11:0] LP_x_pos  
    );
    
    reg [11:0] LP_x_pos_nxt;
    reg [63:0] counter = 0; 
    
  always@(posedge clk_50MHz, posedge rst)
      begin
      if (rst) begin
          LP_x_pos <= 0;
      end else begin
          LP_x_pos <= LP_x_pos_nxt;
          if (counter == 100000)
            begin 
              if (LP_left == 1'b1) begin
                LP_x_pos_nxt = LP_x_pos + 1;
                counter = 0;
                //if (RP_left == 1'b1) begin
                  //RP_x_pos_nxt = RP_x_pos + 1;
                  //counter = 0;
                //end
              end else if (LP_right == 1'b1) begin
                LP_x_pos_nxt = LP_x_pos - 1;
                counter = 0;
              end
            end
          else
           counter = counter + 1;
      end end
    
endmodule
