# Register Controller Functional Coverage Verification

## Project Overview

This project implements a comprehensive SystemVerilog testbench for verifying a black-box register controller with accumulate functionality using constraint-random testing (CRT) and functional coverage analysis. The DUT features an accumulate mode that can perform either addition or multiplication operations on register values.



## Design Under Test (DUT)

The register controller module includes the following key features:

```systemverilog
module reg_ctrl (
    input clk,
    input rstn,
    input [7:0] addr,    // 8-bit address
    input sel,           // Select signal
    input wr,            // Write enable (1=write, 0=read)
    input acc,           // Accumulate enable
    input func,          // Function select (0=add, 1=multiply)
    input [23:0] wdata,  // 24-bit write data
    output reg [23:0] rdata,  // 24-bit read data
    output reg ready     // Ready signal
);
```

**Control Logic**:
- `wr=1`: Write operation
- `wr=0`: Read operation  
- `acc=1`: Enable accumulate mode
- `func=0`: Accumulate addition (when acc=1)
- `func=1`: Accumulate multiplication (when acc=1)

## Testbench Architecture

The verification environment implements a layered testbench architecture with the following components:

### Core Components
- **Transaction Object** (`reg_item`): Randomized transaction class with constraints
- **Generator**: Creates randomized stimulus transactions
- **Driver**: Drives transactions to the DUT interface
- **Monitor**: Observes DUT responses and captures transactions
- **Scoreboard**: Reference model for checking expected vs actual behavior
- **Coverage Collector**: Functional coverage analysis with covergroups
- **Environment**: Top-level container coordinating all components

### Key Features
- Constraint-random stimulus generation
- Functional coverage with cross-coverage analysis
- Mailbox-based communication between components
- Comprehensive transaction monitoring and verification

## Bugs Discovered

Through functional coverage-driven testing, several critical bugs were identified:

### Bug 1: Accumulate Multiply on Read Operations
**Configuration**: `acc=1`, `func=1`, `wr=0`  
**Expected Behavior**: Read current value from address  
**Actual Behavior**: Performs multiplication accumulation during read operation  
**Impact**: Data corruption on read operations when accumulate multiply is enabled

### Bug 2: Accumulate Add on Read Operations  
**Configuration**: `acc=1`, `func=0`, `wr=0`  
**Expected Behavior**: Read current value from address  
**Actual Behavior**: Performs addition accumulation during read operation  
**Impact**: Data corruption on read operations when accumulate add is enabled

### Bug 3: Intermittent Sum Corruption
**Observation**: Occasional incorrect behavior where written data equals `rdata + wdata`  
**Frequency**: Infrequent but reproducible during long test runs  
**Impact**: Potential timing or control logic issue causing data integrity problems

### Working Configuration
**Configuration**: `acc=0` (any `func`, `wr` values)  
**Behavior**: Correct operation for all basic read/write operations

## Functional Coverage Strategy

The coverage model targets the following scenarios:

### Primary Coverpoints
- Address distribution (low, mid, high ranges)
- Write data value ranges
- Read data verification  
- Write/Read operation coverage
- Accumulate mode coverage
- Function selection coverage

### Cross Coverage
- Address × Operation type
- Accumulate mode × Function selection
- Data ranges × Operation combinations

### Coverage Goals
- Achieve 100% functional coverage using pseudo-random testing
- Identify corner cases and rare scenarios
- Quantify stimulus quality and completeness

## Usage

Navigate to the `scripts` directory and use the following make commands:
```bash
cd scripts
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

## Results and Reports

### Coverage Reports
Coverage reports are generated in `results/coverage/` directory:
- `dashboard.html`: Main coverage dashboard
- `hierarchy.html`: Coverage hierarchy view
- `groups.html`: Functional coverage groups analysis

### Simulation Logs
Simulation logs are stored in `results/logs/`:
- `simulation.log`: Main simulation output
- `compile.log`: Compilation messages
- `build.log`: Build process log

### Coverage Analysis Tools
- **DVE GUI**: Interactive coverage analysis and debugging
- **Browser Reports**: HTML-based coverage metrics and analysis
- **VCD Files**: Waveform analysis for debugging

## Project Structure

```
dv_assignment/
├── docs/           # Documentation and images
├── dut/            # Contains Black box files (not used)
├── funct_cov/      # Contains Black box files
├── results/        # Simulation and coverage results
├── scripts/        # Build and run scripts
├── tb/             # Testbench components
└── tests/          # Test registry with 1000 transactions
```
