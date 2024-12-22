module control_main_decoder
    (
        input [6:0] opcode,
        output reg branch,
        output reg [1:0] result_src,
        output reg mem_write,
        output reg alu_src,
        output reg [2:0] imm_src,
        output reg reg_write,
        output reg [1:0] alu_op,
        output reg jump
    );

    always @(opcode)
    begin
        case(opcode)
            7'd3: begin //lw (I type)
                branch = 1'b0;
                result_src = 2'b01;
                mem_write = 1'b0;
                alu_src = 1'b1;
                imm_src = 3'b000;
                reg_write = 1'b1;
                alu_op = 2'b00;
                jump = 1'b0;
            end
            7'd35: begin    // sw (S type)
                branch = 1'b0;
                result_src = 2'bxx;
                mem_write = 1'b1;
                alu_src = 1'b1;
                imm_src = 3'b001;
                reg_write = 1'b0;
                alu_op = 2'b00;
                jump = 1'b0;
            end
            7'd51: begin // or (R type)
                branch = 1'b0;
                result_src = 2'b00;
                mem_write = 1'b0;
                alu_src = 1'b0;
                imm_src = 3'bxxx;
                reg_write = 1'b1;
                alu_op = 2'b10;
                jump = 1'b0;
            end
            7'd99: begin  // beq (B type)
                branch = 1'b1;
                result_src = 2'bxx;
                mem_write = 1'b0;
                alu_src = 1'b0;
                imm_src = 3'b010;
                reg_write = 1'b0;
                alu_op = 2'b01;
                jump = 1'b0;
            end
            7'd19: begin  // addi (I type)
                branch = 1'b0;
                result_src = 2'b00;
                mem_write = 1'b0;
                alu_src = 1'b1;
                imm_src = 3'b000;
                reg_write = 1'b1;
                alu_op = 2'b10;
                jump = 1'b0;
            end
            7'd111: begin    // jal (J type)
                branch = 1'b0;
                result_src = 2'b10;
                mem_write = 1'b0;
                alu_src = 1'bx;
                imm_src = 3'b011;
                reg_write = 1'b1;
                alu_op = 2'bxx;
                jump = 1'b1;
            end
            7'd55: begin    // lui (U type)
                branch = 1'b0;
                result_src = 2'b00;
                mem_write = 1'b0;
                alu_src = 1'b1;
                imm_src = 3'b100;
                reg_write = 1'b1;
                alu_op = 2'b11;
                jump = 1'b0;
            end
            default: begin
                branch = 1'bx;
                result_src = 2'bxx;
                mem_write = 1'bx;
                alu_src = 1'bx;
                imm_src = 3'bxxx;
                reg_write = 1'bx;
                alu_op = 2'bxx;
                jump = 1'b0;
            end
        endcase
    end
endmodule