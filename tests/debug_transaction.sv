class debug_reg_item extends reg_item;    // Override constraints to strongly favor accumulate operations
    constraint c_debug_accumulate {
        // Force high percentage of writes to be accumulate operations
        if (wr) {
            acc inside {0, 1}; // Allow both values
        } else {
            acc == 0;  // No accumulate for reads
        }
        
        // Equal distribution of add/multiply when accumulating
        if (!acc) {
            func == 0;
        }
    }
    
    constraint c_debug_operation {
        // Bias towards writes for focused testing
        wr inside {0, 1}; // Allow both reads and writes
    }
    
    constraint c_debug_data {
        // Use smaller, predictable values for easy debugging
        wdata inside {1, 2, 3, 4, 5};
    }
            5 := 20
        };
    }
    
    constraint c_debug_addr {
        // Use only a few addresses for focused testing
        addr inside {[0:7]};
    }
    
    function void print_debug(string tag="");
        string op_str;
        if (!wr) op_str = "READ";
        else if (!acc) op_str = "WRITE";
        else if (func) op_str = "ACC_MULT";
        else op_str = "ACC_ADD";
        
        $display ("T=%0t [%s] DEBUG: %s addr=0x%02h wdata=0x%06h acc=%0d func=%0d", 
                 $time, tag, op_str, addr, wdata, acc, func);
    endfunction
    
endclass
