module alu
    #(
        parameter BUS_WIDTH = 32
    )
    (
        input [BUS_WIDTH - 1:0] src_a,
        input [BUS_WIDTH - 1:0] src_b,
        input [2:0] alu_op,
        output reg [BUS_WIDTH - 1:0] alu_result,
        output reg zero
    );

    always @(alu_op or src_a or src_b)
    begin
        case(alu_op)
            3'b000: alu_result = src_a + src_b;
            3'b001: begin
                alu_result = src_a - src_b;
                 if (src_a == src_b)
                     zero = 1'b1;
                 else
                     zero = 1'b0;
            end
            3'b010: alu_result = src_a | src_b;
            3'b011: alu_result = src_a & src_b;
            3'b101: begin
                if (src_a < src_b)
                    alu_result = {{BUS_WIDTH - 1{1'b0}}, 1'b1};
                else
                    alu_result = {BUS_WIDTH{1'b0}};
            end
            3'b110: alu_result = src_b;
            default: alu_result = 0;
        endcase
    end

     initial
     begin
         zero = 1'b0;
     end

endmodule