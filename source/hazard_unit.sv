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
  input logic dREN, jumpBranch,
  input [4:0] rsel1/*ifid*/, rsel2/*ifid*/, idexWsel, exmemWsel,
  output logic stallPC, ifidFlush, idexFlush, ifidFreeze
);
  // import types
  import cpu_types_pkg::*;

  always_comb begin
    if ((rsel2 == idexWsel) && (idexWsel != 0) && (dREN == 1'b1)) begin // && (WEN == 1)) begin
      stallPC = 1;
      ifidFlush = 0;
      idexFlush = 1;
      ifidFreeze = 1;
    end
    else if (jumpBranch == 1) begin
      stallPC = 0;
      ifidFlush = 1;
      idexFlush = 1;
      ifidFreeze = 0;
    end
    else begin
      stallPC = 0;
      ifidFlush = 0;
      idexFlush = 0;
      ifidFreeze = 0;
    end
  end

endmodule
