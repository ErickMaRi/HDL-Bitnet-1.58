# Verilog source files
VERILOG_SOURCES = tern_mult.v ADDER/adder.v TWOS/twos.v

# Simulation parameters
SIM_TIME = 100ns

# Simulation commands
SIMULATOR = verilator
SIMULATOR_FLAGS = --debug --gdbbt --unroll-count 4096 -cc -sv -o obj_dir/Vtern_mult

SIMULATOR_EXECUTABLE = ./obj_dir/Vtern_mult

# Waveform viewer command
WAVEFORM_VIEWER = gtkwave

# Default target
all: compile simulate

# Compile Verilog files
compile:
	$(SIMULATOR) $(VERILOG_SOURCES) $(SIMULATOR_FLAGS)

# Run simulation
simulate: compile
	./obj_dir/Vtern_mult

# View waveforms
waveforms:
	$(WAVEFORM_VIEWER) sim.vcd

# Clean generated files
clean:
	rm -rf obj_dir sim.vcd
