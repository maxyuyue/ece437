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

    r_t rType;
    i_t iType;
    j_t jType;

    always_comb begin
      rType = 0;
      iType = 0;
      jType = 0;
      if (instr[31:26] == RTYPE) begin // R-type instruction
        rType = dpif.imemload;
        iType = 0;

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
        if (instr[5:0] == JR) begin // JR - therefore WEN = 0, jmpReg = 1
          countIf.WEN = 0;
          countIf.jmpReg = 1;
        end
        else begin// always 1 otherwise
          countIf.WEN = 1;
          countIf.jmpReg = 0;
        end

        // Differences for Shifts
        if ((instr[5:0] == SLL) || (instr[5:0] == SRL)) // If SLL or SRL
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

      else begin // I or J type instruction 
        // ALways the same signals
        countIf.regDst = 0;
        countIf.jmpReg = 0;
        countIf.shiftSel = 0;
        iType = dpif.imemload;
        rType = 0;

        // Default signals
        countIf.branch = 0;
        countIf.WEN = 1;
        countIf.aluSrc = 1;
        countIf.memToReg = 0;
        countIf.dREN = 0;
        countIf.dWEN = 0;
        countIf.aluOp = ALU_ADD;
        countIf.aluCont = 11; // Actually determine if still needed
        countIf.jmp = 0;
        countIf.jl = 0;
        countIf.bne = 0;
        countIf.zeroExt = 0;
        countIf.lui = 0;

        if (instr[31:26] == ADDI) begin // I-type instruction
          // Nothing needed
        end
        
        else if (instr[31:26] == ADDIU) begin // I-type instruction
          // Nothing needed
        end
        else if (instr[31:26] == ANDI) begin // I-type instruction
          countIf.aluOp = ALU_AND;
        end
        else if (instr[31:26] == BEQ) begin // I-type instruction
          // TODO
        end
        else if (instr[31:26] == BNE) begin // I-type instruction
          // TODO
        end
        else if (instr[31:26] == LUI) begin // I-type instruction
          // TODO
        end
        else if (instr[31:26] == LW) begin // I-type instruction
          // TODO
        end
        else if (instr[31:26] == ORI) begin // I-type instruction
            countIf.branch = 0;
            countIf.WEN = 1;
            countIf.aluSrc = 1;
            countIf.memToReg = 0;
            countIf.dREN = 0;
            countIf.dWEN = 0;
            countIf.aluOp = ALU_OR;
            countIf.aluCont = 11;
            countIf.jmp = 0;
            countIf.jl = 0;//
            countIf.bne = 0;
            countIf.zeroExt = 1;
            countIf.lui = 0;
        end
        else if (instr[31:26] == SLTI) begin // I-type instruction
          // TODO
        end
        else if (instr[31:26] == SLTIU) begin // I-type instruction
          // TODO
        end
        else if (instr[31:26] == SW) begin // I-type instruction
            countIf.branch = 0;
            countIf.WEN = 0;
            countIf.aluSrc = 1;
            countIf.memToReg = 0;
            countIf.dREN = 0;
            countIf.dWEN = 1;
            countIf.aluOp = ALU_ADD;
            countIf.aluCont = 00;
            countIf.jmp = 0;
            countIf.jl = 0;
            countIf.bne = 0;
            countIf.zeroExt = 0;
            countIf.lui = 0;
        end
        else if (instr[31:26] == LL) begin // I-type instruction
          // TODO
        end
        else if (instr[31:26] == SC) begin // I-type instruction
          // TODO
        end
        else if (instr[31:26] == BEQ) begin // I-type instruction
          // TODO
        end
        else if (instr[31:26] == XORI) begin // I-type instruction
          countIf.aluOp = ALU_XOR;
          countIf.zeroExt = 1;
        end

      end

    end
  endmodule
