module game_of_life #(
    parameter WIDTH = 20,
    HEIGHT = 15
) (
    input logic clk,
    input logic clk_40mhz,
    input logic reset,
    output logic [HEIGHT-1:0][WIDTH-1:0] grid
);
  logic [HEIGHT-1:0][WIDTH-1:0] next_grid;

  function automatic int count_neighbors(input int x, input int y);
    int count = 0;
    for (int dx = -1; dx <= 1; dx++) begin
      for (int dy = -1; dy <= 1; dy++) begin
        int nx = x + dx;
        int ny = y + dy;

        if ((dx != 0 || dy != 0) && nx >= 0 && nx < WIDTH && ny >= 0 && ny < HEIGHT) begin
          count += grid[ny][nx];
        end
      end
    end
    return count;
  endfunction

  logic [HEIGHT-1:0][WIDTH-1:0] counter = 0;

  always_ff @(posedge clk_40mhz) begin
    if (reset) begin
      counter += 1;
      counter ^= counter >> 3;
      counter <<= counter % 4;
    end
  end

  always_ff @(posedge clk or negedge reset) begin
    if (~reset) begin
      grid = counter;
    end else begin
      for (int x = 0; x < WIDTH; x++) begin
        for (int y = 0; y < HEIGHT; y++) begin
          int neighbors;
          neighbors = count_neighbors(x, y);
          if (grid[y][x] == 1 && (neighbors < 2 || neighbors > 3)) begin
            next_grid[y][x] = 0;
          end else if (grid[y][x] == 0 && neighbors == 3) begin
            next_grid[y][x] = 1;
          end else begin
            next_grid[y][x] = grid[y][x];
          end
        end
      end
      grid = next_grid;
    end
  end

endmodule
