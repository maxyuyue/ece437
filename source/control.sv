/*
  Kyle Rakos
  krakos@purdue.edu

  Control Unit
  */

  `include "cpu_types_pkg.vh"
  `include "control_if.vh"
  import cpu_types_pkg::*;

  module control
    (
      input word_t instr,
      control_if contIf
      );

  // Outputs
    // logic   regDst, branch, WEN, aluSrc, jmp, jl, jmpReg, memToReg, dREN, dWEN, lui, bne, zeroExt, aluCont;
  // Inputs
    // logic   dhit, ihit, halt;


    always_comb begin
      if (instr[31:26] == 6'b000000) begin // R-type instruction
        contIf.regDst = 1;
        countIf.branch = 0;
        countIf.aluSrc = 0;
        countIf.memToReg = 0;
        countIf.dREN = 0;
        countIf.dWEN = 0;
        countIf.aluCont = 2'b10;
        countIf.jmp = 0;
        countIf.jl = 0;
        countIf.bne = 0;
        countIf.zeroExt = 0;
        countIf.lui = 0;

        // Differences for JR
        if (instr[5:0] == 6'b001000) begin // JR - therefore WEN = 0, jmpReg = 1
          countIf.WEN = 0;
          countIf.jmpReg = 1;
        end
        else begin// always 1 otherwise
          countIf.WEN = 1;
          countIf.jmpReg = 0;
        end

        // Differences for Shifts
        if ((instr[5:0] == 6'b000000) || (instr[5:0] == 6'b000010)) // If SLL or SRL
          countIf.shiftSel = 1;
        else
        countIf.shiftSel = 0;

        // ALU Part of instructions
        casez (instr[5:0])
        SLL : begin
          countIf.aluOp = ALU_SLL;
        end
        SRL : begin
          countIf.aluOp = ALU_SRL;
        end
        JR : begin
            countIf.aluOp = ALU_AND; // actually a don't care I believe
          end
          ADD : begin
            countIf.aluOp = ALU_ADD;
          end
          ADDU : begin
            countIf.aluOp = ALU_ADD; // double check if there is actually a difference with unsigned
          end
          SUB : begin
            countIf.aluOp = ALU_SUB;
          end
          SUBU : begin
            countIf.aluOp = ALU_SUB; // double check if there is actually a difference with unsigned
          end
          AND : begin
            countIf.aluOp = ALU_AND;
          end
          OR : begin
            countIf.aluOp = ALU_OR;
          end
          XOR : begin
            countIf.aluOp = ALU_XOR;
          end
          NOR : begin
            countIf.aluOp = ALU_NOR;
          end
          SLT : begin
            countIf.aluOp = ALU_SLT;
          end
          SLTU : begin
            countIf.aluOp = ALU_SLTU;
          end
        endcase

      end


    end
endmodule
