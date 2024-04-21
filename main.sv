module main (
    input logic left,
    input logic right,
    input logic reset,
    input logic clk_10mhz,
    output logic [7:0] segment_pins,
    output logic [3:0] display_select,
    output logic [3:0] leds,
    output logic [2:0] rgb,
    output logic vsync,
    output logic hsync
);

  assign leds = {left, right, reset, 1'b1};

  logic clk_40mhz;
  pll pll (
      .inclk0(clk_10mhz),
      .c0(clk_40mhz)
  );

  logic clk_600hz;
  clock_divider #(
      .IN_FREQUENCY (10 * 10 ** 6),
      .OUT_FREQUENCY(600)
  ) divider_600hz (
      .inclk (clk_10mhz),
      .outclk(clk_600hz)
  );

  logic clk_3hz;
  clock_divider #(
      .IN_FREQUENCY (600),
      .OUT_FREQUENCY(3)
  ) divider_3hz (
      .inclk (clk_600hz),
      .outclk(clk_3hz)
  );

  localparam WIDTH = 20;
  localparam HEIGHT = 15;
  localparam CELL_SIZE = 40;

  logic [HEIGHT-1:0][WIDTH-1:0] grid;
  game_of_life #(
      .WIDTH (WIDTH),
      .HEIGHT(HEIGHT)
  ) game_of_life (
      .clk(clk_3hz),
      .clk_40mhz(clk_40mhz),
      .reset(reset),
      .grid(grid)
  );

  vga #(
      .CELL_SIZE(CELL_SIZE)
  ) vga (
      .clk  (clk_40mhz),
      .hsync(hsync),
      .vsync(vsync),
      .rgb  (rgb),
      .grid (grid)
  );

  logic [31:0] display_data = 0;
  counter counter (
      .grid(grid),
      .display_data(display_data)
  );

  display display (
      .clk(clk_600hz),
      .display_data(display_data),
      .segment_pins(segment_pins),
      .display_select(display_select)
  );

endmodule
