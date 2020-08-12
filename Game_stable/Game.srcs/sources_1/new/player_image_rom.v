module player_image_rom (
    input wire clk,
    input wire [13:0] address,  // address = {addry[6:0], addrx[6:0]}
    output reg [11:0] rgb
);


reg [11:0] rom [0:16383];

initial $readmemh("../../player1up.data", rom); 

always @(posedge clk)
    rgb <= rom[address];

endmodule