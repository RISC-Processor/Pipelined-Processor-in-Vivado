module register_file
    #(
        parameter ADDR_BUS_WIDTH = 5,
        parameter DATA_BUS_WIDTH = 32
    )
    (
		  // From datapath
        input clk,// done by hand
		  input rst,
        input [ADDR_BUS_WIDTH - 1:0] addr1,
        input [ADDR_BUS_WIDTH - 1:0] addr2,
        input [ADDR_BUS_WIDTH - 1:0] addr3,
        input [DATA_BUS_WIDTH - 1:0] write_data,
        input write_en,
        output [DATA_BUS_WIDTH - 1:0] read_data1,
        output [DATA_BUS_WIDTH - 1:0] read_data2,
		  output [7: 0] LEDG,
		  
		  // From UART
		  input clk_50M,
		  input en,
		  input Tx_busy,
		  output reg [7:0] dout,// Output is now 8 bits
		  output reg Ready_Byte// Ready signal for 8-bit data
    );

    localparam REG_FILE_DEPTH = 32;

    reg [DATA_BUS_WIDTH - 1:0] registerFile [0: REG_FILE_DEPTH - 1];
    
    // Register 0 is always 0.
    assign read_data1 = addr1 == 5'b00000 ? {32{1'b0}} : registerFile[addr1];
    assign read_data2 = addr2 == 5'b00000 ? {32{1'b0}} : registerFile[addr2];
	 
	 
	 initial
	 begin
        registerFile[5]  = 32'b00000000000000000000000000000110; // 6
        registerFile[9]  = 32'b00000000000000000000000000000100; // 4
		  registerFile[0]  = 32'b00000000000000000000000000000000; // Register 0
        registerFile[1]  = 32'b00000000000000000000000000000001; // Register 1
        registerFile[2]  = 32'b00000000000000000000000000000011; // Register 2
        registerFile[3]  = 32'b00000000000000000000000000000111; // Register 3
        registerFile[4]  = 32'b00000000000000000000000000001111; // Register 4
//        registerFile[5]  = 32'b00000000000000000000000000011111; // Register 5
        registerFile[6]  = 32'b00000000000000000000000000111111; // Register 6
        registerFile[7]  = 32'b00000000000000000000000001111111; // Register 7
        registerFile[8]  = 32'b00000000000000000000000011111111; // Register 8
//        registerFile[9]  = 32'b00000000000000000000000111111111; // Register 9
        registerFile[10] = 32'b00000000000000000000001111111111; // Register 10
        registerFile[11] = 32'b00000000000000000000011111111111; // Register 11
        registerFile[12] = 32'b00000000000000000000111111111111; // Register 12
        registerFile[13] = 32'b00000000000000000001111111111111; // Register 13
        registerFile[14] = 32'b00000000000000000011111111111111; // Register 14
        registerFile[15] = 32'b00000000000000000111111111111111; // Register 15
        registerFile[16] = 32'b00000000000000001111111111111111; // Register 16
        registerFile[17] = 32'b00000000000000011111111111111111; // Register 17
        registerFile[18] = 32'b00000000000000111111111111111111; // Register 18
        registerFile[19] = 32'b00000000000001111111111111111111; // Register 19
        registerFile[20] = 32'b00000000000011111111111111111111; // Register 20
        registerFile[21] = 32'b00000000000111111111111111111111; // Register 21
        registerFile[22] = 32'b00000000001111111111111111111111; // Register 22
        registerFile[23] = 32'b00000000011111111111111111111111; // Register 23
        registerFile[24] = 32'b00000000111111111111111111111111; // Register 24
        registerFile[25] = 32'b00000001111111111111111111111111; // Register 25
        registerFile[26] = 32'b00000011111111111111111111111111; // Register 26
        registerFile[27] = 32'b00000111111111111111111111111111; // Register 27
        registerFile[28] = 32'b00001111111111111111111111111111; // Register 28
        registerFile[29] = 32'b00011111111111111111111111111111; // Register 29
        registerFile[30] = 32'b00111111111111111111111111111111; // Register 30
        registerFile[31] = 32'b01111111111111111111111111111111; // Register 31
	 end

	 integer i;
	 
    always @(negedge clk)
	 if (~rst) begin
		  for (i = 0; i <= 31; i = i + 1) begin
				registerFile[i] <= 0;
		  end
	 end else begin
        if(write_en)
        begin
            registerFile[addr3] <= write_data;
        end
    end
	 
	 assign LEDG = registerFile[4];
	 
	 
	 // State encoding
    reg [2:0] current_state, next_state;
    localparam IDLE        = 3'b000,
               OUTPUT_REG  = 3'b001,
               OUTPUT_BYTE = 3'b010,
               SEND_BYTE   = 3'b011,
               BYTE_SENT   = 3'b100,
               REG_SENT    = 3'b101;

    // Internal signals
    reg [4:0] incrementer;           // Register index
    reg [1:0] byte_counter;          // Byte counter for 32-bit data
    reg [31:0] current_reg_value;    // Current 32-bit register value

    // State transition logic
    always @(posedge clk_50M or posedge en) begin
        if (en) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state; // Default to current state
        case (current_state)
            IDLE: begin
                if (~en) begin
                    next_state = OUTPUT_REG;
                end
            end
            OUTPUT_REG: begin
                if (incrementer <= 31) begin
                    next_state = OUTPUT_BYTE;
                end else begin
                    next_state = IDLE;
                end
            end
            OUTPUT_BYTE: begin
                if (!Tx_busy) begin
                    next_state = SEND_BYTE;
                end
            end
            SEND_BYTE: begin
                if (!Tx_busy) begin
                    next_state = BYTE_SENT;
                end
            end
            BYTE_SENT: begin
                if (byte_counter < 3) begin
                    next_state = OUTPUT_BYTE;
                end else if (byte_counter == 3) begin
                    next_state = REG_SENT;
                end
            end
            REG_SENT: begin
                next_state = OUTPUT_REG;
            end
        endcase
    end

    // Output and control logic
    always @(posedge clk_50M or posedge en) begin
        if (en) begin
            incrementer <= 5'b0;
            byte_counter <= 2'b0;
            dout <= 8'b0;
            Ready_Byte <= 1'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    incrementer <= 5'b0;
                    byte_counter <= 2'b0;
                    dout <= 8'b0;
                    Ready_Byte <= 1'b0;
                end
                OUTPUT_REG: begin
                    current_reg_value <= registerFile[incrementer];
                    Ready_Byte <= 1'b0;
                    byte_counter <= 2'b0;
                end
                SEND_BYTE: begin
                    Ready_Byte <= 1'b1;
                    case (byte_counter)
                        2'b00: dout <= current_reg_value[31:24];
                        2'b01: dout <= current_reg_value[23:16];
                        2'b10: dout <= current_reg_value[15:8];
                        2'b11: dout <= current_reg_value[7:0];
                    endcase
                end
                BYTE_SENT: begin
                    Ready_Byte <= 1'b0;
                    byte_counter <= byte_counter + 1;
                end
                REG_SENT: begin
                    Ready_Byte <= 1'b0;
                    incrementer <= incrementer + 1;
                end
            endcase
        end
    end

endmodule
