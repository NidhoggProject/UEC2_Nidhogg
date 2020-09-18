`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 01:50:46
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
    input wire xpos_reset,
    input wire BTNL,
    input wire BTNR,
    input wire BTND,
    input wire BTNU,
    input wire BTNC,
    input wire sw,
    output reg [1:0] key,
    output reg RP_change_legs,
    output reg [11:0] RP_x_pos,
    output reg [11:0] RP_y_pos,
    output reg [11:0] RP_x_sword_pos,
    output reg [4:0] RP_sword_pos,
    output reg LP_change_legs,
    output reg [11:0] LP_x_pos,
    output reg [11:0] LP_y_pos,
    output reg [11:0] LP_x_sword_pos,
    output reg [4:0] LP_sword_pos
    );

reg RP_left, RP_right, RP_jump, RP_throw, RP_sword_up, RP_sword_down;
reg [6:0] RP_counters_counter = 0;
reg [4:0] RP_sword_pos_nxt = 0;
reg [11:0] RP_x_pos_nxt = 0;
reg [11:0] RP_y_pos_nxt = 0;
reg [20:0] RP_counter = 0;
reg RP_falling = 0;
  
reg [6:0] LP_counters_counter = 0;
reg [4:0] LP_sword_pos_nxt = 0;
reg [11:0] LP_x_pos_nxt = 0;
reg [11:0] LP_y_pos_nxt = 0; 
reg [20:0] LP_counter = 0;  
reg LP_falling = 0;

reg [11:0] rgb_out_nxt;
wire [15:0] keycode;
reg start = 0;
wire flag;  
 
//-------------------------------------------------------------------------//
//Left player                  
//LP_GO_LEFT                   //press:    BTNL
//LP_GO_RIGHT                  //press:    BTNR
//LP_SWORD_UP                  //press:    BTNU
//LP_SWORD_DOWN                //press:    BTND
//LP_JUMP                      //press:    BTNC
//LP_THROW_SWORD               //press:    sw[0]
//-------------------------------------------------------------------------//
//Right player    
localparam RP_GO_LEFT                   = 8'h6B;    //press:    arrow left
localparam RP_GO_RIGHT                  = 8'h74;    //press:    arrow right
localparam RP_SWORD_UP                  = 8'h75;    //press:    arrow up
localparam RP_SWORD_DOWN                = 8'h72;    //press:    arrow down
localparam RP_JUMP                      = 8'h29;    //press:    spacebar       = 8'h59;    //press:    shift right
localparam RP_THROW_SWORD               = 8'h5A;    //press:    enter
//-------------------------------------------------------------------------//
 
  PS2Receiver my_PS2Receiver (
    .clk(clk_50MHz),
    .kclk(PS2Clk),
    .kdata(PS2Data),
    .keycode(keycode),
    .oflag(flag)
  );
  
/*=========================================================================*\
*                          RIGHT_PLAYER_BEGIN
\*=========================================================================*/    
  always@(posedge clk_50MHz)
    begin
    if (rst) begin
        RP_x_pos <= 0;
        RP_y_pos <= 0;
    end else if (xpos_reset) begin
        RP_x_pos <= 0;
        RP_y_pos <= 0;
    end else begin
        RP_x_pos <= RP_x_pos_nxt;
        RP_y_pos <= RP_y_pos_nxt;   
//------------------------------------------------------------------------//
        if ((RP_y_pos == 0) && (RP_x_sword_pos == 0))
        begin
        
            if (RP_counter == 100000)
                begin 
                    if (RP_left == 1'b1) RP_x_pos_nxt <= RP_x_pos + 1;
                    else if (RP_right == 1'b1) RP_x_pos_nxt <= RP_x_pos - 1;
                    else if (RP_jump == 1'b1)
                    begin
                        RP_y_pos_nxt <= RP_y_pos + 1;
                        RP_falling <= 0;
                    end
                    else if (RP_throw == 1'b1) RP_x_sword_pos <= 1;
                    else if (RP_sword_down) RP_sword_pos_nxt <= 0;
                    else if (RP_sword_up)
                    begin
                        if (RP_sword_pos >= 31) RP_sword_pos_nxt <= 31;
                        else RP_sword_pos_nxt <= RP_sword_pos + 31;
                    end
                    RP_counter <= 0;
                    RP_counters_counter <= RP_counters_counter + 1;
                end
            else
            
            begin
                RP_counter <= RP_counter + 1;
                if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (RP_counters_counter < 60))
                    RP_change_legs <= 1;
                else if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (RP_counters_counter < 120) && (RP_counters_counter >= 60))
                    RP_change_legs <= 0;
                else if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (RP_counters_counter >= 120))
                    RP_counters_counter <= 0;
            end
        end
//------------------------------------------------------------------------//
        else if ((RP_y_pos != 0) && (RP_x_sword_pos == 0))
            begin
                
                if (RP_counter == 100000)
                begin
                    if (RP_y_pos >= 200)
                    begin
                        RP_y_pos_nxt <= RP_y_pos - 1;
                        RP_counter <= 0;
                        RP_falling <= RP_falling + 1;
                    end
                    else if (RP_falling == 1)
                    begin
                        RP_y_pos_nxt <= RP_y_pos - 1;
                        RP_counter <= 0;
                    end
                    else
                    begin
                        RP_y_pos_nxt <= RP_y_pos + 1;
                        RP_counter <= 0;
                    end
                    if (RP_left == 1'b1) RP_x_pos_nxt <= RP_x_pos + 1;
                    else if (RP_right == 1'b1) RP_x_pos_nxt <= RP_x_pos - 1;
                    else if (RP_throw == 1'b1) RP_x_sword_pos <= 1;
                    else if (RP_sword_down) RP_sword_pos_nxt <= 0;
                    else if (RP_sword_up)
                    begin
                        if (RP_sword_pos >= 31) RP_sword_pos_nxt <= 31;
                        else RP_sword_pos_nxt <= RP_sword_pos + 31;
                    end
                    RP_counter <= 0;
                    RP_counters_counter <= RP_counters_counter + 1;
                end
                
                else
                begin
                    RP_counter <= RP_counter + 1;
                    if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (RP_counters_counter < 60))
                        RP_change_legs <= 1;
                    else if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (RP_counters_counter < 120) && (RP_counters_counter >= 60))
                        RP_change_legs <= 0;
                    else if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (RP_counters_counter >= 120))
                        RP_counters_counter <= 0;
                end
                    
            end
//------------------------------------------------------------------------//   
        else if ((RP_y_pos == 0) && (RP_x_sword_pos != 0))
        begin
            if (RP_counter == 100000)
                begin 
                    if (RP_left == 1'b1) RP_x_pos_nxt <= RP_x_pos + 1;
                    else if (RP_right == 1'b1) RP_x_pos_nxt <= RP_x_pos - 1;
                    else if (RP_jump == 1'b1)
                    begin
                        RP_y_pos_nxt <= RP_y_pos + 1;
                        RP_falling <= 0;
                    end
                    else if (RP_sword_down) RP_sword_pos_nxt <= 0;
                    else if (RP_sword_up)
                    begin
                        if (RP_sword_pos >= 31) RP_sword_pos_nxt <= 31;
                        else RP_sword_pos_nxt <= RP_sword_pos + 31;
                    end
                    RP_counter <= 0;
                    RP_counters_counter <= RP_counters_counter + 1;
                end
            
            else if ((RP_counter == 25000) || (RP_counter == 50000) || (RP_counter == 75000) || (RP_counter == 0))
                begin
                    RP_x_sword_pos <= RP_x_sword_pos + 1; 
                    RP_counter <= RP_counter + 1;
                end

            else
            begin
                RP_counter <= RP_counter + 1;
                if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (RP_counters_counter < 60))
                    RP_change_legs <= 1;
                else if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (RP_counters_counter < 120) && (RP_counters_counter >= 60))
                    RP_change_legs <= 0;
                else if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (RP_counters_counter >= 120))
                    RP_counters_counter <= 0;
            end
            
        end
/*=========================================================================*\
*                          Else_case
\*=========================================================================*/                  
        else
        begin
            if (RP_counter == 100000)
                begin
                if (RP_y_pos >= 200)
                    begin
                        RP_y_pos_nxt <= RP_y_pos - 1;
                        RP_counter <= 0;
                        RP_falling <= RP_falling + 1;
                    end
                else if (RP_falling == 1)
                    begin
                        RP_y_pos_nxt <= RP_y_pos - 1;
                        RP_counter <= 0;
                    end
                else
                    begin
                        RP_y_pos_nxt <= RP_y_pos + 1;
                        RP_counter <= 0;
                    end
                    if (RP_left == 1'b1) RP_x_pos_nxt <= RP_x_pos + 1;
                    else if (RP_right == 1'b1) RP_x_pos_nxt <= RP_x_pos - 1;
                    else if (RP_sword_down) RP_sword_pos_nxt <= 0;
                    else if (RP_sword_up)
                    begin
                        if (RP_sword_pos >= 31) RP_sword_pos_nxt <= 31;
                        else RP_sword_pos_nxt <= RP_sword_pos + 31;
                    end
                    RP_counter <= 0;
                    RP_counters_counter <= RP_counters_counter + 1;
                end
//------------------------------------------------------------------------//            
            else if ((RP_counter == 25000) || (RP_counter == 50000) || (RP_counter == 75000) || (RP_counter == 0))
                begin
                    RP_x_sword_pos <= RP_x_sword_pos + 1; 
                    RP_counter <= RP_counter + 1;
                end
//------------------------------------------------------------------------//                
            else
                begin
                    RP_counter <= RP_counter + 1;
                    if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (RP_counters_counter < 60))
                        RP_change_legs <= 1;
                    else if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (RP_counters_counter < 120) && (RP_counters_counter >= 60))
                        RP_change_legs <= 0;
                    else if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (RP_counters_counter >= 120))
                        RP_counters_counter <= 0;
                end
            
        end
        
    end
end
/*=========================================================================*\
*                          RIGHT_PLAYER_END
\*=========================================================================*/    


/*=========================================================================*\
*                          LEFT_PLAYER_BEGIN
\*=========================================================================*/
  always@(posedge clk_50MHz)
    begin
    if (rst) begin
        LP_x_pos <= 0;
        LP_y_pos <= 0;
    end else if (xpos_reset) begin
        LP_x_pos <= 0;
        LP_y_pos <= 0;
    end else begin
        LP_x_pos <= LP_x_pos_nxt;
        LP_y_pos <= LP_y_pos_nxt;
        LP_sword_pos <= LP_sword_pos_nxt;
//------------------------------------------------------------------------//  
    if ((LP_y_pos == 0) && (LP_x_sword_pos == 0))
    begin
        if (LP_counter == 100000)
            begin 
                if (BTNR) LP_x_pos_nxt <= LP_x_pos + 1;
                else if (BTNL) LP_x_pos_nxt <= LP_x_pos - 1;
                else if (BTNC)
                begin
                    LP_y_pos_nxt <= LP_y_pos + 1;
                    LP_falling <= 0;
                end
                else if (sw) LP_x_sword_pos <= 1;
                else if (BTND) LP_sword_pos_nxt <= 0;
                else if (BTNU)
                begin
                    if (LP_sword_pos >= 31) LP_sword_pos_nxt <= 31;
                    else LP_sword_pos_nxt <= LP_sword_pos + 31;
                end
                LP_counter <= 0;
                LP_counters_counter <= LP_counters_counter + 1;
            end
        else
        begin
            LP_counter <= LP_counter + 1;
            if (((BTNR) || (BTNL)) && (LP_counters_counter < 60))
                LP_change_legs <= 1;
            else if (((BTNR) || (BTNL)) && (LP_counters_counter < 120) && (LP_counters_counter >= 60))
                LP_change_legs <= 0;
            else if (((BTNR) || (BTNL)) && (LP_counters_counter >= 120))
                LP_counters_counter <= 0;
               LP_change_legs <= 0;
        end
    end
//------------------------------------------------------------------------//
    else if ((LP_y_pos != 0) && (LP_x_sword_pos == 0))
    begin
        
        if (LP_counter == 100000)
        begin
            if (LP_y_pos >= 200)
            begin
                LP_y_pos_nxt <= LP_y_pos - 1;
                LP_counter <= 0;
                LP_falling <= LP_falling + 1;
            end
            else if (LP_falling == 1)
            begin
                LP_y_pos_nxt <= LP_y_pos - 1;
                LP_counter <= 0;
            end
            else
            begin
                LP_y_pos_nxt <= LP_y_pos + 1;
                LP_counter <= 0;
            end
            if (BTNR) LP_x_pos_nxt <= LP_x_pos + 1;
            else if (BTNL) LP_x_pos_nxt <= LP_x_pos - 1;
            else if (sw) LP_x_sword_pos <= 1;
            else if (BTND) LP_sword_pos_nxt <= 0;
            else if (BTNU)
            begin
                if (LP_sword_pos >= 31) LP_sword_pos_nxt <= 31;
                else LP_sword_pos_nxt <= LP_sword_pos + 31;
            end
            LP_counter <= 0;
            LP_counters_counter <= LP_counters_counter + 1;
        end
        
        else
        begin
            LP_counter <= LP_counter + 1;
            if (((BTNR) || (BTNL)) && (LP_counters_counter < 60))
                LP_change_legs <= 1;
            else if (((BTNR) || (BTNL)) && (LP_counters_counter < 120) && (LP_counters_counter >= 60))
                LP_change_legs <= 0;
            else if (((BTNR) || (BTNL)) && (LP_counters_counter >= 120))
                LP_counters_counter <= 0;
                LP_change_legs <= 0;
        end
            
    end
//------------------------------------------------------------------------//   
    else if ((LP_y_pos == 0) && (LP_x_sword_pos != 0))
    begin
        if (LP_counter == 100000)
            begin 
                if (BTNR) LP_x_pos_nxt <= LP_x_pos + 1;
                else if (BTNL) LP_x_pos_nxt <= LP_x_pos - 1;
                else if (BTNC)
                begin
                    LP_y_pos_nxt <= LP_y_pos + 1;
                    LP_falling <= 0;
                end
                else if (BTND) LP_sword_pos_nxt <= 0;
                else if (BTNU)
                begin
                    if (LP_sword_pos >= 31) LP_sword_pos_nxt <= 31;
                    else LP_sword_pos_nxt <= LP_sword_pos + 31;
                end
                LP_counter <= 0;
                LP_counters_counter <= LP_counters_counter + 1;
            end
        
        else if ((LP_counter == 25000) || (LP_counter == 50000) || (LP_counter == 75000) || (LP_counter == 0))
            begin
                LP_x_sword_pos <= LP_x_sword_pos + 1; 
                LP_counter <= LP_counter + 1;
            end
        
        else
        begin
            LP_counter <= LP_counter + 1;
            if (((BTNR) || (BTNL)) && (LP_counters_counter < 60))
                LP_change_legs <= 1;
            else if (((BTNR) || (BTNL)) && (LP_counters_counter < 120) && (LP_counters_counter >= 60))
                LP_change_legs <= 0;
            else if (((BTNR) || (BTNL)) && (LP_counters_counter >= 120))
                LP_counters_counter <= 0;
        end
        
    end
//------------------------------------------------------------------------//
/*=========================================================================*\
*                          Else_case
\*=========================================================================*/                  
        else
        begin
            if (LP_counter == 100000)
                begin
                if (LP_y_pos >= 200)
                    begin
                        LP_y_pos_nxt <= LP_y_pos - 1;
                        LP_counter <= 0;
                        LP_falling <= LP_falling + 1;
                    end
                else if (LP_falling == 1)
                    begin
                        LP_y_pos_nxt <= LP_y_pos - 1;
                        LP_counter <= 0;
                    end
                else
                    begin
                        LP_y_pos_nxt <= LP_y_pos + 1;
                        LP_counter <= 0;
                    end
                    if (BTNR) LP_x_pos_nxt <= LP_x_pos + 1;
                    else if (BTNL) LP_x_pos_nxt <= LP_x_pos - 1;
                    else if (BTND) LP_sword_pos_nxt <= 0;
                    else if (BTNU)
                    begin
                        if (LP_sword_pos >= 31) LP_sword_pos_nxt <= 31;
                        else LP_sword_pos_nxt <= LP_sword_pos + 31;
                    end
                    LP_counter <= 0;
                    LP_counters_counter <= LP_counters_counter + 1;
                end
//------------------------------------------------------------------------//            
            else if ((LP_counter == 25000) || (LP_counter == 50000) || (LP_counter == 75000) || (LP_counter == 0))
                begin
                    LP_x_sword_pos <= LP_x_sword_pos + 1; 
                    LP_counter <= LP_counter + 1;
                end
//------------------------------------------------------------------------//                
            else
                begin
                    LP_counter <= LP_counter + 1;
                    if (((BTNR) || (BTNL)) && (LP_counters_counter < 60))
                        LP_change_legs <= 1;
                    else if (((BTNR) || (BTNL)) && (LP_counters_counter < 120) && (LP_counters_counter >= 60))
                        LP_change_legs <= 0;
                    else if (((BTNR) || (BTNL)) && (LP_counters_counter >= 120))
                        LP_counters_counter <= 0;
                end
            
        end
        
    end
end

/*=========================================================================*\
*                          LEFT_PLAYER_END
\*=========================================================================*/

  always@(*)
    if (keycode[7:0] == 8'hf0) begin
        start <= 0;
    end else if (keycode[15:8] == 8'hf0) begin 
        start <= 0;
    end else
        start <= 1;

  always@(*)
    if (start)
      case (keycode[7:0])
      
          RP_GO_LEFT: begin
            RP_left <= 1'b1;
            RP_right <= 1'b0;
            RP_sword_pos <= RP_sword_pos_nxt;
          end
          
          RP_GO_RIGHT: begin
            RP_right <= 1'b1;
            RP_left <= 1'b0; 
            RP_sword_pos <= RP_sword_pos_nxt;
          end
          
          RP_JUMP:
          begin
            RP_jump <= 1'b1;
            RP_sword_pos <= RP_sword_pos_nxt;
          end
          
          RP_SWORD_UP:
          begin
            RP_sword_up <= 1'b1;
            RP_sword_pos <= RP_sword_pos_nxt;
          end
          
          RP_SWORD_DOWN:
          begin
            RP_sword_down <= 1'b1;
            RP_sword_pos <= RP_sword_pos_nxt;
          end
          
          RP_THROW_SWORD:
          begin
            RP_throw <= 1'b1;
            RP_sword_pos <= RP_sword_pos_nxt;
          end
          
          default: begin
            RP_left <= 1'b0;
            RP_right <= 1'b0;
            RP_jump <= 1'b0;
            RP_sword_pos <= RP_sword_pos_nxt;
          end
      endcase
    else begin
      RP_left <= 1'b0;
      RP_right <= 1'b0;
      RP_jump <= 1'b0;
    end


endmodule
