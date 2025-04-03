`include "saxl_lfsr.v"
`include "s_m_hist.v"
`include "axi_ram.v"




module core(
    input aclk,
    input aresetn,
    input wire [C_AXIL_ADDR_WIDTH-1:0] lfsr_s_axi_awaddr,
    input wire lfsr_s_axi_awvalid, 
    output wire lfsr_s_axi_awready,
    input wire [C_AXIL_DATA_WIDTH-1:0] lfsr_s_axi_wdata,
    input wire lfsr_s_axi_wvalid, 
    output wire lfsr_s_axi_wready,
    input wire [C_AXIL_ADDR_WIDTH-1:0] lfsr_s_axi_araddr,
    input wire lfsr_s_axi_arvalid,
    output lfsr_s_axi_arready,
    output wire [1:0] lfsr_s_axi_rresp,
    output wire [1:0] lfsr_s_axi_bresp,
    output wire lfsr_s_axi_bvalid, 
    input wire lfsr_s_axi_bready,
    output wire lfsr_s_axi_rvalid,
    input wire  lfsr_s_axi_rready,
    output wire [C_AXIL_DATA_WIDTH-1:0] lfsr_s_axi_rdata,
    output wire [C_AXIL_DATA_WIDTH-1:0] lfsr_m_axis_tdata,
    output wire lfsr_m_axis_tvalid

);
    parameter C_AXIL_ADDR_WIDTH = 4;
    parameter C_AXIL_DATA_WIDTH = 32;
    wire lfsr_m_axis_tready;
    // wire [C_AXIL_ADDR_WIDTH-1:0] lfsr_s_axi_awaddr;
    // wire lfsr_s_axi_awvalid, lfsr_s_axi_awready;
    // wire [C_AXIL_DATA_WIDTH-1:0] lfsr_s_axi_wdata;
    // wire lfsr_s_axi_wvalid, lfsr_s_axi_wready;
    // wire [C_AXIL_ADDR_WIDTH-1:0] lfsr_s_axi_araddr;
    // wire lfsr_s_axi_arvalid, lfsr_s_axi_arready;
    // wire [1:0] lfsr_s_axi_rresp;
    // wire [1:0] lfsr_s_axi_bresp;
    // wire lfsr_s_axi_bvalid, lfsr_s_axi_bready;
    // wire lfsr_s_axi_rvalid, lfsr_s_axi_rready;
    // wire [C_AXIL_DATA_WIDTH-1:0] lfsr_s_axi_rdata;
    // wire [C_AXIL_DATA_WIDTH-1:0] lfsr_m_axis_tdata;
    // wire lfsr_m_axis_tvalid, lfsr_m_axis_tready;

    // histogram
    wire [31:0] hist_m_axis_tdata;
    wire hist_m_axis_tvalid, hist_m_axis_tready;

    // RAM
    wire [31:0] ram_m_axis_tdata;
    wire ram_m_axis_tvalid, ram_m_axis_tready;

    s_axil u_lfsr_axil(
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axi_awaddr(lfsr_s_axi_awaddr),
        .s_axi_awvalid(lfsr_s_axi_awvalid),
        .s_axi_awready(lfsr_s_axi_awready),
        .s_axi_wdata(lfsr_s_axi_wdata),
        .s_axi_wvalid(lfsr_s_axi_wvalid),
        .s_axi_wready(lfsr_s_axi_wready),
        .s_axi_bresp(lfsr_s_axi_bresp),
        .s_axi_bvalid(lfsr_s_axi_bvalid),
        .s_axi_bready(lfsr_s_axi_bready),
        .s_axi_araddr(lfsr_s_axi_araddr),
        .s_axi_arvalid(lfsr_s_axi_arvalid),
        .s_axi_arready(lfsr_s_axi_arready),
        .s_axi_rdata(lfsr_s_axi_rdata),
        .s_axi_rresp(lfsr_s_axi_rresp),
        .s_axi_rvalid(lfsr_s_axi_rvalid),
        .s_axi_rready(lfsr_s_axi_rready),
        .m_axis_tdata(lfsr_m_axis_tdata),
        .m_axis_tvalid(lfsr_m_axis_tvalid),
        .m_axis_tready(lfsr_m_axis_tready)
    );

    s_m_hist s1(
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_tdata(lfsr_m_axis_tdata),
        .s_axis_tvalid(lfsr_m_axis_tvalid),
        .s_axis_tready(lfsr_m_axis_tready),
        .m_axis_tdata(hist_m_axis_tdata),
        .m_axis_tvalid(hist_m_axis_tvalid),
        .m_axis_tready(hist_m_axis_tready)
    );

    axi_ram a0(
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_tdata(hist_m_axis_tdata),
        .s_axis_tvalid(hist_m_axis_tvalid),
        .s_axis_tready(hist_m_axis_tready),
        .m_axis_tdata(ram_m_axis_tdata),
        .m_axis_tvalid(ram_m_axis_tvalid),
        .m_axis_tready(ram_m_axis_tready)
    );

endmodule
