IVERILOGBASE=${CURDIR}
MAKEFLAGS += --silent

all: build

build:
	@echo [Build] Building the project...
	iverilog -o ./cpu ./test_CPU.v
	@echo [Build] The generated file cpu is available at $(IVERILOGBASE)/cpu

run:
	@echo [Run] Running...
	vvp ./cpu

clean:
	@echo [Clean] Cleaning...
	rm $(IVERILOGBASE)/cpu $(IVERILOGBASE)/output.txt $(IVERILOGBASE)/instructions.bin
	@echo [Clean] Done

test:
	@echo [INFO] The provided tests are all passed on my computer, if there is something wrong when you are running this test, check whether the output.txt is in the CRLF mode.
	@echo [Build] Building the project...
	iverilog -o ./cpu ./test_CPU.v
	@echo [Build] The generated file cpu is available at $(IVERILOGBASE)/cpu
	@echo [Test] Test1
	cp ./cpu_test/machine_code1.txt ./instructions.bin
	@echo [Run] Running...
	vvp ./cpu
	diff ./output.txt ./cpu_test/DATA_RAM1.txt
	@echo [Test] Test2
	cp ./cpu_test/machine_code2.txt ./instructions.bin
	@echo [Run] Running...
	vvp ./cpu
	diff ./output.txt ./cpu_test/DATA_RAM2.txt
	@echo [Test] Test3
	cp ./cpu_test/machine_code3.txt ./instructions.bin
	@echo [Run] Running...
	vvp ./cpu
	diff ./output.txt ./cpu_test/DATA_RAM3.txt
	@echo [Test] Test4
	cp ./cpu_test/machine_code4.txt ./instructions.bin
	@echo [Run] Running...
	vvp ./cpu
	diff ./output.txt ./cpu_test/DATA_RAM4.txt
	@echo [Test] Test5
	cp ./cpu_test/machine_code5.txt ./instructions.bin
	@echo [Run] Running...
	vvp ./cpu
	diff ./output.txt ./cpu_test/DATA_RAM5.txt
	@echo [Test] Test6
	cp ./cpu_test/machine_code6.txt ./instructions.bin
	@echo [Run] Running...
	vvp ./cpu
	diff ./output.txt ./cpu_test/DATA_RAM6.txt
	@echo [Test] Test7
	cp ./cpu_test/machine_code7.txt ./instructions.bin
	@echo [Run] Running...
	vvp ./cpu
	diff ./output.txt ./cpu_test/DATA_RAM7.txt
	@echo [Test] Test8
	cp ./cpu_test/machine_code8.txt ./instructions.bin
	@echo [Run] Running...
	vvp ./cpu
	diff ./output.txt ./cpu_test/DATA_RAM8.txt
	@echo [Test] Tests complete with no error.

help:
	@echo The following are some of the valid targets for this Makefile:
	@echo ... all [the default if no target is provided]
	@echo ... build
	@echo ... run
	@echo ... clean
	@echo ... test