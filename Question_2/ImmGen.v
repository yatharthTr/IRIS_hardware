`define OPCODE_RTYPE 7'b0110011
`define OPCODE_ITYPE 7'b0010011
`define OPCODE_LTYPE 7'b0000011
`define OPCODE_STYPE 7'b0100011
`define OPCODE_BTYPE 7'b1100011
`define OPCODE_JALTYPE 7'b1101111
`define OPCODE_JALRTYPE 7'b1100111



module ImmGen#(parameter Width = 32) (
    input [Width-1:0] inst,
    output reg signed [Width-1:0] imm
);
    // ImmGen generate imm value based on opcode

    wire [6:0] opcode = inst[6:0];
    always @(*) 
    begin
        case(opcode)
            `OPCODE_ITYPE , `OPCODE_LTYPE , `OPCODE_JALRTYPE:imm = {{20{inst[31]}},inst[31:20]}; 
            `OPCODE_STYPE: imm = {{21{inst[31]}},inst[30:25],inst[11:7]};
            `OPCODE_BTYPE: imm = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};
            `OPCODE_JALTYPE: imm = {{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0};

	endcase
    end
            
endmodule

