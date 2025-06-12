# Makefile for Register Controller Testbench
# Usage: make compile, make sim, make run, make clean

# Directories
TB_DIR = ../tb
TEST_DIR = ../tests
RESULTS_DIR = ../results
LOG_DIR = $(RESULTS_DIR)/logs
COV_DIR = $(RESULTS_DIR)/coverage
DELIVERY_DIR = ../funct_cov/delivery

# Source files
TB_SOURCES = $(TB_DIR)/interface.sv \
             $(TB_DIR)/transaction.sv \
             $(TB_DIR)/test_registry.sv \
             $(TB_DIR)/driver.sv \
             $(TB_DIR)/monitor.sv \
             $(TB_DIR)/scoreboard.sv \
             $(TB_DIR)/coverage.sv \
             $(TB_DIR)/generator.sv \
             $(TB_DIR)/enviroment.sv \
             $(TEST_DIR)/basic_test.sv \
             $(TB_DIR)/reg_ctrl_tb.sv

# Simulation executable
SIMV = simv

# Default target
all: compile

# Compile target
compile: $(SIMV)

$(SIMV): $(TB_SOURCES)
	@echo "Compiling testbench with precompiled DUT..."
	@mkdir -p $(LOG_DIR)
	@echo "Linking with precompiled DUT from delivery folder..."
	cd $(DELIVERY_DIR) && vlogan -sverilog ../../tb/interface.sv ../../tb/transaction.sv ../../tb/test_registry.sv ../../tb/driver.sv ../../tb/monitor.sv ../../tb/scoreboard.sv ../../tb/coverage.sv ../../tb/generator.sv ../../tb/enviroment.sv ../../tests/basic_test.sv ../../tb/reg_ctrl_tb.sv -l ../../results/logs/compile.log
	cd $(DELIVERY_DIR) && vcs -debug_access+all -full64 +vcs+vcdpluson tb -l ../../results/logs/build.log
	@echo "Compilation completed!"
	@touch $(SIMV)  # Create a timestamp file to track compilation

# Simulation target
sim: $(SIMV)
	@echo "Running simulation..."
	@mkdir -p $(LOG_DIR) $(COV_DIR)
	@echo "Running simulation from delivery directory..."
	cd $(DELIVERY_DIR) && ./simv +vcs+vcdpluson -l ../../results/logs/simulation.log +vcdfile=../../results/logs/dump.vcd
	@echo "Simulation completed!"

# Run everything
run: compile sim

# Coverage compilation target
compile-cov: 
	@echo "Compiling testbench with coverage enabled..."
	@mkdir -p $(LOG_DIR)
	@echo "Linking with precompiled DUT from delivery folder..."
	cd $(DELIVERY_DIR) && vlogan -sverilog ../../tb/interface.sv ../../tb/transaction.sv ../../tb/test_registry.sv ../../tb/driver.sv ../../tb/coverage.sv ../../tb/monitor.sv ../../tb/scoreboard.sv ../../tb/generator.sv ../../tb/enviroment.sv ../../tests/basic_test.sv ../../tb/reg_ctrl_tb.sv -l ../../results/logs/compile_cov.log
	cd $(DELIVERY_DIR) && vcs -full64 -licqueue -timescale=1ns/1ns +vcs+flush+all +warn=all -sverilog -debug_access+all +vcs+vcdpluson -cm line+cond+fsm+branch+tgl tb -l ../../results/logs/build_cov.log
	@echo "Coverage compilation completed!"

# Coverage simulation target
sim-cov:
	@echo "Running simulation with coverage..."
	@mkdir -p $(LOG_DIR) $(COV_DIR)
	@echo "Running coverage simulation from delivery directory..."
	cd $(DELIVERY_DIR) && ./simv +vcs+vcdpluson -cm line+cond+fsm+branch+tgl -l ../../results/logs/simulation_cov.log +vcdfile=../../results/logs/dump_cov.vcd
	@echo "Coverage simulation completed!"
	@echo "Coverage database available in delivery/simv.vdb"

# View coverage in DVE GUI
view-cov:
	@echo "Opening DVE for coverage viewing..."
	cd $(DELIVERY_DIR) && dve -cov &

# Generate coverage reports (HTML)
cov-report:
	@echo "Generating coverage reports..."
	@mkdir -p $(COV_DIR)
	cd $(DELIVERY_DIR) && urg -dir simv.vdb -report ../../results/coverage
	@echo "Coverage reports generated in results/coverage/"
	@echo "Open results/coverage/dashboard.html in browser to view"

# Generate coverage reports (Text)
cov-report-text:
	@echo "Generating text coverage reports..."
	@mkdir -p $(COV_DIR)
	cd $(DELIVERY_DIR) && urg -dir simv.vdb -format text -report ../../results/coverage
	@echo "Text coverage reports generated in results/coverage/"
	@echo "View with: cat results/coverage/*.txt"

# View coverage reports in browser (Linux)
view-report:
	@echo "Opening coverage report in browser..."
	firefox $(COV_DIR)/dashboard.html &

# Complete coverage flow
cov-flow: compile-cov sim-cov cov-report
	@echo "Complete coverage flow finished!"
	@echo "Coverage reports available in results/coverage/"

# Run coverage and view
run-cov: compile-cov sim-cov view-cov

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(SIMV)* csrc DVEfiles AN.DB *.log *.vcd *.vpd simv.daidir
	@echo "Clean completed!"

# Clean everything including results
clean-all: clean
	rm -rf $(RESULTS_DIR)/*
	@echo "Full clean completed!"

# Help
help:
	@echo "Available targets:"
	@echo "  compile        - Compile the testbench"
	@echo "  sim            - Run simulation"
	@echo "  run            - Compile and simulate"
	@echo ""
	@echo "Coverage targets:"
	@echo "  compile-cov    - Compile with coverage enabled"
	@echo "  sim-cov        - Run simulation with coverage"
	@echo "  view-cov       - Open DVE for coverage viewing"
	@echo "  cov-report     - Generate HTML coverage reports"
	@echo "  cov-report-text- Generate text coverage reports"
	@echo "  view-report    - Open coverage report in browser"
	@echo "  cov-flow       - Complete coverage flow (compile+sim+report)"
	@echo "  run-cov        - Run coverage and open DVE"
	@echo ""
	@echo "Utility targets:"
	@echo "  clean          - Clean build artifacts"
	@echo "  clean-all      - Clean everything including results"
	@echo "  help           - Show this help message"

.PHONY: all compile sim run compile-cov sim-cov view-cov cov-report cov-report-text view-report cov-flow run-cov clean clean-all help
