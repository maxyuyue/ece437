/*
  Kyle Rakos
  krakos@purdue.edu

  Memory Control test bench
*/

// mapped needs this
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"
`include "cpu_types_pkg.vh"
`include "datapath_cache_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module icache_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;


  // clock
  always #(PERIOD/2) CLK++;

  // interface
  caches_if cif();
  caches_if dummy();
  cache_control_if #(.CPUS(1)) ccif(cif,dummy);
  cpu_ram_if ramif();
  datapath_cache_if dcif();

  // test program
  test PROG (CLK, nRST, dcif,cif);
  // DUT
  `ifndef MAPPED
    memory_control MC(CLK, nRST, ccif);
    ram  #(.LAT(0)) RAM(CLK, nRST, ramif);
    //datapath DP(CLK, nRST, dcif);
    caches DUT(CLK, nRST, dcif, cif);
  `else
  memory_control MC(
    .\ccif.iwait (ccif.iwait),
    .\ccif.dwait (ccif.dwait),
    .\ccif.iREN (ccif.iREN),
    .\ccif.dREN (ccif.dREN),
    .\ccif.dWEN (ccif.dWEN),
    .\cload (cload),
    .\cload (cload),
    .\ccif.dstore (ccif.dstore),
    .\ccif.iaddr (ccif.iaddr),
    .\ccif.daddr (ccif.daddr),
    .\ccif.ramWEN (ccif.ramWEN),
    .\ccif.ramREN (ccif.ramREN),
    .\ccif.ramstate (ccif.ramstate),
    .\ccif.ramaaddr (ccif.ramaddr),
    .\ccif.ramstore (ccif.ramstore),
    .\ccif.ramload (ccif.ramload),
    .\nRST (nRST),
    .\CLK (CLK)
    );

    ramstate RAM(
    .\ramif.ramaddr(ramif.ramaddr),
    .\ramif.ramstore(ramif.ramstore),
    .\ramif.ramREN(ramif.ramREN),
    .\ramif.ramWEN(ramif.ramWEN),
    .\ramif.ramstate(ramif.ramstate),
    .\ramload(ramload),
    .\nRST (nRST),
    .\CLK (CLK)
    );

    // datapath DP(
    // .\cif.iwait(cif.iwait),
    // .\cif.dwait(cif.dwait),
    // .\cif.iREN(cif.iREN),
    // .\cif.dREN(cif.dREN),
    // .\cif.dWEN(cif.dWEN),
    // .\cif.iload(cif.iload),
    // .\cif.dload(cif.dload),
    // .\cif.dstore(cif.dstore),
    // .\cif.iaddr(cif.iaddr),
    // .\cif.daddr(cif.daddr),
    // .\cif.ccwait(cif.ccwait),
    // .\cif.ccinv(cif.ccinv),
    // .\cif.ccwrite(cif.ccwrite),
    // .\cif.cctrans(cif.cctrans),
    // .\cif.ccnoopaddr(cif.ccsnoopaddr),
    // .\dcif.halt(dcif.halt),
    // .\dcif.ihit(dcif.ihit),
    // .\dcif.imemREN(dcif.imemREN),
    // .\dcif.imemload(dcif.imemload),
    // .\dcif.imemaddr(dcif.imemaddr),
    // .\dcif.dhit(dcif.dhit),
    // .\dcif.datomic(dcif.datomic),
    // .\dcif.dmemREN(dcif.dmemREN),
    // .\dcif.dmemWEN(dcif.dmemWEN),
    // .\dcif.flushed(dcif.flushed),
    // .\dcif.dmemload(dcif.dmemload),
    // .\dcif.dmemstore(dcif.dmemstore),
    // .\dcif.dmemaddr(dcif.dmemaddr),
    // .\nRST (nRST),
    // .\CLK (CLK)
    // );

  `endif

  // Glue logic and such
  assign ramif.ramaddr = ccif.ramaddr;
  assign ramif.ramstore = ccif.ramstore;
  assign ramif.ramREN = ccif.ramREN;
  assign ramif.ramWEN = ccif.ramWEN;

  assign ccif.ramstate = ramif.ramstate;
  assign ccif.ramload = ramif.ramload;

  /*
    Stuff Left:
    ccif.iwait: 1 when no instructioload and/or not access busy, 0 otherwise ->
    ccif.dwait: 1 when no datload/write and/or not access busy, 0 otherwise ->
    ccif.iREN: 1 when ask to load) instruction, 0 otherwise <-
    ccif.dREN: 1 when ask to load) data, 0 otherwise <-
    ccif.dWEN: 1 when ready to write data, 0 otherwise <-
    cload: instruction to return to cache (32) ->
    cload: data to return to cache (32) ->
    ccif.dstore: data to write to RAM (32) <-
    ccif.iaddr: addresload instruction from (32) <-
    ccif.daddr: address to wload data from (32) <- 
  */

endmodule

program test (
  input logic  CLK,
  output logic nRST,
  datapath_cache_if dcif,
  caches_if cif
  );
    parameter PERIOD = 10;
    string testType = "Initialization";
    
     initial begin
      nRST = 0;
      //cif.iwait = 0;
      //cif.iload = 0;
      dcif.imemREN = 0;
      dcif.imemaddr = 0;
      
      @(posedge CLK);
      nRST = 1;
      @(posedge CLK);

      testType = "Miss on reset test";
      
      dcif.imemREN = 1;
      dcif.imemaddr = 32'h0000;
      //cif.iwait = 1;
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

      //cif.iwait = 0;
      //cif.iload = 32'hDEAD;
      //dcif.imemREN = 0;
      @(negedge CLK);

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

      //cif.iwait = 1;
      dcif.imemaddr = 32'h40;      
      //cif.iload = 32'hBEAD;
      dcif.imemREN = 1;
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
      //cif.iwait = 0;      
      //dcif.imemREN = 0;

       @(negedge CLK);

      if (dcif.ihit == 1 && cif.iREN == 0 && cif.iaddr == dcif.imemaddr  && cif.iload == dcif.imemload) begin
        $display("%s pass!", testType);
      end
      else begin
        $display("%s error!", testType);
      end
      
      @(negedge CLK);         

    //dump_memory();
   
    end
// task automatic dump_memory();
//     import cpu_types_pkg::*;
//     string filename = "memcpu.hex";
//     int memfd;
    

//     cif.daddr = 0;
//     cif.dWEN = 0;
//     cif.dREN = 0;
//     cif.iREN = 0;

//     memfd = $fopen(filename,"w");
//     if (memfd)
//       $display("Starting memory dump.");
//     else
//       begin $display("Failed to open %s.",filename); $finish; end

//     for (int unsigned i = 0; memfd && i < 16384; i++)
//     begin
//       int chksum = 0;
//       bit [7:0][7:0] values;
//       string ihex;

//       cif.daddr = i << 2;
//       cif.dREN = 1;
//       repeat (4) @(posedge CLK);
//       if (ccif.ramload  === 0)
//         continue;
//       values = {8'h04,16'(i),8'h00,ccif.ramload };
//       foreach (values[j])
//         chksum += values[j];
//       chksum = 16'h100 - chksum;
//       ihex = $sformatf(":04%h00%h%h",16'(i),ccif.ramload ,8'(chksum));
//       $fdisplay(memfd,"%s",ihex.toupper());
//     end //for
//     if (memfd)
//     begin
//       cif.dREN = 0;
//       $fdisplay(memfd,":00000001FF");
//       $fclose(memfd);
//       $display("Finished memory dump.");
//     end
//   endtask

endprogram
