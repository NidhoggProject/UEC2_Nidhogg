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


module image_rom_player
#(parameter picture = "C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/playerL_gora1.data")
    (
    input wire clk,
    input wire [11:0] address,  // address = {addry[5:0], addrx[5:0]}
    output reg [11:0] rgb
    );
    
    integer counter = 0;
    
    reg [11:0] rom [0:4095];
    
    initial $readmemh(picture, rom);
    
    always @(posedge clk)
    rgb <= rom[address];
    
endmodule