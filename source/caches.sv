/*
  Eric Villasenor
  evillase@gmail.com

  this block holds the i and d cache
*/


// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"

module caches (
  input logic CLK, nRST,
  datapath_cache_if dcif,
  caches_if cif
);
<<<<<<< HEAD
=======
  
>>>>>>> e30ca295dd8a833d4b694d6ea01c7843ef60c1c3
  // icache
  icache  ICACHE(CLK, nRST, dcif, cif);
  // dcache
  dcache  DCACHE(CLK, nRST, dcif, cif);
<<<<<<< HEAD
    
  //  // dcache invalidate before halt handled by dcache when exists
  // assign dcif.flushed = dcif.halt;

  // //singlecycle
  // assign dcif.ihit = (dcif.imemREN) ? ~cif.iwait : 0;
  // assign dcif.dhit = (dcif.dmemREN|dcif.dmemWEN) ? ~cif.dwait : 0;
  // assign dcif.imemload = cif.iload;
  // assign dcif.dmemload = cif.dload;


  // assign cif.iREN = dcif.imemREN;
  // assign cif.dREN = dcif.dmemREN;
  // assign cif.dWEN = dcif.dmemWEN;
  // assign cif.dstore = dcif.dmemstore;
  // assign cif.iaddr = dcif.imemaddr;
  // assign cif.daddr = dcif.dmemaddr;
  
=======
  
  
  /*
   // dcache invalidate before halt handled by dcache when exists
  assign dcif.flushed = dcif.halt;

  //singlecycle
  assign dcif.ihit = (dcif.imemREN) ? ~cif.iwait : 0;
  assign dcif.dhit = (dcif.dmemREN|dcif.dmemWEN) ? ~cif.dwait : 0;
  assign dcif.imemload = cif.iload;
  assign dcif.dmemload = cif.dload;


  assign cif.iREN = dcif.imemREN;
  assign cif.dREN = dcif.dmemREN;
  assign cif.dWEN = dcif.dmemWEN;
  assign cif.dstore = dcif.dmemstore;
  assign cif.iaddr = dcif.imemaddr;
  assign cif.daddr = dcif.dmemaddr;
  */
>>>>>>> e30ca295dd8a833d4b694d6ea01c7843ef60c1c3

endmodule
