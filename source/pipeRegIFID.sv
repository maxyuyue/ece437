/*
  Kyle Rakos

  datapath contains register file, control, hazard, muxes
  and glue logic for processor
*/

// data path interface
`include "pipe_reg_if.vh"
`include "cpu_types_pkg.vh"


module datapath (
  input logic CLK, nRST,
  pipe_reg_if prIFID;
);
  // import types
  import cpu_types_pkg::*;

 
  always_ff @(posedge CLK or negedge nRST) begin
  	if (nRST == 0 || prIFID.flush = 1) begin	  
      prIFID.regDst = 0;
      prIFID.branch = 0;
      prIFID.WEN = 0;
      prIFID.aluSrc = 0;
      prIFID.jmp = 0;
      prIFID.jl = 0;
      prIFID.jmpReg = 0;
      prIFID.memToReg = 0;
      prIFID.dREN = 0;
      prIFID.dWEN = 0;
      prIFID.lui = 0;
      prIFID.bne = 0;
      prIFID.zeroExt = 0;
      prIFID.shiftSel = 0;
      prIFID.aluCont = 0;
      prIFID.aluOp = 0;
      instr = 32'h0;
      extendOut = 32'h0;
      incPC = 32'h0;
      pc = 32'h0;
      rdat1 = 32'h0;
      rdat2 = 32'h0;
      jmpAddr = 32'h0;
      outputPort = 32'h0;
  	end
  	else if () begin
  		
  	end
  end