`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: RISC_Processor
// Engineer: Linuka Ratnayake
// 
// Create Date: 10/03/2024 07:10:57 PM
// Design Name: 
// Module Name: data_memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module data_memory
    #(  
        parameter ADDR_BUS_WIDTH = 32,
        parameter DATA_BUS_WIDTH = 32)
    (
        input clk,
        input [ADDR_BUS_WIDTH - 1:0] addr,
        input [DATA_BUS_WIDTH - 1:0] write_data,
        input write_en,
        output [DATA_BUS_WIDTH - 1:0] read_data
    );
        
    localparam MEM_DEPTH = 64;
    localparam MEM_WIDTH = 8;

    reg [MEM_WIDTH - 1:0] mem [0:MEM_DEPTH - 1];

    assign read_data = {mem[addr], mem[addr + 1], mem[addr + 2], mem[addr + 3]};
	 
	 initial begin
        // Initialize 16 words, each occupying 4 bytes
         {mem[0], mem[1], mem[2], mem[3]}   = 32'b00000000000000000000000000001010; // Word 0
			{mem[4], mem[5], mem[6], mem[7]}   = 32'b00110011001100110011001100110011; // Word 1
			{mem[8], mem[9], mem[10], mem[11]} = 32'b10101010101010101010101010101010; // Word 2
			{mem[12], mem[13], mem[14], mem[15]} = 32'b11001100110011001100110011001100; // Word 3
			{mem[16], mem[17], mem[18], mem[19]} = 32'b00011100011100011100011100011100; // Word 4
			{mem[20], mem[21], mem[22], mem[23]} = 32'b11110000111100001111000011110000; // Word 5
			{mem[24], mem[25], mem[26], mem[27]} = 32'b10011001100110011001100110011001; // Word 6
			{mem[28], mem[29], mem[30], mem[31]} = 32'b01100110011001100110011001100110; // Word 7
			{mem[32], mem[33], mem[34], mem[35]} = 32'b00001111000011110000111100001111; // Word 8
			{mem[36], mem[37], mem[38], mem[39]} = 32'b11111111000000001111111100000000; // Word 9
			{mem[40], mem[41], mem[42], mem[43]} = 32'b10100101101001011010010110100101; // Word 10
			{mem[44], mem[45], mem[46], mem[47]} = 32'b01011010010110100101101001011010; // Word 11
			{mem[48], mem[49], mem[50], mem[51]} = 32'b11110000111100001111000011110000; // Word 12
			{mem[52], mem[53], mem[54], mem[55]} = 32'b00001111000011110000111100001111; // Word 13
			{mem[56], mem[57], mem[58], mem[59]} = 32'b10101011101010111010101110101011; // Word 14
			{mem[60], mem[61], mem[62], mem[63]} = 32'b11010101110101011101010111010101; // Word 15

    end

    always @(negedge clk)
    begin
        if(write_en)
        begin
            mem[addr] <= write_data[4 * MEM_WIDTH - 1: 3 * MEM_WIDTH];
            mem[addr + 1] <= write_data[3 * MEM_WIDTH - 1: 2 * MEM_WIDTH];
            mem[addr + 2] <= write_data[2 * MEM_WIDTH - 1: MEM_WIDTH];
            mem[addr + 3] <= write_data[MEM_WIDTH - 1: 0];
        end
    end
    
endmodule
