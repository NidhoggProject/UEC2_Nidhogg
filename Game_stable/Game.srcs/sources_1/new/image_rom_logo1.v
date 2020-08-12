module image_rom_logo1(
    input wire clk,
    input wire [15:0] address,  // address = {addry[7:0], addrx[7:0]}
    output reg [11:0] rgb
    );
    
    
    reg [11:0] rom [0:65535];

    initial $readmemh("../../logo1_newnew.data", rom); 

    always @(posedge clk)
        rgb <= rom[address];

endmodule