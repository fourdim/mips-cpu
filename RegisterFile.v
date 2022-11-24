

module RegisterFile(A1, A2, A3, WD3, WE3, Clk, RD1, RD2);

	input [4:0] A1, A2, A3;
	input [31:0] WD3;
	input WE3, Clk;
	
	output reg [31:0] RD1, RD2;

	reg [31:0] Registers [0:31];

	initial begin
		Registers[0] <= 32'h00000000;
		Registers[1] <= 32'h00000000;
		Registers[2] <= 32'h00000000;
		Registers[3] <= 32'h00000000;
		Registers[4] <= 32'h00000000;
		Registers[5] <= 32'h00000000;
		Registers[6] <= 32'h00000000;
		Registers[7] <= 32'h00000000;
		Registers[8] <= 32'h00000000;
		Registers[9] <= 32'h00000000;
		Registers[10] <= 32'h00000000;
		Registers[11] <= 32'h00000000;
		Registers[12] <= 32'h00000000;
		Registers[13] <= 32'h00000000;
		Registers[14] <= 32'h00000000;
		Registers[15] <= 32'h00000000;
		Registers[16] <= 32'h00000000;
		Registers[17] <= 32'h00000000;
		Registers[18] <= 32'h00000000;
		Registers[19] <= 32'h00000000;
		Registers[20] <= 32'h00000000;
		Registers[21] <= 32'h00000000;
		Registers[22] <= 32'h00000000;
		Registers[23] <= 32'h00000000;
		Registers[24] <= 32'h00000000;
		Registers[25] <= 32'h00000000;
		Registers[29] <= 32'h00000200;
		Registers[30] <= 32'h00000000;
		Registers[31] <= 32'h00000000;
	end


	always @(*) begin
		if (WE3 == 1) begin
			if (A3 != 0) begin
				Registers[A3] <= WD3;
			end
		end
		RD1 <= Registers[A1];
		RD2 <= Registers[A2];
	end



endmodule