/*
  Kyle Rakos

  datapath contains register file, control, hazard, muxes
  and glue logic for processor
  */

// data path interface
`include "pipe_reg_if.vh"
`include "cpu_types_pkg.vh"


module pipeRegMEMWB(
  input logic CLK, nRST, ihit,
  //two instances of the pipe_reg_if --> one as input and other as output
  pipe_reg_if prMEMWB_in,
  pipe_reg_if prMEMWB_out,
  pipe_reg_if prMEMWB_out_old,
  input logic enable, flush
  );
  // import types
  import cpu_types_pkg::*;

  
  //write on positive edge of clock
  always_ff @(posedge CLK or negedge nRST) begin
  	if (nRST == 0) // nRST for both out and out_old
    begin	  
      prMEMWB_out.regDst = 0;
      prMEMWB_out.branch = 0;
      prMEMWB_out.WEN = 0;
      prMEMWB_out.aluSrc = 0;
      prMEMWB_out.jmp = 0;
      prMEMWB_out.jl = 0;
      prMEMWB_out.jmpReg = 0;
      prMEMWB_out.dREN = 0;
      prMEMWB_out.dWEN = 0;
      prMEMWB_out.lui = 0;
      prMEMWB_out.bne = 0;
      prMEMWB_out.zeroExt = 0;
      prMEMWB_out.shiftSel = 0;
      prMEMWB_out.aluOp = ALU_SLL;
      prMEMWB_out.instr = 32'h0;
      prMEMWB_out.incPC = 32'h0;
      prMEMWB_out.pc = 32'h0;
      prMEMWB_out.rdat1 = 32'h0;
      prMEMWB_out.rdat2 = 32'h0;
      prMEMWB_out.outputPort = 32'h0;
      prMEMWB_out.dmemload = 32'h0;
      prMEMWB_out.dest = 5'h0;
      prMEMWB_out.ll = 1'b0;

      prMEMWB_out_old.regDst = 0;
      prMEMWB_out_old.branch = 0;
      prMEMWB_out_old.WEN = 0;
      prMEMWB_out_old.aluSrc = 0;
      prMEMWB_out_old.jmp = 0;
      prMEMWB_out_old.jl = 0;
      prMEMWB_out_old.jmpReg = 0;
      prMEMWB_out_old.dREN = 0;
      prMEMWB_out_old.dWEN = 0;
      prMEMWB_out_old.lui = 0;
      prMEMWB_out_old.bne = 0;
      prMEMWB_out_old.zeroExt = 0;
      prMEMWB_out_old.shiftSel = 0;
      prMEMWB_out_old.aluOp = ALU_SLL;
      prMEMWB_out_old.instr = 32'h0;
      prMEMWB_out_old.incPC = 32'h0;
      prMEMWB_out_old.pc = 32'h0;
      prMEMWB_out_old.rdat1 = 32'h0;
      prMEMWB_out_old.rdat2 = 32'h0;
      prMEMWB_out_old.outputPort = 32'h0;
      prMEMWB_out_old.dmemload = 32'h0;
      prMEMWB_out_old.dest = 5'h0;
      prMEMWB_out_old.ll = 1'b0;
    end
    else if (flush == 1 && ihit == 1) // regular flush stuff
    begin   
      prMEMWB_out.regDst = 0;
      prMEMWB_out.branch = 0;
      prMEMWB_out.WEN = 0;
      prMEMWB_out.aluSrc = 0;
      prMEMWB_out.jmp = 0;
      prMEMWB_out.jl = 0;
      prMEMWB_out.jmpReg = 0;
      prMEMWB_out.dREN = 0;
      prMEMWB_out.dWEN = 0;
      prMEMWB_out.lui = 0;
      prMEMWB_out.bne = 0;
      prMEMWB_out.zeroExt = 0;
      prMEMWB_out.shiftSel = 0;
      prMEMWB_out.aluOp = ALU_SLL;
      prMEMWB_out.instr = 32'h0;
      prMEMWB_out.incPC = 32'h0;
      prMEMWB_out.pc = 32'h0;
      prMEMWB_out.rdat1 = 32'h0;
      prMEMWB_out.rdat2 = 32'h0;
      prMEMWB_out.outputPort = 32'h0;
      prMEMWB_out.dmemload = 32'h0;
      prMEMWB_out.dest = 5'h0;
      prMEMWB_out.ll = 1'b0;
    end
    else if (enable == 1) begin
      prMEMWB_out_old.regDst = prMEMWB_out.regDst;
      prMEMWB_out_old.branch = prMEMWB_out.branch;
      prMEMWB_out_old.WEN = prMEMWB_out.WEN;
      prMEMWB_out_old.aluSrc = prMEMWB_out.aluSrc;
      prMEMWB_out_old.jmp = prMEMWB_out.jmp;
      prMEMWB_out_old.jl = prMEMWB_out.jl;
      prMEMWB_out_old.jmpReg = prMEMWB_out.jmpReg;
      prMEMWB_out_old.dREN = prMEMWB_out.dREN;
      prMEMWB_out_old.dWEN = prMEMWB_out.dWEN;
      prMEMWB_out_old.lui = prMEMWB_out.lui;
      prMEMWB_out_old.bne = prMEMWB_out.bne;
      prMEMWB_out_old.zeroExt = prMEMWB_out.zeroExt;
      prMEMWB_out_old.shiftSel = prMEMWB_out.shiftSel;
      prMEMWB_out_old.aluOp = prMEMWB_out.aluOp;
      prMEMWB_out_old.instr = prMEMWB_out.instr;
      prMEMWB_out_old.incPC = prMEMWB_out.incPC;
      prMEMWB_out_old.pc = prMEMWB_out.pc;
      prMEMWB_out_old.rdat1 = prMEMWB_out.rdat1;
      prMEMWB_out_old.rdat2 = prMEMWB_out.rdat2;
      prMEMWB_out_old.outputPort = prMEMWB_out.outputPort; 
      prMEMWB_out_old.dmemload = prMEMWB_out.dmemload;
      prMEMWB_out_old.dest = prMEMWB_out.dest;
      prMEMWB_out_old.ll = prMEMWB_out.ll;

      prMEMWB_out.regDst = prMEMWB_in.regDst;
      prMEMWB_out.branch = prMEMWB_in.branch;
      prMEMWB_out.WEN = prMEMWB_in.WEN;
      prMEMWB_out.aluSrc = prMEMWB_in.aluSrc;
      prMEMWB_out.jmp = prMEMWB_in.jmp;
      prMEMWB_out.jl = prMEMWB_in.jl;
      prMEMWB_out.jmpReg = prMEMWB_in.jmpReg;
      prMEMWB_out.dREN = prMEMWB_in.dREN;
      prMEMWB_out.dWEN = prMEMWB_in.dWEN;
      prMEMWB_out.lui = prMEMWB_in.lui;
      prMEMWB_out.bne = prMEMWB_in.bne;
      prMEMWB_out.zeroExt = prMEMWB_in.zeroExt;
      prMEMWB_out.shiftSel = prMEMWB_in.shiftSel;
      prMEMWB_out.aluOp = prMEMWB_in.aluOp;
      prMEMWB_out.instr = prMEMWB_in.instr;
      prMEMWB_out.incPC = prMEMWB_in.incPC;
      prMEMWB_out.pc = prMEMWB_in.pc;
      prMEMWB_out.rdat1 = prMEMWB_in.rdat1;
      prMEMWB_out.rdat2 = prMEMWB_in.rdat2;
      prMEMWB_out.outputPort = prMEMWB_in.outputPort; 
      prMEMWB_out.dmemload = prMEMWB_in.dmemload;
      prMEMWB_out.dest = prMEMWB_in.dest;
      prMEMWB_out.ll = prMEMWB_in.ll;
    end
  end

endmodule