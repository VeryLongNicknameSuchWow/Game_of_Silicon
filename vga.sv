module vga #(
    parameter H_PIXELS = 800,
    H_SYNCTIME = 128,
    H_PORCH = 88 + 40,
    V_LINES = 600,
    V_SYNCTIME = 4,
    V_PORCH = 1 + 23,
    CELL_SIZE = 40
) (
    input logic clk,
    output logic hsync,
    output logic vsync,
    output logic [2:0] rgb,
    input logic [V_LINES/CELL_SIZE-1:0][H_PIXELS/CELL_SIZE-1:0] grid
);

  localparam H_PERIOD = H_PIXELS + H_SYNCTIME + H_PORCH;
  localparam V_PERIOD = V_LINES + V_SYNCTIME + V_PORCH;

  logic [$clog2(H_PERIOD):0] hcnt;
  logic [$clog2(V_PERIOD):0] vcnt;

  logic blank;
  assign blank = (hcnt >= H_PIXELS || vcnt >= V_LINES) ? 1 : 0;

  always_ff @(posedge clk) begin
    if (hcnt < H_PERIOD) begin
      hcnt <= hcnt + 1;
    end else begin
      hcnt <= 0;
    end
  end

  always_ff @(posedge hsync) begin
    if (vcnt < V_PERIOD) begin
      vcnt <= vcnt + 1;
    end else begin
      vcnt <= 0;
    end
  end

  always_ff @(posedge clk) begin
    if (hcnt >= H_PIXELS && hcnt < (H_PIXELS + H_SYNCTIME)) begin
      hsync <= 1;
    end else begin
      hsync <= 0;
    end
  end

  always_ff @(posedge hsync) begin
    if (vcnt >= V_LINES && vcnt < (V_LINES + V_SYNCTIME)) begin
      vsync <= 1;
    end else begin
      vsync <= 0;
    end
  end

  always_ff @(posedge clk) begin
    if (!blank && grid[vcnt/CELL_SIZE][hcnt/CELL_SIZE]) begin
      rgb <= 3'b101;  // MAGENTA UWU
    end else begin
      rgb <= 3'b000;  // BLACK
    end
  end
endmodule
