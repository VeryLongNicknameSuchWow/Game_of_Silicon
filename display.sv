module display (
    input logic clk,
    input logic [31:0] display_data,
    output logic [7:0] segment_pins,
    output logic [3:0] display_select
);

  logic [1:0] display_counter = 0;
  always_ff @(posedge clk) begin
    display_select = 1'b1 << display_counter;
    segment_pins   = display_data[display_counter*8+:8];
    display_counter += 1;
  end

endmodule
