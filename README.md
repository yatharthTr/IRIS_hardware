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
wire [1:…
Kuch nikla ?
abhi tak to nhi, tumhare me wires bohot kam h pata nhi kaise, mere design me kaafi saare h

`include "PC.v"
`include "Adder.v"
`include "InstructionMemory.v"
`include "Control.v"
`include "Register.v"
`include "ImmGen.v"
`include "ShiftLeftOne.v"
`include "Mux2to1.v"
`include "ALUCtrl.v"
`include "ALU.v"
`include "DataMemory.v"

module SingleCycleCPU (
    input clk,
    input start
);

// When input start is zero, cpu should reset
// When input start is high, cpu start running

// Wire declarations
wire [31:0] pc_current, pc_next, pc_plus4; // addresses can remain unsigned
wire signed [31:0] branch_target;
wire [31:0] instruction;
wire [31:0] read_data1, read_data2; // from Register module (could be cast to signed later)
wire [31:0]…
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
            `OPCODE_JALTYPE: imm = {…
Time=10 | PC=00000000 | Instr=00001010001100000000010000010011 | x2=       128 | x5=         0 | x6=         0 | x8=         0
Time=15 | PC=00000004 | Instr=11111111110000010000000100010011 | x2=       128 | x5=         0 | x6=         0 | x8=         0
Time=25 | PC=00000008 | Instr=00000000100000010010000000100011 | x2=         0 | x5=         0 | x6=         0 | x8=         0
Time=35 | PC=0000000c | Instr=00000000000000000000010000110011 | x2=         0 | x5=         0 | x6=         0 | x8=         0
Time=45 | PC=00000010 | Instr=00000000000000000000001010010011 | x2=         0 | x5=         0 | x6=         0 | x8=         0
Time=55 | PC=00000014 | Instr=00000000011100101010001100010011 | x2=         0 | x5=         0 | x6=         0 | x8=         0
Time=6…
Kya hua?
out put aa rha hai but, ye aa rha hai
call kru abhi ?
# Question 1 Submission

## Project Structure  
- *src Folder*: Contains all Verilog source files used to design the system, along with a .vcd file that captures the simulation results.  
- *Results Folder*: Includes screenshots of different signal values at various clock cycles. It also contains register and memory data values that were stored or loaded during instruction execution.  

## Viewing the Simulation  
To analyze the simulation results, open the .vcd file using *GTKWave*. This will allow you to observe signal transitions and debug execution behavior effectively.  

---

## Simulation Results  

### *1. Memory Operations*  
The following screenshots illustrate the loading and storing of the value *163* in stack memory:  

#### *Data Memory Signals*  
![Memory Signals](Results/DataMem_signals/image.png)  

![Memory Signals (Copy)](Results/DataMem_signals/image%20copy%202.png)  

---

### *2. Register Values After Execution*  
The screenshot below shows the final values stored in registers upon completion of instruction execution:  

#### *Register Values*  
![Register Signals](Results/Register_signals/image%20copy%205.png)
