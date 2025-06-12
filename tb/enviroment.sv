class env;
    driver d0;
    monitor m0;
    scoreboard s0;
    generator g0;
    mailbox scb_mbx;
    mailbox drv_mbx;
    virtual reg_if vif;
    coverage_collector cov_collector; // Add coverage collector

    function new();
        drv_mbx = new();
        scb_mbx = new();
        d0 = new;
        m0 = new;
        s0 = new;
        g0 = new(drv_mbx);
        cov_collector = new(); // Instantiate coverage collector
    endfunction

    virtual task run();
        d0.vif = vif;
        m0.vif = vif;
        d0.drv_mbx = drv_mbx;
        m0.scb_mbx = scb_mbx;
        s0.scb_mbx = scb_mbx;
        m0.cov_collector = cov_collector; // Connect coverage collector to monitor
        fork
            s0.run();
            d0.run();
            m0.run();
            g0.run();
        join_any
    endtask
    
    function void report_coverage();
        cov_collector.report_coverage();
    endfunction
endclass