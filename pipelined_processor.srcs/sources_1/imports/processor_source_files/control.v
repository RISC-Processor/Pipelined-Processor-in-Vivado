module control
    #(parameter INSTR_WIDTH = 32)
    (
        input clk,
        input zero,
        input [INSTR_WIDTH - 1: 0] instr,
        // output pc_src,
        output [1:0] result_src,
        output mem_write,
        output [2:0] alu_control,
        output alu_src,
        output [2:0] imm_src,
        output reg_write,
        output branch
    );

    wire [6:0] opcode = instr[6:0];
    wire [6:0] funct7 = instr[31:25];
    wire [2:0] funct3 = instr[14:12];

    wire [1:0] alu_op;

    wire [6:0] ID_EX_opcode;
    wire [6:0] ID_EX_funct7;
    wire [2:0] ID_EX_funct3;
    wire [1:0] ID_EX_alu_op;

    // wire branch;
    wire jump;

    control_main_decoder control_main_decoder_inst (
        .opcode(opcode),
        .branch(branch),
        .result_src(result_src),
        .mem_write(mem_write),
        .alu_src(alu_src),
        .imm_src(imm_src),
        .reg_write(reg_write),
        .alu_op(alu_op),
        .jump(jump)
    );

    // Instantiate a pipeline register to store the 'alu_op' signal
    pipeline_register #(2) pipeline_register_inst_alu_op (
        .clk(clk),
        .din(alu_op),
        .dout(ID_EX_alu_op)
    );

    // Instantiate a pipeline register to store the 'opcode' signal
    pipeline_register #(7) pipeline_register_inst_opcode (
        .clk(clk),
        .din(opcode),
        .dout(ID_EX_opcode)
    );

    // Instantiate a pipeline register to store the 'funct7' signal
    pipeline_register #(7) pipeline_register_inst_funct7 (
        .clk(clk),
        .din(funct7),
        .dout(ID_EX_funct7)
    );

    // Instantiate a pipeline register to store the 'funct3' signal
    pipeline_register #(3) pipeline_register_inst_funct3 (
        .clk(clk),
        .din(funct3),
        .dout(ID_EX_funct3)
    );

    control_alu_decoder control_alu_decoder_inst (
        .opcode(ID_EX_opcode),
        .funct7_5(ID_EX_funct7[5]),
        .funct3(ID_EX_funct3),
        .alu_op(ID_EX_alu_op),
        .alu_control(alu_control)
    );

    // reg pc_src_reg;

    // always @(*) begin
    //     if (jump)
    //         pc_src_reg = 1'b1;
    //     else
    //         pc_src_reg = zero & branch;
    // end
    
    // assign pc_src = pc_src_reg;


    // TODO: IMPORTANT
    // Currently the 'jump' signal is not being used.
    // Use it appropriately and avoid hazards as well.

endmodule