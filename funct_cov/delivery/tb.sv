interface reg_if (input bit clk);
    logic rstn;
    logic [7:0] addr;
    logic [23:0] wdata;
    logic [23:0] rdata;
    logic wr;
    logic sel;
    logic ready;
endinterface

class reg_item;
    rand bit [7:0] addr;
    rand bit [23:0] wdata;
    bit [23:0] rdata;
    rand bit wr;

    function void print(string tag="");
        $display ("T=%0t [%s] addr=0x%0h wr=%0d wdata=0x%0h rdata=0x%0h",
            $time, tag, addr, wr, wdata, rdata);
    endfunction
endclass

class driver;
    virtual reg_if vif;
    event drv_done;
    mailbox drv_mbx;

    task run();
        $display ("T=%0t [Driver] starting ...", $time);
        @(posedge vif.clk);
        forever begin
            reg_item item;
            $display ("T=%0t [Driver] waiting for item ...", $time);
            drv_mbx.get(item);
            item.print("Driver");
            vif.sel   <= 1;
            vif.addr  <= item.addr;
            vif.wr    <= item.wr;
            vif.wdata <= item.wdata;
            @(posedge vif.clk);
            while (!vif.ready) begin
                $display ("T=%0t [Driver] wait until ready is high", $time);
                @(posedge vif.clk);
            end
            vif.sel <= 0;
            ->drv_done;
        end
    endtask
endclass

class monitor;
    virtual reg_if vif;
    mailbox scb_mbx;

    task run();
        $display ("T=%0t [Monitor] starting ...", $time);
        forever begin
            @(posedge vif.clk);
            if (vif.sel) begin
                reg_item item = new;
                item.addr  = vif.addr;
                item.wr    = vif.wr;
                item.wdata = vif.wdata;
                if (!vif.wr) begin
                    @(posedge vif.clk);
                    item.rdata = vif.rdata;
                end
                item.print("Monitor");
                scb_mbx.put(item);
            end
        end
    endtask
endclass

class scoreboard;
    mailbox scb_mbx;
    reg_item refq[256];

    task run();
        forever begin
            reg_item item;
            scb_mbx.get(item);
            item.print("Scoreboard");
            if (item.wr) begin
                refq[item.addr] = item;
                $display ("T=%0t [Scoreboard] Store addr=0x%0h wr=0x%0h data=0x%0h",
                    $time, item.addr, item.wr, item.wdata);
            end
            if (!item.wr) begin
                if (refq[item.addr] == null) begin
                    if (item.rdata != 'h1234)
                        $display ("T=%0t [Scoreboard] ERROR! First time read, addr=0x%0h exp=1234 act=0x%0h", $time, item.addr, item.rdata);
                    else
                        $display ("T=%0t [Scoreboard] PASS! First time read, addr=0x%0h exp=1234 act=0x%0h", $time, item.addr, item.rdata);
                end else begin
                    if (item.rdata != refq[item.addr].wdata)
                        $display ("T=%0t [Scoreboard] ERROR! addr=0x%0h exp=0x%0h act=0x%0h", $time, item.addr, refq[item.addr].wdata, item.rdata);
                    else
                        $display ("T=%0t [Scoreboard] PASS! addr=0x%0h exp=0x%0h act=0x%0h", $time, item.addr, refq[item.addr].wdata, item.rdata);
                end
            end
        end
    endtask
endclass

class TestRegistry;
    static int configs[string];

    static function void set_int(string key, int value);
        configs[key] = value;
    endfunction

    static function int get_int(string key);
        if (configs.exists(key))
            return configs[key];
        else
            return 0; // default
    endfunction
endclass

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

        item = new;
        item.randomize() with { addr == 8'haa; wr == 1; wdata == 16'hbeef; };
        drv_mbx.put(item);

        item = new;
        item.randomize() with { addr == 8'haa; wr == 0; };
        drv_mbx.put(item);
    endtask
endclass


class env;
    driver d0;
    monitor m0;
    scoreboard s0;
    mailbox scb_mbx;
    virtual reg_if vif;

    function new();
        d0 = new;
        m0 = new;
        s0 = new;
        scb_mbx = new();
    endfunction

    virtual task run();
        d0.vif = vif;
        m0.vif = vif;
        m0.scb_mbx = scb_mbx;
        s0.scb_mbx = scb_mbx;
        fork
            s0.run();
            d0.run();
            m0.run();
        join_any
    endtask
endclass

class test;
    env e0;
    mailbox drv_mbx;
    generator g0;

    function new();
        drv_mbx = new();
        e0 = new();
        g0 = new(drv_mbx);
    endfunction

    virtual task run();
        // Set configuration
        TestRegistry::set_int("NoOfTransactions", 10);

        // Connect mailbox
        e0.d0.drv_mbx = drv_mbx;
        fork
            e0.run();
        join_none

        // Start generator
        g0.run();
    endtask
endclass

module tb;
    reg clk;
    always #10 clk = ~clk;

    reg_if _if(clk);

    reg_ctrl u0 (
        .clk   (clk),
        .rstn  (_if.rstn),
        .addr  (_if.addr),
        .sel   (_if.sel),
        .wr    (_if.wr),
	.acc(1'b0),
	.func(1'b0),
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
        #20 _if.rstn = 1;

        t0 = new;
        t0.e0.vif = _if;
        t0.run();
        #500 $finish;
        end
endmodule