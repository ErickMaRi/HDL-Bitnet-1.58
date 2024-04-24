# Verilog source files (List all source files)
VERILOG_SOURCES = tern_mult.v tern_mult_tb.v DEMUXERS/demuxers.v TWOS/twos.v ADDER/adder.v

# Simulation parameters
SIM_TIME = 1s

# Simulation commands
SIMULATOR = iverilog
SIMULATOR_FLAGS = -g2012 -o  # Enable debug symbols, output to executable named 'sim'

# Default target
all: compile simulate

# Compile Verilog files with dependency tracking (uses all cores)
compile: $(VERILOG_SOURCES)
	@echo "Compiling Verilog sources:"
	@make -j$(nproc) $^ -C .  # Use all available cores with -j
