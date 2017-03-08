// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"
// import types	
import cpu_types_pkg::word_t;


// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module icache_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  //interface
  datapath_cache_if dcif();
  caches_if cif();

  //test program
  test PROG(CLK, nRST, dcif, cif);

  //DUT
	`ifndef MAPPED
		icache DUT(CLK, nRST, dcif, cif);
  `else
  icache DUT(
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
  endmodule // icache_tb

  program test(
  	input logic CLK,
  	datapath_cache_if.cache dcif,
  	caches_if.caches cif,
  	output logic nRST
  );

  parameter PERIOD = 10;

  initial 
  	begin

  	end

  endprogram
  