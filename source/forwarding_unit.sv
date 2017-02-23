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
// import types
import cpu_types_pkg::*;

  module forwarding_unit (
  input [4:0] rsel1/*idex*/, rsel2/*idex*/,
  pipe_reg_if idexValue, exmemValue, memwbValue, memwbValueOld,
  output word_t rdat1Fwd, rdat2Fwd,
  output logic r1Fwd, r2Fwd
);


  always_comb begin
    // Forwarding of register 1
    if((memwbValue.WEN) && (memwbValue.dest != 0) && !(exmemValue.WEN && (exmemValue.dest != 0) && (exmemValue.dest != rsel1)) && (memwbValue.dest == rsel1))
      begin
        r1Fwd = 1'b1;
        if (memwbValue.lui == 1)
          rdat1Fwd = {memwbValue.instr[15:0],16'b0000000000000000};
        else if (memwbValue.jl == 1)
          rdat1Fwd = memwbValue.pc + 4;
        else if (memwbValue.dREN == 1)
          rdat1Fwd = memwbValue.dmemload;
        else
          rdat1Fwd = memwbValue.outputPort;
    end 

    else if ((exmemValue.WEN) && (exmemValue.dest != 0) && (exmemValue.dest == rsel1)) 
      begin // if dren = 1 then pipeline stall
      r1Fwd = 1'b1;
        if (exmemValue.lui == 1)
          rdat1Fwd = {exmemValue.instr[15:0],16'b0000000000000000};
        else if (exmemValue.jl == 1)
          rdat1Fwd = exmemValue.pc + 4;
        else
          rdat1Fwd = exmemValue.outputPort;
      end

    else if((memwbValueOld.WEN) && (memwbValueOld.dest != 0) && !(exmemValue.WEN && (exmemValue.dest != 0) && (exmemValue.dest != rsel1)) && (memwbValueOld.dest == rsel1))
      begin
        r1Fwd = 1'b1;
        if (memwbValueOld.lui == 1)
          rdat1Fwd = {memwbValueOld.instr[15:0],16'b0000000000000000};
        else if (memwbValueOld.jl == 1)
          rdat1Fwd = memwbValueOld.pc + 4;
        else if (memwbValueOld.dREN == 1)
          rdat1Fwd = memwbValueOld.dmemload;
        else
          rdat1Fwd = memwbValueOld.outputPort;
    end 

    else begin
      r1Fwd = 1'b0;
      rdat1Fwd = 32'h0; // don't care
    end



    // Forwarding of register 2
    if((memwbValue.WEN) && (memwbValue.dest != 0) && !(exmemValue.WEN && (exmemValue.dest != 0) && (exmemValue.dest != rsel2)) && (memwbValue.dest == rsel2))
      begin
        r2Fwd = 1'b1;
        if (memwbValue.lui == 1)
          rdat2Fwd = {memwbValue.instr[15:0],16'b0000000000000000};
        else if (memwbValue.jl == 1)
          rdat2Fwd = memwbValue.pc + 4;
        else if (memwbValue.dREN == 1)
          rdat2Fwd = memwbValue.dmemload;
        else
          rdat2Fwd = memwbValue.outputPort;
      end

    else if ((exmemValue.WEN) && (exmemValue.dest != 0) && (exmemValue.dest == rsel2)) 
      begin // if dren = 1 then pipeline stall
        r2Fwd = 1'b1;
        if (exmemValue.lui == 1)
          rdat2Fwd = {exmemValue.instr[15:0],16'b0000000000000000};
        else if (exmemValue.jl == 1)
          rdat2Fwd = exmemValue.pc + 4;
        else
          rdat2Fwd = exmemValue.outputPort;
    end

    else if((memwbValueOld.WEN) && (memwbValueOld.dest != 0) && !(exmemValue.WEN && (exmemValue.dest != 0) && (exmemValue.dest != rsel2)) && (memwbValueOld.dest == rsel2))
      begin
        r2Fwd = 1'b1;
        if (memwbValueOld.lui == 1)
          rdat2Fwd = {memwbValueOld.instr[15:0],16'b0000000000000000};
        else if (memwbValueOld.jl == 1)
          rdat2Fwd = memwbValueOld.pc + 4;
        else if (memwbValueOld.dREN == 1)
          rdat2Fwd = memwbValueOld.dmemload;
        else
          rdat2Fwd = memwbValueOld.outputPort;
      end

    else begin
      r2Fwd = 1'b0;
      rdat2Fwd = 32'h0; // don't care
    end

  end
  

endmodule
