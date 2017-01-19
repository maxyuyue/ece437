/*
  Eric Villasenor
  evillase@gmail.com

  register file interface
*/
`ifndef ALU_FILE_IF_VH
`define ALU_FILE_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_file_if;
  // import types
  import cpu_types_pkg::*;

  logic     negative, overflow, zero;
  aluop_t   aluop;
  word_t    portA, portB, outputPort;

  // register file ports
  modport rf (
    input   portA, portB, aluop, 
    output  negative, overflow, zero, outputPort
  );
  // register file tb
  modport tb (
    input   negative, overflow, zero, outputPort,
    output  portA, portB, aluop
  );
endinterface

`endif //REGISTER_FILE_IF_VH
