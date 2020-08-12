`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.08.2020 21:53:18
// Design Name: 
// Module Name: keyboard
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


module keyboard(
    input wire clk_50MHz,
    input wire rst,
    input wire PS2Data,
    input wire PS2Clk,
    output reg [1:0] key,
    output reg [11:0] rgb_out
    );
    
wire [15:0] keycode;
reg [11:0] rgb_out_nxt;   
   
//----------------------
//Left player    
localparam LP_GO_LEFT                   = 8'h1C;    //press:    a
localparam LP_GO_RIGHT                  = 8'h23;    //press:    d
localparam LP_SWORD_UP                  = 8'h1D;    //press:    w
localparam LP_SWORD_DOWN                = 8'h1B;    //press:    s
localparam LP_THROW_OR_PICK_UP_SWORD    = 8'h12;    //press:    shift left
localparam LP_JUMP                      = 8'h29;    //press:    spacebar

//----------------------
//Right player    
localparam RP_GO_LEFT                   = 8'h6B;    //press:    arrow left
localparam RP_GO_RIGHT                  = 8'hE0;    //press:    arrow right
localparam RP_SWORD_UP                  = 8'h75;    //press:    arrow up
localparam RP_SWORD_DOWN                = 8'h72;    //press:    arrow down
localparam RP_THROW_OR_PICK_UP_SWORD    = 8'h59;    //press:    shift right
localparam RP_JUMP                      = 8'h5A;    //press:    enter

//reg and wire here

/*
  PS2Receiver uut (
    .clk(clk_50MHz),
    .kclk(PS2Clk),
    .kdata(PS2Data),
    .keycode(keycode),
    .oflag(flag)
  );
*/

/*
  always@(*)
    if (keycode[7:0] == 8'hf0) begin
    
    end
*/

/*
  always@(posedge clk_50MHz) begin
    ... <= ...  
  end
*/

  always@(posedge clk_50MHz, posedge rst)
    begin
    if (rst)
        rgb_out <= 0;
    else
        rgb_out <= rgb_out_nxt;
    end

  always@(*)
    case (keycode[7:0])
      RP_GO_RIGHT: begin
        //zmiana wartosci horizontal
        rgb_out_nxt = 12'h6_f_f;
      end
      RP_GO_LEFT: begin
        //zmiana wartosci horizontal
        rgb_out_nxt = 12'hf_f_6;
      end
    endcase
  
endmodule
