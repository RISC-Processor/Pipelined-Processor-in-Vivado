module control_alu_decoder
    (
        input [6:0] opcode,
        input funct7_5,
        input [2:0] funct3,
        input [1:0] alu_op,
        output reg [2:0] alu_control
    );

    always @(opcode, funct7_5, funct3, alu_op)
    begin
        case(alu_op)
            2'b00: alu_control = 3'b000;    // add
            2'b01: alu_control = 3'b001;    // sub
            2'b10: 
            begin
                case(funct3)
                    3'b000: 
                    begin
                        if({opcode[5], funct7_5} == 2'b11)
                        begin
                            alu_control = 3'b001;   // sub
                        end
                        else
                        begin
                            alu_control = 3'b000;   // add
                        end
                    end
                    3'b010: alu_control = 3'b101;  // slt (set less than)
                    3'b110: alu_control = 3'b010;   // or
                    3'b111: alu_control = 3'b011;   // and
                    default: alu_control = 3'bxxx;
                endcase
            end
            2'b11: alu_control = 3'b110;    // just pass
            default: alu_control = 3'bxxx;
        endcase
    end
endmodule