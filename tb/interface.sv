interface reg_if (input bit clk);
    logic rstn;
    logic [7:0] addr;
    logic [23:0] wdata;
    logic [23:0] rdata;
    logic wr;
    logic sel;
    logic ready;
    logic acc;      // accumulate enable
    logic func;     // function: 0=add, 1=multiply
endinterface