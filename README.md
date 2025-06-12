# register-controller-functional-coverage

SystemVerilog testbench for verifying a register control module with accumulate functionality using constraint-random testing and functional coverage.

## Usage

Navigate to the `scripts` directory and use the following make commands:

### Basic Simulation

```bash
cd scripts
make compile        # Compile the testbench
make sim           # Run simulation
make run           # Compile and simulate in one step
```

### Coverage Testing

```bash
make compile-cov   # Compile with coverage enabled
make sim-cov       # Run simulation with coverage collection
make view-cov      # Open DVE GUI for coverage analysis
make cov-report    # Generate HTML coverage reports
make cov-flow      # Complete coverage flow (compile+sim+report)
make run-cov       # Run coverage and open DVE viewer
```

### Utilities

```bash
make clean         # Clean build artifacts
make clean-all     # Clean everything including results
make help          # Show all available targets
```

Coverage reports are generated in `results/coverage/` directory. Open `results/coverage/dashboard.html` in a browser to view detailed coverage metrics.
