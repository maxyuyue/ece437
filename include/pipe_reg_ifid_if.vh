/*
  Kyle Rakos

  interface for control unit

  Last modified: Spring 2016 by John Skubic

*/

`ifndef PIPE_REG_IFID_IF_VH
`define PIPE_REG_IFID_IF_VH

// ram memory types
`include "cpu_types_pkg.vh"
`include "caches_if.vh"

interface pipe_reg_ifid_if;
  // import types
  import cpu_types_pkg::*;

  aluop_t aluOp;
  word_t instr, incPC, pc;

endinterface

`endif //CONTROL_IF_VH
