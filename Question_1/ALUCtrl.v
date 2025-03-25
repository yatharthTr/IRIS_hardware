module ALUCtrl (
    input [1:0] ALUOp,
    input funct7,
    input [2:0] funct3,
    output reg [3:0] ALUCtl
);
    always @(*) begin
        case (ALUOp)
        2'b00: ALUCtl = 4'b0000; // LW, SW, JAL (ADD)
        2'b01: ALUCtl = 4'b0001; // BEQ, BGT (SUB)
        2'b10: begin
            case (funct3)
                3'b000: ALUCtl = (funct7 == 1'b1) ? 4'b0001 : 4'b0000; // SUB if funct7 = 1, else ADD
                3'b010: ALUCtl = 4'b0010; // SLTI
                3'b110: ALUCtl = 4'b0011; // ORI
                3'b111: ALUCtl = 4'b0100; // AND
                3'b100: ALUCtl = 4'b0101; // XOR
                3'b001: ALUCtl = 4'b0110; // SLL
                3'b101: ALUCtl = (funct7 == 1'b1) ? 4'b1000 : 4'b0111; // SRA if funct7 = 1, else SRL
                default: ALUCtl = 4'b0000; // Default ADD
            endcase
        end
        default: ALUCtl = 4'b0000; // Default ADD
        endcase;
end

endmodule

