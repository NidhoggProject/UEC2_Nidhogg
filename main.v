`timescale 1ns / 1ps

module main(
    input wire clk,
    input wire help,
    input wire menu,
    input wire select_map,
    input wire game_castle,
    input wire game_forest,
    output wire win
    );
    
reg [2:0] state;
reg [2:0] next_state;

localparam
IDLE = 'b000,
HELP = 'b001,
SELECT_MAP = 'b010,
GAME_FOREST = 'b011,
GAME_CASTLE = 'b100,
END_GAME_FOREST = 'b101,
END_GAME_CASTLE = 'b111;

always @(posedge clk)
    state <= next_state;
    
always @(state or help or menu or game_forest or game_castle or win or select_map)
    case(state)
        IDLE:               next_state = help ? HELP : (select_map ? SELECT_MAP : IDLE);
        HELP:               next_state = menu ? IDLE : HELP;
        SELECT_MAP:         next_state = game_forest ? GAME_FOREST : (game_castle ? GAME_CASTLE : (menu ? IDLE : SELECT_MAP));
        GAME_FOREST:        next_state = win ? END_GAME_FOREST : GAME_FOREST;
        GAME_CASTLE:        next_state = win ? END_GAME_CASTLE : GAME_CASTLE;
        END_GAME_FOREST:    next_state = menu ? IDLE : END_GAME_FOREST;
        END_GAME_CASTLE:    next_state = menu ? IDLE : END_GAME_CASTLE;
        default:            next_state = IDLE;
    endcase

endmodule
