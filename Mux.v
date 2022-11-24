
module Mux2to1_32bit (in0, in1, sel, out);
    input [31:0] in0, in1;
    input sel;
    output [31:0] out;
    reg [31:0] out;
    always @(in0, in1, sel) begin
        if (sel == 0) begin
            out <= in0;
        end else begin
            out <= in1;
        end
    end
endmodule

module Mux2to1_5bit (in0, in1, sel, out);
    input [4:0] in0, in1;
    input sel;
    output [4:0] out;
    reg [4:0] out;
    always @(in0, in1, sel) begin
        if (sel == 0) begin
            out <= in0;
        end else begin
            out <= in1;
        end
    end
endmodule

module Mux2to1_1bit (in0, in1, sel, out);
    input in0, in1;
    input sel;
    output out;
    reg out;
    always @(in0, in1, sel) begin
        if (sel == 0) begin
            out <= in0;
        end else begin
            out <= in1;
        end
    end
endmodule

module Mux3to1_32bit (in0, in1, in2, sel, out);
    input [31:0] in0, in1, in2;
    input [1:0] sel;
    output [31:0] out;
    reg [31:0] out;
    always @(in0, in1, in2, sel) begin
        case (sel)
            0: begin
                out <= in0;
            end
            1: begin
                out <= in1;
            end
            2: begin
                out <= in2;
            end
        endcase
    end
endmodule

module Mux4to1_32bit (in0, in1, in2, in3, sel, out);
    input [31:0] in0, in1, in2, in3;
    input [1:0] sel;
    output [31:0] out;
    reg [31:0] out;
    always @(in0, in1, in2, in3, sel) begin
        case (sel)
            0: begin
                out <= in0;
            end
            1: begin
                out <= in1;
            end
            2: begin
                out <= in2;
            end
            3: begin
                out <= in3;
            end
        endcase
    end
endmodule