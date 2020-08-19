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
    output reg LP_left,
    output reg LP_right,
    output reg RP_left,
    output reg RP_right
    );
    
wire [15:0] keycode;   
reg start = 0;
wire flag;

reg LP_left_nxt, LP_right_nxt;
reg RP_left_nxt, RP_right_nxt;
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
localparam RP_GO_RIGHT                  = 8'h74;    //press:    arrow right
localparam RP_SWORD_UP                  = 8'h75;    //press:    arrow up
localparam RP_SWORD_DOWN                = 8'h72;    //press:    arrow down
localparam RP_THROW_OR_PICK_UP_SWORD    = 8'h59;    //press:    shift right
localparam RP_JUMP                      = 8'h5A;    //press:    enter  

  PS2Receiver my_PS2Receiver (
    .clk(clk_50MHz),
    .kclk(PS2Clk),
    .kdata(PS2Data),
    .keycode(keycode),
    .oflag(flag)
  );

  always@(posedge clk_50MHz, posedge rst)
    begin
    if (rst) begin
      LP_left <= 0;
      LP_right <= 0;
        
      RP_left <= 0;
      RP_right <= 0;
    end else begin     
      LP_left <= LP_left_nxt;
      LP_right <= LP_right_nxt;
        
      RP_left <= RP_left_nxt;
      RP_right <= RP_right_nxt;
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
            LP_left_nxt = 1'b1;
            LP_right_nxt = 1'b0;
          end
          LP_GO_RIGHT: begin
            LP_right_nxt = 1'b1;
            LP_left_nxt = 1'b0;
            /*
            case (keycode[7:0])
              RP_GO_LEFT: begin
                RP_left_nxt = 1'b1;
                RP_right_nxt = 1'b0;   
              end
              RP_GO_RIGHT: begin
                RP_right_nxt = 1'b1;
                RP_left_nxt = 1'b0;  
              end
            endcase
            */
          end
          RP_GO_LEFT: begin
            RP_left_nxt = 1'b1;
            RP_right_nxt = 1'b0;   
          end
          RP_GO_RIGHT: begin
            RP_right_nxt = 1'b1;
            RP_left_nxt = 1'b0;  
          end
          default: begin
            LP_left_nxt = 1'b0;
            LP_right_nxt = 1'b0;
            
            RP_left_nxt = 1'b0;
            RP_right_nxt = 1'b0;
          end
      endcase
    else begin
      LP_left_nxt = 1'b0;
      LP_right_nxt = 1'b0;
      
      RP_left_nxt = 1'b0;
      RP_right_nxt = 1'b0;
    end

endmodule
