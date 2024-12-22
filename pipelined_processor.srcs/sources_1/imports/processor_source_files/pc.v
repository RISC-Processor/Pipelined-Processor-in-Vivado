`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2024 11:25:52 AM
// Design Name: 
// Module Name: pc
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


module pc
    #(parameter BUS_WIDTH = 16)
    (
        input clk,
		input rst,
        input [BUS_WIDTH - 1:0] pc_next,
        output reg [BUS_WIDTH - 1:0] pc
    );
	 
	 initial
	 begin
		  pc = 16'h0000;
	 end
    
    always @(posedge clk) begin
		if (~rst) begin 
			pc <= 0;
		end else begin
			pc <= pc_next;
		end
	 end

endmodule
