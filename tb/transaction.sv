class reg_item;
    rand bit [7:0]  addr;
    rand bit [23:0] wdata;
    bit [23:0]     rdata;
    rand bit        wr;
    rand bit        acc;
    rand bit        func;

    // Default value for uninitialized reads
    static bit [23:0] DEFAULT_VALUE = 24'h123456;

    // Constraints to ensure proper test scenarios emerge
    constraint c_valid_scenarios {
        // Ensure 30% accumulate operations
        acc dist {0 := 70, 1 := 30};

        // When accumulating, use small numbers for easier verification
             
        if (acc) {
            wdata inside {[1:100]};
            func dist {0 := 50, 1 := 50}; // Equal add/mult probability
        }
        else {
            // More diverse distribution for non-accumulate operations
            wdata dist {
                [0:255]                 :/ 10,  // 8-bit values
                [256:65_535]           :/ 30,  // 16-bit values
                [65_536:1_000_000]      :/ 25,  // Mid-range 24-bit values
                [1_000_001:16_777_215]  :/ 25,  // Upper 24-bit values
                24'h000000              :/ 5,   // All zeros
                24'hFFFFFF              :/ 5    // All ones
            };

        }
    

        // Address distribution to ensure some address reuse
        addr dist {
            [2:6]   := 40,  // Frequently reused addresses
            [16:239] := 40,  // General addresses
            [240:255] := 20   // Boundary addresses
        };

        // Ensure some write-then-read sequences naturally occur
        // (No explicit constraint needed - handled by statistics)
    }

    function void print(string tag="");
        $display("T=%0t [%s] addr=0x%0h %s %s wdata=0x%0h rdata=0x%0h",
                 $time, tag, addr,
                 wr ? "WR" : "RD",
                 acc ? (func ? "ACC_MULT" : "ACC_ADD") : "NO_ACC",
                 wdata, rdata);
    endfunction
endclass