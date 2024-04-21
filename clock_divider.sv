module clock_divider #(
    parameter IN_FREQUENCY  = 10 ** 7,
    parameter OUT_FREQUENCY = 100
) (
    input  logic inclk,
    output logic outclk
);

  localparam MAX_COUNT = IN_FREQUENCY / OUT_FREQUENCY / 2 - 1;
  localparam COUNTER_WIDTH = $clog2(MAX_COUNT + 1);

  logic [COUNTER_WIDTH-1:0] counter = 0;

  always_ff @(posedge inclk) begin
    if (counter >= MAX_COUNT) begin
      counter <= 0;
      outclk  <= ~outclk;
    end else begin
      counter <= counter + 1;
    end
  end
endmodule
