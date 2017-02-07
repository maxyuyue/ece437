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
      control_if contIf,
      logic dHit
      );

  // Outputs
    // logic   regDst, branch, WEN, aluSrc, jmp, jl, jmpReg, memToReg, dREN, dWEN, lui, bne, zeroExt, aluCont;
  // Inputs
    // logic   dhit, ihit, halt;

    r_t rType;
    i_t iType;
    j_t jType;

    always_comb begin

      if (instr[31:26] == RTYPE) begin // R-type instruction
        rType = instr;
        iType = 0;

        contIf.regDst = 1;
        contIf.branch = 0;
        contIf.aluSrc = 0;
        contIf.memToReg = 0;
        contIf.dREN = 0;
        contIf.dWEN = 0;
        contIf.jmp = 0;
        contIf.jl = 0;
        contIf.bne = 0;
        contIf.zeroExt = 0;
        contIf.lui = 0;
        contIf.aluOp = ALU_ADD; // default

        // Differences for JR
        if (instr[5:0] == JR) begin // JR - therefore WEN = 0, jmpReg = 1
          contIf.WEN = 0;
          contIf.jmpReg = 1;
        end
        else begin// always 1 otherwise
          contIf.WEN = 1;
          contIf.jmpReg = 0;
        end

        // Differences for Shifts
        if ((instr[5:0] == SLL) || (instr[5:0] == SRL)) // If SLL or SRL
          contIf.shiftSel = 1;
        else
          contIf.shiftSel = 0;

        // ALU Part of instructions
        casez (instr[5:0])
        SLL : begin
          contIf.aluOp = ALU_SLL;
        end
        SRL : begin
          contIf.aluOp = ALU_SRL;
        end
        JR : begin
            contIf.aluOp = ALU_AND; // actually a don't care I believe
          end
          ADD : begin
            contIf.aluOp = ALU_ADD;
          end
          ADDU : begin
            contIf.aluOp = ALU_ADD; // double check if there is actually a difference with unsigned
          end
          SUB : begin
            contIf.aluOp = ALU_SUB;
          end
          SUBU : begin
            contIf.aluOp = ALU_SUB; // double check if there is actually a difference with unsigned
          end
          AND : begin
            contIf.aluOp = ALU_AND;
          end
          OR : begin
            contIf.aluOp = ALU_OR;
          end
          XOR : begin
            contIf.aluOp = ALU_XOR;
          end
          NOR : begin
            contIf.aluOp = ALU_NOR;
          end
          SLT : begin
            contIf.aluOp = ALU_SLT;
          end
          SLTU : begin
            contIf.aluOp = ALU_SLTU;
          end
        endcase

      end

      else begin // I or J type instruction 
        // ALways the same signals
        contIf.regDst = 0;
        contIf.jmpReg = 0;
        contIf.shiftSel = 0;
        iType = instr;
        rType = 0;

        // Default signals
        contIf.branch = 0;
        contIf.WEN = 1;
        contIf.aluSrc = 1;
        contIf.memToReg = 0;
        contIf.dREN = 0;
        contIf.dWEN = 0;
        contIf.aluOp = ALU_ADD;
        contIf.jmp = 0;
        contIf.jl = 0;
        contIf.bne = 0;
        contIf.zeroExt = 0;
        contIf.lui = 0;

        if (instr[31:26] == ADDI) begin // I-type instruction
          // Nothing needed
        end
        else if (instr[31:26] == ADDIU) begin // I-type instruction
          // Nothing needed
        end
        else if (instr[31:26] == ANDI) begin // I-type instruction
          contIf.aluOp = ALU_AND;
        end
        else if (instr[31:26] == BEQ) begin // I-type instruction
          contIf.branch = 1;
          contIf.WEN = 0;
          contIf.aluSrc = 0;
          contIf.aluOp = ALU_SUB;
        end
        else if (instr[31:26] == BNE) begin // I-type instruction
          contIf.branch = 1;
          contIf.WEN = 0;
          contIf.aluSrc = 0;
          contIf.aluOp = ALU_SUB;
          contIf.bne = 1;
        end
        else if (instr[31:26] == LUI) begin // I-type instruction
          contIf.lui = 1;
        end
        else if (instr[31:26] == LW) begin // I-type instruction
          contIf.memToReg = 1;
          contIf.dREN = 1;
          contIf.WEN = dHit;
        end
        else if (instr[31:26] == ORI) begin // I-type instruction
            contIf.aluOp = ALU_OR;
            contIf.zeroExt = 1;
        end
        else if (instr[31:26] == SLTI) begin // I-type instruction
          contIf.aluOp = ALU_SLT;
        end
        else if (instr[31:26] == SLTIU) begin // I-type instruction
          contIf.aluOp = ALU_SLTU;
        end
        else if (instr[31:26] == SW) begin // I-type instruction
            contIf.WEN = 0;
            contIf.dWEN = 1;
        end
        else if (instr[31:26] == LL) begin // I-type instruction
          // TODO when needed
        end
        else if (instr[31:26] == SC) begin // I-type instruction
          // TODO when needed
        end
        else if (instr[31:26] == XORI) begin // I-type instruction
          contIf.aluOp = ALU_XOR;
          contIf.zeroExt = 1;
        end
        else if (instr[31:26] == J) begin // J-type instruction
          contIf.WEN = 0;
          contIf.jmp = 1;
        end
        else if (instr[31:26] == JAL) begin // J-type instruction
          contIf.jmp = 1;
          contIf.jl = 1;
        end
        else 
          contIf.jl = 0; // just to make compiler happy (maybe?)

      end

    end
  endmodule
