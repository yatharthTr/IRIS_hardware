module ALU (
    input [3:0] ALUCtl,
    input signed [31:0] A,B,
    output reg signed  [31:0] ALUOut,
    output wire zero
);
    // ALU has two operand, it execute different operator based on ALUctl wire 
    // output zero is for determining taking branch or not 
    always @(*) begin
      case(ALUCtl)
        4'd0: ALUOut=A+B;
        4'd1: ALUOut=A-B;
        4'd3: ALUOut=A|B;
        4'd4: ALUOut=A&B;
        4'd2:ALUOut=A<B;
        4'd5:ALUOut=A<<B;
        4'd8:ALUOut=$signed(A>>>B);
        4'd7:ALUOut=A>>B;
        default:ALUOut=0;
        endcase;
    end
    // TODO: implement your ALU here
    // Hint: you can use operator to implement
    assign zero=(A==B);
endmodule

