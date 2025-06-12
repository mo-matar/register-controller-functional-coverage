class coverage_collector;
    reg_item tr;
    
    covergroup reg_ctrl_cg with function sample(reg_item tr);
        // Basic coverpoints
        cp_addr: coverpoint tr.addr {
            bins low_addr    = {[0:63]};
            bins mid_addr    = {[64:191]};
            bins high_addr   = {[192:255]};
            bins power_of_2 = {1,2,4,8,16,32,64,128,192};
        }
        
        cp_wdata: coverpoint tr.wdata {
            bins low_values  = {[0:24'hFFFF]};
            bins mid_values  = {[24'h10000:24'hFFFFF]};
            bins high_values = {[24'h100000:24'hFFFFFF]};
            bins zero        = {0};
            bins max_value   = {24'hFFFFFF};
        }

        cp_rdata: coverpoint tr.rdata {
            bins low_values  = {[0:24'hFFFF]};
            bins mid_values  = {[24'h10000:24'hFFFFF]};
            bins high_values = {[24'h100000:24'hFFFFFF]};
            bins default_val = {24'h123456};  // DEFAULT_VALUE
        }
        
        cp_wr: coverpoint tr.wr {
            bins write = {1};
            bins read  = {0};
        }
        
        cp_acc: coverpoint tr.acc {
            bins no_accumulate = {0};
            bins accumulate    = {1};
        }
        
        cp_func: coverpoint tr.func {
            bins add_func  = {0};
            bins mult_func = {1};
        }
        
        // Cross coverpoints - meaningful combinations
        wr_x_addr: cross cp_wr, cp_addr {
            ignore_bins read_ignored = binsof(cp_wr) intersect {0} && 
                                      binsof(cp_addr.power_of_2);
        }
        
        wr_x_acc: cross cp_wr, cp_acc {
            bins write_with_acc    = binsof(cp_wr.write) && binsof(cp_acc.accumulate);
            bins write_no_acc     = binsof(cp_wr.write) && binsof(cp_acc.no_accumulate);
            bins read_after_acc   = binsof(cp_wr.read)  && binsof(cp_acc.accumulate);
            bins read_after_no_acc= binsof(cp_wr.read)  && binsof(cp_acc.no_accumulate);
        }
        
        acc_x_func: cross cp_acc, cp_func {
            bins acc_add   = binsof(cp_acc.accumulate) && binsof(cp_func.add_func);
            bins acc_mult  = binsof(cp_acc.accumulate) && binsof(cp_func.mult_func);
            ignore_bins no_acc_func = binsof(cp_acc.no_accumulate);
        }
        
        addr_x_wdata: cross cp_addr, cp_wdata {
            bins low_addr_small_data  = binsof(cp_addr.low_addr) && binsof(cp_wdata.low_values);
            bins high_addr_large_data = binsof(cp_addr.high_addr) && binsof(cp_wdata.high_values);
        }
        
        
        // Special case coverage
        special_cases: coverpoint {tr.wr, tr.acc, tr.func} {
            bins write_acc_add     = {3'b1_1_0};
            bins write_acc_mult    = {3'b1_1_1};
            bins read_after_acc    = {3'b0_1_X};
            bins simple_write      = {3'b1_0_X};
            bins simple_read      = {3'b0_0_X};
        }
    endgroup

    function new();
        reg_ctrl_cg = new();
    endfunction

    function void sample(reg_item t);
        this.tr = t;
        reg_ctrl_cg.sample(t);
    endfunction

    function real get_coverage();
        return reg_ctrl_cg.get_coverage();
    endfunction

    function void report_coverage();
        $display("\n=== ENHANCED FUNCTIONAL COVERAGE REPORT ===");
        $display("Total Coverage: %.2f%%", reg_ctrl_cg.get_coverage());
        $display("Address Coverage: %.2f%%", reg_ctrl_cg.cp_addr.get_coverage());
        $display("Write Data Coverage: %.2f%%", reg_ctrl_cg.cp_wdata.get_coverage());
        $display("Read Data Coverage: %.2f%%", reg_ctrl_cg.cp_rdata.get_coverage());
        $display("Write/Read Coverage: %.2f%%", reg_ctrl_cg.cp_wr.get_coverage());
        $display("Accumulate Coverage: %.2f%%", reg_ctrl_cg.cp_acc.get_coverage());
        $display("Function Coverage: %.2f%%", reg_ctrl_cg.cp_func.get_coverage());
        
        // Cross coverage reporting
        $display("\nCross Coverage:");
        $display("WR x Addr: %.2f%%", reg_ctrl_cg.wr_x_addr.get_coverage());
        $display("WR x ACC: %.2f%%", reg_ctrl_cg.wr_x_acc.get_coverage());
        $display("ACC x Func: %.2f%%", reg_ctrl_cg.acc_x_func.get_coverage());
        $display("Addr x Wdata: %.2f%%", reg_ctrl_cg.addr_x_wdata.get_coverage());
        $display("Special Cases: %.2f%%", reg_ctrl_cg.special_cases.get_coverage());
        $display("==========================================\n");
    endfunction
endclass


// // CoverageCollector class for basic reg_ctrl coverage
// class coverage_collector;
//     reg_item tr;  // Changed from 'item' to 'tr' to match coverpoint references
    
//     // Covergroup definition with proper naming conventions
//     covergroup reg_ctrl_cg with function sample(reg_item tr);
//         cp_addr: coverpoint tr.addr {
//             bins low_addr    = {[0:63]};
//             bins mid_addr    = {[64:191]};
//             bins high_addr   = {[192:255]};
//         }
        
//         cp_wdata: coverpoint tr.wdata {
//             bins low_values  = {[0:24'hFFFF]};
//             bins mid_values  = {[24'h10000:24'hFFFFF]};
//             bins high_values = {[24'h100000:24'hFFFFFF]};
//         }

//         cp_rdata: coverpoint tr.rdata {
//             bins low_values  = {[0:24'hFFFF]};
//             bins mid_values  = {[24'h10000:24'hFFFFF]};
//             bins high_values = {[24'h100000:24'hFFFFFF]};
//         }
        
//         cp_wr: coverpoint tr.wr {
//             bins write = {1};
//             bins read  = {0};
//         }
        
//         cp_acc: coverpoint tr.acc {
//             bins no_accumulate = {0};
//             bins accumulate    = {1};
//         }
        
//         cp_func: coverpoint tr.func {
//             bins add_func  = {0};
//             bins mult_func = {1};
//         }
//     endgroup

//     // Constructor
//     function new();
//         reg_ctrl_cg = new();
//     endfunction

//     // Sample function with proper argument handling
//     function void sample(reg_item t);
//         this.tr = t;  // Store transaction locally
//         reg_ctrl_cg.sample(t);  // Pass transaction to covergroup
//     endfunction

//     // Get coverage percentage
//     function real get_coverage();
//         return reg_ctrl_cg.get_coverage();
//     endfunction

//     // Enhanced coverage reporting
//     function void report_coverage();
//         $display("\n=== FUNCTIONAL COVERAGE REPORT ===");
//         $display("Total Coverage: %.2f%%", reg_ctrl_cg.get_coverage());
//         $display("Address Coverage: %.2f%%", reg_ctrl_cg.cp_addr.get_coverage());
//         $display("Write Data Coverage: %.2f%%", reg_ctrl_cg.cp_wdata.get_coverage());
//         $display("Write/Read Coverage: %.2f%%", reg_ctrl_cg.cp_wr.get_coverage());
//         $display("Accumulate Coverage: %.2f%%", reg_ctrl_cg.cp_acc.get_coverage());
//         $display("Function Coverage: %.2f%%", reg_ctrl_cg.cp_func.get_coverage());
//         $display("==================================\n");
//     endfunction
// endclass


