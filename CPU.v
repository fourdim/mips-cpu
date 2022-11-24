`include "Adder.v"
`include "ALU.v"
`include "BranchController.v"
`include "ControlUnit.v"
`include "HazardUnit.v"
`include "InstructionRAM.v"
`include "MainMemory.v"
`include "Mux.v"
`include "PipelineReg.v"
`include "RegisterFile.v"
`include "Extend.v"

// this module connects all the submodules
module CPU (Clk, stop);
    input Clk;
    output stop;
    wire Clk, stop, stopImm;

    // hazard unit series
    wire StallF, StallD, StallE;
    wire FlushE;
    wire ForwardAD, ForwardBD;
    wire [1:0] ForwardAE, ForwardBE;
    // PC series
    wire [31:0] PC, PCF, PCPlus4F, PCBranchD, PCPlus4D, PCPlus4E;
    wire [31:0] TargetImmD;
    wire [31:0] JRTarget;
    // Control series
    wire [1:0] PCSrcD, PCSrcE;
    // Instruction series
    wire [31:0] Instr, InstrD;
    wire [4:0] RsD, RtD, RdD;
    wire [4:0] RsE, RtE, RdE;
    // Reg series
    wire [4:0] A1, A2;
    wire [4:0] WriteRegMid, WriteRegE, WriteRegM, WriteRegW;
    wire [31:0] RD1, RD2;
    wire [31:0] RD1D, RD2D;
    wire [31:0] RD1E, RD2E;
    // control unit series
    wire [5:0] Op, Funct;
    wire RegWriteD, MemtoRegD, MemWriteD, BranchD, ALUSrcD, RegDstD, BeqD, BneD, LinkRaD, JumpTypeD, ShiftDstD, ExtendTypeD;
    wire RegWriteE, MemtoRegE, MemWriteE, BranchE, ALUSrcE, RegDstE, BeqE, BneE, LinkRaE, JumpTypeE, ShiftDstE;
    wire RegWriteM, MemtoRegM, MemWriteM;
    wire [3:0] ALUControlD, ALUControlE;
    // Extend series
    wire [31:0] SignImmD, SignImmE;
    wire [31:0] ShiftAmountD, ShiftAmountE;
    // ALU series
    wire [31:0] SrcAMidE;
    wire [31:0] SrcAE, SrcBE;
    wire [31:0] ALUOut, ALUOutE, ALUOutM, ALUOutW;
    wire [31:0] ResultW;
    // Memory series
    wire [31:0] WriteDataE, WriteDataM;
    wire [31:0] ReadDataM, ReadDataW;

// IF
    PipeLineRegF program_counter(Clk, !StallF, PC, PCF);
    PCAdder pc_adder(PCF, PCPlus4F);
    Mux2to1_32bit jr_target_mux(RD1D >> 2, ResultW >> 2, RegWriteE && ((RsD == WriteRegE) && (RsD != 0)), JRTarget);
    Mux4to1_32bit pc_mux(PCPlus4F, PCBranchD, TargetImmD, JRTarget, PCSrcD, PC);
    InstructionRAM instruction_ram(Clk, 1'b0, !stopImm, PCF, Instr);
// ID
    PipeLineRegFD pipeline_reg_if_id(Clk, !StallD, JREnd, PCSrcD, Instr, PCPlus4F, InstrD, PCPlus4D, stop, stopImm);
    assign A1 = InstrD[25:21];
    assign A2 = InstrD[20:16];
    RegisterFile register_file(A1, A2, WriteRegW, ResultW, RegWriteW, Clk, RD1, RD2);
    assign Op = InstrD[31:26];
    assign Funct = InstrD[5:0];
    ControlUnit control_unit(Op, Funct, RegWriteD, MemtoRegD, MemWriteD, BranchD, ALUControlD, ALUSrcD, RegDstD, BeqD, BneD, LinkRaD, JumpTypeD, ShiftDstD, ExtendTypeD);
    // check whether sign extend or zero extend
    ExtendUnit_16bit extend_unit_16bit(InstrD[15:0], ExtendTypeD, SignImmD);
    JumpTargetExtend_26bit jump_target_extend_26bit(InstrD[25:0], PCF[31:26], TargetImmD);
    // PC + 4 + offset
    Adder_32bit adder_32bit(SignImmD, PCPlus4D, PCBranchD);
    Mux2to1_32bit forward_a_mux(RD1, ALUOutM, ForwardAD, RD1D);
    Mux2to1_32bit forward_b_mux(RD2, ALUOutM, ForwardBD, RD2D);
    BranchController branch_controller(BranchD, BeqD, BneD, RD1D, RD2D, JumpTypeD, PCSrcD);
    assign RsD = InstrD[25:21];
    assign RtD = InstrD[20:16];
    assign RdD = InstrD[15:11];
    assign ShiftAmountD = {27'b0, InstrD[10:6]};
// EX
    PipeLineRegDE pipeline_reg_id_ex(Clk, !StallE, FlushE,
        RegWriteD, MemtoRegD, MemWriteD, ALUControlD, ALUSrcD, RegDstD, LinkRaD, ShiftDstD,
        RD1D, RD2D, RsD, RtD, RdD, SignImmD, ShiftAmountD, PCPlus4D, PCSrcD,
        RegWriteE, MemtoRegE, MemWriteE, ALUControlE, ALUSrcE, RegDstE, LinkRaE, ShiftDstE,
        RD1E, RD2E, RsE, RtE, RdE, SignImmE, ShiftAmountE, PCPlus4E, PCSrcE);
    // record the register to write
    Mux2to1_5bit reg_dst_mux(RtE, RdE, RegDstE, WriteRegMid);
    // if jal, use 5'b11111 instead
    Mux2to1_5bit reg_link_mux(WriteRegMid, 5'b11111, LinkRaE, WriteRegE);
    // forward unit
    Mux3to1_32bit reg_RD1E_mux(RD1E, ResultW, ALUOutM, ForwardAE, SrcAMidE);
    // if shift amount is presented, use shift amount instead
    Mux2to1_32bit alu_srca_mux(SrcAMidE, ShiftAmountE, ShiftDstE, SrcAE);
    Mux3to1_32bit reg_RD2E_mux(RD2E, ResultW, ALUOutM, ForwardBE, WriteDataE);
    Mux2to1_32bit alu_srcb_mux(WriteDataE, SignImmE, ALUSrcE, SrcBE);
    ALU alu(ALUControlE, SrcAE, SrcBE, ALUOut);
    Mux2to1_32bit alu_out_jal_mux(ALUOut, PCPlus4E << 2, LinkRaE, ALUOutE);
// MEM
    PipeLineRegEM pipeline_reg_ex_mem(Clk, RegWriteE, MemtoRegE, MemWriteE,
        ALUOutE, WriteDataE, WriteRegE,
        RegWriteM, MemtoRegM, MemWriteM,
        ALUOutM, WriteDataM, WriteRegM);
    //                                                     ENABLE     AddrToWrite   DataToWrite
    MainMemory main_memory(Clk, 1'b0, 1'b1, ALUOutM >> 2, {MemWriteM, ALUOutM >> 2, WriteDataM}, ReadDataM);
// WB
    PipeLineRegMW pipeline_reg_mem_wb(Clk, RegWriteM, MemtoRegM,
        ReadDataM, ALUOutM, WriteRegM,
        RegWriteW, MemtoRegW,
        ReadDataW, ALUOutW, WriteRegW);
    Mux2to1_32bit result_mux(ALUOutW, ReadDataW, MemtoRegW, ResultW);
    // Hazard Unit
    HazardUnit hazard_unit(BranchD, PCSrcD, PCSrcE, RsD, RtD, RsE, RtE, MemtoRegE, MemtoRegM, MemtoRegW, RegWriteE, RegWriteM, RegWriteW,
    WriteRegE, WriteRegM, WriteRegW,
    StallF, StallD, StallE, FlushE, JREnd,
    ForwardAD, ForwardBD, ForwardAE, ForwardBE);

endmodule