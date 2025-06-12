class test;
    env e0;

    function new();
        e0 = new();
    endfunction

    virtual task run();
        // Set configuration for comprehensive coverage
        TestRegistry::set_int("NoOfTransactions", 2000);  // More transactions for coverage

        // Start environment (which includes generator now)
        $display("T=%0t [Test] Environment started ...", $time);
        fork
            e0.run();
        join_none

        // Wait a bit for coverage collection
        #1000;

        
        // Report final coverage
        $display("T=%0t [Test] Reporting coverage ...", $time);
        e0.report_coverage();
    endtask
endclass