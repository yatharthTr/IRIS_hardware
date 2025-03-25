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
        4'd15: ALUOut = counting_trailing_Zeros(A);
        default:ALUOut=0;
        endcase;
    end
    function [31:0] counting_trailing_Zeros(input [31:0] val);
        integer i;
        begin
            // default if val == 0, trailing zeros is 32
            counting_trailing_Zeros = 32;
            for (i = 0; i < 32; i = i + 1) begin
                if (val[i] == 1'b1 && counting_trailing_Zeros == 32) begin
                    counting_trailing_Zeros = i; 
                end
            end
        end
    endfunction
    // TODO: implement your ALU here
    // Hint: you can use operator to implement
    assign zero=(A==B);
endmodule

