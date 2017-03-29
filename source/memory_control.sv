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
    ccif.iwait: 1 when no instruction to load and/or not access busy, 0 otherwise ->
    ccif.dwait: 1 when no data to load/write and/or not access busy, 0 otherwise ->
    ccif.iREN: 1 when ask to read(load) instruction, 0 otherwise <-
    ccif.dREN: 1 when ask to read(load) data, 0 otherwise <-
    ccif.dWEN: 1 when ready to write data, 0 otherwise <-
    ccif.iload: instruction to return to cache (32) ->
    ccif.dload: data to return to cache (32) ->
    ccif.dstore: data to write to RAM (32) <-
    ccif.iaddr: address to load instruction from (32) <-
    ccif.daddr: address to write/load data from (32) <- 

    ccif.ramWEN: 1 when requesting to write data, 0 otherwise ->
    ccif.ramREN: 1 when requesting to read(load) instruction or data, 0 otherwise ->
    ccif.ramstate: Indicates current state of RAM as either FREE, BUSY, ACCESS, or ERROR <-
    ccif.ramaddr: Address to load/write from (32) ->
    ccif.ramstore: Data to write (32) ->
    ccif.ramload: Data returned from RAM (32) <-

    // coherence
      CPUS = number of cpus parameter passed from system -> cc
      ccwait         : lets a cache know it needs to block cpu
      ccinv          : let a cache know it needs to invalidate entry
      ccwrite        : high if cache is doing a write of addr
      ccsnoopaddr    : the addr being sent to other cache with either (wb/inv)
      cctrans        : high if the cache state is transitioning (i.e. I->S, I->M, etc...)

  */

  always_comb // determine wait signals sent to cache
  begin
    if (ccif.ramstate == ACCESS) begin
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
    
    if (ccif.dREN == 1'b1) begin // ready to read data from RAM
      ccif.ramWEN = 1'b0;
      ccif.ramREN = 1'b1;
      ccif.ramaddr = ccif.daddr; 
    end
    else if (ccif.dWEN == 1'b1) begin // ready to write data to RAM
      ccif.ramWEN = 1'b1;
      ccif.ramREN = 1'b0;
      ccif.ramaddr = ccif.daddr;
    end
    else if (ccif.iREN == 1'b1) begin // ready to read instruction from RAM
      ccif.ramWEN = 1'b0;
      ccif.ramREN = 1'b1;
      ccif.ramaddr = ccif.iaddr;
    end
    else begin // default don't access memory
      ccif.ramWEN = 1'b0;
      ccif.ramREN = 1'b0;
      ccif.ramaddr = 32'hBAD1BAD1;
    end

    ccif.dload = ccif.ramload;
    ccif.iload = ccif.ramload;
    ccif.ramstore = ccif.dstore; // Data to store
  
    
  end

endmodule
