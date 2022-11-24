
module PipeLineRegF (Clk, EN, PC, PCF);
    input Clk, EN;
    input [31:0] PC;
    output [31:0] PCF;
    reg[31:0] PCF;
    
    initial begin
        PCF <= 32'b0;
    end

    always @(posedge Clk) begin
        if (EN) begin
            PCF <= PC;
        end
    end

endmodule

module PipeLineRegFD (Clk, EN, JREnd, PCSrcD, Instr, PCPlus4F, InstrD, PCPlus4D, stop, stopImm);
    input [1:0] PCSrcD;
    input Clk, EN, JREnd;
    input [31:0] Instr, PCPlus4F;
    output [31:0] InstrD, PCPlus4D;
    output stop, stopImm;
    reg [31:0] InstrD, PCPlus4D;
    wire CLR;

    assign CLR = PCSrcD != 2'b00;

    reg stop, stop1, stop2, stop3, stop4, stop5, stop6, stop7, stopImm;
    
    initial begin
        stop1 <= 0;
        stop2 <= 0;
        stop3 <= 0;
        stop4 <= 0;
        stop5 <= 0;
        stop6 <= 0;
        stop7 <= 0;
        stop <= 0;
        stopImm <= 0;
    end

    always @(posedge Clk) begin
        stop3 <= stop2;
    end
    always @(negedge Clk) begin
        stop2 <= stop1;
        stop <= stop3;
    end

    always @(posedge Clk) begin
        if (CLR) begin
            if (JREnd || PCSrcD != 2'b11) begin
                InstrD <= 32'hfc000000;
            end
            // $display("%h", Instr);
        end else begin
            if (EN) begin
                InstrD <= Instr;
                PCPlus4D <= PCPlus4F;
            end
            if (Instr == 32'hffffffff) begin
                stop1 <= 1;
                stopImm <= 1;
            end
        end
    end

endmodule

module PipeLineRegDE (Clk, EN, CLR,
 RegWriteD, MemtoRegD, MemWriteD, ALUControlD, ALUSrcD, RegDstD, LinkRaD, ShiftDstD,
 RD1D, RD2D, RsD, RtD, RdD, SignImmD, ShiftAmountD, PCPlus4D, PCSrcD,
 RegWriteE, MemtoRegE, MemWriteE, ALUControlE, ALUSrcE, RegDstE, LinkRaE, ShiftDstE,
 RD1E, RD2E, RsE, RtE, RdE, SignImmE, ShiftAmountE, PCPlus4E, PCSrcE);
    input Clk, EN, CLR, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, RegDstD, LinkRaD, ShiftDstD;
    input [3:0] ALUControlD;
    input [4:0] RsD, RtD, RdD;
    input [31:0] RD1D, RD2D, SignImmD, ShiftAmountD, PCPlus4D;
    input [1:0] PCSrcD;
    output RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE, LinkRaE, ShiftDstE;
    output [3:0] ALUControlE;
    output [4:0] RsE, RtE, RdE;
    output [31:0] RD1E, RD2E, SignImmE, ShiftAmountE, PCPlus4E;
    output [1:0] PCSrcE;
    reg RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, RegDstE, LinkRaE, ShiftDstE;
    reg [3:0] ALUControlE;
    reg [4:0] RsE, RtE, RdE;
    reg [31:0] RD1E, RD2E, SignImmE, ShiftAmountE, PCPlus4E;
    reg [1:0] PCSrcE;

    always @(posedge Clk) begin
        if (CLR) begin
            RegWriteE <= 0;
            MemtoRegE <= 0;
            MemWriteE <= 0;
            ALUSrcE <= 0;
            RegDstE <= 0;
            LinkRaE <= 0;
            ShiftDstE <= 0;
            ALUControlE <= 2;
            RsE <= 0;
            RtE <= 0;
            RdE <= 0;
            RD1E <= 0;
            RD2E <= 0;
            SignImmE <= 0;
            ShiftAmountE <= 0;
            PCPlus4E <= 0;
            PCSrcE <= 0;
        end else begin
            if (EN) begin
                RegWriteE <= RegWriteD;
                MemtoRegE <= MemtoRegD;
                MemWriteE <= MemWriteD;
                ALUSrcE <= ALUSrcD;
                RegDstE <= RegDstD;
                LinkRaE <= LinkRaD;
                ShiftDstE <= ShiftDstD;
                ALUControlE <= ALUControlD;
                RsE <= RsD;
                RtE <= RtD;
                RdE <= RdD;
                RD1E <= RD1D;
                RD2E <= RD2D;
                SignImmE <= SignImmD;
                ShiftAmountE <= ShiftAmountD;
                PCPlus4E <= PCPlus4D;
                PCSrcE <= PCSrcD;
            end
        end
    end
    
endmodule

module PipeLineRegEM (Clk, RegWriteE, MemtoRegE, MemWriteE,
 ALUOutE, WriteDataE, WriteRegE,
 RegWriteM, MemtoRegM, MemWriteM,
 ALUOutM, WriteDataM, WriteRegM);
    input Clk, RegWriteE, MemtoRegE, MemWriteE;
    input [31:0] ALUOutE, WriteDataE;
    input [4:0] WriteRegE;
    output RegWriteM, MemtoRegM, MemWriteM;
    output [31:0] ALUOutM, WriteDataM;
    output [4:0] WriteRegM;
    reg RegWriteM, MemtoRegM, MemWriteM;
    reg [31:0] ALUOutM, WriteDataM;
    reg [4:0] WriteRegM;

    always @(posedge Clk) begin
        RegWriteM <= RegWriteE;
        MemtoRegM <= MemtoRegE;
        MemWriteM <= MemWriteE;
        ALUOutM <= ALUOutE;
        WriteDataM <= WriteDataE;
        WriteRegM <= WriteRegE;
    end
    
endmodule

module PipeLineRegMW (Clk, RegWriteM, MemtoRegM,
 ReadDataM, ALUOutM, WriteRegM,
 RegWriteW, MemtoRegW,
 ReadDataW, ALUOutW, WriteRegW);
    input Clk, RegWriteM, MemtoRegM;
    input [31:0] ReadDataM, ALUOutM;
    input [4:0] WriteRegM;
    output RegWriteW, MemtoRegW;
    output [31:0] ReadDataW, ALUOutW;
    output [4:0] WriteRegW;
    reg RegWriteW, MemtoRegW;
    reg [31:0] ReadDataW, ALUOutW;
    reg [4:0] WriteRegW;

    always @(posedge Clk) begin
        RegWriteW <= RegWriteM;
        MemtoRegW <= MemtoRegM;
        ReadDataW <= ReadDataM;
        ALUOutW <= ALUOutM;
        WriteRegW <= WriteRegM;
    end

endmodule