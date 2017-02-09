/*
  Kyle Rakos

  interface for control unit

  Last modified: Spring 2016 by John Skubic

*/

`ifndef CONTROL_IF_VH
`define CONTROL_IF_VH

// ram memory types
`include "cpu_types_pkg.vh"
`include "caches_if.vh"

interface control_if;
  // import types
  import cpu_types_pkg::*;


  // Outputs
  logic   regDst, branch, WEN, aluSrc, jmp, jl, jmpReg, memToReg, dREN, dWEN, lui, bne, zeroExt, shiftSel;
  logic	  [1:0] aluCont;
  aluop_t aluOp;

  // Inputs
  logic   dhit, ihit, halt;

endinterface

`endif //CONTROL_IF_VH
