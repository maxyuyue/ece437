/*
  Kyle Rakos

  datapath contains register file, control, hazard, muxes
  and glue logic for processor
*/

// data path interface
`include "pipe_reg_if.vh"
`include "cpu_types_pkg.vh"


module pipeRegMEMWB(
  input logic CLK, nRST,
  //two instances of the pipe_reg_if --> one as input and other as output
  pipe_reg_if prMEMWB_in,
  pipe_reg_if prMEMWB_out
);
  // import types
  import cpu_types_pkg::*;

  
  //write on positive edge of clock
  always_ff @(posedge CLK or negedge nRST) begin
  	if (nRST == 0 || prMEMWB_in.flush = 1) 
      begin	  
        prMEMWB_out.regDst = 0;
        prMEMWB_out.branch = 0;
        prMEMWB_out.WEN = 0;
        prMEMWB_out.aluSrc = 0;
        prMEMWB_out.jmp = 0;
        prMEMWB_out.jl = 0;
        prMEMWB_out.jmpReg = 0;
        prMEMWB_out.memToReg = 0;
        prMEMWB_out.dREN = 0;
        prMEMWB_out.dWEN = 0;
        prMEMWB_out.lui = 0;
        prMEMWB_out.bne = 0;
        prMEMWB_out.zeroExt = 0;
        prMEMWB_out.shiftSel = 0;
        prMEMWB_out.aluCont = 0;
        prMEMWB_out.aluOp = 0;
        prMEMWB_out.instr = 32'h0;
        prMEMWB_out.extendOut = 32'h0;
        prMEMWB_out.incPC = 32'h0;
        prMEMWB_out.pc = 32'h0;
        prMEMWB_out.rdat1 = 32'h0;
        prMEMWB_out.rdat2 = 32'h0;
        prMEMWB_out.jmpAddr = 32'h0;
        prMEMWB_out.outputPort = 32'h0;
    	end
  end


always_ff @(negedge CLK) 
  begin
    if(prMEMWB_in.enable) 
      begin
        prMEMWB_out.regDst = prMEMWB_in.regDst;
        prMEMWB_out.branch = prMEMWB_in.branch;
        prMEMWB_out.WEN = prMEMWB_in.WEN;
        prMEMWB_out.aluSrc = prMEMWB_in.aluSrc;
        prMEMWB_out.jmp = prMEMWB_in.jmp;
        prMEMWB_out.jl = prMEMWB_in.jl;
        prMEMWB_out.jmpReg = prMEMWB_in.jmpReg;
        prMEMWB_out.memToReg = prMEMWB_in.memToReg;
        prMEMWB_out.dREN = prMEMWB_in.dREN;
        prMEMWB_out.dWEN = prMEMWB_in.dWEN;
        prMEMWB_out.lui = prMEMWB_in.lui;
        prMEMWB_out.bne = prMEMWB_in.bne;
        prMEMWB_out.zeroExt = prMEMWB_in.zeroExt;
        prMEMWB_out.shiftSel = prMEMWB_in.shiftSel;
        prMEMWB_out.aluCont = prMEMWB_in.aluCont;
        prMEMWB_out.aluOp = prMEMWB_in.aluOp;
        prMEMWB_out.instr = prMEMWB_in.instr;
        prMEMWB_out.extendOut = prMEMWB_in.extendOut;
        prMEMWB_out.incPC = prMEMWB_in.incPC;
        prMEMWB_out.pc = prMEMWB_in.pc;
        prMEMWB_out.rdat1 = prMEMWB_in.rdat1;
        prMEMWB_out.rdat2 = prMEMWB_in.rdat2;
        prMEMWB_out.jmpAddr = prMEMWB_in.jmpAddr;
        prMEMWB_out.outputPort = prMEMWB_in.outputPort;      
      end
  end