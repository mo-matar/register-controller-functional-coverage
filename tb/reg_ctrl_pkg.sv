package reg_ctrl_pkg;
    // Include all the testbench components
    `include "transaction.sv"
    `include "test_registry.sv"
    `include "driver.sv"
    `include "coverage.sv" // coverage_collector must be included before monitor.sv
    `include "monitor.sv"
    `include "scoreboard.sv"
    `include "generator.sv"
    `include "enviroment.sv"
endpackage
