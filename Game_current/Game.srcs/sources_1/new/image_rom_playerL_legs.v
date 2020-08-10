`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.08.2020 00:15:45
// Design Name: 
// Module Name: image_rom_arrow
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


module image_rom_playerL_legs(
    input wire clk,
    input wire [11:0] address,  // address = {addry[5:0], addrx[5:0]}
    output reg [11:0] rgb
    );
    
    
    reg [11:0] rom [0:4095];
    
    initial $readmemh("../../playerL_dol1.data", rom);
    
    always @(posedge clk)
    rgb <= rom[address];
    
endmodule
