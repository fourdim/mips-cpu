
module HazardUnit (BranchD, PCSrcD, PCSrcE, RsD, RtD, RsE, RtE, MemtoRegE, MemtoRegM, MemtoRegW, RegWriteE, RegWriteM, RegWriteW,
    WriteRegE, WriteRegM, WriteRegW,
    StallF, StallD, StallE, FlushE, JREnd,
    ForwardAD, ForwardBD, ForwardAE, ForwardBE);
    input BranchD, MemtoRegE, MemtoRegM, MemtoRegW, RegWriteE, RegWriteM, RegWriteW;
    input [4:0] RsD, RtD, RsE, RtE, WriteRegE, WriteRegM, WriteRegW;
    input [1:0] PCSrcD, PCSrcE;
    output StallF, StallD, StallE, FlushE, JREnd;
    output ForwardAD, ForwardBD;
    output [1:0] ForwardAE, ForwardBE;
    reg StallF, StallD, StallE, FlushE, JREnd;
    reg ForwardAD, ForwardBD;
    reg [1:0] ForwardAE, ForwardBE;
    
    initial begin
        StallD <= 0;
        StallF <= 0;
        StallE <= 0;
        // It means that stall for jr should end
        JREnd <= 1;
        FlushE <= 0;
        ForwardAD <= 0;
        ForwardAE <= 0;
        ForwardBD <= 0;
        ForwardBE <= 0;
    end

    always @(*) begin
        // stall
        // stall for lw
        if (MemtoRegE && (((RsD == RsE) && (RsD != 0)) || ((RtD == RtE) && (RtD != 0)))) begin
            StallF <= 1;
            StallD <= 1;
        // stall for jr after lw 3rd stage
        end else if (MemtoRegW && (((PCSrcD == 2'b11) && (RsD == WriteRegW) && (RsD != 0)))) begin
            StallF <= 0;
            StallD <= 1;
            StallE <= 1;
            JREnd <= 1;
        // stall for jr after lw 2nd stage
        end else if (MemtoRegM && (((PCSrcD == 2'b11) && (RsD == WriteRegM) && (RsD != 0)))) begin
            StallF <= 1;
            StallD <= 1;
            StallE <= 1;
            JREnd <= 0;
        // stall for jr after lw 1st stage
        end else if (MemtoRegE && (((PCSrcD == 2'b11) && (RsD == RtE) && (RsD != 0)))) begin
            StallF <= 1;
            StallD <= 1;
            StallE <= 1;
            JREnd <= 0;
        // stall for normal jr 1st stage
        end else if ((PCSrcD == 2'b11) && (RsD == RtE) && (RsD != 0)) begin
            StallF <= 1;
            StallD <= 1;
            StallE <= 1;
            JREnd <= 0;
        // stall for normal jr 2nd stage
        end else if ((PCSrcD == 2'b11) && (RsD == WriteRegM) && (RsD != 0)) begin
            StallF <= 0;
            StallD <= 1;
            StallE <= 1;
            JREnd <= 1;
        // stall for beq and bne after lw
        end else if (MemtoRegE && ((RsD == WriteRegE) && (RsD != 0))) begin
            StallD <= 1;
        // stall for beq and bne
        end else if (RegWriteE && (PCSrcD == 2'b01) && (((RsD == WriteRegE) && (RsD != 0)) || ((RtD == WriteRegE) && (RtD != 0)))) begin
            StallF <= 1;
            StallD <= 1;
        // no stall
        end else begin
            StallF <= 0;
            StallD <= 0;
            StallE <= 0;
            JREnd <= 1;
        end

        if (PCSrcD == 2'b11) begin
            FlushE <= 1;
        end else begin
            FlushE <= 0;
        end

        // Forward from EX to EX
        if (RegWriteM && (WriteRegM == RsE) && (WriteRegM != 0)) begin
            ForwardAE <= 2'b10;
        // Forward from Mem to EX when lw (MemtoRegW == 1)
        end else if (MemtoRegW && (WriteRegW == RsE) && (WriteRegW != 0)) begin
            ForwardAE <= 2'b01;
        // No forward
        end else begin
            ForwardAE <= 2'b00;
        end

        // Forward from EX to EX
        if (RegWriteM && (WriteRegM == RtE) && (WriteRegM != 0)) begin
            ForwardBE <= 2'b10;
        // Forward from Mem to EX when lw (MemtoRegW == 1)
        end else if (MemtoRegW && (WriteRegW == RtE) && (WriteRegW != 0)) begin
            ForwardBE <= 2'b01;
        // No forward
        end else begin
            ForwardBE <= 2'b00;
        end

        // Forward from EX to ID
        if (RegWriteM && (WriteRegM == RsD) && (WriteRegM != 0)) begin
            ForwardAD <= 1;
        // No forward
        end else begin
            ForwardAD <= 0;
        end

        // Forward from EX to ID
        if (RegWriteM && (WriteRegM == RtD) && (WriteRegM != 0)) begin
            ForwardBD <= 1;
        // No forward
        end else begin
            ForwardBD <= 0;
        end


    end

endmodule