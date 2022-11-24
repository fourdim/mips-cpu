
// adder for program counter
module PCAdder (PCF, PCPlus4F);
    input [31:0] PCF;
    output [31:0] PCPlus4F;
    assign PCPlus4F = PCF + 1;
endmodule

// simple adder: used in beq and bne to calculate the branch offset
module Adder_32bit (In1, In2, Out);
    input [31:0] In1, In2;
    output [31:0] Out;
    assign Out = In1 + In2;
endmodule
