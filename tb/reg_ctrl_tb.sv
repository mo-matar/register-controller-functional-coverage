module tb;
    reg clk;
    always #10 clk = ~clk;

    reg_if _if(clk);    reg_ctrl u0 (
        .clk   (clk),
        .rstn  (_if.rstn),
        .addr  (_if.addr),
        .sel   (_if.sel),
        .wr    (_if.wr),
        .acc   (_if.acc),
        .func  (_if.func),
        .wdata (_if.wdata),
        .rdata (_if.rdata),
        .ready (_if.ready)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

    initial begin
        test t0;
        clk = 0;
        _if.rstn = 0;
        _if.sel  = 0;
        #20 _if.rstn = 1;        t0 = new;
        t0.e0.vif = _if;
        t0.run();
        #10000 $finish;  // Longer simulation time for comprehensive testing
        end
endmodule