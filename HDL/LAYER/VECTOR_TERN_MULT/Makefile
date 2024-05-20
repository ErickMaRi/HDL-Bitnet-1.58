# Verilog source files
VERILOG_SOURCES = tern_mult.v DEMUXERS/demuxers.v TWOS/twos.v ADDER/adder.v

# Testbench source files
TESTBENCH_SOURCES = tern_mult_tb.v

# Simulation parameters
SIM_TIME = 100ns

# Simulation commands
SIMULATOR = verilator
SIMULATOR_FLAGS = --cc --unroll-count 500000 --trace --exe
SIMULATOR_EXECUTABLE = ./obj_dir/Vtern_mult_tb

# Waveform viewer command
WAVEFORM_VIEWER = gtkwave

# Synthesis commands with Yosys
YOSYS = yosys

# Default target
all: compile simulate synthesize test waveforms

# Compile Verilog files
compile:
	$(SIMULATOR) $(SIMULATOR_FLAGS) --top-module vector_ternary_multiplication_tb $(VERILOG_SOURCES) $(TESTBENCH_SOURCES)

# Run simulation with original code
simulate: compile
	$(SIMULATOR_EXECUTABLE)

# Synthesize with Yosys
synthesize:
	echo "read_verilog $(VERILOG_SOURCES); hierarchy -top vector_ternary_multiplication; proc; opt; fsm; opt; memory; opt; techmap; opt; abc -g NAND; flatten; write_verilog synth_tern_mult.v" | $(YOSYS)

# Test synthesized design
test: synthesize
	$(SIMULATOR) $(SIMULATOR_FLAGS) --top-module vector_ternary_multiplication_tb synth_tern_mult.v $(TESTBENCH_SOURCES)
	$(SIMULATOR_EXECUTABLE)

# View waveforms
waveforms:
	$(WAVEFORM_VIEWER) tern_mult_tb.vcd

# Clean generated files
clean:
	rm -rf obj_dir tern_mult_tb.vcd synth_tern_mult.v