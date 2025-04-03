/// use this module to create a RAM with AXI-Stream interface
/// you are allowed to change the input interface to axi-lite if you want


module axi_ram (

    input aclk,
    input aresetn,

    // AXI-Stream Slave

    input [31:0]s_axis_tdata,
    input s_axis_tvalid,
    output reg s_axis_tready,

    // AXI-Stream Master 

    output reg [31:0]m_axis_tdata,
    output reg m_axis_tvalid,
    input m_axis_tready
    
);
reg [7:0] wr_ptr, rd_ptr;
integer count;
reg [7:0] pointer;
reg [7:0] mem [0:288];
// reg valid [0:288];
// integer pointer=0;
always @(posedge aclk) begin
    if(!aresetn) begin
        m_axis_tdata<=0;
        m_axis_tvalid<=0;
        rd_ptr<=0;
    end
    else begin
            
        if(m_axis_tready) begin
            m_axis_tdata<={24'd0, mem[rd_ptr]};
            m_axis_tvalid<=1;
            rd_ptr=(rd_ptr+8'b1)%289;
            // valid[rd_ptr]<=0;
            count=count-1;
        end
        else begin
            m_axis_tdata<=0;
            m_axis_tvalid<=0;
        end
    end
end
wire [8:0]full;
assign full=count;
always @(posedge aclk) begin
    if(!aresetn) begin
        s_axis_tready<=0;
        count<=0;
    end
    else begin
        s_axis_tready<=(count<289);
        if(s_axis_tvalid && full<=9'd288) begin
            mem[s_axis_tdata[23:16]]<=s_axis_tdata[7:0];
            mem[s_axis_tdata[29:25]]<=s_axis_tdata[12:8];
            count<=count+1;
            // valid[s_axis_tdata[23:16]]<=1;
        end
    end
end
endmodule