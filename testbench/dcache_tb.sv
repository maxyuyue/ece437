
// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"
// import types	
import cpu_types_pkg::*;


// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module dcache_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  //interface
  datapath_cache_if dcif();
  caches_if cif();

  //test program
  test PROG(CLK, dcif, cif, nRST);

  //DUT
	`ifndef MAPPED
		dcache DUT(CLK, nRST, dcif, cif);
  `else
  dcache DUT(
  	.\cif.iwait(cif.iwait),
  	.\cif.dwait(cif.dwait),
  	.\cif.iREN(cif.iREN),
  	.\cif.dREN(cif.dREN),
  	.\cif.dWEN(cif.dWEN),
  	.\cif.iload(cif.iload),
  	.\cif.dload(cif.dload),
  	.\cif.dstore(cif.dstore),
  	.\cif.iaddr(cif.iaddr),
  	.\cif.daddr(cif.daddr),
  	.\cif.ccwait(cif.ccwait),
  	.\cif.ccinv(cif.ccinv),
  	.\cif.ccwrite(cif.ccwrite),
  	.\cif.cctrans(cif.cctrans),
  	.\cif.ccnoopaddr(cif.ccsnoopaddr),
  	.\dcif.halt(dcif.halt),
  	.\dcif.ihit(dcif.ihit),
  	.\dcif.imemREN(dcif.imemREN),
  	.\dcif.imemload(dcif.imemload),
  	.\dcif.imemaddr(dcif.imemaddr),
  	.\dcif.dhit(dcif.dhit),
  	.\dcif.datomic(dcif.datomic),
  	.\dcif.dmemREN(dcif.dmemREN),
  	.\dcif.dmemWEN(dcif.dmemWEN),
  	.\dcif.flushed(dcif.flushed),
  	.\dcif.dmemload(dcif.dmemload),
  	.\dcif.dmemstore(dcif.dmemstore),
  	.\dcif.dmemaddr(dcif.dmemaddr),
    .\nRST (nRST),
    .\CLK (CLK)
    );
  `endif
  endmodule // dcache_tb

  program test(
  	input logic CLK,
  	datapath_cache_if.dcache dcif,
  	caches_if.dcache cif,
  	output logic nRST
  );
  import cpu_types_pkg::*;
  parameter PERIOD = 10;

  initial begin
    nRST = 0;
    #(PERIOD);
    nRST = 1;
    dcif.dmemWEN = 1;
    dcif.dmemaddr = 1234;
    dcif.dmemstore = 5678;
    dcif.dmemREN = 0;
    cif.dwait = 1;
    #(PERIOD);
    #(PERIOD);
    cif.dwait = 0;
    cif.dload = 2468;
    #(PERIOD);
    #(PERIOD);
  end

  endprogram
  