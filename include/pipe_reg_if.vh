/*
  Kyle Rakos

  interface for control unit

  Last modified: Spring 2016 by John Skubic

*/

`ifndef PIPE_REG_IF_VH
`define PIPE_REG_IF_VH

// ram memory types
`include "cpu_types_pkg.vh"
`include "caches_if.vh"

interface pipe_reg_if( );
  // import types
  import cpu_types_pkg::*;


  // Input/Outputs
  logic   regDst, branch, WEN, aluSrc, jmp, jl, jmpReg, memToReg, dREN, dWEN, lui, bne, zeroExt, shiftSel;
  logic	  [1:0] aluCont;
  aluop_t aluOp;

  logic   dhit, ihit, halt;

  word_t instr, incPC, pc, rdat1, rdat2, jmpAddr, outputPort;

endinterface

`endif //CONTROL_IF_VH
