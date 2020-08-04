module start_button_image_rom (
    input wire clk,
    input wire [16:0] address,  // address = {addry[7:0], addrx[8:0]}
    output reg [11:0] rgb
);


reg [11:0] rom [0:262143];

initial $readmemh("../../button_start.data", rom); 

always @(posedge clk)
    rgb <= rom[address];

endmodule