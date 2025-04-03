# Question 1 Submission

## A) Control Signals for Instructions

### *1. For beq (Branch Equal)*
- *Branch:* 1  
- *MemRead:* 0  
- *MemtoReg:* X (does not matter, no register write)  
- *ALUOp:* 01 (typically means "subtract/compare")  
- *MemWrite:* 0  
- *ALUSrc:* 0 (we compare two registers)  
- *RegWrite:* 0  

### *2. For sw (Store Word)*
- *Branch:* 0  
- *MemRead:* 0  
- *MemtoReg:* X (does not matter, no register write)  
- *ALUOp:* 00 (we do an add for address calculation)  
- *MemWrite:* 1  
- *ALUSrc:* 1 (immediate offset for store address)  
- *RegWrite:* 0  

### *3. For lw (Load Word)*
- *Branch:* 0  
- *MemRead:* 1  
- *MemtoReg:* 1  
- *ALUOp:* 00 (add for address calculation)  
- *MemWrite:* 0  
- *ALUSrc:* 1 (immediate offset)  
- *RegWrite:* 1  

---

## B) Iteration Breakdown

Each iteration follows these steps:

1. slt x2, x0, x1 → Sets x2 = 1 if x1 > 0, else 0.  
2. beq x2, x0, done → Branches to done if x2 = 0.  
3. If not branched:  
   - addi x1, x1, -1 → Decrements x1.  
   - addi x2, x2, 2 → Adds 2 to x2.  
   - Jumps back to the loop.  
   
### *Final Outcome:*  
The loop runs until x2 = 0, at which point it branches to the done segment.  


---

## C) Count Trailing Zeros Instruction

This instruction is implemented in the ALU using a function named countTrailingZeros, which determines the number of consecutive `0`s at the least significant bit positions of an input value.

### *Implementation Details:*
- A local parameter CTZ = 4'b1010 is defined to represent the CTZ operation in the ALU control signals.
- The countTrailingZeros function iterates over the 32-bit input value A, checking each bit from the least significant bit (LSB) to the most significant bit (MSB).
- If a 1 is encountered, the loop stops, and the function returns the count of trailing 0`s before the first `1.
- If the entire value is 0, it returns 32, indicating all bits are zero.
- The ALU assigns the result of countTrailingZeros(A) to ALUOut when ALUCtl is set to CTZ.

### *Design Choices:*
1. *Loop-based Approach:* The function uses a loop to check each bit, making it simple and easy to understand.
2. *Integer-based Indexing:* Uses an integer loop counter to track positions efficiently.
3. *Default Value Handling:* If the input is completely 0, the function returns 32 (since all bits are trailing zeroes), which is useful for certain applications where zero detection is needed.
4. *Synthesizable:* The design follows a procedural approach that can be synthesized for hardware implementation in FPGA/ASIC designs.