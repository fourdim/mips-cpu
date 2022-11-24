module ControlUnit (Op, Funct, RegWriteD, MemtoRegD, MemWriteD, BranchD, ALUControlD, ALUSrcD, RegDstD, BeqD, BneD, LinkRaD, JumpTypeD, ShiftDstD, ExtendTypeD);
    input [5:0] Op, Funct;
    output RegWriteD, MemtoRegD, MemWriteD, BranchD, ALUSrcD, RegDstD, BeqD, BneD, LinkRaD, JumpTypeD, ShiftDstD, ExtendTypeD;
    output [3:0] ALUControlD;
    reg RegWriteD, MemtoRegD, MemWriteD, BranchD, ALUSrcD, RegDstD, BeqD, BneD, LinkRaD, JumpTypeD, ShiftDstD, ExtendTypeD;
    reg [3:0] ALUControlD;


    initial begin
        // whether to write to the register file
        RegWriteD <= 0;
        // whether the data is from the main memory
        MemtoRegD <= 0;
        // whether to write the main memory
        MemWriteD <= 0;
        // whether the instruction may need to change the program counter
        BranchD <= 0;
        // ALU Control code
        ALUControlD <= 4'b1110; // nop
        // 0 to use the RD2 from the register file (or the forwarding value), 1 to use the immediate value
        // as the SrcB in ALU
        ALUSrcD <= 0;
        // 0 for Rd, 1 for Rt as the target of register
        RegDstD <= 0;
        // beq instruction is called, does not mean should branch
        BeqD <= 0;
        // bne instruction is called, does not mean should branch
        BneD <= 0;
        // jal is called, make the store the PC in $ra
        LinkRaD <= 0;
        // 0 for j / jal, 1 for jr
        JumpTypeD <= 0;
        // 0 for s**v, 1 for s**
        ShiftDstD <= 0;
        // 0 for sign extend, 1 for zero extend
        ExtendTypeD <= 0;
    end

    always @(Op, Funct) begin
        case (Op)
            // r type
            6'b000000: begin
                case (Funct)
                    // add
                    6'b100000: begin
                        RegWriteD <= 1;
                        MemtoRegD <= 0;
                        MemWriteD <= 0;
                        BranchD <= 0;
                        ALUControlD <= 2;
                        ALUSrcD <= 0;
                        RegDstD <= 1;
                        BeqD <= 0;
                        BneD <= 0;
                        LinkRaD <= 0;
                        JumpTypeD <= 0;
                        ShiftDstD <= 0;
                        ExtendTypeD <= 0;
                    end
                    // addu
                    6'b100001: begin
                        RegWriteD <= 1;
                        MemtoRegD <= 0;
                        MemWriteD <= 0;
                        BranchD <= 0;
                        ALUControlD <= 2;
                        ALUSrcD <= 0;
                        RegDstD <= 1;
                        BeqD <= 0;
                        BneD <= 0;
                        LinkRaD <= 0;
                        JumpTypeD <= 0;
                        ShiftDstD <= 0;
                        ExtendTypeD <= 0;
                    end
                    // sub
                    6'b100010: begin
                        RegWriteD <= 1;
                        MemtoRegD <= 0;
                        MemWriteD <= 0;
                        BranchD <= 0;
                        ALUControlD <= 6;
                        ALUSrcD <= 0;
                        RegDstD <= 1;
                        BeqD <= 0;
                        BneD <= 0;
                        LinkRaD <= 0;
                        JumpTypeD <= 0;
                        ShiftDstD <= 0;
                        ExtendTypeD <= 0;
                    end
                    // subu
                    6'b100011: begin
                        RegWriteD <= 1;
                        MemtoRegD <= 0;
                        MemWriteD <= 0;
                        BranchD <= 0;
                        ALUControlD <= 6;
                        ALUSrcD <= 0;
                        RegDstD <= 1;
                        BeqD <= 0;
                        BneD <= 0;
                        LinkRaD <= 0;
                        JumpTypeD <= 0;
                        ShiftDstD <= 0;
                        ExtendTypeD <= 0;
                    end
                    // and
                    6'b100100: begin
                        RegWriteD <= 1;
                        MemtoRegD <= 0;
                        MemWriteD <= 0;
                        BranchD <= 0;
                        ALUControlD <= 0;
                        ALUSrcD <= 0;
                        RegDstD <= 1;
                        BeqD <= 0;
                        BneD <= 0;
                        LinkRaD <= 0;
                        JumpTypeD <= 0;
                        ShiftDstD <= 0;
                        ExtendTypeD <= 1;
                    end
                    // nor
                    6'b100111: begin
                        RegWriteD <= 1;
                        MemtoRegD <= 0;
                        MemWriteD <= 0;
                        BranchD <= 0;
                        ALUControlD <= 12;
                        ALUSrcD <= 0;
                        RegDstD <= 1;
                        BeqD <= 0;
                        BneD <= 0;
                        LinkRaD <= 0;
                        JumpTypeD <= 0;
                        ShiftDstD <= 0;
                        ExtendTypeD <= 1;
                    end
                    // or
                    6'b100101: begin
                        RegWriteD <= 1;
                        MemtoRegD <= 0;
                        MemWriteD <= 0;
                        BranchD <= 0;
                        ALUControlD <= 1;
                        ALUSrcD <= 0;
                        RegDstD <= 1;
                        BeqD <= 0;
                        BneD <= 0;
                        LinkRaD <= 0;
                        JumpTypeD <= 0;
                        ShiftDstD <= 0;
                        ExtendTypeD <= 1;
                    end
                    // xor
                    6'b100110: begin
                        RegWriteD <= 1;
                        MemtoRegD <= 0;
                        MemWriteD <= 0;
                        BranchD <= 0;
                        ALUControlD <= 4;
                        ALUSrcD <= 0;
                        RegDstD <= 1;
                        BeqD <= 0;
                        BneD <= 0;
                        LinkRaD <= 0;
                        JumpTypeD <= 0;
                        ShiftDstD <= 0;
                        ExtendTypeD <= 1;
                    end
                    // sll
                    6'b000000: begin
                        RegWriteD <= 1;
                        MemtoRegD <= 0;
                        MemWriteD <= 0;
                        BranchD <= 0;
                        ALUControlD <= 10;
                        ALUSrcD <= 0;
                        RegDstD <= 1;
                        BeqD <= 0;
                        BneD <= 0;
                        LinkRaD <= 0;
                        JumpTypeD <= 0;
                        ShiftDstD <= 1;
                        ExtendTypeD <= 0;
                    end
                    // sllv
                    6'b000100: begin
                        RegWriteD <= 1;
                        MemtoRegD <= 0;
                        MemWriteD <= 0;
                        BranchD <= 0;
                        ALUControlD <= 10;
                        ALUSrcD <= 0;
                        RegDstD <= 1;
                        BeqD <= 0;
                        BneD <= 0;
                        LinkRaD <= 0;
                        JumpTypeD <= 0;
                        ShiftDstD <= 0;
                        ExtendTypeD <= 0;
                    end
                    // srl
                    6'b000010: begin
                        RegWriteD <= 1;
                        MemtoRegD <= 0;
                        MemWriteD <= 0;
                        BranchD <= 0;
                        ALUControlD <= 13;
                        ALUSrcD <= 0;
                        RegDstD <= 1;
                        BeqD <= 0;
                        BneD <= 0;
                        LinkRaD <= 0;
                        JumpTypeD <= 0;
                        ShiftDstD <= 1;
                        ExtendTypeD <= 0;
                    end
                    // srlv
                    6'b000110: begin
                        RegWriteD <= 1;
                        MemtoRegD <= 0;
                        MemWriteD <= 0;
                        BranchD <= 0;
                        ALUControlD <= 13;
                        ALUSrcD <= 0;
                        RegDstD <= 1;
                        BeqD <= 0;
                        BneD <= 0;
                        LinkRaD <= 0;
                        JumpTypeD <= 0;
                        ShiftDstD <= 0;
                        ExtendTypeD <= 0;
                    end
                    // sra
                    6'b000011: begin
                        RegWriteD <= 1;
                        MemtoRegD <= 0;
                        MemWriteD <= 0;
                        BranchD <= 0;
                        ALUControlD <= 15;
                        ALUSrcD <= 0;
                        RegDstD <= 1;
                        BeqD <= 0;
                        BneD <= 0;
                        LinkRaD <= 0;
                        JumpTypeD <= 0;
                        ShiftDstD <= 1;
                        ExtendTypeD <= 0;
                    end
                    // srav
                    6'b000111: begin
                        RegWriteD <= 1;
                        MemtoRegD <= 0;
                        MemWriteD <= 0;
                        BranchD <= 0;
                        ALUControlD <= 15;
                        ALUSrcD <= 0;
                        RegDstD <= 1;
                        BeqD <= 0;
                        BneD <= 0;
                        LinkRaD <= 0;
                        JumpTypeD <= 0;
                        ShiftDstD <= 0;
                        ExtendTypeD <= 0;
                    end
                    // slt
                    6'b101010: begin
                        RegWriteD <= 1;
                        MemtoRegD <= 0;
                        MemWriteD <= 0;
                        BranchD <= 0;
                        ALUControlD <= 7;
                        ALUSrcD <= 0;
                        RegDstD <= 1;
                        BeqD <= 0;
                        BneD <= 0;
                        LinkRaD <= 0;
                        JumpTypeD <= 0;
                        ShiftDstD <= 0;
                        ExtendTypeD <= 0;
                    end
                    // jr
                    6'b001000: begin
                        RegWriteD <= 0;
                        MemtoRegD <= 0;
                        MemWriteD <= 0;
                        BranchD <= 1;
                        ALUControlD <= 2;
                        ALUSrcD <= 0;
                        RegDstD <= 1;
                        BeqD <= 0;
                        BneD <= 0;
                        LinkRaD <= 0;
                        JumpTypeD <= 1;
                        ShiftDstD <= 0;
                        ExtendTypeD <= 0;
                    end
                endcase
            end
            // i type
            // addi
            6'b001000: begin
                RegWriteD <= 1;
                MemtoRegD <= 0;
                MemWriteD <= 0;
                BranchD <= 0;
                ALUControlD <= 2;
                ALUSrcD <= 1;
                RegDstD <= 0;
                BeqD <= 0;
                BneD <= 0;
                LinkRaD <= 0;
                JumpTypeD <= 0;
                ShiftDstD <= 0;
                ExtendTypeD <= 0;
            end
            // addiu
            6'b001001: begin
                RegWriteD <= 1;
                MemtoRegD <= 0;
                MemWriteD <= 0;
                BranchD <= 0;
                ALUControlD <= 2;
                ALUSrcD <= 1;
                RegDstD <= 0;
                BeqD <= 0;
                BneD <= 0;
                LinkRaD <= 0;
                JumpTypeD <= 0;
                ShiftDstD <= 0;
                ExtendTypeD <= 0;
            end
            // andi
            6'b001100: begin
                RegWriteD <= 1;
                MemtoRegD <= 0;
                MemWriteD <= 0;
                BranchD <= 0;
                ALUControlD <= 0;
                ALUSrcD <= 1;
                RegDstD <= 0;
                BeqD <= 0;
                BneD <= 0;
                LinkRaD <= 0;
                JumpTypeD <= 0;
                ShiftDstD <= 0;
                ExtendTypeD <= 1;
            end
            // ori
            6'b001101: begin
                RegWriteD <= 1;
                MemtoRegD <= 0;
                MemWriteD <= 0;
                BranchD <= 0;
                ALUControlD <= 1;
                ALUSrcD <= 1;
                RegDstD <= 0;
                BeqD <= 0;
                BneD <= 0;
                LinkRaD <= 0;
                JumpTypeD <= 0;
                ShiftDstD <= 0;
                ExtendTypeD <= 1;
            end
            // xori
            6'b001110: begin
                RegWriteD <= 1;
                MemtoRegD <= 0;
                MemWriteD <= 0;
                BranchD <= 0;
                ALUControlD <= 4;
                ALUSrcD <= 1;
                RegDstD <= 0;
                BeqD <= 0;
                BneD <= 0;
                LinkRaD <= 0;
                JumpTypeD <= 0;
                ShiftDstD <= 0;
                ExtendTypeD <= 1;
            end
            // lw
            6'b100011: begin
                RegWriteD <= 1;
                MemtoRegD <= 1;
                MemWriteD <= 0;
                BranchD <= 0;
                ALUControlD <= 2;
                ALUSrcD <= 1;
                RegDstD <= 0;
                BeqD <= 0;
                BneD <= 0;
                LinkRaD <= 0;
                JumpTypeD <= 0;
                ShiftDstD <= 0;
                ExtendTypeD <= 0;
            end
            // sw
            6'b101011: begin
                RegWriteD <= 0;
                MemtoRegD <= 0;
                MemWriteD <= 1;
                BranchD <= 0;
                ALUControlD <= 2;
                ALUSrcD <= 1;
                RegDstD <= 0;
                BeqD <= 0;
                BneD <= 0;
                LinkRaD <= 0;
                JumpTypeD <= 0;
                ShiftDstD <= 0;
                ExtendTypeD <= 0;
            end
            // beq
            6'b000100: begin
                RegWriteD <= 0;
                MemtoRegD <= 0;
                MemWriteD <= 0;
                BranchD <= 1;
                ALUControlD <= 6;
                ALUSrcD <= 1;
                RegDstD <= 0;
                BeqD <= 1;
                BneD <= 0;
                LinkRaD <= 0;
                JumpTypeD <= 0;
                ShiftDstD <= 0;
                ExtendTypeD <= 0;
            end
            // bne
            6'b000101: begin
                RegWriteD <= 0;
                MemtoRegD <= 0;
                MemWriteD <= 0;
                BranchD <= 1;
                ALUControlD <= 6;
                ALUSrcD <= 1;
                RegDstD <= 0;
                BeqD <= 0;
                BneD <= 1;
                LinkRaD <= 0;
                JumpTypeD <= 0;
                ShiftDstD <= 0;
                ExtendTypeD <= 0;
            end
            // j type
            // j
            6'b000010: begin
                RegWriteD <= 0;
                MemtoRegD <= 0;
                MemWriteD <= 0;
                BranchD <= 1;
                ALUControlD <= 0;
                ALUSrcD <= 1;
                RegDstD <= 0;
                BeqD <= 0;
                BneD <= 0;
                LinkRaD <= 0;
                JumpTypeD <= 0;
                ShiftDstD <= 0;
                ExtendTypeD <= 0;
            end
            // jal
            6'b000011: begin
                RegWriteD <= 1;
                MemtoRegD <= 0;
                MemWriteD <= 0;
                BranchD <= 1;
                ALUControlD <= 0;
                ALUSrcD <= 1;
                RegDstD <= 0;
                BeqD <= 0;
                BneD <= 0;
                LinkRaD <= 1;
                JumpTypeD <= 0;
                ShiftDstD <= 0;
                ExtendTypeD <= 0;
            end
            // reset and nop
            6'b111111: begin
                RegWriteD <= 0;
                MemtoRegD <= 0;
                MemWriteD <= 0;
                BranchD <= 0;
                ALUControlD <= 4'b1110; // nop
                ALUSrcD <= 0;
                RegDstD <= 0;
                BeqD <= 0;
                BneD <= 0;
                LinkRaD <= 0;
                JumpTypeD <= 0;
                ShiftDstD <= 0;
                ExtendTypeD <= 0;
            end
        endcase
    end
endmodule