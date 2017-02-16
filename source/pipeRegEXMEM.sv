/*
  Kyle Rakos

  datapath contains register file, control, hazard, muxes
  and glue logic for processor
  */

// data path interface
`include "pipe_reg_if.vh"
`include "cpu_types_pkg.vh"


module pipeRegEXMEM(
  input logic CLK, nRST,
  //two instances of the pipe_reg_if --> one as input and other as output
  pipe_reg_if prEXMEM_in,
  pipe_reg_if prEXMEM_out,
  input logic enable, flush
  );
  // import types
  import cpu_types_pkg::*;

  
  //write on positive edge of clock
  always_ff @(posedge CLK or negedge nRST) begin
  	if (nRST == 0 || flush == 1) 
    begin	  
      prEXMEM_out.regDst = 0;
      prEXMEM_out.branch = 0;
      prEXMEM_out.WEN = 0;
      prEXMEM_out.aluSrc = 0;
      prEXMEM_out.jmp = 0;
      prEXMEM_out.jl = 0;
      prEXMEM_out.jmpReg = 0;
      prEXMEM_out.memToReg = 0;
      prEXMEM_out.dREN = 0;
      prEXMEM_out.dWEN = 0;
      prEXMEM_out.lui = 0;
      prEXMEM_out.bne = 0;
      prEXMEM_out.zeroExt = 0;
      prEXMEM_out.shiftSel = 0;
      prEXMEM_out.aluCont = 0;
      prEXMEM_out.aluOp = ALU_SLL;
      prEXMEM_out.instr = 32'h0;
      prEXMEM_out.incPC = 32'h0;
      prEXMEM_out.pc = 32'h0;
      prEXMEM_out.rdat1 = 32'h0;
      prEXMEM_out.rdat2 = 32'h0;
      prEXMEM_out.outputPort = 32'h0;
      prEXMEM_out.dmemload = 32'h0;
      prEXMEM_out.dest = 5'h0;
    end
    else if (enable == 1) begin
      prEXMEM_out.regDst = prEXMEM_in.regDst;
      prEXMEM_out.branch = prEXMEM_in.branch;
      prEXMEM_out.WEN = prEXMEM_in.WEN;
      prEXMEM_out.aluSrc = prEXMEM_in.aluSrc;
      prEXMEM_out.jmp = prEXMEM_in.jmp;
      prEXMEM_out.jl = prEXMEM_in.jl;
      prEXMEM_out.jmpReg = prEXMEM_in.jmpReg;
      prEXMEM_out.memToReg = prEXMEM_in.memToReg;
      prEXMEM_out.dREN = prEXMEM_in.dREN;
      prEXMEM_out.dWEN = prEXMEM_in.dWEN;
      prEXMEM_out.lui = prEXMEM_in.lui;
      prEXMEM_out.bne = prEXMEM_in.bne;
      prEXMEM_out.zeroExt = prEXMEM_in.zeroExt;
      prEXMEM_out.shiftSel = prEXMEM_in.shiftSel;
      prEXMEM_out.aluCont = prEXMEM_in.aluCont;
      prEXMEM_out.aluOp = prEXMEM_in.aluOp;
      prEXMEM_out.instr = prEXMEM_in.instr;
      prEXMEM_out.incPC = prEXMEM_in.incPC;
      prEXMEM_out.pc = prEXMEM_in.pc;
      prEXMEM_out.rdat1 = prEXMEM_in.rdat1;
      prEXMEM_out.rdat2 = prEXMEM_in.rdat2;
      prEXMEM_out.outputPort = prEXMEM_in.outputPort; 
      prEXMEM_out.dmemload = prEXMEM_in.dmemload;
      prEXMEM_out.dest = prEXMEM_in.dest;
    end
  end

endmodule