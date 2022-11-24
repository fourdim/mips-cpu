

module ALU (ALUControl, SrcAE, SrcBE, ALUOut);
    input [3:0] ALUControl;
    input signed [31:0] SrcAE, SrcBE;
    output [31:0] ALUOut;
    reg signed [31:0] ALUOut;

    always @(ALUControl, SrcAE, SrcBE) begin
        case (ALUControl)
            // and
            4'b0000: begin
                ALUOut <= SrcAE & SrcBE;
            end
            // or
            4'b0001: begin
                ALUOut <= SrcAE | SrcBE;
            end
            // add
            4'b0010: begin
                ALUOut <= SrcAE + SrcBE;
            end
            // sub
            4'b0110: begin
                ALUOut <= SrcAE - SrcBE;
            end
            // slt
            4'b0111: begin
                if (SrcAE[31] != SrcBE[31]) begin
					if (SrcAE[31] > SrcBE[31]) begin
						ALUOut <= 1;
					end else begin
						ALUOut <= 0;
					end
				end else begin
					if (SrcAE < SrcBE) begin
						ALUOut <= 1;
					end else begin
						ALUOut <= 0;
					end
				end
            end
            // nor
            4'b1100: begin
                ALUOut <= ~(SrcAE | SrcBE);
            end
            // xor
            4'b0100: begin
                ALUOut <= SrcAE ^ SrcBE;
            end
            // sll
            4'b1010: begin
                ALUOut <= SrcBE << SrcAE[4:0];
            end
            // srl
            4'b1101: begin
                ALUOut <= SrcBE >> SrcAE[4:0];
            end
            // sra
            4'b1111: begin
                ALUOut <= SrcBE >>> SrcAE[4:0];
            end
        endcase
    end
endmodule