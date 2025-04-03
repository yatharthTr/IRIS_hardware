`include "lfsr_core.v"

`timescale 1ns/1ns

module tb_top_level;


core dut (
    .aclk(aclk),
    .aresetn(aresetn),

    // AXI Write Address Channel
    .lfsr_s_axi_awaddr(lfsr_s_axi_awaddr),
    .lfsr_s_axi_awvalid(lfsr_s_axi_awvalid),
    .lfsr_s_axi_awready(lfsr_s_axi_awready),

    // AXI Write Data Channel
    .lfsr_s_axi_wdata(lfsr_s_axi_wdata),
    .lfsr_s_axi_wvalid(lfsr_s_axi_wvalid),
    .lfsr_s_axi_wready(lfsr_s_axi_wready),

    // AXI Read Address Channel
    .lfsr_s_axi_araddr(lfsr_s_axi_araddr),
    .lfsr_s_axi_arvalid(lfsr_s_axi_arvalid),
    .lfsr_s_axi_arready(lfsr_s_axi_arready),

    // AXI Read Data Channel
    .lfsr_s_axi_rresp(lfsr_s_axi_rresp),
    .lfsr_s_axi_rvalid(lfsr_s_axi_rvalid),
    .lfsr_s_axi_rready(lfsr_s_axi_rready),
    .lfsr_s_axi_rdata(lfsr_s_axi_rdata),

    // AXI Write Response Channel
    .lfsr_s_axi_bresp(lfsr_s_axi_bresp),
    .lfsr_s_axi_bvalid(lfsr_s_axi_bvalid),
    .lfsr_s_axi_bready(lfsr_s_axi_bready),

    // LFSR Output Stream
    .lfsr_m_axis_tdata(lfsr_m_axis_tdata),
    .lfsr_m_axis_tvalid(lfsr_m_axis_tvalid)
);

        // LFSR Interface Signals
    reg aclk, aresetn;
    reg [3:0]  lfsr_s_axi_awaddr;
    reg        lfsr_s_axi_awvalid;
    wire       lfsr_s_axi_awready;
    reg [31:0] lfsr_s_axi_wdata;
    reg        lfsr_s_axi_wvalid;
    wire       lfsr_s_axi_wready;
    reg [3:0]  lfsr_s_axi_araddr;
    reg        lfsr_s_axi_arvalid;
    wire       lfsr_s_axi_arready;
    wire [1:0] lfsr_s_axi_rresp;
    wire [1:0] lfsr_s_axi_bresp;
    wire       lfsr_s_axi_bvalid;
    reg        lfsr_s_axi_bready;
    wire       lfsr_s_axi_rvalid;
    reg        lfsr_s_axi_rready;
    wire [31:0] lfsr_s_axi_rdata;

    // LFSR Data Stream
    wire [31:0] lfsr_m_axis_tdata;
    wire        lfsr_m_axis_tvalid;
    reg         lfsr_m_axis_tready;

    // Histogram Output
    wire [31:0] hist_m_axis_tdata;
    wire        hist_m_axis_tvalid;
    reg         hist_m_axis_tready;

    // RAM Output
    wire [31:0] ram_m_axis_tdata;
    wire        ram_m_axis_tvalid;
    reg         ram_m_axis_tready;

    initial begin
        aclk = 1'b0;
        forever #5 aclk = ~aclk;
    end

    initial begin
        aresetn = 1'b0;
        #20;        
        aresetn = 1'b1;
    end

    initial begin
        lfsr_s_axi_awaddr  = 4'h0;
        lfsr_s_axi_awvalid = 1'b0;
        lfsr_s_axi_wdata   = 32'd0;
        lfsr_s_axi_wvalid  = 1'b0;
        lfsr_s_axi_bready  = 1'b0;

        lfsr_s_axi_araddr  = 4'h0;
        lfsr_s_axi_arvalid = 1'b0;
        lfsr_s_axi_rready  = 1'b0;
    end

    //------------------------------------------------------------------------------
    //  AXI-Lite Write Task
    //------------------------------------------------------------------------------
    task axi_lite_write(
        input [3:0]  addr,
        input [31:0] data
    );
    begin
        // Address phase
        lfsr_s_axi_awaddr  <= addr;
        lfsr_s_axi_awvalid <= 1'b1;
        // Data phase
        lfsr_s_axi_wdata   <= data;
        lfsr_s_axi_wvalid  <= 1'b1;

        // Wait until AW and W are accepted
        @(posedge aclk);
        while(!(lfsr_s_axi_awready && lfsr_s_axi_awvalid && lfsr_s_axi_wready && lfsr_s_axi_wvalid)) begin
            @(posedge aclk);
        end

        // Deassert
        lfsr_s_axi_awvalid <= 1'b0;
        lfsr_s_axi_wvalid  <= 1'b0;

        // Wait for BVALID
        @(posedge aclk);
        while(!lfsr_s_axi_bvalid) begin
            @(posedge aclk);
        end

        // Ack the response
        lfsr_s_axi_bready <= 1'b1;
        @(posedge aclk);
        lfsr_s_axi_bready <= 1'b0;
    end
    endtask

    //------------------------------------------------------------------------------
    //  AXI-Lite Read Task
    //------------------------------------------------------------------------------
    task axi_lite_read(
        input  [3:0]  addr,
        output [31:0] data_out
    );
    begin
        lfsr_s_axi_araddr  <= addr;
        lfsr_s_axi_arvalid <= 1'b1;

        // Wait for AR to be accepted
        @(posedge aclk);
        while(!(lfsr_s_axi_awready && lfsr_s_axi_arvalid)) begin
            @(posedge aclk);
        end
        lfsr_s_axi_arvalid <= 1'b0;

        // Wait for RVALID
        @(posedge aclk);
        while(!lfsr_s_axi_rvalid) begin
            @(posedge aclk);
        end
        data_out      = lfsr_s_axi_rdata;

        // Ack
        lfsr_s_axi_rready <= 1'b1;
        @(posedge aclk);
        lfsr_s_axi_rready <= 1'b0;
    end
    endtask

    //------------------------------------------------------------------------------
    //  Test Sequence
    //------------------------------------------------------------------------------
    initial begin
        // Wait for reset
        @(posedge aresetn);
        @(posedge aclk);

        $display("INFO: Configuring lfsr through AXI-Lite...");

        // Example writes:
        // Write seed_reg @0x08 = 8'hAC
        axi_lite_write(4'h8, 32'h000000AC);

        // Write taps_reg @0x0C = 8'hA2
        axi_lite_write(4'hC, 32'h000000A2);

        // Write stop_reg @0x04 = 0
        axi_lite_write(4'h4, 32'h0);

        // Write start_reg @0x00 = 1
        axi_lite_write(4'h0, 32'h1);

        $display("LFSR has started.");
        // $display("Time=%0t,aw_valid=%b, w_valid=%b start_reg=%b, stop_reg=%b, seed_reg=%h, taps_reg=%h, lfsr_reg=%h",
        //   $time,
        //   dut.u_lfsr_axil.start_reg,lfsr_s_axi_awvalid,lfsr_s_axi_wvalid, dut.u_lfsr_axil.stop_reg, dut.u_lfsr_axil.seed_reg, dut.u_lfsr_axil.taps_reg, dut.u_lfsr_axil.lfsr_tdata);

        $monitor("Time=%0t,aw_valid=%b, w_valid=%b start_reg=%b, stop_reg=%b, seed_reg=%h, taps_reg=%h, lfsr_reg=%h",
          $time,
          dut.u_lfsr_axil.start_reg,lfsr_s_axi_awvalid,lfsr_s_axi_wvalid, dut.u_lfsr_axil.stop_reg, dut.u_lfsr_axil.seed_reg, dut.u_lfsr_axil.taps_reg, dut.u_lfsr_axil.lfsr_tdata);


        // Let the design run for a while
        repeat(300) @(posedge aclk);

        $display("INFO: Simulation done. Check waveforms / logs to see memory writes.");
        $finish;
    end

    
    //------------------------------------------------------------------------------
    //  (Optional) Waveform Dump
    //------------------------------------------------------------------------------
    initial begin
        // VCD file name can be anything you like
        $dumpfile("tb_top_level.vcd");
        // 0 means dump everything in the hierarchy
        $dumpvars(0, tb_top_level);
    end

endmodule