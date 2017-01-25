/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;

  /*
    ccif.iwait: 1 when no instruction to load and/or ram busy, 0 otherwise ->
    ccif.dwait: 1 when no data to load/write and/or ram busy, 0 otherwise ->
    ccif.iREN: 1 when ready to read(load) instruction, 0 otherwise <-
    ccif.dREN: 1 when ready to read(load) data, 0 otherwise <-
    ccif.dWEN: 1 when ready to write data, 0 otherwise <-
    ccif.iload: instruction to return to cache (32) ->
    ccif.dload: data to return to cache (32) ->
    ccif.dstore: data to write to RAM (32) <-
    ccif.iaddr: address to load instruction from (32) <-
    ccif.daddr: address to write/load data from (32) <- 

    ccif.ramWEN: 1 when ready to write data, 0 otherwise ->
    ccif.ramREN: 1 when ready to read(load) instruction or data, 0 otherwise ->
    ccif.ramstate: Indicates current state of RAM as either FREE, BUSY, ACCESS, or ERROR <-
    ccif.ramaddr: Address to load/write from (32) ->
    ccif.ramstore: Data to write (32) ->
    ccif.ramload: Data returned from RAM (32) <-



  */

  always_comb // determine wait signals sent to cache
  begin
    if (ccif.ramstate == FREE) begin
      if (ccif.dREN == 1'b1) begin // data ready to be read
        ccif.iwait = 1'b1;
        ccif.dwait = 1'b0;
      end
      else if (ccif.dWEN == 1'b1) begin // data ready to be written
        ccif.iwait = 1'b1;
        ccif.dwait = 1'b0;
      end
      else if (ccif.iREN == 1'b1) begin // instruction ready to be read
        ccif.iwait = 1'b0;
        ccif.dwait = 1'b1;
      end
      else begin //default is data is not ready
        ccif.iwait = 1'b1;
        ccif.dwait = 1'b1;
      end
    end
      else begin //default is data is not ready
        ccif.iwait = 1'b1;
        ccif.dwait = 1'b1;
      end
  end



  always_comb begin // determine RAM signals
    if (ccif.dwait == 1'b0 && ccif.dREN == 1'b1) begin // ready to read data from RAM
      ccif.ramWEN = 1'b0;
      ccif.ramREN = 1'b1;
      ccif.dload = ccif.ramload;
      ccif.iload = 0; // MAYBE DON'T CARE
      ccif.ramaddr = ccif.daddr; 
      ccif.ramaddr = 0; // MAYBE DON'T CARE
    end
    else if (ccif.dwait == 1'b0 && ccif.dWEN == 1'b1) begin // ready to write data to RAM
      ccif.ramWEN = 1'b1;
      ccif.ramREN = 1'b0;
      ccif.dload = ccif.ramload;
      ccif.iload = 0;  // MAYBE DON'T CARE
      ccif.ramaddr = ccif.daddr; 
      ccif.ramaddr = 0; // MAYBE DON'T CARE
    end
    else if (ccif.iwait == 1'b0) begin // ready to read instruction from RAM
      cif.ramWEN = 1'b0;
      ccif.ramREN = 1'b1;
      ccif.dload = 0; // MAYBE DON'T CARE
      ccif.iload = ccif.ramload;
      ccif.ramaddr = 0; // MAYBE DON'T CARE
      ccif.ramaddr = ccif.iaddr;
    end
    else begin // default don't access memory
      cif.ramWEN = 1'b0;
      ccif.ramREN = 1'b1;
      ccif.dload = 0; // MAYBE DON'T CARE
      ccif.iload = 0; // MAYBE DON'T CARE
      ccif.ramaddr = 0; // MAYBE DON'T CARE
      ccif.ramaddr = 0; // MAYBE DON'T CARE
    end

    ccif.ramstore = ccif.dstore; // Data to store
    
  end

endmodule
