// Simple test to verify constraint randomization is working
module constraint_debug_test;
    
    initial begin
        reg_item item;
        int acc_count = 0;
        int total_writes = 0;
        
        $display("=== CONSTRAINT DEBUG TEST ===");
        $display("Testing 100 randomizations to verify accumulate constraint...");
        
        for (int i = 0; i < 100; i++) begin
            item = new;
            if (!item.randomize()) begin
                $error("Randomization failed at iteration %0d", i);
                continue;
            end
            
            if (item.wr) begin
                total_writes++;
                if (item.acc) begin
                    acc_count++;
                    $display("ACC_%s: addr=0x%02h, wdata=0x%06h", 
                            item.func ? "MULT" : "ADD", item.addr, item.wdata);
                end
            end
        end
        
        $display("\n=== CONSTRAINT RESULTS ===");
        $display("Total writes: %0d", total_writes);
        $display("Accumulate operations: %0d", acc_count);
        if (total_writes > 0) begin
            real acc_percentage = (real'(acc_count) / real'(total_writes)) * 100.0;
            $display("Accumulate percentage: %.1f%%", acc_percentage);
            if (acc_percentage >= 70.0) begin
                $display("SUCCESS: Constraint working correctly (expected ~80%%)");
            end else begin
                $display("WARNING: Low accumulate percentage (expected ~80%%)");
            end
        end
        
        $finish;
    end
    
endmodule
