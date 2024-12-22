`timescale 1ns / 1ps

module adder
    # (parameter BUS_WIDTH = 16)
    (
    input logic [BUS_WIDTH - 1:0] a, b,
    output logic [BUS_WIDTH - 1:0] y
    );

    assign  y = a + b;

endmodule
