//////////////////////////////////////////////////////////////////////////////////////////////////
////      Edit to create a block to create a data processing block, which takes in data //////////
/// from the lfsr through a AXI-Stream slave interface, and categorises them into bins  //////////
/////      The output data includes the  count value of numbers in each bin and data    //////////
////     + address in ram , which the data is supposed to be written to as provided in  //////////
////                            the address map below                                   //////////
////     The output data is to sent out through a AXI-Stream master/AXI-Lite interface.    ///////
//////////////////////////////////////////////////////////////////////////////////////////////////


//  -------------------------------------------------
//  | Bin Number |    Range of Values               |
//  -------------------------------------------------
//  | Bin 0      |        1   -  32                 |
//  | Bin 1      |       33   -  64                 |
//  | Bin 2      |       65   -  96                 |
//  | Bin 3      |       97   - 128                 |
//  | Bin 4      |      129   - 160                 |
//  | Bin 5      |      161   - 192                 |
//  | Bin 6      |      193   - 224                 |
//  | Bin 7      |      225   - 255                 |
//  -------------------------------------------------


// assume the ram to be 0x120 x 8 bit 

// ----------------------------------------------------------------------------------------
// | Address Range      | Register / Memory     | Description                              |
// ----------------------------------------------------------------------------------------
// | 0x00              | Bin 0 Count           | Count for values in range 1-32           |
// | 0x04              | Bin 1 Count           | Count for values in range 33-64          |
// | 0x08              | Bin 2 Count           | Count for values in range 65-96          |
// | 0x0C              | Bin 3 Count           | Count for values in range 97-128         |
// | 0x10              | Bin 4 Count           | Count for values in range 129-160        |
// | 0x14              | Bin 5 Count           | Count for values in range 161-192        |
// | 0x18              | Bin 6 Count           | Count for values in range 193-224        |
// | 0x1C              | Bin 7 Count           | Count for values in range 225-255        |
// ----------------------------------------------------------------------------------------
// | 0x20 - 0x3F       | Bin 0 Data Storage    | Stores values belonging to Bin 0         |
// | 0x40 - 0x5F       | Bin 1 Data Storage    | Stores values belonging to Bin 1         |
// | 0x60 - 0x7F       | Bin 2 Data Storage    | Stores values belonging to Bin 2         |
// | 0x80 - 0x9F       | Bin 3 Data Storage    | Stores values belonging to Bin 3         |
// | 0xA0 - 0xBF       | Bin 4 Data Storage    | Stores values belonging to Bin 4         |
// | 0xC0 - 0xDF       | Bin 5 Data Storage    | Stores values belonging to Bin 5         |
// | 0xE0 - 0xFF       | Bin 6 Data Storage    | Stores values belonging to Bin 6         |
// | 0x100 - 0x11F     | Bin 7 Data Storage    | Stores values belonging to Bin 7         |
// ----------------------------------------------------------------------------------------





module s_m_hist (

    input aclk,
    input aresetn,

    // AXI-Stream Slave

    input [31:0]s_axis_tdata,
    input s_axis_tvalid,
    output reg s_axis_tready,

    // AXI-Stream Master 

    output reg [31:0]m_axis_tdata,
    output reg m_axis_tvalid,
    input wire m_axis_tready
    
);
    reg [31:0]s_final_tdata;
    reg [4:0] count[7:0];
    always @(*) begin
        if(!aresetn) begin
            count[0] = 8'd0;
            count[1] = 8'd0;
            count[2] = 8'd0;
            count[3] = 8'd0;
            count[4] = 8'd0;
            count[5] = 8'd0;
            count[6] = 8'd0;
            count[7] = 8'd0;
        end
        else begin

            // if(!m_axis_tvalid && m_axis_tready) begin
            //     s_axis_tready <= 1'b1;
            // end

            // else s_axis_tready <= 1'b0;

            if(s_axis_tdata<=32'd32 && s_axis_tdata>=32'd1) begin
                count[0]=count[0]+5'd1;
                s_final_tdata={5'd0,5'd0,9'h20 + count[0]-8'd1,count[0],s_axis_tdata[7:0]};
            end
            else if (s_axis_tdata<=32'd64 && s_axis_tdata>=32'd33) begin
                count[1]=count[1]+5'd1;
                s_final_tdata={5'd0,5'd4,9'h40 + count[1]-8'd1,count[1],s_axis_tdata[7:0]};
            end
            else if (s_axis_tdata<=32'd96 && s_axis_tdata>=32'd65) begin
                count[2]=count[2]+5'd1;
                s_final_tdata={5'd0,5'd8,9'h60 + count[2]-8'd1,count[2],s_axis_tdata[7:0]};
            end
            else if (s_axis_tdata<=32'd128 && s_axis_tdata>=32'd97) begin
                count[3]=count[3]+5'd1;
                s_final_tdata={5'd0, 5'hc, 9'h80 + count[3]-8'd1,count[3],s_axis_tdata[7:0]};
            end
            else if (s_axis_tdata<=32'd160 && s_axis_tdata>=32'd129) begin
                count[4]=count[4]+5'd1;
                s_final_tdata={5'd0,5'h10,9'ha0 + count[4]-8'd1,count[4],s_axis_tdata[7:0]};
            end
            else if (s_axis_tdata<=32'd192 && s_axis_tdata>=32'd161) begin
                count[5]=count[5]+5'd1;
                s_final_tdata={5'd0,5'h14,9'hc0 + count[5]-8'd1,count[5],s_axis_tdata[7:0]};
            end
            else if (s_axis_tdata<=32'd224 && s_axis_tdata>=32'd193) begin
                count[6]=count[6]+5'd1;
                s_final_tdata={5'd0,5'h18,9'he0 + count[6]-8'd1,count[6],s_axis_tdata[7:0]};
            end
            else if (s_axis_tdata<=32'd255 && s_axis_tdata>=32'd225) begin
                count[7]=count[7]+5'd1;
                s_final_tdata={5'd0,5'h1c,9'h100 + count[7]-8'd1,count[7],s_axis_tdata[7:0]};
            end
        end
    end

    always @(posedge aclk) begin

        if(!aresetn) begin
            s_axis_tready<=0;
            m_axis_tvalid<=0;
            m_axis_tdata<=0;
        end

        else begin

            // s_axis_tready<=1;

            if(!m_axis_tvalid && m_axis_tready) begin

                s_axis_tready<=1;

                if(s_axis_tvalid && m_axis_tready) begin
                    m_axis_tdata<=s_final_tdata;
                    m_axis_tvalid<=1;
                end

                else begin
                    m_axis_tvalid<=0;
                end
            end

            else begin
                m_axis_tvalid<=0;
                s_axis_tready <= 1'b0;
            end
        end
    end
endmodule