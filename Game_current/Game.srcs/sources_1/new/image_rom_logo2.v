`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2020 01:06:06
// Design Name: 
// Module Name: image_rom_logo2
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


module image_rom_logo2(
    input wire clk,
    input wire [15:0] address,  // address = {addry[7:0], addrx[7:0]}
    output reg [11:0] rgb
    );
    
    
    reg [11:0] rom [0:65535];

    initial $readmemh("../../logo2_newnew.data", rom); 

    always @(posedge clk)
        rgb <= rom[address];

endmodule