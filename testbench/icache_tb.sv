// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "cpu_ram_if.vh"
`include "cache_control_if.vh"

// cpu types
`include "cpu_types_pkg.vh"
// import types	
import cpu_types_pkg::*;


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
  //caches_if dummy();
  //cache_control_if #(.CPUS(1)) ccif(cif,dummy);
  //cpu_ram_if ramif();

  //test program
  test PROG(CLK, nRST, dcif, cif);

  //DUT
	`ifndef MAPPED
    //memory_control MC(CLK, nRST, ccif);  
    //ram  #(.LAT(0)) RAM(CLK, nRST, ramif);
    icache DUT(CLK, nRST, dcif, cif);

  `else
    // memory_control MC(
    // .\ccif.iwait (ccif.iwait),
    // .\ccif.dwait (ccif.dwait),
    // .\ccif.iREN (ccif.iREN),
    // .\ccif.dREN (ccif.dREN),
    // .\ccif.dWEN (ccif.dWEN),
    // .\cload (cload),
    // .\cload (cload),
    // .\ccif.dstore (ccif.dstore),
    // .\ccif.iaddr (ccif.iaddr),
    // .\ccif.daddr (ccif.daddr),
    // .\ccif.ramWEN (ccif.ramWEN),
    // .\ccif.ramREN (ccif.ramREN),
    // .\ccif.ramstate (ccif.ramstate),
    // .\ccif.ramaaddr (ccif.ramaddr),
    // .\ccif.ramstore (ccif.ramstore),
    // .\ccif.ramload (ccif.ramload),
    // .\nRST (nRST),
    // .\CLK (CLK)
    // );

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


    // ramstate RAM(
    // .\ramif.ramaddr(ramif.ramaddr),
    // .\ramif.ramstore(ramif.ramstore),
    // .\ramif.ramREN(ramif.ramREN),
    // .\ramif.ramWEN(ramif.ramWEN),
    // .\ramif.ramstate(ramif.ramstate),
    // .\ramload(ramload),
    // .\nRST (nRST),
    // .\CLK (CLK)
    // );

  `endif

  // Glue logic and such
  // assign ramif.ramaddr = ccif.ramaddr;
  // assign ramif.ramstore = ccif.ramstore;
  // assign ramif.ramREN = ccif.ramREN;
  // assign ramif.ramWEN = ccif.ramWEN;
  // assign ccif.ramstate = ramif.ramstate;
  // assign ccif.ramload = ramif.ramload;

  endmodule // icache_tb

  program test(input logic CLK, 
    output logic nRST, 
    datapath_cache_if dcif, 
    caches_if cif);

  parameter PERIOD = 10;
  // import word type
  import cpu_types_pkg::*;
   string testType = "";
   initial begin
      nRST = 0;
      cif.iwait = 0;
      cif.iload = 0;
      dcif.imemREN = 0;
      dcif.imemaddr = 0;
      
      @(posedge CLK);
      nRST = 1;
      @(posedge CLK);

      testType = "Miss on reset test";
      
      dcif.imemREN = 1;
      dcif.imemaddr = 32'hBEEF;
      cif.iwait = 1;
      @(negedge CLK);      

      if (dcif.ihit == 0 && cif.iREN == 1 && cif.iaddr == dcif.imemaddr) begin
        $display("%s pass!", testType);
      end
      else begin
        $display("%s error!", testType);
      end

      @(posedge CLK);
      @(posedge CLK);
      @(posedge CLK);

      testType = "Hit on first write test";

      cif.iwait = 0;
      cif.iload = 32'hDEAD;
      @(posedge CLK);

      if (dcif.ihit == 1 && cif.iREN == 0 && cif.iaddr == dcif.imemaddr && cif.iload == dcif.imemload) begin
        $display("%s pass!", testType);
      end
      else begin
        $display("%s error!", testType);
      end

      @(negedge CLK);
      @(negedge CLK);
      @(negedge CLK);      

      testType = "Miss on overwrite test";

      cif.iwait = 1;
      dcif.imemaddr = 32'hBEEF + 32'h40;      
      cif.iload = 32'hBEAD;
      @(negedge CLK);

      if (dcif.ihit == 0 && cif.iREN == 1 && cif.iaddr == dcif.imemaddr) begin
        $display("%s pass!", testType);
      end
      else begin
        $display("%s error!", testType);
      end

      @(negedge CLK);
      @(negedge CLK);
      @(negedge CLK);

      testType = "Hit after overwrite test";
      cif.iwait = 0;      

       @(negedge CLK);

      if (dcif.ihit == 1 && cif.iREN == 0 && cif.iaddr == dcif.imemaddr  && cif.iload == dcif.imemload) begin
        $display("%s pass!", testType);
      end
      else begin
        $display("%s error!", testType);
      end
      
      @(negedge CLK);      

   end
      
      
endprogram
  