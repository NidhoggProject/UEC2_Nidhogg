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
    input wire [11:0] rgb_in,
    output reg [1:0] key,
    output reg [11:0] rgb_out,
    output reg [11:0] RP_x_pos,
    output reg [11:0] LP_x_pos
    );
    
wire [15:0] keycode;
reg [11:0] rgb_out_nxt;
//reg [11:0] LP_x_pos_nxt; // = 75;
//reg [11:0] RP_x_pos_nxt = 885;
reg [11:0] RP_x_pos_nxt;
reg [11:0] LP_x_pos_nxt;
wire flag;   

reg [63:0] counter = 0;    
reg start = 0;
//----------------------
//Left player    
localparam LP_GO_LEFT                   = 8'h1C;    //press:    a
localparam LP_GO_RIGHT                  = 8'h23;    //press:    d
localparam LP_SWORD_UP                  = 8'h1D;    //press:    w
localparam LP_SWORD_DOWN                = 8'h1B;    //press:    s
localparam LP_THROW_OR_PICK_UP_SWORD    = 8'h12;    //press:    shift left
localparam LP_JUMP                      = 8'h29;    //press:    spacebar
reg LP_left, LP_right;

//----------------------
//Right player    
localparam RP_GO_LEFT                   = 8'h6B;    //press:    arrow left
localparam RP_GO_RIGHT                  = 8'h74;    //press:    arrow right
localparam RP_SWORD_UP                  = 8'h75;    //press:    arrow up
localparam RP_SWORD_DOWN                = 8'h72;    //press:    arrow down
localparam RP_THROW_OR_PICK_UP_SWORD    = 8'h59;    //press:    shift right
localparam RP_JUMP                      = 8'h5A;    //press:    enter
reg RP_left, RP_right;  

  PS2Receiver my_PS2Receiver (
    .clk(clk_50MHz),
    .kclk(PS2Clk),
    .kdata(PS2Data),
    .keycode(keycode),
    .oflag(flag)
  );

/*
  always@(*)
    if (keycode[7:0] == 8'hf0) begin
    
    end
*/

  always@(posedge clk_50MHz, posedge rst)
    begin
    if (rst) begin
        rgb_out  <= 0;
        LP_x_pos <= 0;
        RP_x_pos <= 0;
    end else begin
        rgb_out  <= rgb_out_nxt;
        LP_x_pos <= LP_x_pos_nxt;
        RP_x_pos <= RP_x_pos_nxt;
        if (counter == 100000)
          begin 
            if ((LP_right == 1'b1) && (RP_left == 1'b1)) begin
              LP_x_pos_nxt = LP_x_pos - 1;
              RP_x_pos_nxt = RP_x_pos + 1;
              counter = 0;
            end else if ((LP_left == 1'b1) && (RP_right == 1'b1)) begin
              LP_x_pos_nxt = LP_x_pos + 1;
              RP_x_pos_nxt = RP_x_pos - 1;
              counter = 0;
            end else if (LP_left == 1'b1) begin
              LP_x_pos_nxt = LP_x_pos + 1;
              counter = 0;
            end else if (LP_right == 1'b1) begin
              LP_x_pos_nxt = LP_x_pos - 1;
              counter = 0;
            end else if (RP_left == 1'b1) begin
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

  always@(*)
    if (keycode[7:0] == 8'hf0) begin
        start = 0;
    end else if (keycode[15:8] == 8'hf0) begin 
        start = 0;
    end else
        start = 1;

  always@(*)
    if (start)
      case (keycode[7:0])
          LP_GO_LEFT: begin
            LP_left = 1'b1;
            LP_right = 1'b0;
            rgb_out_nxt = rgb_in;
          end
          LP_GO_RIGHT: begin
            LP_right = 1'b1;
            LP_left = 1'b0;
            rgb_out_nxt = rgb_in;
          end
          RP_GO_LEFT: begin
            RP_left = 1'b1;
            RP_right = 1'b0;
            rgb_out_nxt = rgb_in;    
          end
          RP_GO_RIGHT: begin
            RP_right = 1'b1;
            RP_left = 1'b0;
            rgb_out_nxt = rgb_in;    
          end
          default: begin
            LP_left = 1'b0;
            LP_right = 1'b0;
            RP_left = 1'b0;
            RP_right = 1'b0;
            rgb_out_nxt = rgb_in;
          end
      endcase
    else begin
      LP_left = 1'b0;
      LP_right = 1'b0;
      RP_left = 1'b0;
      RP_right = 1'b0;
      rgb_out_nxt = rgb_in;
    end
      //RP_left = 1'b0;
        //RP_left = 1'b0;
      //end     
      //assign RP_left = 1'b0;
      
/*    
  always@(*)
    case(key_state)
      RP_left_state: begin
        RP_left = 1'b0;
      end
      default: begin
        rgb_out_nxt = rgb_in;
      end
    endcase  
*/    
/*
  always@(*)
    if (keycode[7:0] == 8'hf0) begin
      RP_left = 1'b0;
    end else if (keycode[15:8] == 8'hf0) begin
      RP_left = 1'b0;    
    end
*/
endmodule
