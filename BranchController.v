module BranchController (BranchD, BeqD, BneD, Src1, Src2, JumpTypeD, PCSrcD);
    input BranchD, BeqD, BneD, JumpTypeD;
    input [31:0] Src1, Src2;
    output [1:0] PCSrcD;
    reg [1:0] PCSrcD;
    wire EqualD;
    initial begin
        PCSrcD <= 2'b00;
    end
    
    always @(*) begin
        // jr
        if (BranchD && (!BeqD) && (!BneD) && JumpTypeD) begin
            PCSrcD <= 2'b11;
        // j / jal
        end else if (BranchD && (!BeqD) && (!BneD) && (!JumpTypeD)) begin
            PCSrcD <= 2'b10;
        // beq
        end else if (BranchD && BeqD && (!BneD) && (Src1 == Src2)) begin
            PCSrcD <= 2'b01;
        // bne
        end else if (BranchD && (!BeqD) && BneD && (Src1 != Src2)) begin
            PCSrcD <= 2'b01;
        // default
        end else begin
            PCSrcD <= 2'b00;
        end
    end

endmodule
