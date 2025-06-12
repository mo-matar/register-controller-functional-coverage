class monitor;
    virtual reg_if vif;
    mailbox scb_mbx;
    coverage_collector cov_collector;

    task run();
        $display("T=%0t [Monitor] starting ...", $time);
        forever begin
            @(posedge vif.clk);
            if (vif.sel) begin
                reg_item item = new();
                item.addr  = vif.addr;
                item.wr    = vif.wr;
                item.acc   = vif.acc;
                item.func  = vif.func;
                item.wdata = vif.wdata;

                if (!vif.wr) begin
                    // Wait for valid read data
                    do begin
                       @(posedge vif.clk);
                    end while (vif.ready);
                    item.rdata = vif.rdata;
                end

                item.print("Monitor");
                scb_mbx.put(item);
                if (cov_collector != null) begin
                    cov_collector.sample(item);
                end
            end
        end
    endtask
endclass