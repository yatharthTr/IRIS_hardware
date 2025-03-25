`include "SingleCycleCPU.v"
`timescale 1ns/1ns

module tb_riscv_sc;

    reg clk;
    reg start;

    // Instantiate the CPU
    SingleCycleCPU riscv_DUT(
        .clk(clk),
        .start(start)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin
        $dumpfile("cpu_simulation_2.vcd");
        $dumpvars(0, tb_riscv_sc);

        clk = 0;
        start = 0;
        #10 start = 1;

        $monitor(
          "Time=%0t | PC=%h | Instr=%b | opcode=%b | ALU=%h | regWrite=%b | x2=%h | x5=%d | x6=%d | x8=%d",
           $time,
           riscv_DUT.pc_o,
           riscv_DUT.i_inst,
		   riscv_DUT.m_Control.opcode,
		   riscv_DUT.m_ALU.ALUOut,
		   riscv_DUT.m_Register.regWrite,
           riscv_DUT.m_Register.regs[2],
           riscv_DUT.m_Register.regs[5],
           riscv_DUT.m_Register.regs[6],
           riscv_DUT.m_Register.regs[8]
        );

        // Run for enough cycles
        #3000 $finish;
    end

endmodule