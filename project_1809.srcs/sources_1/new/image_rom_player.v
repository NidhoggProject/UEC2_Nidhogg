`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.09.2020 18:41:39
// Design Name: 
// Module Name: image_rom_player
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
#(parameter picture = "../../playerL_gora1.data")
    (
    input wire clk,
    input wire [11:0] address,  // address = {addry[5:0], addrx[5:0]}
    output reg [11:0] rgb
    );
    
    integer counter = 0;
    
    reg [11:0] rom [0:4095];
    
    initial $readmemh(picture, rom);
    
    /*begin
        if (arrow_type[2:0] == 3'b001)        $readmemh("../../strzalka_dol.data", rom);
        else if (arrow_type[2:0] == 3'b010)   $readmemh("../../strzalka_gora.data", rom);
        else if (arrow_type[2:0] == 3'b011)   $readmemh("../../strzalka_dol.data", rom);
        else if (arrow_type[2:0] == 3'b100)   $readmemh("../../strzalka_lewo.data", rom);
    end*/
    
    always @(posedge clk)
    rgb <= rom[address];
    
endmodule
