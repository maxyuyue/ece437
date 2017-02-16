/*
  Kyle Rakos

  Hazard unit for pipeliniing
*/

// data path interface
`include "datapath_cache_if.vh"
`include "cpu_types_pkg.vh"
`include "control_if.vh"
`include "register_file_if.vh"
`include "alu_file_if.vh"
`include "pipe_reg_if.vh"

module hazard_unit (
  input logic WEN, jumpBranch,
  input [4:0] rsel1, rsel2, idexWsel, exmemWsel,
  output logic stallPC, ifidFlush, idexFlush, exmemFlush,
  output logic idexFreeze
);
  // import types
  import cpu_types_pkg::*;

  always_comb begin
    if (((rsel1 == exmemWsel) || (rsel2 == exmemWsel)) && (exmemWsel != 0) && (WEN == 1)) begin
      stallPC = 1;
      ifidFlush = 0;
      idexFlush = 1;
      exmemFlush = 0;
      idexFreeze = 0;
    end
    else if (((rsel1 == idexWsel) || (rsel2 == idexWsel)) && (idexWsel != 0) && (WEN == 1)) begin
      stallPC = 1;
      ifidFlush = 0;
      idexFlush = 1;
      exmemFlush = 0;
      idexFreeze = 0;
    end
    else if (jumpBranch == 1) begin
      stallPC = 0;
      ifidFlush = 1;
      idexFlush = 1;
      exmemFlush = 0;
      idexFreeze = 0;
    end
    else begin
      stallPC = 0;
      ifidFlush = 0;
      idexFlush = 0;
      exmemFlush = 0;
      idexFreeze = 0;
    end


  end
  

endmodule
