`include "PC.v"
`include "Adder.v"
`include "Register.v"
`include "ShiftLeftOne.v"
`include "Mux2to1.v"
`include "InstructionMemory.v"
`include "DataMemory.v"
`include "ImmGen.v"
`include "Control.v"
`include "ALUCtrl.v"
`include "ALU.v"
module SingleCycleCPU (
    input wire clk,
    input wire start
);


// When input start is zero, cpu should reset
// When input start is high, cpu start running

// TODO: connect wire to realize SingleCycleCPU
// The following provides simple template,
wire [31:0] pc_i, pc_o;//pc_o feeded to the instr_memory
wire [31:0]pc_sum;
//adder
wire [31:0] b_a, b_b;
wire [31:0] b_sum;// 
//instruction memory
wire [31:0] i_inst; //feeded to control

// control

wire branch, memRead, memtoReg, memWrite, ALUSrc, regWrite;
wire [1:0] ALUOp;
//Immediate
wire [31:0]imm;
// Aluclt

wire [3:0] Aluctl;

// register file



wire [31:0] readData1, readData2, writeData;

// ALU

wire [31:0] ALUOut;
wire zero;
wire [31:0] ALUData2;
// Memory
wire [31:0] load_data;

//shift left one for branching and jumps
// wire [31:0] o_shift;
PC m_PC(
    .clk(clk),
    .rst(start),
    .pc_i(pc_i),
    .pc_o(pc_o)
);

// for branching
Adder m_Adder_1(
    .a(pc_o),
    .b(imm),
    .sum(b_sum)// feeded to mux
);

InstructionMemory m_InstMem(
    .readAddr(pc_o),
    .inst(i_inst)
);

Control m_Control(
    .opcode(i_inst[6:0]),
    .branch(branch),
    .func3(i_inst[14:12]),
    .memRead(memRead),
    .memtoReg(memtoReg),
    .ALUOp(ALUOp),
    .memWrite(memWrite),
    .ALUSrc(ALUSrc),
    .regWrite(regWrite)
);


Register m_Register (
    .clk(clk),
    .rst(start),
    .regWrite(regWrite),
    .readReg1(i_inst[19:15]),  
    .readReg2(i_inst[24:20]), 
    .writeReg(i_inst[11:7]), 
    .writeData(writeData),
    .readData1(readData1),
    .readData2(readData2)
);


ImmGen #(.Width(32)) m_ImmGen(
    .inst(i_inst),
    .imm(imm)
);

// ShiftLeftOne m_ShiftLeftOne(
//     .i(imm),
//     .o(o_shift)
// );

Adder m_Adder_2(
    .a(pc_o),
    .b(32'd4),
    .sum(pc_sum)
);
wire jump_sel;
assign jump_sel=branch & zero;
Mux2to1 #(.size(32)) m_Mux_PC(
    .sel(jump_sel),
    .s0(pc_sum),
    .s1(b_sum),
    .out(pc_i)
);

Mux2to1 #(.size(32)) m_Mux_ALU(
    .sel(ALUSrc),
    .s0(readData2),
    .s1(imm),
    .out(ALUData2)
);

ALUCtrl m_ALUCtrl(
    .ALUOp(ALUOp),
    .funct7(i_inst[30]),
    .funct3(i_inst[14:12]),
    .ALUCtl(Aluctl)
);

ALU m_ALU(
    .ALUCtl(Aluctl),
    .A(readData1),
    .B(ALUData2),
    .ALUOut(ALUOut),
    .zero(zero)
);

DataMemory m_DataMemory(
    .rst(start),
    .clk(clk),
    .memWrite(memWrite),
    .memRead(memRead),
    .address(ALUOut),//aluout
    .writeData(readData2),//readdata2
    .readData(load_data)//load_data
);

Mux2to1 #(.size(32)) m_Mux_WriteData(
    .sel(memtoReg),
    .s1(load_data),
    .s0(ALUOut),//aluout
    .out(writeData)
);

endmodule
