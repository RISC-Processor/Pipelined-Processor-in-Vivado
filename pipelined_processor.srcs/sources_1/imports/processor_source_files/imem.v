`timescale 1ns / 1ps

module imem
    #(  
      parameter ADDR_BUS_WIDTH = 16,
      parameter DATA_BUS_WIDTH = 32
    )
    (
        input [ADDR_BUS_WIDTH - 1:0] a,
        output  [DATA_BUS_WIDTH - 1:0] rd,
		  output [7: 0] LEDR,
		  input enable, 
		  input [7: 0] instIn
		  
    );

    localparam MEM_DEPTH = 2 ** (ADDR_BUS_WIDTH-10);
    localparam MEM_WIDTH = 8;
      
    reg [MEM_WIDTH - 1:0] memory[MEM_DEPTH - 1:0];
    

	 integer i; // Loop variable

    initial begin
        // Initialize all memory locations to 0
        for (i = 0; i < 64; i = i + 1) begin
            memory[i] = 8'h00;
        end

        // Assign the specific memory values
        // lw x6 -4(x9)
        memory[4]  = 8'hFF;
        memory[5]  = 8'hC4;
        memory[6]  = 8'hA3;
        memory[7]  = 8'h03;

        // sw x6, 8(x9)
        memory[8]  = 8'h00;
        memory[9]  = 8'h64;
        memory[10] = 8'hA4;
        memory[11] = 8'h23;

        // or x4, x5, x6
        memory[12] = 8'h00;
        memory[13] = 8'h62;
        memory[14] = 8'hE2;
        memory[15] = 8'h33;

        // beq x4, x4, 24
        memory[16] = 8'h00;  // 8'hFE;
        memory[17] = 8'h42;
        memory[18] = 8'h0C;  // 8'h0A;
        memory[19] = 8'h63;  // 8'hE3;

        // or x4, x5, x6
        memory[40] = 8'h00;
        memory[41] = 8'h62;
        memory[42] = 8'hE2;
        memory[43] = 8'h33;

        // Addi x12, x5(17)
        memory[44] = 8'h01;
        memory[45] = 8'h12;
        memory[46] = 8'h86;
        memory[47] = 8'h13;

        // lui x7, 4560
        memory[48] = 8'h01;
        memory[49] = 8'h1d;
        memory[50] = 8'h03;
        memory[51] = 8'hb7;

        // jal x2, -40
        memory[52] = 8'hfd;
        memory[53] = 8'h9f;
        memory[54] = 8'hf1;
        memory[55] = 8'h6f;
    end
        
//  assign LEDG = memory[5];
    assign rd = {memory[a], memory[a + 1], memory[a + 2], memory[a + 3]};

	 reg [6: 0] j = 0;
	 
	 always @(posedge enable) begin
			memory[j] <= instIn;
			j <= j + 1;
	 end
	 
	 assign LEDR = memory[0];
	 
endmodule
