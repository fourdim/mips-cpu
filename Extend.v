module ExtendUnit_16bit(in, sel, out);


    input [15:0] in;
    input sel;
    output [31:0] out;

	reg [31:0] out;


    always @(in, sel) begin
		if (!sel && (in[15]==1)) begin
			out <= {16'hffff, in};
		end else begin
			out <= in;
		end
	end

endmodule

module JumpTargetExtend_26bit(in, PCPrefix, out);


    input   [25:0] in;
	input [5:0] PCPrefix;
    output  [31:0] out;
    wire  [31:0] out;

	assign out = {PCPrefix, in};

endmodule