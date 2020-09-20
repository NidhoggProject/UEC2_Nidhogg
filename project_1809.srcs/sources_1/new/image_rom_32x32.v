`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 18:42:28
// Design Name: 
// Module Name: image_rom_32x32
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


module image_rom_32x32
    #(parameter picture = "C:/__Programowanie__/Vivado/PrzemyslawKurzak/UEC_2_Project/project_0709/korona.data")
    (
    input wire clk,
    input wire [9:0] address,  // address = {addry[5:0], addrx[5:0]}
    output reg [11:0] rgb
    );
    
    
    reg [11:0] rom [0:1023];
    
    initial $readmemh(picture, rom);
    
    always @(posedge clk)
    rgb <= rom[address];

endmodule
