/*
  Kyle Rakos
  krakos@purdue.edu

  Memory Control test bench
*/

// mapped needs this
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;


  // clock
  always #(PERIOD/2) CLK++;

  // interface
  caches_if cif0();
  caches_if cif1();
  cache_control_if #(.CPUS(2)) ccif(cif0,cif1);
  cpu_ram_if ramif();

  // test program
  test PROG (CLK,ccif,nRST);
  // DUT
  `ifndef MAPPED
    memory_control DUT(CLK, nRST, ccif);
    ram  #(.LAT(0)) RAM(CLK, nRST, ramif);
  `else
  memory_control DUT(
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
  cache_control_if.cc cfif,
  output logic nRST
  );
    import cpu_types_pkg::*;
    parameter PERIOD = 10;
    ramstate_t ramState = ACCESS;
    string testType = "Initialization";

    initial begin
    // Set these inputs from the cache/datapath
    nRST = 0;
    cif0.iREN = 1'b0;
    cif0.dREN = 1'b0;
    cif0.dWEN = 1'b0;
    cif0.dstore = 32'hBAD1BAD1;
    cif0.iaddr = 32'hBAD1BAD1;
    cif0.daddr = 32'hBAD1BAD1;
    cif0.cctrans = 1'b0;
    cif0.ccwrite = 1'b0;
    
    cif1.iREN = 1'b0;
    cif1.dREN = 1'b0;
    cif1.dWEN = 1'b0;
    cif1.dstore = 32'hBAD1BAD1;
    cif1.iaddr = 32'hBAD1BAD1;
    cif1.daddr = 32'hBAD1BAD1;
    cif1.cctrans = 1'b0;
    cif1.ccwrite = 1'b0;

    // Check these outputs which goes to the datapath/cache
      //ccif.iwait
      //ccif.dwait
      //ccif.dload
      //ccif.iload

      //cif#.ccwait
      //cif#.ccinv
      //cif#.ccsnoopaddr

    // Check these outputs which goes to the RAM
      //ccif.ramWEN
      //ccif.ramREN
      //ccif.ramaddr
      //ccif.ramstore

    // Check these inputs from RAM
      //ccif.ramstate
      //ccif.ramload   
    @(posedge CLK); @(posedge CLK);

    reset();
    testType = "Read instr from core 0";
    cif0.iREN = 1'b1;
    cif0.iaddr = 32'h00000000;
    @(posedge ccif.ramREN); @(posedge CLK);
    
    reset();
    testType = "Read instr from core 1";
    cif1.iREN = 1'b1;
    cif1.iaddr = 32'h00000004;
    @(posedge ccif.ramREN); @(posedge CLK); @(posedge CLK);

    reset();
    testType = "1st read instr from both cores";
    nRST = 1;
    cif0.iREN = 1'b1;
    cif0.iaddr = 32'h0000008;
    cif1.iREN = 1'b1;
    cif1.iaddr = 32'h0000000C;
    @(posedge CLK); @(posedge CLK); @(posedge CLK); @(posedge CLK); @(posedge CLK); @(posedge CLK);

    reset();
    testType = "2nd read instr from both cores";
    nRST = 1;
    cif0.iREN = 1'b1;
    cif0.iaddr = 32'h0000010;
    cif1.iREN = 1'b1;
    cif1.iaddr = 32'h00000014;
    @(posedge CLK); @(posedge CLK); @(posedge CLK); @(posedge CLK); @(posedge CLK); @(posedge CLK);

    reset();
    testType = "Read data from core 0";
    cif0.dREN = 1'b1;
    cif0.daddr = 32'h000000F0;
    cif0.cctrans = 1'b1; // transition  from Invalid to Shared
    @(posedge CLK); 
    cif1.cctrans = 1'b1; // let know that cache 1 doesn't have value
    @(posedge CLK); 
    cif1.cctrans = 1'b0;
    @(posedge CLK); @(posedge CLK); @(posedge CLK); 
    
    reset();
    testType = "Read data from core 1";
    cif1.dREN = 1'b1;
    cif1.daddr = 32'h000000F4;
    cif1.cctrans = 1'b1; // transition  from Invalid to Shared
    @(posedge CLK); 
    cif0.cctrans = 1'b1; // let know that cache 0 doesn't have value
    @(posedge CLK);
    cif0.cctrans = 1'b0;
    @(posedge CLK);  @(posedge CLK); @(posedge CLK); @(posedge CLK); @(posedge CLK); 
 

    reset();
    testType = "Write data from core 0";
    cif0.dWEN = 1'b1;
    cif0.daddr = 32'h000000FC;
    cif0.dstore = 32'h12345678;
    cif0.cctrans = 1'b1; // transition  from Invalid to Shared
    @(posedge CLK); 
    cif1.cctrans = 1'b1; // let know that cache 1 doesn't have value
    @(posedge CLK); 
    cif1.cctrans = 1'b0;
    @(posedge CLK); @(posedge CLK); @(posedge CLK); @(posedge CLK)

    testType = "Dump Memory";
    //dump_memory();
   
    end
task automatic dump_memory();
    import cpu_types_pkg::*;
    string filename = "memcpu.hex";
    int memfd;
    

    cif0.daddr = 0;
    cif0.dWEN = 0;
    cif0.dREN = 0;
    cif0.iREN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      cif0.daddr = i << 2;
      cif0.dREN = 1;
      repeat (4) @(posedge CLK);
      if (ccif.ramload  === 0)
        continue;
      values = {8'h04,16'(i),8'h00,ccif.ramload };
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),ccif.ramload ,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      cif0.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask



  task automatic reset();
    import cpu_types_pkg::*;
    nRST = 1;
    cif0.iREN = 1'b0;
    cif0.dREN = 1'b0;
    cif0.dWEN = 1'b0;
    cif0.dstore = 32'hBAD1BAD1;
    cif0.iaddr = 32'hBAD1BAD1;
    cif0.daddr = 32'hBAD1BAD1;
    cif0.cctrans = 1'b0;
    cif0.ccwrite = 1'b0;
    
    cif1.iREN = 1'b0;
    cif1.dREN = 1'b0;
    cif1.dWEN = 1'b0;
    cif1.dstore = 32'hBAD1BAD1;
    cif1.iaddr = 32'hBAD1BAD1;
    cif1.daddr = 32'hBAD1BAD1;
    cif1.cctrans = 1'b0;
    cif1.ccwrite = 1'b0;
  endtask

endprogram
