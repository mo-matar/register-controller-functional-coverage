class scoreboard;
    mailbox scb_mbx;
    
    // Memory model with expected values
    bit [23:0] ref_mem[bit [7:0]];

    task run();
        forever begin
            reg_item item;
            scb_mbx.get(item);

            // Initialize address if first access
            if (!ref_mem.exists(item.addr)) begin
                ref_mem[item.addr] = reg_item::DEFAULT_VALUE;
            end

            if (item.wr) begin
                // Handle writes
                $display("[SCB] Writing to Addr 0x%0h: the value is 0x%0h", 
                         item.addr, item.wdata);
                         
                if (item.acc) begin
                    if (item.func) begin
                        ref_mem[item.addr] *= item.wdata; // Accumulate multiply
                    end
                    else begin
                        ref_mem[item.addr] += item.wdata; // Accumulate add
                    end
                end
                else begin
                    ref_mem[item.addr] = item.wdata; // Direct write
                end

                $display("[SCB] Updated Addr 0x%0h: New value is 0x%0h", 
                         item.addr, ref_mem[item.addr]);
            end else begin
                // Verify reads
                if (item.rdata !== ref_mem[item.addr]) begin
                    $display("[SCB] ERROR! Addr 0x%0h: Exp=0x%0h Act=0x%0h",
                             item.addr, ref_mem[item.addr], item.rdata);
                end else begin
                    $display("[SCB] PASS! Addr 0x%0h: 0x%0h", item.addr, item.rdata);
                end
            end
        end
    endtask
endclass