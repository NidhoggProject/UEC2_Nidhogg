`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.04.2020 13:25:27
// Design Name: 
// Module Name: image_rom
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


module image_rom (
    input wire clk,
    input wire [11:0] address,  // address = {addry[5:0], addrx[5:0]}
    output reg [11:0] rgb
);


reg [11:0] rom [0:4095];

initial $readmemh("../../background_64_64.data", rom); 

always @(posedge clk)
    rgb <= rom[address];

endmodule