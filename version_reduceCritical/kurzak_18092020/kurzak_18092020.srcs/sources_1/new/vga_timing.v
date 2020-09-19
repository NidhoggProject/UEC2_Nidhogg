`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 18:36:29
// Design Name: 
// Module Name: vga_timing
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


module vga_timing (
  output reg [11:0] vcount,
  output reg vsync,
  output reg vblnk,
  output reg [11:0] hcount,
  output reg hsync,
  output reg hblnk,
  input wire pclk,
  input wire rst
  );


always@ (posedge pclk)
if (rst)
    hcount <= 10'b0;
else
    begin
        if (hcount == 1343)
           hcount <= 10'b0;
       else
           hcount <= hcount + 1;
    end


always@ (posedge pclk) 
if (rst)
    vcount <= 10'b0;
else
    begin
        if (hcount == 1343)
        begin
            if (vcount == 807)
                vcount <= 10'b0;
            else
                vcount <= vcount + 1;
        end
    end
    
    

always@ (posedge pclk)
if (rst)
    begin
        hblnk <= 0;
        hsync <= 0;
        vblnk <= 0;
        vsync <= 0;
    end
else
begin
    if (hcount >= 1047 && hcount < 1183)
    begin
        hsync <= 1;
        if (vcount >= 767 && vcount < 803)
            vblnk <= 1;
        else
            vblnk <= 0;
        if (vcount >= 768 && vcount < 797)
            vsync <= 1;
        else
            vsync <= 0;
    end
    else
        hsync <= 0;
        
    if (hcount >= 1023 && hcount < 1343)
        hblnk <= 1;
    else
        hblnk <= 0;
end 


endmodule