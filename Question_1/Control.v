module Control (
    input [6:0] opcode,
    output  reg branch,
    input [2:0] func3,
    output  reg memRead,
    output  reg memtoReg,
    output  reg [1:0] ALUOp,
    output reg  memWrite,
    output  reg ALUSrc,
    output  reg regWrite
    );

    always @(*) begin
        case (opcode)
            7'b0110011: begin  // for (Add, Sub, SLtI, OR, And, Xor, Sll, Srl, Sra)
                branch = 0;
                memRead = 0;
                memtoReg = 0;
                ALUOp = 2'b10;
                memWrite = 0;
                ALUSrc = 0;
                regWrite = 1;
            end

            7'b0010011: begin // for I-type (AddI, SltI, OrI)
                if(func3==0) begin
                    ALUOp=0;
                end
                else ALUOp=2'b10;
                branch = 0;
                memRead = 0;
                memtoReg = 0;
                // ALUOp = 2'b10;
                memWrite = 0;
                ALUSrc = 1;
                regWrite = 1;
            end

            7'b0000011: begin // Load
                branch = 0;
                memRead = 1;
                memtoReg = 1;
                ALUOp = 2'b00;
                memWrite = 0;
                ALUSrc = 1;
                regWrite = 1;
            end

            7'b0100011: begin // Store
                branch = 0;
                memRead = 0;
                memtoReg = 0;
                ALUOp = 2'b00;
                memWrite = 1;
                ALUSrc = 1;
                regWrite = 0;
            end

            7'b1100011: begin // Branching
                branch = 1;
                memRead = 0;
                memtoReg = 0;
                ALUOp = 2'b01;
                memWrite = 0;
                ALUSrc = 0;
                regWrite = 0;
            end

            7'b1101111: begin //  fro Jump and link register(JAL)
                branch = 0;
                memRead = 0;
                memtoReg = 0;
                ALUOp = 2'b00;
                memWrite = 0;
                ALUSrc = 1;
                regWrite = 1;
            end

            default: begin
                branch = 0;
                memRead = 0;
                memtoReg = 0;
                ALUOp = 2'b00;
                memWrite = 0;
                ALUSrc = 0;
                regWrite = 0;
            end
        endcase
    end

endmodule




