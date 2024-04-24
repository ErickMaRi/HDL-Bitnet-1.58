# Makefile for compiling, simulating and synthesizing Verilog files

# Verilog source files
VERILOG_SOURCES = demuxers.v

# Testbench source files
TESTBENCH_SOURCES = demuxers_tb.v

# Simulation parameters
SIM_TIME = 1s

# Simulation commands
SIMULATOR = iverilog
SIMULATOR_FLAGS = -v -g2012 -o
SIMULATOR_EXECUTABLE = sim

# Commands for viewing simulation output
WAVEFORM_VIEWER = gtkwave

# Yosys synthesis commands
YOSYS = yosys

# Default target
all: compile simulate synthesize

# Compile Verilog files
compile:
	$(SIMULATOR) $(SIMULATOR_FLAGS) $(SIMULATOR_EXECUTABLE) $(VERILOG_SOURCES) $(TESTBENCH_SOURCES)

# Run simulation
simulate:
	./$(SIMULATOR_EXECUTABLE)

# View waveforms
waveforms:
	$(WAVEFORM_VIEWER) $(SIMULATOR_EXECUTABLE).vcd

# Synthesize with Yosys
synthesize:
	echo "read_verilog $(VERILOG_SOURCES); hierarchy -top adder; proc; opt; fsm; opt; memory; opt; techmap; opt; abc -g AND; flatten; write_verilog synth_demuxers.v" | $(YOSYS)

# Clean generated files
clean:
	rm -f $(SIMULATOR_EXECUTABLE) $(SIMULATOR_EXECUTABLE).vcd _.vvp_ .vcd _.log synth_demuxers.v