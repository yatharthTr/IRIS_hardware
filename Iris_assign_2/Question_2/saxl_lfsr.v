//////////////////////////////////////////////////////////////////////////////////
////      Edit to create a 8bit LFSR module with AXI-Lite interface          /////
/////      for register configuration and AX-Stream for lfsr output          /////
//////////////////////////////////////////////////////////////////////////////////


module s_axil #(
    parameter C_AXIL_ADDR_WIDTH = 4,
    parameter C_AXIL_DATA_WIDTH = 32
)(
    input aclk,
    input aresetn,

    // AXI-Lite Slave Interface
    input  [C_AXIL_ADDR_WIDTH-1:0] s_axi_awaddr,
    input                       s_axi_awvalid,
    output reg                  s_axi_awready,

    input  [C_AXIL_DATA_WIDTH-1:0] s_axi_wdata,
    input                       s_axi_wvalid,
    output reg                  s_axi_wready,

    output reg [1:0]            s_axi_bresp,
    output reg                  s_axi_bvalid,
    input                       s_axi_bready,

    // read starts

    input  [C_AXIL_ADDR_WIDTH-1:0] s_axi_araddr,
    input                       s_axi_arvalid,
    output reg                  s_axi_arready,

    output reg [C_AXIL_DATA_WIDTH-1:0] s_axi_rdata,
    output reg [1:0]            s_axi_rresp,
    output reg                  s_axi_rvalid,
    input                       s_axi_rready,

    // AXI - Stream Master Interface
    output reg [C_AXIL_DATA_WIDTH-1:0] m_axis_tdata,
    output reg                    m_axis_tvalid,
    input         wire                m_axis_tready
);


    //Address map for these registers

    // 0x00 - start_reg
    // 0x04 - stop_reg
    // 0x08 - seed_reg
    // 0x0C - taps_reg

    // Registers
    reg start_reg;
    reg stop_reg;
    reg [7:0] seed_reg;
    reg [7:0] taps_reg;
    reg [31:0] last_lfsr_val;
    reg lfsr_tvalid;
    reg [7:0] lfsr_tdata;

    // for write slave
    always @(posedge aclk) begin
        if(!aresetn) begin
            s_axi_awready<=0;
            s_axi_wready<=0;
        end
        else begin
            if(s_axi_awvalid && s_axi_wvalid && !s_axi_awready && !s_axi_wready) begin
                s_axi_awready<=1;
                s_axi_wready<=1;
                case (s_axi_awaddr)
                    4'b0: begin
                        start_reg<=1;
                        // stop_reg<=0;
                        end
                    4'h4:begin 
                        stop_reg<=s_axi_wdata[0];
                        // start_reg<=0;
                        end
                    4'h8: seed_reg<=s_axi_wdata[7:0];
                    4'hc: taps_reg<=s_axi_wdata[7:0];
                endcase;
                s_axi_bresp<=2'd0;
                s_axi_bvalid<=1;
            end
            if(s_axi_awvalid && s_axi_wvalid && s_axi_awready && s_axi_wready) begin
                s_axi_bresp<=2'd0;
                s_axi_bvalid<=1;
            end               
            else if(s_axi_awready & s_axi_wready) begin
                s_axi_awready<=0;
                s_axi_wready<=0;
            end
            if(s_axi_bready) s_axi_bvalid<=0;

            
        end
    end
    always @(posedge aclk) begin
        if(!aresetn) begin
            s_axi_arready<=0;
            s_axi_rdata<=0;
            s_axi_rresp<=0;
            s_axi_rvalid<=0;
            // s_axi_rready<=0;
        end
        else begin
            if(s_axi_arvalid && !s_axi_arready && !s_axi_rresp && !s_axi_rvalid) begin
                s_axi_arready<=1;
                s_axi_rresp<=2'd0;
                s_axi_rvalid<=1;
                case (s_axi_awaddr)
                    4'b0: begin
                        s_axi_rdata={31'd0,start_reg};
                        // stop_reg<=0;
                        end
                    4'd4:begin 
                        s_axi_rdata={31'd0,stop_reg};
                        // start_reg<=0;
                        end
                    4'd8:s_axi_rdata={24'd0,seed_reg[7:0]};
                    4'hc:s_axi_rdata={24'd0,taps_reg[7:0]};
                endcase;
            end
            else if(s_axi_arready && s_axi_rvalid) begin
                s_axi_arready<=0;
                s_axi_rresp<=0;
                s_axi_rvalid<=0;
            end
        end

    end
    always @(*) begin
        if(!aresetn) begin
            lfsr_tvalid=0;
            // m_axis_tready<=0;
            lfsr_tdata=8'd0;
            stop_reg<=0;
        end
        else begin
            if(stop_reg) begin 
                lfsr_tdata=lfsr_tdata;
                lfsr_tvalid=0;
            end
            else if(start_reg) begin
                if(!lfsr_tvalid) begin
                    lfsr_tdata={seed_reg};
                    lfsr_tvalid=1;
                end
                else if(m_axis_tready && lfsr_tvalid) begin
                    lfsr_tdata={lfsr_tdata[6:0],^(taps_reg&lfsr_tdata)};
                end

            end
        end
    end
    always @ (posedge aclk) begin
        if(!aresetn) begin
            m_axis_tdata<=0;
            m_axis_tvalid<=0;
        end
        else begin
            m_axis_tvalid<=lfsr_tvalid;
            m_axis_tdata<={24'b0,lfsr_tdata};
        end
    end



endmodule;