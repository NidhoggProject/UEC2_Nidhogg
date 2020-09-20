// File: vga_timing.v
// This is the vga timing design for EE178 Lab #4.

// The `timescale directive specifies what the
// simulation time units are (1 ns here) and what
// the simulator time step should be (1 ps here).

`timescale 1 ns / 1 ps

// Declare the module and its ports. This is
// using Verilog-2001 syntax.

module vga_timing (
  output reg [10:0] vcount,
  output reg vsync,
  output reg vblnk,
  output reg [10:0] hcount,
  output reg hsync,
  output reg hblnk,
  input wire pclk,
  input wire rst
  );

  // Describe the actual circuit for the assignment.
  // Video timing controller set for 800x600@60fps
  // using a 40 MHz pixel clock per VESA spec.


// horizontal counter  
always@ (posedge pclk or posedge rst)
if (rst)
    hcount <= 10'b0;
else
    begin
        if (hcount == 1055)
           hcount <= 10'b0;
       else
           hcount <= hcount + 1;
    end

// vertical counter
always@ (posedge pclk or posedge rst) 
if (rst)
    vcount <= 10'b0;
else
    begin
        if (hcount == 1055) begin
            if (vcount == 627)
                vcount <= 10'b0;
            else
                vcount <= vcount + 1;
        end
    end
    
    

always@ (posedge pclk or posedge rst)
if (rst) begin
    hblnk <= 0;
    hsync <= 0;
    vblnk <= 0;
    vsync <= 0;
    end
else begin
    if (hcount>=839 && hcount<967) begin
        hsync <= 1;
        if (vcount>=599 && vcount<627)
            vblnk <= 1;
        else
            vblnk <= 0;
        if (vcount>=600 && vcount<623)
            vsync <= 1;
        else
            vsync <= 0;
        end
    else
        hsync <= 0;
        
    if (hcount>=799 && hcount<1055)
        hblnk <= 1;
    else
        hblnk <= 0;
end 


endmodule
