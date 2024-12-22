module processor
    #(  
        parameter BUS_WIDTH = 32
    )
    (
		  input wire clk,
		  input rst,
		  output [7: 0] LEDG,
		  output [7: 0] LEDR,
		  
		  input en,
		  input Tx_busy,
		  output [7:0]   dout,        // Output is now 8 bits
		  output Ready_Byte,   // Ready signal for 8-bit data
		  
		  input clk_50M,
		  
		  input[7: 0] instIn,
	     input enable
	 );
    
    localparam DATA_MEMORY_ADDR_BUS_WIDTH = 32;
    localparam DATA_MEMORY_DATA_BUS_WIDTH = 32;
    localparam REG_FILE_ADDR_BUS_WIDTH = 5;
    localparam REG_FILE_DATA_BUS_WIDTH = 32;
    localparam INST_MEMORY_ADDR_BUS_WIDTH = 16;
    localparam INST_MEMORY_DATA_BUS_WIDTH = 32;
     
    // Wires for module instantiation, and connections
    wire [INST_MEMORY_ADDR_BUS_WIDTH - 1:0] pc_out;
    wire [INST_MEMORY_ADDR_BUS_WIDTH - 1:0] pc_4;
    wire [INST_MEMORY_DATA_BUS_WIDTH - 1:0] instr;
    wire [BUS_WIDTH - 1:0] imm_ext;
    wire [DATA_MEMORY_ADDR_BUS_WIDTH - 1:0] alu_result;
    wire [DATA_MEMORY_DATA_BUS_WIDTH - 1:0] read_data;
    wire [REG_FILE_DATA_BUS_WIDTH - 1:0] read_data_1;
    wire [REG_FILE_DATA_BUS_WIDTH - 1:0] read_data_2;
    wire [REG_FILE_DATA_BUS_WIDTH - 1:0] write_data;
    wire [BUS_WIDTH - 1:0] src_a;
    wire [BUS_WIDTH - 1:0] src_b;
    wire [BUS_WIDTH - 1:0] pc_target;
    wire [BUS_WIDTH - 1:0] pc_next;

    wire zero;
    wire pc_src;
    wire [1:0] result_src;
    wire mem_write;
    wire [2:0] alu_control;
    wire alu_src;
    wire [2:0] imm_src;
    wire reg_write;
    wire branch;

    // Pipeline registers

    wire [INST_MEMORY_DATA_BUS_WIDTH - 1:0] IF_ID_instr;
    wire [INST_MEMORY_ADDR_BUS_WIDTH - 1:0] IF_ID_pc_out;
    wire [INST_MEMORY_ADDR_BUS_WIDTH - 1:0] IF_ID_pc_4;

    wire [INST_MEMORY_DATA_BUS_WIDTH - 1:0] ID_EX_instr;
    wire [INST_MEMORY_ADDR_BUS_WIDTH - 1:0] ID_EX_pc_out;
    wire [INST_MEMORY_ADDR_BUS_WIDTH - 1:0] ID_EX_pc_4;
    wire [REG_FILE_DATA_BUS_WIDTH - 1:0] ID_EX_read_data_1;
    wire [REG_FILE_DATA_BUS_WIDTH - 1:0] ID_EX_read_data_2;
    wire [BUS_WIDTH - 1:0] ID_EX_imm_ext;
    wire [1:0] ID_EX_result_src;
    wire ID_EX_mem_write;
    wire ID_EX_alu_src;
    wire ID_EX_reg_write;
    wire ID_EX_branch;

    wire [INST_MEMORY_DATA_BUS_WIDTH - 1:0] EX_MEM_instr;
    wire [INST_MEMORY_ADDR_BUS_WIDTH - 1:0] EX_MEM_pc_4;
    wire [BUS_WIDTH - 1:0] EX_MEM_pc_target;
    wire [DATA_MEMORY_ADDR_BUS_WIDTH - 1:0] EX_MEM_alu_result;
    wire EX_MEM_zero;
    wire [REG_FILE_DATA_BUS_WIDTH - 1:0] EX_MEM_read_data_2;
    wire [1:0] EX_MEM_result_src;
    wire EX_MEM_mem_write;
    wire EX_MEM_reg_write;
    wire EX_MEM_branch;

    assign pc_src = EX_MEM_zero && EX_MEM_branch;

    wire [INST_MEMORY_DATA_BUS_WIDTH - 1:0] MEM_WB_instr;
    wire [INST_MEMORY_ADDR_BUS_WIDTH - 1:0] MEM_WB_pc_4;
    wire [DATA_MEMORY_DATA_BUS_WIDTH - 1:0] MEM_WB_read_data;
    wire [DATA_MEMORY_ADDR_BUS_WIDTH - 1:0] MEM_WB_alu_result;
    wire [1:0] MEM_WB_result_src;
    wire MEM_WB_reg_write;

    assign src_a = ID_EX_read_data_1;
    assign src_b = ID_EX_alu_src ? ID_EX_imm_ext : ID_EX_read_data_2;
    assign write_data = MEM_WB_result_src == 2'b00 ? MEM_WB_alu_result : (MEM_WB_result_src == 2'b01 ? MEM_WB_read_data : {{BUS_WIDTH - INST_MEMORY_ADDR_BUS_WIDTH{1'b0}}, MEM_WB_pc_4});
    assign pc_next = pc_src ? EX_MEM_pc_target[INST_MEMORY_ADDR_BUS_WIDTH - 1:0] : pc_4;
	 
//	 assign LEDG = pc_next[7: 0];

    // Instantiate control module
    control # (BUS_WIDTH) control_inst (
        .clk(clk),
        .zero(zero),
        .instr(IF_ID_instr),
        // .pc_src(pc_src),
        .result_src(result_src),
        .mem_write(mem_write),
        .alu_control(alu_control),
        .alu_src(alu_src),
        .imm_src(imm_src),
        .reg_write(reg_write),
        .branch(branch)
    );

    // Instantiate program counter
    pc # (INST_MEMORY_ADDR_BUS_WIDTH) pc_inst (
        .clk(clk),
		.rst(rst),
        .pc_next(pc_next),
        .pc(pc_out)
    );

    // Instantiate adder for adding 4 to pc
    adder # (INST_MEMORY_ADDR_BUS_WIDTH) adder_inst1 (
        .a(pc_out),
        .b({{12{1'b0}}, 4'b0100}),
        .y(pc_4)
    );

    // Instantiate adder for adding pc and imm_ext
    adder # (BUS_WIDTH) adder_inst2 (
        .a({{BUS_WIDTH - INST_MEMORY_ADDR_BUS_WIDTH{1'b0}}, ID_EX_pc_out}),
        .b(ID_EX_imm_ext),
        .y(pc_target)
    );
    
    // Instantiate instruction memory module
    imem # (INST_MEMORY_ADDR_BUS_WIDTH, INST_MEMORY_DATA_BUS_WIDTH) imem_inst (
        .a(pc_out),
        .rd(instr),
//		  .LEDG(LEDG)
		.instIn(instIn),
	    .enable(enable),
		.LEDR(LEDR)
    );
	
    // Instantiate a pipeline register to store the instruction
    pipeline_register #(INST_MEMORY_DATA_BUS_WIDTH) pipeline_register_inst_IF_ID_instr (
        .clk(clk),
        .din(instr),
        .dout(IF_ID_instr)
    );

    // Instantiate a pipeline register to store the program counter
    pipeline_register #(INST_MEMORY_ADDR_BUS_WIDTH) pipeline_register_IF_ID_inst_pc (
        .clk(clk),
        .din(pc_out),
        .dout(IF_ID_pc_out)
    );

    // Instantiate a pipeline register to store the program counter + 4
    pipeline_register #(INST_MEMORY_ADDR_BUS_WIDTH) pipeline_register_IF_ID_inst_pc_4 (
        .clk(clk),
        .din(pc_4),
        .dout(IF_ID_pc_4)
    );

    // Insntiate register_file module
    register_file #(REG_FILE_ADDR_BUS_WIDTH, REG_FILE_DATA_BUS_WIDTH) register_file_inst (
        .clk(clk),
		.rst(rst),
        .addr1(IF_ID_instr[19:15]),
        .addr2(IF_ID_instr[24:20]),
        .addr3(MEM_WB_instr[11:7]),
        .write_data(write_data),
        .write_en(MEM_WB_reg_write),
        .read_data1(read_data_1),
        .read_data2(read_data_2),
		  .LEDG(LEDG),
		  
		  .clk_50M(clk_50M),
		  .en(en),
		  .Tx_busy(Tx_busy),
		  .dout(dout),        // Output is now 8 bits
		  .Ready_Byte(Ready_Byte)  // Ready signal for 8-bit data
    );

    // Insntiate extend module
    extend #(BUS_WIDTH) extend_inst (
        .imm_src(imm_src),
        .instr(IF_ID_instr),
        .extended_imm(imm_ext)
    );

    // Instantiate a pipeline register to store the instruction
    pipeline_register #(INST_MEMORY_DATA_BUS_WIDTH) pipeline_register_inst_ID_EX_instr (
        .clk(clk),
        .din(IF_ID_instr),
        .dout(ID_EX_instr)
    );

    // Instantiate a pipeline register to store the program counter
    pipeline_register #(INST_MEMORY_ADDR_BUS_WIDTH) pipeline_register_ID_EX_inst_pc (
        .clk(clk),
        .din(IF_ID_pc_out),
        .dout(ID_EX_pc_out)
    );

    // Instantiate a pipeline register to store the read data 1
    pipeline_register #(REG_FILE_DATA_BUS_WIDTH) pipeline_register_inst_ID_EX_read_data_1 (
        .clk(clk),
        .din(read_data_1),
        .dout(ID_EX_read_data_1)
    );

    // Instantiate a pipeline register to store the read data 2
    pipeline_register #(REG_FILE_DATA_BUS_WIDTH) pipeline_register_inst_ID_EX_read_data_2 (
        .clk(clk),
        .din(read_data_2),
        .dout(ID_EX_read_data_2)
    );

    // Instantiate a pipeline register to store the imm_ext
    pipeline_register #(BUS_WIDTH) pipeline_register_inst_ID_EX_imm_ext (
        .clk(clk),
        .din(imm_ext),
        .dout(ID_EX_imm_ext)
    );

    // Instantiate a pipeline register to store the result_src
    pipeline_register #(2) pipeline_register_inst_result_src (
        .clk(clk),
        .din(result_src),
        .dout(ID_EX_result_src)
    );

    // Instantiate a pipeline register to store the mem_write
    pipeline_register #(1) pipeline_register_inst_mem_write (
        .clk(clk),
        .din(mem_write),
        .dout(ID_EX_mem_write)
    );

    // Instantiate a pipeline register to store the alu_src
    pipeline_register #(1) pipeline_register_inst_alu_src (
        .clk(clk),
        .din(alu_src),
        .dout(ID_EX_alu_src)
    );

    // Instantiate a pipeline register to store the reg_write
    pipeline_register #(1) pipeline_register_inst_reg_write (
        .clk(clk),
        .din(reg_write),
        .dout(ID_EX_reg_write)
    );

    // Instantiate a pipeline register to store the branch
    pipeline_register #(1) pipeline_register_inst_branch (
        .clk(clk),
        .din(branch),
        .dout(ID_EX_branch)
    );

    // Instantiate a pipeline register to store the program counter + 4
    pipeline_register #(INST_MEMORY_ADDR_BUS_WIDTH) pipeline_register_ID_EX_inst_pc_4 (
        .clk(clk),
        .din(IF_ID_pc_4),
        .dout(ID_EX_pc_4)
    );

    // Insntiate alu module
    alu #(BUS_WIDTH) alu_inst (
        .src_a(src_a),
        .src_b(src_b),
        .alu_op(alu_control),
        .alu_result(alu_result),
        .zero(zero)
    );

    // Instantiate a pipeline register to store the instruction
    pipeline_register #(INST_MEMORY_DATA_BUS_WIDTH) pipeline_register_inst_EX_MEM_instr (
        .clk(clk),
        .din(ID_EX_instr),
        .dout(EX_MEM_instr)
    );

    // Instantiate a pipeline register to store the pc_target
    pipeline_register #(BUS_WIDTH) pipeline_register_inst_EX_MEM_pc_target (
        .clk(clk),
        .din(pc_target),
        .dout(EX_MEM_pc_target)
    );

    // Instantiate a pipeline register to store the alu_result
    pipeline_register #(DATA_MEMORY_ADDR_BUS_WIDTH) pipeline_register_inst_EX_MEM_alu_result (
        .clk(clk),
        .din(alu_result),
        .dout(EX_MEM_alu_result)
    );

    // Instantiate a pipeline register to store the zero
    pipeline_register #(1) pipeline_register_inst_EX_MEM_zero (
        .clk(clk),
        .din(zero),
        .dout(EX_MEM_zero)
    );

    // Instantiate a pipeline register to store the read data 2
    pipeline_register #(REG_FILE_DATA_BUS_WIDTH) pipeline_register_inst_EX_MEM_read_data_2 (
        .clk(clk),
        .din(ID_EX_read_data_2),
        .dout(EX_MEM_read_data_2)
    );

    // Instantiate a pipeline register to store the result_src
    pipeline_register #(2) pipeline_register_inst_EX_MEM_result_src (
        .clk(clk),
        .din(ID_EX_result_src),
        .dout(EX_MEM_result_src)
    );

    // Instantiate a pipeline register to store the mem_write
    pipeline_register #(1) pipeline_register_inst_EX_MEM_mem_write (
        .clk(clk),
        .din(ID_EX_mem_write),
        .dout(EX_MEM_mem_write)
    );

    // Instantiate a pipeline register to store the reg_write
    pipeline_register #(1) pipeline_register_inst_EX_MEM_reg_write (
        .clk(clk),
        .din(ID_EX_reg_write),
        .dout(EX_MEM_reg_write)
    );

    // Instantiate a pipeline register to store the branch
    pipeline_register #(1) pipeline_register_inst_EX_MEM_branch (
        .clk(clk),
        .din(ID_EX_branch),
        .dout(EX_MEM_branch)
    );

    // Instantiate a pipeline register to store the program counter + 4
    pipeline_register #(INST_MEMORY_ADDR_BUS_WIDTH) pipeline_register_EX_MEM_inst_pc_4 (
        .clk(clk),
        .din(ID_EX_pc_4),
        .dout(EX_MEM_pc_4)
    );

    // Insntiate data_memory module
    data_memory #(DATA_MEMORY_ADDR_BUS_WIDTH, DATA_MEMORY_DATA_BUS_WIDTH) data_memory_inst (
        .clk(clk),
        .addr(EX_MEM_alu_result),
        .write_data(EX_MEM_read_data_2),
        .write_en(EX_MEM_mem_write),
        .read_data(read_data)
    );

    // Instantiate a pipeline register to store the instruction
    pipeline_register #(INST_MEMORY_DATA_BUS_WIDTH) pipeline_register_inst_MEM_WB_instr (
        .clk(clk),
        .din(EX_MEM_instr),
        .dout(MEM_WB_instr)
    );

    // Instantiate a pipeline register to store the read data
    pipeline_register #(DATA_MEMORY_DATA_BUS_WIDTH) pipeline_register_inst_MEM_WB_read_data (
        .clk(clk),
        .din(read_data),
        .dout(MEM_WB_read_data)
    );

    // Instantiate a pipeline register to store the alu_result
    pipeline_register #(DATA_MEMORY_ADDR_BUS_WIDTH) pipeline_register_inst_MEM_WB_alu_result (
        .clk(clk),
        .din(EX_MEM_alu_result),
        .dout(MEM_WB_alu_result)
    );

    // Instantiate a pipeline register to store the result_src
    pipeline_register #(2) pipeline_register_inst_MEM_WB_result_src (
        .clk(clk),
        .din(EX_MEM_result_src),
        .dout(MEM_WB_result_src)
    );

    // Instantiate a pipeline register to store the reg_write
    pipeline_register #(1) pipeline_register_inst_MEM_WB_reg_write (
        .clk(clk),
        .din(EX_MEM_reg_write),
        .dout(MEM_WB_reg_write)
    );

    // Instantiate a pipeline register to store the program counter + 4
    pipeline_register #(INST_MEMORY_ADDR_BUS_WIDTH) pipeline_register_MEM_WB_inst_pc_4 (
        .clk(clk),
        .din(EX_MEM_pc_4),
        .dout(MEM_WB_pc_4)
    );
	 
//	 assign LEDG = instr[7: 0];
	 
endmodule