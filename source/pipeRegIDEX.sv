/*
  Kyle Rakos

  datapath contains register file, control, hazard, muxes
  and glue logic for processor
  */

// data path interface
`include "pipe_reg_if.vh"
`include "cpu_types_pkg.vh"


module pipeRegIDEX (
  input logic CLK, nRST,
  //two instances of the pipe_reg_if --> one as input and other as output
  pipe_reg_if prIDEX_in,
  pipe_reg_if prIDEX_out,
  input logic enable, flush 
  );
  // import types
  import cpu_types_pkg::*;

  
  //write on positive edge of clock
  always_ff @(posedge CLK or negedge nRST) begin
  	if (nRST == 0 || flush == 1) 
    begin	  
      prIDEX_out.regDst = 0;
      prIDEX_out.branch = 0;
      prIDEX_out.WEN = 0;
      prIDEX_out.aluSrc = 0;
      prIDEX_out.jmp = 0;
      prIDEX_out.jl = 0;
      prIDEX_out.jmpReg = 0;
      prIDEX_out.memToReg = 0;
      prIDEX_out.dREN = 0;
      prIDEX_out.dWEN = 0;
      prIDEX_out.lui = 0;
      prIDEX_out.bne = 0;
      prIDEX_out.zeroExt = 0;
      prIDEX_out.shiftSel = 0;
      prIDEX_out.aluCont = 0;
      prIDEX_out.aluOp = ALU_SLL;
      prIDEX_out.instr = 32'h0;
      prIDEX_out.incPC = 32'h0;
      prIDEX_out.pc = 32'h0;
      prIDEX_out.rdat1 = 32'h0;
      prIDEX_out.rdat2 = 32'h0;
      prIDEX_out.outputPort = 32'h0;
      prIDEX_out.dmemload = 32'h0;
      prIDEX_out.dest = 5'h0;
    end
    else if (enable == 1) begin
      prIDEX_out.regDst = prIDEX_in.regDst;
      prIDEX_out.branch = prIDEX_in.branch;
      prIDEX_out.WEN = prIDEX_in.WEN;
      prIDEX_out.aluSrc = prIDEX_in.aluSrc;
      prIDEX_out.jmp = prIDEX_in.jmp;
      prIDEX_out.jl = prIDEX_in.jl;
      prIDEX_out.jmpReg = prIDEX_in.jmpReg;
      prIDEX_out.memToReg = prIDEX_in.memToReg;
      prIDEX_out.dREN = prIDEX_in.dREN;
      prIDEX_out.dWEN = prIDEX_in.dWEN;
      prIDEX_out.lui = prIDEX_in.lui;
      prIDEX_out.bne = prIDEX_in.bne;
      prIDEX_out.zeroExt = prIDEX_in.zeroExt;
      prIDEX_out.shiftSel = prIDEX_in.shiftSel;
      prIDEX_out.aluCont = prIDEX_in.aluCont;
      prIDEX_out.aluOp = prIDEX_in.aluOp;
      prIDEX_out.instr = prIDEX_in.instr;
      prIDEX_out.incPC = prIDEX_in.incPC;
      prIDEX_out.pc = prIDEX_in.pc;
      prIDEX_out.rdat1 = prIDEX_in.rdat1;
      prIDEX_out.rdat2 = prIDEX_in.rdat2;
      prIDEX_out.outputPort = prIDEX_in.outputPort;
      prIDEX_out.dmemload = prIDEX_in.dmemload;
      prIDEX_out.dest = prIDEX_in.dest;
    end
  end

endmodule