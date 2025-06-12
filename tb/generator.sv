class generator;
    mailbox drv_mbx;
    reg_item item;

    function new(mailbox mbx);
        drv_mbx = mbx;
    endfunction

    task run();
        int count = TestRegistry::get_int("NoOfTransactions");
        $display ("T=%0t [Generator] Generating %0d transactions ...", $time, count);

        for (int i = 0; i < count; i++) begin
            item = new;
            item.randomize();
            drv_mbx.put(item);
        end
    endtask
endclass


// class generator;
//     mailbox drv_mbx;

//     function new(mailbox mbx);
//         drv_mbx = mbx;
//     endfunction

//     task run();
//         int count = TestRegistry::get_int("NoOfTransactions");
//         $display("T=%0t [Generator] Running %0d CRT transactions", $time, count);

//         for (int i = 0; i < count; i++) begin
//             reg_item itemw = new();
//             reg_item itemr = new();
//             itemw.addr = i+1;
//             itemw.wr = 1;  // Write operation
//             itemw.acc = 0;  // Normal write
//             itemw.func = 0;  // No special function
//             itemw.wdata = i+1;
//             drv_mbx.put(itemw);
//             itemw.print("GEN");
//             // $display("waiting for clock edge before reading");
//             // @(posedge item.clk);  // Wait for clock edge

//             itemr.addr = i+1;
//            itemr.wr = 0;
//             itemr.acc = 0;  // Normal read
//             itemr.func = 0;  // No special function




//             // if (!item.randomize()) begin
//             //     $fatal("Randomization failed!");
//             // end
//             drv_mbx.put(itemr);
//             itemr.print("GEN");
//         end
//     endtask
// endclass