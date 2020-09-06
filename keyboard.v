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
    input wire xpos_reset,
    output reg [1:0] key,
    output reg [11:0] RP_x_pos,
    output reg [11:0] RP_y_pos,
    output reg [11:0] LP_x_pos,
    output reg change_legs_R,
    output reg [11:0] x_sword_pos,
    output reg [4:0] sword_pos
    );
    
wire [15:0] keycode;
reg [11:0] rgb_out_nxt;
reg [11:0] RP_x_pos_nxt = 0;
reg [11:0] RP_y_pos_nxt = 0;
reg [11:0] LP_x_pos_nxt = 75;
wire flag;   

reg [20:0] counter = 0;    
reg [6:0] counters_counter = 0;
reg falling = 0;
reg start = 0;
reg [4:0] sword_pos_nxt = 0;
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
localparam RP_JUMP                      = 8'h29;    //press:    spacebar       //= 8'h59;    //press:    shift right
localparam RP_THROW_SWORD               = 8'h5A;    //press:    enter

reg RP_left, RP_right, RP_jump, RP_throw, RP_sword_up, RP_sword_down;  

  PS2Receiver my_PS2Receiver (
    .clk(clk_50MHz),
    .kclk(PS2Clk),
    .kdata(PS2Data),
    .keycode(keycode),
    .oflag(flag)
  );



  always@(posedge clk_50MHz, posedge rst, posedge xpos_reset)
    begin
    if (rst) begin

        RP_x_pos <= 0;
        end
        
    else if (xpos_reset) 
        begin
            RP_x_pos <= 0;
            RP_y_pos <= 0;
        end 
        
    else 
        begin
        LP_x_pos <= LP_x_pos_nxt;
        RP_x_pos <= RP_x_pos_nxt;
        RP_y_pos <= RP_y_pos_nxt;
        
        if ((RP_y_pos == 0) && (x_sword_pos == 0))
        begin
            if (counter == 100000)
                begin 
                    if (RP_left == 1'b1) RP_x_pos_nxt = RP_x_pos + 1;
                    else if (RP_right == 1'b1) RP_x_pos_nxt = RP_x_pos - 1;
                    else if (RP_jump == 1'b1)
                    begin
                        RP_y_pos_nxt <= RP_y_pos + 1;
                        falling <= 0;
                    end
                    else if (RP_throw == 1'b1) x_sword_pos <= 1;
                    else if (RP_sword_down) sword_pos_nxt <= 0;
                    else if (RP_sword_up)
                    begin
                        if (sword_pos >= 31) sword_pos_nxt = 31;
                        else sword_pos_nxt = sword_pos + 31;
                    end
                    counter <= 0;
                    counters_counter <= counters_counter + 1;
                end
            else
            begin
                counter <= counter + 1;
                if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (counters_counter < 60))
                    change_legs_R <= 1;
                else if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (counters_counter < 120) && (counters_counter >= 60))
                    change_legs_R <= 0;
                else if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (counters_counter >= 120))
                    counters_counter <= 0;
            end
        end


        else if (((RP_y_pos != 0) && (x_sword_pos == 0)))
            begin
                
                if (counter == 100000)
                begin
                    if (RP_y_pos >= 200)
                    begin
                        RP_y_pos_nxt <= RP_y_pos - 1;
                        counter <= 0;
                        falling <= falling + 1;
                    end
                    else if (falling == 1)
                    begin
                        RP_y_pos_nxt <= RP_y_pos - 1;
                        counter <= 0;
                    end
                    else
                    begin
                        RP_y_pos_nxt <= RP_y_pos + 1;
                        counter <= 0;
                    end
                    if (RP_left == 1'b1) RP_x_pos_nxt = RP_x_pos + 1;
                    else if (RP_right == 1'b1) RP_x_pos_nxt = RP_x_pos - 1;
                    else if (RP_throw == 1'b1) x_sword_pos <= 1;
                    else if (RP_sword_down) sword_pos_nxt <= 0;
                    else if (RP_sword_up)
                    begin
                        if (sword_pos >= 31) sword_pos_nxt = 31;
                        else sword_pos_nxt = sword_pos + 31;
                    end
                    counter <= 0;
                    counters_counter <= counters_counter + 1;
                end
                
                else
                begin
                    counter <= counter + 1;
                    if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (counters_counter < 60))
                        change_legs_R <= 1;
                    else if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (counters_counter < 120) && (counters_counter >= 60))
                        change_legs_R <= 0;
                    else if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (counters_counter >= 120))
                        counters_counter <= 0;
                end
                    
            end

   
        else if ((RP_y_pos == 0) && (x_sword_pos != 0))
        begin
            if (counter == 100000)
                begin 
                    if (RP_left == 1'b1) RP_x_pos_nxt = RP_x_pos + 1;
                    else if (RP_right == 1'b1) RP_x_pos_nxt = RP_x_pos - 1;
                    else if (RP_jump == 1'b1)
                    begin
                        RP_y_pos_nxt <= RP_y_pos + 1;
                        falling <= 0;
                    end
                    else if (RP_sword_down) sword_pos_nxt <= 0;
                    else if (RP_sword_up)
                    begin
                        if (sword_pos >= 31) sword_pos_nxt = 31;
                        else sword_pos_nxt = sword_pos + 31;
                    end
                    counter <= 0;
                    counters_counter <= counters_counter + 1;
                end
            
            else if ((counter == 25000) || (counter == 50000) || (counter == 75000) || (counter == 0))
                begin
                    x_sword_pos <= x_sword_pos + 1; 
                    counter <= counter + 1;
                end

            else
            begin
                counter <= counter + 1;
                if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (counters_counter < 60))
                    change_legs_R <= 1;
                else if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (counters_counter < 120) && (counters_counter >= 60))
                    change_legs_R <= 0;
                else if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (counters_counter >= 120))
                    counters_counter <= 0;
            end
            
        end
        
        
        
        else
        begin
            if (counter == 100000)
                begin
                if (RP_y_pos >= 200)
                    begin
                        RP_y_pos_nxt <= RP_y_pos - 1;
                        counter <= 0;
                        falling <= falling + 1;
                    end
                else if (falling == 1)
                    begin
                        RP_y_pos_nxt <= RP_y_pos - 1;
                        counter <= 0;
                    end
                else
                    begin
                        RP_y_pos_nxt <= RP_y_pos + 1;
                        counter <= 0;
                    end
                    if (RP_left == 1'b1) RP_x_pos_nxt = RP_x_pos + 1;
                    else if (RP_right == 1'b1) RP_x_pos_nxt = RP_x_pos - 1;
                    else if (RP_sword_down) sword_pos_nxt <= 0;
                    else if (RP_sword_up)
                    begin
                        if (sword_pos >= 31) sword_pos_nxt = 31;
                        else sword_pos_nxt = sword_pos + 31;
                    end
                    counter <= 0;
                    counters_counter <= counters_counter + 1;
                end
            
            else if ((counter == 25000) || (counter == 50000) || (counter == 75000) || (counter == 0))
                begin
                    x_sword_pos <= x_sword_pos + 1; 
                    counter <= counter + 1;
                end

            else
            begin
                counter <= counter + 1;
                if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (counters_counter < 60))
                    change_legs_R <= 1;
                else if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (counters_counter < 120) && (counters_counter >= 60))
                    change_legs_R <= 0;
                else if (((RP_right == 1'b1)||(RP_left == 1'b1)) && (counters_counter >= 120))
                    counters_counter <= 0;
            end
            
        end
        
    end
end


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
      
          RP_GO_LEFT: begin
            RP_left <= 1'b1;
            RP_right <= 1'b0;
            sword_pos <= sword_pos_nxt;
          end
          
          RP_GO_RIGHT: begin
            RP_right <= 1'b1;
            RP_left <= 1'b0; 
            sword_pos <= sword_pos_nxt;
          end
          
          RP_JUMP:
          begin
            RP_jump <= 1'b1;
            sword_pos <= sword_pos_nxt;
          end
          
          RP_SWORD_UP:
          begin
            RP_sword_up <= 1'b1;
            sword_pos <= sword_pos_nxt;
          end
          
          RP_SWORD_DOWN:
          begin
            RP_sword_down <= 1'b1;
            sword_pos <= sword_pos_nxt;
          end
          
          RP_THROW_SWORD:
          begin
            RP_throw <= 1'b1;
            sword_pos <= sword_pos_nxt;
          end
          
          default: begin
            LP_left = 1'b0;
            LP_right = 1'b0;
            RP_left = 1'b0;
            RP_right = 1'b0;
            RP_jump = 1'b0;
            sword_pos <= sword_pos_nxt;
          end
      endcase
    else begin
      LP_left = 1'b0;
      LP_right = 1'b0;
      RP_left = 1'b0;
      RP_right = 1'b0;
      RP_jump = 1'b0;
    end


endmodule