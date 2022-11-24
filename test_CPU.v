`include "CPU.v"

`timescale 100fs/100fs

module TestCPU ();

    reg Clk;
    wire stop;
    integer i;
    integer j;
    integer f;

    CPU cpu(Clk, stop);

	initial begin
        i = 0;
        // if you need to check the cycles, uncomment the code below.
        // $monitor("%h %d", cpu.InstrD, i);
		#10 Clk <= 1'b0;
        #10 Clk <= ~Clk;
		for (i = 1; !stop; i = i + 1) begin
            if (!stop) begin
                #10 Clk <= ~Clk;
                #10 Clk <= ~Clk;
            end
        end
        #10
        f = $fopen("output.txt","w");
        for (j = 0; j < 512; j = j + 1) begin
            $fwrite(f, "%b\n", cpu.main_memory.DATA_RAM[j]);
        end
	end

endmodule