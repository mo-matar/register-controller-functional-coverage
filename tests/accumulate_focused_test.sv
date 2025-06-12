class accumulate_focused_test;
    env e0;

    function new();
        e0 = new();
    endfunction

    virtual task run();
        $display("========================================");
        $display("  ACCUMULATE FOCUSED DEBUG TEST");
        $display("========================================");
        
        // Configure for focused accumulate testing
        TestRegistry::set_int("NoOfTransactions", 500);  // Smaller number for focused testing
        
        $display("Debug Test Configuration:");
        $display("- Purpose: Debug accumulate operation generation and processing");
        $display("- Method: High percentage accumulate operations");
        $display("- Transactions: %0d", TestRegistry::get_int("NoOfTransactions"));

        // Start environment with enhanced debugging
        fork
            e0.run();
        join_none

        // Shorter simulation time for focused testing
        #20000;
        
        // Final reports
        $display("\n========================================");
        $display("      ACCUMULATE DEBUG TEST SUMMARY");
        $display("========================================");
        e0.report_coverage();
        $display("========================================\n");
        
        // Final coverage report
        $display("Final Coverage Report:");
        $display("Coverage Goal: Focus on accumulate operations");
        if (e0.s0.accumulate_add_count > 0 || e0.s0.accumulate_mult_count > 0) begin
            $display("SUCCESS: Accumulate operations detected!");
            $display("- Accumulate Adds: %0d", e0.s0.accumulate_add_count);
            $display("- Accumulate Multiplies: %0d", e0.s0.accumulate_mult_count);
        end else begin
            $error("FAILURE: No accumulate operations detected in debug test!");
        end
        
        $finish;
    endtask
endclass

// Test instantiation
module accumulate_debug_tb;
    accumulate_focused_test t0;
    reg_if _if(clk, rstn);
    
    reg clk;
    reg rstn;

    // Connect to DUT (same as original)
    reg_ctrl u0 (
        .clk(clk),
        .rstn(rstn),
        .addr(_if.addr),
        .sel(_if.sel),
        .wr(_if.wr),
        .acc(_if.acc),
        .func(_if.func),
        .wdata(_if.wdata),
        .rdata(_if.rdata),
        .ready(_if.ready)
    );

    always #10 clk = ~clk;

    initial begin
        {clk, rstn} <= 0;
        repeat(2) @(posedge clk);
        rstn <= 1;
        
        t0 = new;
        t0.e0.vif = _if;
        t0.run();
    end

    initial begin
        $dumpvars;
        #30000;
        $display("Timeout reached in accumulate debug test");
        $finish;
    end
endmodule
