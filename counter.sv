module counter #(
    parameter WIDTH = 20,
    HEIGHT = 15
) (
    input logic [HEIGHT-1:0][WIDTH-1:0] grid,
    output logic [31:0] display_data
);

  typedef enum logic [7:0] {
    SEG_EMPTY = 8'b00000000,
    SEG_TM = 8'b00000001,
    SEG_TR = 8'b00000010,
    SEG_BR = 8'b00000100,
    SEG_BM = 8'b00001000,
    SEG_BL = 8'b00010000,
    SEG_TL = 8'b00100000,
    SEG_MM = 8'b01000000,
    SEG_DOT = 8'b10000000,
    SEG_0 = 8'b00111111,
    SEG_1 = 8'b00000110,
    SEG_2 = 8'b01011011,
    SEG_3 = 8'b01001111,
    SEG_4 = 8'b01100110,
    SEG_5 = 8'b01101101,
    SEG_6 = 8'b01111101,
    SEG_7 = 8'b00000111,
    SEG_8 = 8'b01111111,
    SEG_9 = 8'b01101111
  } segment_t;

  function automatic segment_t digit(int index);
    case (index)
      0: digit = SEG_0;
      1: digit = SEG_1;
      2: digit = SEG_2;
      3: digit = SEG_3;
      4: digit = SEG_4;
      5: digit = SEG_5;
      6: digit = SEG_6;
      7: digit = SEG_7;
      8: digit = SEG_8;
      9: digit = SEG_9;
      default: digit = SEG_EMPTY;
    endcase
  endfunction

  always_comb begin
    int live_cell_count;
    live_cell_count = 0;

    for (int i = 0; i < HEIGHT; i++) begin
      for (int j = 0; j < WIDTH; j++) begin
        if (grid[i][j]) begin
          live_cell_count += 1;
        end
      end
    end

    display_data = {
      digit((live_cell_count / 1000) % 10),
      digit((live_cell_count / 100) % 10),
      digit((live_cell_count / 10) % 10),
      digit(live_cell_count % 10)
    };
  end

endmodule
